--Cheat instruction
--
--This feature is only available in development mode
---@class Develop.Command
local M = Class 'Develop.Command'

---@class Develop.Command.ExecuteParam
---@field command string # Input command (same as input, case status is not guaranteed)
---@field args string[] # Command parameter
---@field player? Player # The player who invokes the command

---@class Develop.Command.InfoParam
---@field onCommand? fun(...)
---@field onCommandEX? fun(param: Develop.Command.ExecuteParam)
---@field needSync? boolean
---@field priority? number
---@field desc? string

---@class Develop.Command.Info: Develop.Command.InfoParam
---@field name string
---@field priority number


---@private
---@type table<string, Develop.Command.Info>
M.commands = {}

--Register cheat instruction (instruction name is case insensitive)
---@param command string
---@param info Develop.Command.InfoParam|function
function M.register(command, info)
    local lname = command:lower()
    if type(info) == 'function' then
        info = {
            onCommand = info,
        }
    end
    ---@cast info Develop.Command.Info
    info.name = lname
    info.priority = info.priority or 0
    M.commands[lname] = info
end

---@param reload Reload
local function remove_all_triggers_in_include(reload)
    local event_manager = clicli.game:get_event_manager()
    for trigger in event_manager:pairs() do
        local name = trigger:get_include_name()
        if reload:isValidName(name) then
            trigger:remove()
        end
    end
end

---@param reload Reload
local function remove_all_custom_triggers_in_include(reload)
    local event_manager = clicli.game:get_custom_event_manager()
    if not event_manager then
        return
    end
    for trigger in event_manager:pairs() do
        local name = trigger:get_include_name()
        if reload:isValidName(name) then
            trigger:remove()
        end
    end
end

---@param reload Reload
local function remove_all_timers_in_include(reload)
    for timer in clicli.timer.pairs() do
        local name = timer:get_include_name()
        if reload:isValidName(name) then
            timer:remove()
        end
    end
end

---@param reload Reload
local function remove_all_local_timers_in_include(reload)
    for timer in clicli.ltimer.pairs() do
        local name = timer:get_include_name()
        if reload:isValidName(name) then
            timer:remove()
        end
    end
end

---@param reload Reload
local function remove_all_client_timers_in_include(reload)
    for timer in clicli.ctimer.pairs() do
        local name = timer:get_include_name()
        if reload:isValidName(name) then
            timer:remove()
        end
    end
end

M.register('RD', {
    needSync = true,
    priority = 100,
    desc = 'Override all script files loaded with `include` and clean up their global timers and triggers.',
    onCommand = function ()
        clicli.reload.reload()
    end,
})

M.register('SS', {
    desc = 'Generate a memory snapshot',
    onCommand = function (extraInfo)
        clicli.doctor.toString('onlylua', 'onlylua')
        local reports = clicli.doctor.report()
        local lines = {}
        lines[#lines+1] = '===GCObject==='
        for _, report in ipairs(reports.report) do
            lines[#lines+1] = string.format('%16s(%d): %s'
                , report.point
                , report.count
                , report.name
            )
        end
        if extraInfo then
            lines[#lines+1] = '===WeakTable==='
            lines[#lines+1] = string.format('TotalSize: %d', reports.weakTableInfo.totalSize)
            for _, info in ipairs(reports.weakTableInfo.tables) do
                lines[#lines+1] = string.format('%16s(%d): %s'
                    , info.point
                    , info.size
                    , info.name
                )
            end

            lines[#lines+1] = '===GCTable==='
            lines[#lines+1] = string.format('TotalCount: %d', #reports.gcTableInfo.tables)
            for _, info in ipairs(reports.gcTableInfo.tables) do
                lines[#lines+1] = string.format('%16s: %s => %s'
                    , info.point
                    , info.name
                    , info.gc
                )
            end

            lines[#lines+1] = '===String==='
            lines[#lines+1]  = string.format('TotalNum:  %d', reports.stringInfo.count)
            lines[#lines+1]  = string.format('TotalSize: %.3fKB', reports.stringInfo.totalSize / 1024)
            lines[#lines+1] = '===Large Strings==='
            for _, str in ipairs(reports.stringInfo.largeStrings) do
                lines[#lines+1] = string.format('(↓↓↓ Len = %.3fKB)\n%s...\n(↑↑↑ Len = %.3fKB)', #str / 1024, str:sub(1, 1000), #str / 1024)
            end
        end
        lines[#lines+1] = '===Finish==='
        local content = table.concat(lines, '\n')
        ---@diagnostic disable-next-line: undefined-global
        clicli.fs.save('.log/snapshot.txt', content)
        log.debug('The snapshot is saved to script/.log/snapshot.txt')
    end
})

M.register('CT', {
    desc = 'Query a reference to an object',
    onCommand = function (...)
        collectgarbage()
        collectgarbage()
        clicli.doctor.toString('onlylua', 'onlylua')
        local results = clicli.doctor.catch(...)
        local lines = {}
        for _, result in ipairs(results) do
            result[1] = 'root'
            lines[#lines+1] = table.concat(result, '\n\t')
        end
        local content = table.concat(lines, '\n')
        ---@diagnostic disable-next-line: undefined-global
        clicli.fs.save('.log/catch.txt', content)
        log.debug('The snapshot is saved to script/.log/ cat.txt')
    end
})

M.register('RR', {
    desc = 'Restart the game',
    onCommand = function ()
        clicli.sync.send('$restart')
    end
})

local hasRestartd = false
clicli.sync.onSync('$restart', function ()
    if hasRestartd then
        return
    end
    hasRestartd = true
    clicli.game.restart_game()
end)

clicli.reload.onBeforeReload(function (reload, willReload)
    remove_all_triggers_in_include(reload)
    remove_all_custom_triggers_in_include(reload)
    remove_all_timers_in_include(reload)
    remove_all_local_timers_in_include(reload)
    remove_all_client_timers_in_include(reload)
end)

clicli.game:event('Player - Send message', function (trg, data)
    M.input('.', data.str1, data.player)
end)

--Enter cheat instruction
---@param prefix string
---@param input string
---@param player? Player
function M.input(prefix, input, player)
    if not clicli.game.is_debug_mode() then
        return
    end
    if not clicli.util.stringStartWith(input, prefix) then
        return
    end

    local content = input:sub(1 + #prefix)
    local strs = {}
    for str in content:gmatch('[^%s]+') do
        strs[#strs+1] = str
    end

    if #strs == 0 then
        return
    end

    local command = table.remove(strs, 1):lower()
    local info = M.commands[command]
    if not info then
        return
    end
    M.executeEX {
        command = command,
        args = strs,
        player = player,
        info = info,
    }
end

--Execute cheat instruction
---@param command string
---@param ... any
function M.execute(command, ...)
    M.executeEX {
        command = command,
        args = {...},
    }
end

--Execute cheat instruction
---@param param Develop.Command.ExecuteParam
function M.executeEX(param)
    local command = param.command:lower()
    local info = M.commands[command]
    assert(info, 'Cheat instruction does not exist:' .. param.command)
    M.params = param
    if info.onCommand then
        info.onCommand(table.unpack(param.args))
    end
    if info.onCommandEX then
        info.onCommandEX(param)
    end
end

---@param command string
---@return Develop.Command.Info?
function M.getCommandInfo(command)
    local lname = command:lower()
    return M.commands[lname]
end

---@return string[]
function M.getAllCommands()
    return clicli.util.getTableKeys(M.commands, function (a, b)
        return M.getCommandInfo(a).priority > M.getCommandInfo(b).priority
    end)
end

---@return Develop.Command.ExecuteParam
function M.getParams()
    return M.params
end

return M
