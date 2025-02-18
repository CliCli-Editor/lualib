local M = {}

---@type fun(mesg: string)
M.print = log.debug

local state = ''
local limit = 500 * 1000
local incre_count = 0
local last_mem = collectgarbage 'count'

local function change_to_generational()
    local c1 = python.debug_ns_timestamp()
    state = 'generation'
    collectgarbage('generational', 20, 500)
    collectgarbage('stop')
    local mem = collectgarbage 'count'
    limit = mem * 2
    local c2 = python.debug_ns_timestamp()
    M.print(('Switching to generational recycling, time: % 7.3fms'):format((c2 - c1) / 1000000))
    M.print(('Current memory limit: % 7.3fM'):format(limit / 1000))
end

local function change_to_incremental()
    --collectgarbage()
    local c1 = python.debug_ns_timestamp()
    state = 'increment'
    incre_count = 0
    collectgarbage('incremental', 100, 100, 13)
    collectgarbage('stop')
    last_mem = collectgarbage 'count'
    local c2 = python.debug_ns_timestamp()
    M.print(('Switching to incremental reclamation takes % 7.3fms'):format((c2 - c1) / 1000000))
end

local function do_collect()
    local mem = collectgarbage 'count'
    if state == 'generation' then
        if mem > limit then
            change_to_incremental()
            return
        end
        local delta = mem - last_mem
        collectgarbage('step', math.floor(delta))
        mem = collectgarbage 'count'
        last_mem = mem
    elseif state == 'increment' then
        local full = collectgarbage('step')
        mem = collectgarbage 'count'
        last_mem = mem

        if full then
            M.print('An increment cycle is completed')
            state = 'Switch to generational'
        else
            incre_count = incre_count + 1
            if incre_count > 300 then
                M.print('The incremental period times out. The switchover is forced back to the generation')
                state = 'Switch to generational'
            end
        end
    elseif state == 'Switch to generational' then
        change_to_generational()
    end
end

local function full_collect()
    M.print('Start full recovery')
    local c1 = python.debug_ns_timestamp()
    if state == 'generation' then
        collectgarbage()
    elseif state == 'increment' then
        collectgarbage()
        change_to_generational()
    end
    last_mem = collectgarbage 'count'
    local c2 = python.debug_ns_timestamp()
    M.print(('Full recovery complete, time: % 7.3fms'):format((c2 - c1) / 1000000))
end

local function step_collector()
    local c1 = python.debug_ns_timestamp()

    do_collect()

    local c2 = python.debug_ns_timestamp()
    local ns = c2 - c1

    if M.log then
        M.log:write(string.format('%s\t% 7.3fms\t% 7.3fM\n', state, ns / 1000000, collectgarbage('count') / 1000))
        M.log:flush()
    end
end

---@private
M._stated = false

---@private
M._inited = false

---@private
function M.init()
    if M._inited then
        return
    end
    M._inited = true
    ---@private
    M.log = io.open(script_path:match('^(.-)%?') .. '/.log/gctrace.log', 'w+b')
        or  io.open('gctrace.log', 'w+b')

    if M.log then
        M.log:setvbuf 'no'
        M.print = function (msg)
            M.log:write(msg, '\n')
            M.log:flush()
        end
    end

    change_to_generational()
    collectgarbage()
    last_mem = collectgarbage 'count'
end

---Enable automatic recycling
function M.start()
    M.init()
    ---@private
    M.timer = M.timer or clicli.ctimer.loop_frame(13, function (timer, count)
        step_collector()
    end)
end

---Deactivate automatic recovery
function M.stop()
    if M.timer then
        M.timer:remove()
        M.timer = nil
    end
end

---Do a recycling immediately
function M.step()
    M.init()
    step_collector()
end

---Full recovery immediately
function M.full()
    M.init()
    full_collect()
end

return M
