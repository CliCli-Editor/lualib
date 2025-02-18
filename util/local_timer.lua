--Local timer
--
--Support asynchronous creation or callbacks (as long as you promise not to cause other out-of-sync issues)
--If it is executed synchronously, then synchronous callbacks are ensured
---@class LocalTimer
---@field private include_name? string
---@field package id integer
---@field private time number
---@field private mode LocalTimer.Mode
---@field private count integer
---@field private on_timer LocalTimer.OnTimer
---@field private init_ms integer
---@field private start_ms integer
---@field private target_ms number
---@field private removed? boolean
---@field private pausing? boolean
---@field private paused_at? number
---@field private waking_up? boolean
---@field private queue_index? integer
---@overload fun(time: number, mode: LocalTimer.Mode, count: integer, on_timer: LocalTimer.OnTimer): self
local M = Class 'LocalTimer'

---@alias LocalTimer.Mode 'second' | 'frame'
---@alias LocalTimer.OnTimer fun(timer: LocalTimer, count: integer)

---@private
M.all_timers = setmetatable({}, clicli.util.MODE_V)

---@private
M.runned_count = 0

---@private
M.total_fixed_ms = 0

---@private
M.paused_ms = 0

local cur_frame = 0
local cur_ms = 0
local id = 0

---@type table<integer, { [integer]: LocalTimer, need_sort? : true }>
local timer_queues = {}

---@param time number
---@param mode LocalTimer.Mode
---@param count integer
---@param on_timer LocalTimer.OnTimer
function M:__init(time, mode, count, on_timer)
    id = id + 1

    self.id = id
    self.time = time
    self.mode = mode
    self.count = count
    self.on_timer = on_timer
    self.include_name = clicli.reload.getCurrentIncludeName()
    self.init_ms = cur_ms
    self.target_ms = cur_ms
    self.start_ms = cur_ms

    M.all_timers[id] = self

    self:set_time_out()
end

function M:__del()
    self.removed = true
    self:pop()
end

---@private
function M:set_time_out()
    if self.removed or self.pausing then
        return
    end

    local next_time

    if self.mode == 'second' then
        next_time = self.time * (self.runned_count + 1) * 1000
    else
        next_time = self.time * (self.runned_count + 1) * 1000 // clicli.config.logic_frame
    end

    self.target_ms = self.init_ms
                   + next_time
                   + self.total_fixed_ms

    if self.changed_time_out_time then
        self.changed_time_out_time = nil
        local once_time

        if self.mode == 'second' then
            once_time = self.time * 1000
        else
            once_time = self.time * 1000 // clicli.config.logic_frame
        end

        local target_ms = cur_ms + once_time
        self.total_fixed_ms = self.total_fixed_ms + target_ms - self.target_ms
        self.target_ms = target_ms
    end

    self:push()
end

---@package
function M:wakeup()
    if self.removed or self.pausing then
        return
    end

    self.runned_count = self.runned_count + 1
    self.waking_up = true
    self:execute()
    self.waking_up = false
    if self.count > 0 and self.runned_count >= self.count then
        self:remove()
    end
    self.paused_ms = 0
    self.start_ms = cur_ms

    self:set_time_out()
end

---Immediate execution
function M:execute(...)
    xpcall(self.on_timer, log.error, self, self.runned_count, ...)
end

---Remove timer
function M:remove()
    Delete(self)
end

---@package
function M:push()
    self:pop()
    local ms = math.floor(self.target_ms)
    if ms <= cur_ms then
        ms = cur_ms + 1
    end
    local queue = timer_queues[ms]
    if not queue then
        queue = {}
        timer_queues[ms] = queue
    end
    local last = queue[#queue]
    if last and last.id > self.id then
        queue.need_sort = true
    end
    self.queue_pos = #queue + 1
    queue[self.queue_pos] = self
    self.queue_index = ms
end

---@package
function M:pop()
    local ms = self.queue_index
    local pos = self.queue_pos
    self.queue_index = nil
    self.queue_pos = nil
    local queue = timer_queues[ms]
    if not queue then
        return
    end
    local last = queue[#queue]
    if last == self then
        queue[pos] = nil
        return
    end
    queue[pos] = last
    queue[#queue] = nil
    last.queue_pos = pos
    queue.need_sort = true
end

---Pause timer
function M:pause()
    if self.pausing or self.removed then
        return
    end
    self.pausing = true
    self.paused_at = cur_ms
    self:pop()
end

---Recovery timer
function M:resume()
    if not self.pausing or self.removed then
        return
    end
    self.pausing = false
    local paused_ms = cur_ms - self.paused_at
    self.paused_ms = self.paused_ms + paused_ms
    self.total_fixed_ms = self.total_fixed_ms + paused_ms

    if not self.waking_up then
        self:set_time_out()
    end
end

---Whether it is running
function M:is_running()
    return  not self.removed
        and not self.pausing
end

---Get the elapsed time
---@return number
function M:get_elapsed_time()
    if self.removed then
        return 0.0
    end
    if self.waking_up then
        return (self.target_ms - self.start_ms - self.paused_ms) / 1000.0
    end
    if self.pausing then
        return (self.paused_at - self.start_ms - self.paused_ms) / 1000.0
    end
    return (cur_ms - self.start_ms - self.paused_ms) / 1000.0
end

---Get initial count
---@return integer
function M:get_init_count()
    return self.count
end

---Get remaining time
---@return number
function M:get_remaining_time()
    if self.removed or self.waking_up then
        return 0.0
    end
    if self.pausing then
        return (self.target_ms - self.paused_at) / 1000.0
    end
    return (self.target_ms - cur_ms) / 1000.0
end

---Set the remaining time (cannot be set when the timer expires)
---@param sec number
function M:set_remaining_time(sec)
    if self.removed or self.waking_up then
        return
    end
    local delta = sec * 1000 - self:get_remaining_time() * 1000
    self.target_ms = self.target_ms + delta
    self.total_fixed_ms = self.total_fixed_ms + delta
    self:set_time_out()
end

---Get residual count
---@return integer
function M:get_remaining_count()
    if self.count <= 0 then
        return -1
    end
    return self.count - self.runned_count
end

---Set the remaining count (values set to <= 0 will become no count limit)
---@param count integer
function M:set_remaining_count(count)
    self.count = self.runned_count + count
end

---Get timer cycle
---@return number
function M:get_time_out_time()
    return self.time
end

---Set timer period (effective from next cycle)
---@param time number
function M:set_time_out_time(time)
    self.time = time
    ---@private
    self.changed_time_out_time = true
end

---@return string?
function M:get_include_name()
    return self.include_name
end

---Wait for the execution time
---@param timeout number
---@param on_timer LocalTimer.OnTimer
---@return LocalTimer
function M.wait(timeout, on_timer)
    local timer = New 'LocalTimer' (timeout, 'second', 1, on_timer)
    return timer
end

---Wait for a certain number of frames before executing
---@param frame integer
---@param on_timer LocalTimer.OnTimer
---@return LocalTimer
function M.wait_frame(frame, on_timer)
    local timer = New 'LocalTimer' (frame, 'frame', 1, on_timer)
    return timer
end

---Loop execution
---@param timeout number
---@param on_timer LocalTimer.OnTimer
---@return LocalTimer
function M.loop(timeout, on_timer)
    local timer = New 'LocalTimer' (timeout, 'second', 0, on_timer)
    return timer
end

---Execute after a certain number of frames
---@param frame integer
---@param on_timer LocalTimer.OnTimer
---@return LocalTimer
function M.loop_frame(frame, on_timer)
    local timer = New 'LocalTimer' (frame, 'frame', 0, on_timer)
    return timer
end

---Loop execution, you can specify a maximum number of times
---@param timeout number
---@param count integer
---@param on_timer LocalTimer.OnTimer
---@return LocalTimer
function M.loop_count(timeout, count, on_timer)
    local timer = New 'LocalTimer' (timeout, 'second', count, on_timer)
    return timer
end

---You can specify the maximum number of frames to be executed after a certain number of frames
---@param frame integer
---@param count integer
---@param on_timer LocalTimer.OnTimer
---@return LocalTimer
function M.loop_count_frame(frame, count, on_timer)
    local timer = New 'LocalTimer' (frame, 'frame', count, on_timer)
    return timer
end

---Iterate over all timers for debugging purposes only (it may be possible to iterate over an invalid one)
---@return fun():LocalTimer?
function M.pairs()
    local timers = {}
    for _, timer in clicli.util.sortPairs(M.all_timers) do
        timers[#timers+1] = timer
    end
    local i = 0
    return function ()
        i = i + 1
        return timers[i]
    end
end

--Get current logic time (milliseconds)
---@return number
function M.clock()
    return cur_ms
end

---@type LocalTimer[]
local desk = {}
local function update_frame()
    cur_frame = cur_frame + 1

    local target_ms = cur_frame * 1000 // clicli.config.logic_frame
    for ti = cur_ms, target_ms do
        local queue = timer_queues[ti]
        if queue then
            cur_ms = ti
            if queue.need_sort then
                table.sort(queue, function (a, b)
                    return a.id < b.id
                end)
            end
            for i = 1, #queue do
                desk[i] = queue[i]
            end
            timer_queues[ti] = nil
            for i = 1, #desk do
                local t = desk[i]
                desk[i] = nil
                t:wakeup()
            end
        end
    end

    cur_ms = target_ms
end

function M.debug_fastward(frame_count)
    for _ = 1, frame_count do
        update_frame()
    end
end

---@diagnostic disable-next-line: deprecated
clicli.timer.loop_frame(1, update_frame)

return M
