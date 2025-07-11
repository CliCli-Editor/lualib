---@class Log
---@field private file? file*
---@field private option Log.Option
---@field private logLevel table<Log.Level, integer>
---@field private needTraceBack table<Log.Level, boolean>
---@field verb  fun(...) : string, string
---@field trace fun(...) : string, string
---@field debug fun(...) : string, string
---@field info  fun(...) : string, string
---@field warn  fun(...) : string, string
---@field error fun(...) : string, string
---@field fatal fun(...) : string, string
---@field print fun(...) : string, string
---@overload fun(option: Log.Option): Log
local M = Class 'Log'

--Set the maximum size of log files
M.maxSize = 100 * 1024 * 1024

---@private
M.usedSize = 0

---@type Log.Level
M.level = 'debug'

---@private
M.clock = os.clock

---@private
M.messageFormat = '[%s][%5s][%s]: %s\n'

---@enum (key) Log.Level
M.logLevel = {
    verb  = 0,
    trace = 1,
    debug = 2,
    info  = 3,
    warn  = 4,
    error = 5,
    fatal = 6,
}

M.needTraceBack = {
    trace = true,
    error = true,
    fatal = true,
}

--Whether to print to a log file
M.enable = true

---@param a  table
---@param b? table
---@return table
local function merge(a, b)
    local new = {}
    for k, v in pairs(a) do
        new[k] = v
    end
    if b then
        for k, v in pairs(b) do
            new[k] = v
        end
    end
    return new
end

---@class Log.Option
---@field maxSize? integer # Maximum size of the log file
---@field path? string # The path of the log file can be either file or log file
---@field file? file* # Log file object, choose either path or log file object
---@field print? fun(level: Log.Level, message: string, timeStamp: string) # Additional print callbacks
---@field level? Log.Level # Log level. Logs below this level are not recorded
---@field logLevel? table<Log.Level, integer> # Customize log levels
---@field needTraceBack? table<Log.Level, boolean> # Whether to print stack information
---@field clock? fun(): number # To get the current time, it needs to be accurate to milliseconds
---@field startTime? integer # The timestamp at the beginning of the log, if not provided, is obtained using 'os.time'
---@field traceback? (fun(message: string, level: integer): string) # Get the stack function, default is debug.traceback

---@param path string
---@param mode openmode
---@return file*?
---@return string? errmsg
local function ioOpen(path, mode)
    if not io then
        return nil, 'No io module'
    end
    if not io.open then
        return nil, 'No io.open'
    end
    local file, err
    local suc, res = pcall(function ()
        file, err = io.open(path, mode)
    end)
    if not suc then
        return nil, res
    end
    return file, err
end

---@param option Log.Option
function M:__init(option)
    self.maxSize = option.maxSize
    self.level   = option.level
    self.clock = option.clock
    ---@private
    self.option = option
    if option.file then
        self.file = option.file
    else
        if option.path then
            local file, err = ioOpen(option.path, 'w+b')
            if file then
                self.file = file
                self.file:setvbuf 'no'
            elseif err then
                self:applyPrint('warn', err, self:getTimeStamp())
            end
        end
    end
    ---@private
    self.logLevel = merge(M.logLevel, option.logLevel)
    ---@private
    self.needTraceBack = merge(M.needTraceBack, option.needTraceBack)

    for level in pairs(self.logLevel) do
        self[level] = function (...)
            return self:build(level, 0, ...)
        end
    end
    self.print = function (...)
        return self:build('debug', 1, ...)
    end
    ---@private
    self.startClock = self.clock()
    ---@private
    self.startTime  = option.startTime or os.time()
end

---@private
---@return string
function M:getTimeStamp()
    local deltaClock = self.clock() - self.startClock
    local deltaSec, ms = math.modf(deltaClock)
    local sec = self.startTime + deltaSec
    local timeStamp = os.date('%m-%d %H:%M:%S', sec) --[[@as string]]
    timeStamp = ('%s.%03.f'):format(timeStamp, ms * 1000)
    return timeStamp
end

---@private
M.lockPrint = false

---@private
---@param level string
---@param message string
---@param timeStamp string
function M:applyPrint(level, message, timeStamp)
    if self.option.print then
        if M.lockPrint then
            return
        end
        M.lockPrint = true
        pcall(self.option.print, level, message, timeStamp)
        M.lockPrint = false
    end
end

---@private
---@param level string
---@param exStack integer
---@param ... any
---@return string message
---@return string timestamp
function M:build(level, exStack, ...)
    local t = table.pack(...)
    for i = 1, t.n do
        t[i] = tostring(t[i])
    end
    local message = table.concat(t, '\t', 1, t.n)

    if self.needTraceBack[level] then
        if debug.getinfo(1, "t").istailcall then
            message = (self.option.traceback or debug.traceback)(message, 2 + exStack)
        else
            message = (self.option.traceback or debug.traceback)(message, 3 + exStack)
        end
    end

    local timeStamp = self:getTimeStamp()

    if self.logLevel[level] < self.logLevel[self.level] then
        return message, timeStamp
    end

    self:applyPrint(level, message, timeStamp)

    if not self.file then
        return message, timeStamp
    end

    if not self.enable then
        return message, timeStamp
    end

    local info = debug.getinfo(2 + exStack, 'Sl')
    local sourceStr
    if info.currentline == -1 then
        sourceStr = '?'
    else
        sourceStr = ('%s:%d'):format(info.short_src, info.currentline)
    end
    local fullMessage = self.messageFormat:format(timeStamp, level, sourceStr, message)
    self.usedSize = self.usedSize + #fullMessage
    if self.usedSize > self.maxSize then
        self.file:write('[REACH MAX SIZE]!')
        self.file:close()
        self.file = nil
    else
        self.file:write(fullMessage)
    end

    return message, timeStamp
end
