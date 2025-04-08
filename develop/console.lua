---@diagnostic disable-next-line: undefined-global
local console_tips_match = console_tips_match

---@class Develop.Console
local M = Class 'Develop.Console'

function M.getHelpInfo()
    local info = {}

    info[#info+1] = 'List of instructions:'
    local commands = clicli.develop.command.getAllCommands()
    for _, command in ipairs(commands) do
        local commandInfo = clicli.develop.command.getCommandInfo(command)
        if commandInfo then
            info[#info+1] = ('  .%s - %s'):format(command, commandInfo.desc)
        end
    end
    info[#info+1] = ''
    info[#info+1] = 'You can directly enter the code to run to `! `The code at the beginning will run after synchronization:'
    info[#info+1] = '1 + 2 --> Current console print 3'
    info[#info+1] = '! clicli.player(1):get_name() --> All consoles will print Player 1`s name on multiple tests'
    info[#info+1] = ''
    info[#info+1] = 'Enter `? `View this help'

    return table.concat(info, '\n')
end

---@param message string
local function print_to_console(message)
    consoleprint(message)
    clicli.develop.helper.print(message)
end

---@param ok boolean
---@param result any
---@return any
function M.show_result(ok, result)
    if not ok then
        print_to_console(result)
        return
    end
    if getmetatable(result) and getmetatable(result).__tostring then
        print_to_console(tostring(result))
        return
    end
    local view = clicli.inspect(result)
    if #view > 10000 then
        view = view:sub(1, 10000) .. '...'
    end
    print_to_console(view)
end

--Console input
---@param input string
function M.input(input)
    if input == '?' then
        print_to_console(M.getHelpInfo())
        return
    end

    if input:sub(1, 1) == '.' then
        clicli.player.with_local(function (local_player)
            clicli.sync.send('$command', {
                input = input,
                player = local_player,
            })
        end)
        return
    end

    if input:sub(1, 1) == '!' then
        local code = input:sub(2)
        clicli.develop.code.sync_run(code, nil, '$console')
        return
    end

    local ok, result = clicli.develop.code.run(input)
    M.show_result(ok, result)
end

clicli.game:event('Console - Input', function (trg, data)
    if not clicli.game.is_debug_mode() then
        return
    end
    local input = data.str1
    M.input(input)
end)

clicli.develop.code.on_sync('$console', {
    complete = function (suc, result, data)
        M.show_result(suc, result)
    end
})

clicli.sync.onSync('$command', function (data)
    if not clicli.game.is_debug_mode() then
        return
    end
    if type(data) ~= 'table' then
        return
    end
    if type(data.input) ~= 'string' then
        return
    end
    clicli.develop.command.input('.', data.input, data.player)
end)

---@param word string
---@return table<string, integer>
local function getUsedCharsSet(word)
    local usedChars = {}
    for i = 1, #word do
        local c = word:sub(i, i)
        usedChars[c] = (usedChars[c] or 0) + 1
    end
    return usedChars
end

---@param inputed string
---@param candidates string[]
---@return string[]
local function filterOut(inputed, candidates)
    if not inputed then
        return {}
    end
    local lownerInputed = inputed:lower()
    local inputChars = getUsedCharsSet(lownerInputed)
    local completes = {}
    for _, word in ipairs(candidates) do
        local lword = word:lower()
        local wordChars = getUsedCharsSet(lword)
        local notMatch = false
        for char, count in pairs(inputChars) do
            if (wordChars[char] or 0) < count then
                notMatch = true
                break
            end
        end
        if not notMatch then
            completes[#completes+1] = word
        end
    end

    if #completes == 0 then
        return completes
    end

    local getMatchScore = (function ()
        local cache = {}
        ---@param word string
        ---@return integer
        return function (word)
            if not cache[word] then
                local score = - #word
                for i = 1, #inputed do
                    if inputed:sub(i, i) == word:sub(i, i) then
                        if i == 1 then
                            score = score + 1000
                        else
                            score = score + 100
                        end
                    elseif lownerInputed:sub(i, i) == word:lower():sub(i, i) then
                        if i == 1 then
                            score = score + 100
                        else
                            score = score + 1
                        end
                    else
                        break
                    end
                end
                cache[word] = score
            end
            return cache[word]
        end
    end)()

    table.sort(completes, function (a, b)
        return getMatchScore(a) > getMatchScore(b)
    end)

    if getMatchScore(completes[1]) >= 100 then
        for i = 1, #completes do
            if getMatchScore(completes[i]) < 100 then
                completes[i] = nil
            end
        end
    end

    return completes
end

local function getFieldsOf(t)
    local fields = {}
    for k in pairs(t) do
        if type(k) == 'string' then
            fields[k] = true
        end
    end

    local mtMark = {}
    local function lookIntoMetaTable(mt)
        if mtMark[mt] then
            return
        end
        if type(mt) == 'table' and type(mt.__index) == 'table' then
            for k in pairs(mt.__index) do
                if type(k) == 'string' then
                    fields[k] = true
                end
            end
            lookIntoMetaTable(getmetatable(mt.__index))
        end
    end

    lookIntoMetaTable(getmetatable(t))

    return clicli.util.getTableKeys(fields, true)
end

local function requestWordsByField(words)
    local current = _G
    for i = 1, #words - 1 do
        current = current[words[i]]
        if type(current) ~= 'table' then
            return {}
        end
    end
    local fields = getFieldsOf(current)
    return fields
end

local function requestWordsByKeyWord(words)
    if #words > 1 then
        return {}
    end
    return {'if', 'else', 'elseif', 'for', 'while', 'repeat', 'until', 'function', 'local', 'return', 'break', 'do', 'end', 'then', 'in', 'nil', 'true', 'false', 'and', 'or', 'not'}
end

local function mergeAndRemoveDuplicate(...)
    local result = {}
    local mark = {}
    for _, words in ipairs({...}) do
        for _, word in ipairs(words) do
            if not mark[word] then
                mark[word] = true
                result[#result+1] = word
            end
        end
    end
    return result
end

---@param input string
---@return string[]
local function parseWords(input)
    local nearestTokens = input:match '[%w_%.%:%s]*$'
    if nearestTokens:match '^%s*[%.%:]' then
        return {}
    end
    local tokens = {}
    local pos = 1
    for _ = 1, 10000 do
        pos = nearestTokens:match('()%S', pos) or pos
        if pos > #nearestTokens then
            break
        end
        local word, newPos = nearestTokens:match('([%a_][%w_]*)()', pos)
        if word then
            tokens[#tokens+1] = word
            pos = newPos
        end
        local symbol, newPos = nearestTokens:match('([%.%:])()', pos)
        if symbol then
            tokens[#tokens+1] = symbol
            pos = newPos
        end
    end
    if #tokens == 0 then
        return {}
    end
    local words = {}
    local expectSymbol, expectWord
    for i = #tokens, 1, -1 do
        if tokens[i] == '.'
        or tokens[i] == ':' then
            if expectWord then
                break
            end
            expectSymbol = false
            expectWord = true
            if i == #tokens then
                words[#words+1] = ''
            end
        elseif tokens[i]:match '[%w_]+' then
            if expectSymbol then
                break
            end
            expectSymbol = true
            expectWord = false
            words[#words+1] = tokens[i]
        else
            break
        end
    end
    clicli.util.revertArray(words)
    return words
end

---@param inputed string
---@return string[]
local function requestWords(inputed)
    local words = parseWords(inputed)
    local result1 = requestWordsByField(words)
    local result2 = requestWordsByKeyWord(words)
    local mergedResult = mergeAndRemoveDuplicate(result1, result2)
    local resultFields = filterOut(words[#words], mergedResult)
    local completes = {}
    for i, field in ipairs(resultFields) do
        completes[i] = inputed:sub(1, -#words[#words] - 1) .. field
    end
    return completes
end

clicli.game:event('Console - Request completion', function (trg, data)
    if not clicli.game.is_debug_mode() then
        return
    end
    local input = data.str1

    if input == '?' then
        return
    end

    if input:sub(1, 1) == '.' then
        local commands = clicli.develop.command.getAllCommands()
        local words = {}
        for _, comman in ipairs(commands) do
            words[#words+1] = '.' .. comman
        end
        local completes = filterOut(input, words)
        console_tips_match(table.concat(completes, '\x01'))
        return
    end

    local completes = requestWords(input)
    console_tips_match(table.concat(completes, '\x01'))
end)

clicli.game:event_on('$CliCli- Initialize', function ()
    consoleprint(M.getHelpInfo())
end)

return M
