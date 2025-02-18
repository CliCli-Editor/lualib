local watcher = require 'clicli.develop.watcher'
local attr    = require 'clicli.develop.helper.attr'
local helper  = require 'clicli.develop.helper.helper'

---@class Develop.Helper.Explorer
local M = Class 'Develop.Helper.Explorer'

---@type number
M.gameSpeed = M.gameSpeed or 4

M.gameSpeedApply = M.gameSpeedApply or false

M.gamePaused = M.gamePaused or false

function M.createGameSpeed()
    return clicli.develop.helper.createTreeNode('speed', {
        description = string.format('%.1f', M.gameSpeed),
        tooltip = 'Game speed',
        onClick = function (node)
            clicli.develop.helper.createInputBox {
                title = 'Set the game speed',
                value = string.format('%.1f', M.gameSpeed),
                validateInput = function (value)
                    if not tonumber(value) then
                        return 'Please enter the number'
                    end
                    if tonumber(value) < 0 then
                        return 'The velocity cannot be less than 0'
                    end
                    if tonumber(value) > 100 then
                        return 'The speed cannot be greater than 100'
                    end
                    return nil
                end,
            } :show(function (value)
                local newSpeed = tonumber(value)
                if not newSpeed or newSpeed < 0 or newSpeed > 100 then
                    return
                end
                clicli.sync.send('$game_speed', newSpeed)
            end)
        end,
        check = M.gameSpeedApply,
        onCheck = function (node)
            clicli.sync.send('$game_speed_apply', true)
        end,
        onUnCheck = function (node)
            clicli.sync.send('$game_speed_apply', false)
        end,
    })
end

function M.createGamePause()
    return clicli.develop.helper.createTreeNode('Pause', {
        icon = 'debug-pause',
        onClick = function (node)
            clicli.sync.send('$game_pause', not M.gamePaused)
        end,
    })
end

---@return Develop.Helper.TreeNode
function M.createGameTimer()
    local function formatTime(sec)
        local hour = sec // 3600
        local min  = sec % 3600 // 60
        local s    = sec % 60
        return string.format('%02d:%02d:%02d', hour, min, s)
    end
    local node = clicli.develop.helper.createTreeNode('time', {
        icon = 'clock',
        description = formatTime(clicli.ltimer.clock() // 1000),
        childsGetter = function ()
            M.gameSpeedButton = M.createGameSpeed()
            M.gamePauseButton = M.createGamePause()
            return {
                M.gameSpeedButton,
                M.gamePauseButton,
            }
        end
    })
    node:bindGC(clicli.ltimer.loop(1, function ()
        node.description = formatTime(clicli.ltimer.clock() // 1000)
    end))
    return node
end

---@param source Player
local function updateGameSpeed(source)
    local speed = M.gameSpeedApply and M.gameSpeed or 1
    print(string.format('%s changes the game speed to: %.1f', source, speed))
    GameAPI.api_set_time_scale(speed)
end

---@param speed number
---@param source Player
clicli.sync.onSync('$game_speed', function (speed, source)
    M.gameSpeed = speed
    if M.gameSpeedButton then
        M.gameSpeedButton.description = string.format('%.1f', M.gameSpeed)
    end
    updateGameSpeed(source)
end)

---@param apply boolean
---@param source Player
clicli.sync.onSync('$game_speed_apply', function (apply, source)
    M.gameSpeedApply = apply
    if M.gameSpeedButton then
        M.gameSpeedButton.check = apply
    end
    updateGameSpeed(source)
end)

clicli.sync.onSync('$game_pause', function (pause, source)
    M.gamePaused = pause
    if pause then
        print(string.format('%s pauses the game', source))
        clicli.game.enable_soft_pause()
    else
        print(string.format('%s continued the game', source))
        clicli.game.resume_soft_pause()
    end
    if M.gamePauseButton then
        if pause then
            M.gamePauseButton.name = 'continue'
            M.gamePauseButton.icon = 'debug-start'
        else
            M.gamePauseButton.name = 'Pause'
            M.gamePauseButton.icon = 'debug-pause'
        end
    end
end)

---@return Develop.Helper.TreeNode
function M.createMemoryWatcher()
    local function getMemory()
        local mem = collectgarbage 'count'
        return string.format('%.2f MB', mem / 1000)
    end

    local node = clicli.develop.helper.createTreeNode('Memory footprint', {
        icon = 'eye',
        description = getMemory(),
        tooltip = 'Only the memory usage of Lua is collected',
    })
    node:bindGC(clicli.ctimer.loop(1, function ()
        node.description = getMemory()
    end)):execute()

    return node
end

---@return Develop.Helper.TreeNode
function M.createTimerWatcher()
    ---@type table<string, Develop.Helper.TreeNode>
    local subNodes = {}
    for _, mod in ipairs {'timer', 'ltimer', 'ctimer'} do
        subNodes[mod] = clicli.develop.helper.createTreeNode(mod)
    end

    local node = clicli.develop.helper.createTreeNode('timepiece', {
        icon = 'watch',
        tooltip = 'Number of timers held by Lua (in parentheses are the number removed but not yet reclaimed by Lua)',
        childs = {
            subNodes['timer'],
            subNodes['ltimer'],
            subNodes['ctimer'],
        },
    })

    node:bindGC(clicli.ctimer.loop(1, function ()
        local counts = watcher.timerWatcher.count()
        local all = 0
        local alive = 0
        for mod, count in pairs(counts) do
            subNodes[mod].description = string.format('Quantity: %d(%d)', count.alive, count.all - count.alive)
            all = all + count.all
            alive = alive + count.alive
        end
        node.description = string.format('Total: %d(%d)', alive, all - alive)
    end)):execute()

    return node
end

---@return Develop.Helper.TreeNode
function M.createTriggerWatcher()
    local node = clicli.develop.helper.createTreeNode('flip-flop', {
        icon = 'eye',
        tooltip = 'Number of triggers held by Lua (in parentheses are the number removed but not yet reclaimed by Lua)',
    })

    node:bindGC(clicli.ctimer.loop(1, function ()
        local count = watcher.triggerWatcher.count()
        node.description = string.format('Total: %d(%d)', count.alive, count.all - count.alive)
    end)):execute()

    return node
end

---@return Develop.Helper.TreeNode
function M.createRefWatcher()
    local reflib = require 'clicli.util.ref'

    local function countTable(t)
        local n = 0
        for _ in pairs(t) do
            n = n + 1
        end
        return n
    end

    local node = clicli.develop.helper.createTreeNode('quote', {
        icon = 'list-selection',
        tooltip = 'Number of objects held by Lua (alive | dead | not reclaimed)',
        childsGetter = function (node)
            local childs = {}
            for className, ref in clicli.util.sortPairs(reflib.all_managers) do
                ---@type ClientTimer?
                local timer
                childs[#childs+1] = clicli.develop.helper.createTreeNode(className, {
                    onVisible = function (child)
                        timer = clicli.ctimer.loop(1, function ()
                            ---@diagnostic disable-next-line: invisible
                            local strongCount = countTable(ref.strongRefMap)
                            ---@diagnostic disable-next-line: invisible
                            local weakCount   =countTable(ref.weakRefMap)

                            child.description = string.format('%d | %d'
                                , strongCount
                                , weakCount
                            )
                        end)
                        timer:execute()
                    end,
                    onInvisible = function (child)
                        if timer then
                            timer:remove()
                            timer = nil
                        end
                    end,
                })
            end
            return childs
        end,
        onInit = function (node)
            local last = countTable(reflib.all_managers)
            node:bindGC(clicli.ctimer.loop(1, function (timer, count, local_player)
                local now = countTable(reflib.all_managers)
                if now ~= last then
                    last = now
                    node:refresh()
                end
            end))
        end
    })

    return node
end

function M.createTracy()
    return clicli.develop.helper.createTreeNode('Activate Tracy', {
        icon = 'rss',
        tooltip = 'The performance analysis of Lua will greatly affect the operating efficiency',
        onClick = function ()
            enable_lua_profile(true)
            helper.request('createTracy', {})
        end,
    })
end

function M.createReloadButton()
    local node = clicli.develop.helper.createTreeNode('Heavy duty Lua', {
        icon = 'refresh',
        tooltip = 'Save you by typing `.rd `',
        onClick = function ()
            clicli.develop.command.execute('RD')
        end,
    })

    return node
end

function M.createRestartGameButton()
    local node = clicli.develop.helper.createTreeNode('Restart the game', {
        icon = 'warning',
        tooltip = 'Save you by typing `.rr `',
        onClick = function ()
            clicli.develop.command.execute('RR')
        end,
    })

    return node
end

---Reassigning this variable redefines the layout. You can study the syntax yourself
M.attrLayout = [[
Life ${life} / ${maximum life}
    Maximum life
    Life recovery
    Percent health recovery
Magic ${magic} / ${Maximum magic}
    Maximum magic
    Magic recovery
Moving speed
Physical attack
    Attack speed
    Attack interval
    Attack range
    Critical Hit Chance
    Critical hit damage
    Physical penetration
    Physical penetration ratio
    Physical blood feeding
    Damage bonus
    Hit rate
Spell attack
    Spell attack
    Spell penetration
    Spell penetration ratio
    Spell sucking
    Cooling reduction
Defense ${Physical defense} | ${Spell defense}
    Physical defense
    Spell defense
    Bonus by healing
    Dodge rate
    Injury relief
Attributes ${Strength} | ${Agility} | ${Intelligence}
    strength
    Agility
    intelligence
    Primary attribute
Daytime visual field
    Daytime fan-field radius
    Angle of daytime fan-shaped field of view
    Night vision
    Radius of the fan field of view at night
    Angle of fan view at night
    True field of view
Custom attribute
    ...
]]

---@param layout string
---@return table[]
local function compileAttrLayout(layout)
    local used = {}
    local result = {
        childs = {},
    }
    local currentNode = result
    local function pushNode(name, desc, indent)
        if name == '...' then
            for attr in clicli.util.sortPairs(clicli.const.UnitAttr) do
                if not used[attr] then
                    local myNode = {
                        name = attr,
                        indent = indent,
                        childs = {},
                    }
                    myNode.parent = currentNode
                    currentNode.childs[#currentNode.childs+1] = myNode
                end
            end
        else
            local myNode = {
                name = name,
                desc = desc,
                indent = indent,
                childs = {},
            }
            myNode.parent = currentNode
            currentNode.childs[#currentNode.childs+1] = myNode
        end
    end
    for line in clicli.util.eachLine(layout) do
        local indent = line:match '^[ \t]*'
        local name, desc = line:match '^[ \t]*([^\t ]+)[ \t]*(.*)$'
        if not name then
            goto continue
        end
        if desc == '' then
            desc = nil
        end
        used[name] = true
        local lastNode = currentNode.childs[#currentNode.childs]
        if not lastNode or #indent == #lastNode.indent then
            pushNode(name, desc, indent)
        elseif #indent > #lastNode.indent then
            currentNode = lastNode
            pushNode(name, desc, indent)
        else
            while #indent < #lastNode.indent do
                currentNode = currentNode.parent
                lastNode = currentNode.childs[#currentNode.childs]
            end
            pushNode(name, desc, indent)
        end
        ::continue::
    end
    return result
end

local compiledAttrLayout

---@param unit Unit
---@param layout table
---@param nodes Develop.Helper.TreeNode[]
---@return Develop.Helper.TreeNode[]
local function makeAttrList(unit, layout, nodes)
    local list = {}

    for _, def in ipairs(layout.childs) do
        local node = clicli.develop.helper.createTreeNode(def.name, {
            description = def.desc,
            childsGetter = #def.childs > 0 and function (node)
                return makeAttrList(unit, def, nodes)
            end or nil,
            ---@param node Develop.Helper.TreeNode
            updateAttr = function (node)
                if not node:isVisible() then
                    return
                end
                local desc
                if def.desc then
                    desc = def.desc:gsub('${(.-)}', function (name)
                        local attr = unit:get_attr(name)
                        return string.format('%.2f', attr)
                    end)
                elseif clicli.const.UnitAttr[def.name] then
                    local attr = unit:get_attr(def.name)
                    desc = string.format('%.2f', attr)
                end
                node.description = desc
            end,
            onVisible = function (node)
                ---@diagnostic disable-next-line: undefined-field
                node.optional.updateAttr(node)
            end,
            onClick = clicli.const.UnitAttr[def.name] and function (node)
                attr.show_modify(unit, def.name, {
                    can_create_watch = true,
                })
            end or nil,
        })
        list[#list+1] = node
        nodes[#nodes+1] = node
    end

    return list
end

---@param unit Unit
---@return Develop.Helper.TreeNode
function M.createUnitButton(unit)
    local name = string.format('%s(%d)', unit:get_name(), unit:get_id())
    local attrNodes = {}

    local function update()
        for _, node in ipairs(attrNodes) do
            node.optional.updateAttr(node)
        end
    end

    local timer
    local node = clicli.develop.helper.createTreeNode(name, {
        childsGetter = function (node)
            if not compiledAttrLayout then
                compiledAttrLayout = compileAttrLayout(M.attrLayout)
            end

            local childs = makeAttrList(unit, compiledAttrLayout, attrNodes)

            update()

            return childs
        end,
        onExpand = function (node)
            update()
            timer = clicli.ltimer.loop(0.5, function ()
                update()
            end)
        end,
        onCollapse = function (node)
            timer:remove()
        end,
    })

    return node
end

function M.createSelectingButton()
    local list = clicli.linked_table.create()

    local node = clicli.develop.helper.createTreeNode('Selected unit', {
        icon = 'organization',
        onInit = function (node)
            local function updateSelecting()
                ---@type Unit?
                local first = list:getHead()
                if first then
                    node.description = string.format('%s(%d)', first:get_name(), first:get_id())
                else
                    node.description = 'Unselected unit'
                end
                node:refresh()
            end

            clicli.player.with_local(function (local_player)
                local ug = local_player:get_local_selecting_unit_group()
                if ug then
                    for _, unit in ipairs(ug:pick()) do
                        list:pushTail(unit)
                    end
                else
                    list:pushTail(local_player:get_local_selecting_unit())
                end

                updateSelecting()

                node:bindGC(clicli.game:event('Local - Select - Unit', function (trg, data)
                    list:pop(data.unit)
                    list:pushHead(data.unit)
                    updateSelecting()
                end))
                node:bindGC(clicli.game:event('Local - Select - Unit Group', function (trg, data)
                    local last
                    for _, unit in ipairs(data.unit_group_id_list:pick()) do
                        list:pop(unit)
                        if last then
                            list:pushAfter(unit, last)
                        else
                            list:pushHead(unit)
                        end
                        last = unit
                    end
                    updateSelecting()
                end))
            end)
        end,
        childsGetter = function (node)
            local childs = {}

            ---@param unit Unit
            for unit in list:pairsSafe() do
                if unit:is_exist() and #childs <= 10 then
                    childs[#childs+1] = M.createUnitButton(unit)
                else
                    list:pop(unit)
                end
            end

            return childs
        end,
    })
    return node
end

---@param name string
---@return Develop.Helper.TreeNode
function M.createRoot(name)
    local root = clicli.develop.helper.createTreeNode(name, {
        icon = 'account',
        childsGetter = function ()
            return {
                M.createReloadButton(),
                M.createRestartGameButton(),
                M.createGameTimer(),
                M.createMemoryWatcher(),
                M.createTimerWatcher(),
                M.createTriggerWatcher(),
                M.createRefWatcher(),
                M.createTracy(),
                M.createSelectingButton(),
            }
        end,
    })
    return root
end

---@return Develop.Helper.TreeView
function M.create()
    local treeView
    clicli.player.with_local(function (local_player)
        local name = string.format('Instrument Panel (%s)', local_player:get_name())
        clicli.reload.recycle(function (trash)
            treeView = trash(clicli.develop.helper.createTreeView(name, M.createRoot(name)))
        end)
    end)
    return treeView
end

return M
