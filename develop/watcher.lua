---@class Develop.TimerWatcher
local TMR = Class 'Develop.TimerWatcher'

---@return table<string, { all: integer, alive: integer }>
function TMR.count()
    local result = {}

    for _, mod in ipairs {'timer', 'ltimer', 'ctimer'} do
        local all = 0
        local alive = 0
        for _, timer in pairs(clicli[mod].all_timers) do
            all = all + 1
            if IsValid(timer) then
                alive = alive + 1
            end
        end
        result[mod] = { all = all, alive = alive }
    end

    return result
end

---@class Develop.TriggerWatcher
local TRG = Class 'Develop.TriggerWatcher'

---@return { all: integer, alive: integer }
function TRG.count()
    local all = 0
    local alive = 0

    local triggerModule = require 'clicli.util.trigger'

    for _, trigger in pairs(triggerModule.all_triggers) do
        all = all + 1
        if IsValid(trigger) then
            alive = alive + 1
        end
    end

    return { all = all, alive = alive }
end

--Start monitor trigger
function TRG.start()
    if TRG.activeWatcher then
        return
    end
    ---@type Develop.TriggerWatcherInstance
    TRG.activeWatcher = New 'Develop.TriggerWatcherInstance' ()
end

--Stop monitor trigger
function TRG.stop()
    if not TRG.activeWatcher then
        return
    end
    Delete(TRG.activeWatcher)
    TRG.lastWatcher = TRG.activeWatcher
end

--Obtain monitoring report
function TRG.report()
    local watcher = TRG.activeWatcher or TRG.lastWatcher
    if not watcher then
        return
    end
    return watcher:makeReport()
end

---@class Develop.TriggerWatcherInstance
local TRGI = Class 'Develop.TriggerWatcherInstance'

function TRGI:__init()
    local triggerModule = require 'clicli.util.trigger'
    --Start time (milliseconds)
    self.startTime = clicli.ltimer.clock()
    self.originalExecute = triggerModule.execute

    local index = 0
    local runnedClock    = {}
    local runnedCost     = {}
    local runnedCallback = {}

    self.runnedClock    = runnedClock
    self.runnedCost     = runnedCost
    self.runnedCallback = runnedCallback

    local ltimerClock = clicli.ltimer.clock
    local osClock = os.clock_banned

    ---@diagnostic disable-next-line: duplicate-set-field
    triggerModule.execute = function (trg, ...)
        index = index + 1
        runnedClock[index] = ltimerClock()
        local c1 = osClock()
        ---@diagnostic disable-next-line: invisible
        runnedCallback[index] = trg._callback
        local a, b, c, d = self.originalExecute(trg, ...)
        runnedCost[index] = osClock() - c1
        return a, b, c, d
    end
end

function TRGI:__del()
    --End time (milliseconds)
    self.endTime = clicli.ltimer.clock()
    local triggerModule = require 'clicli.util.trigger'
    triggerModule.execute = self.originalExecute
end

---@param inTime? number # Only the last X seconds are counted
---@param topCount? integer # The positions of the first X functions that take the longest time are counted
---@return { count: integer, cost: number, time: number, average: number, tops? : string[] }
function TRGI:makeReport(inTime, topCount)
    local report = {}

    return report
end


return {
    timerWatcher = TMR,
    triggerWatcher = TRG,
}
