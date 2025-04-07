---@class Await
local M = {}

---@type fun(traceback: string)
local errorHandler = function () end

---@type fun(time: number, callback: fun())?
local waker

local function presume(co, ...)
    local suc, err = coroutine.resume(co, ...)
    if not suc then
        errorHandler(debug.traceback(co, err))
    end
end

---@class Await.API
local API = {}

--The current coroutine sleeps for a while
---@async
---@param time number
function API.sleep(time)
    if not waker then
        error('You need to try setSleepWaker to set up the wakeup device first')
    end
    if not coroutine.isyieldable() then
        errorHandler(debug.traceback('Current coroutine cannot be relinquished!'))
        return
    end
    local co = coroutine.running()
    waker(time, function ()
        if coroutine.status(co) ~= 'suspended' then
            return
        end
        presume(co)
    end)
    coroutine.yield()
end

--Current coroutine relinquishes
---@async
---@param callback fun(resume: fun(...)) # The current coroutine is relinquished until resume is called. The argument passed by calling resume will be the return value of the current coroutine.
---@return ...
function API.yield(callback)
    local co = coroutine.running()
    local resolved, yielded, fastResults
    local function resume(...)
        if resolved then
            return
        end
        resolved = true
        if yielded then
            if coroutine.status(co) ~= 'suspended' then
                return
            end
            presume(co, ...)
        else
            fastResults = table.pack(...)
        end
    end
    callback(resume)
    if resolved then
        return table.unpack(fastResults, 1, fastResults.n)
    else
        yielded = true
        return coroutine.yield()
    end
end

---@param callback async fun()
---@return thread
function API.call(callback)
    local co = coroutine.create(callback)
    presume(co)
    return co
end

---The current coroutine waits for multiple asynchronous functions to complete execution
---@async
---@param callbacks async fun()[]
---@return [boolean, ...] []
function API.waitAll(callbacks)
    if not waker then
        error('You need to try setSleepWaker to set up the wakeup device first')
    end
    local cur = coroutine.running()
    local cos = {}
    local results = {}
    for i = 1, #callbacks do
        local callback = callbacks[i]
        local co = coroutine.create(function ()
            results[i] = xpcall(callback, errorHandler)
            cos[i] = nil
            if not next(cos) and coroutine.status(cur) == 'suspended' then
                presume(cur)
            end
        end)
        cos[i] = co
        coroutine.resume(co)
    end
    if next(cos) then
        coroutine.yield()
    end
    return results
end

--Set error handler
---@param handler fun(traceback: string) # When an error occurs, this function is called with the error stack as an argument
function API.setErrorHandler(handler)
    errorHandler = handler
end

--Set the wakeup
---@param f fun(time: number, callback: fun()) # You need to pass in a timer implementation function. When the time is up, the implementation function needs to call the callback.
function API.setSleepWaker(f)
    waker = f
end

return API
