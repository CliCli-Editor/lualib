--[[
    Event bus (EventBus)

    A lightweight observer pattern implementation for decoupling communication between modules。
    Typical scenario: Data layer change → Event bus → UI layer refresh

    Usage example：

    1. Obtain the global event bus
    ```lua
    local event = GamePlay.event
    ```

    2. Subscribe to events
    ```lua
    --Basic Subscription
    event:on("currency_change", function(data)
        self:refreshGold(data.gold)
    end)

    --Save the cancellation function for convenient cancellation in the future
    self._unsubscribe = event:on("currency_change", function(data)
        self:refreshGold(data.gold)
    end)
    ```

    3. Release event
    ```lua
    event:emit("currency_change", { gold = 100 })
    ```

    4. Unsubscribe
    ```lua
    --Method 1: Through the returned cancellation function
    self._unsubscribe()

    --Method 2: Manual cancellation
    event:off("currency_change", self._myCallback)

    --Method 3: Clear all listeners for a certain event
    event:clear("currency_change")
    ```

    5. One-time monitoring (automatically cancelled after being triggered once.）
    ```lua
    event:once("game_start", function()
        log.Info("TheGameHasStarted!")
    end)
    ```

    Design Description：
    - Use xpcall to protect callbacks, and a single callback exception will not affect other listeners
    - on() Return the unsubscribe function to avoid manually managing callback references
    - Supports once() for one-time listening, suitable for initializing scenarios
    - No built-in frame update/batch processing, maintaining simplicity (users can expand it by themselves)）
]]

---@class EventBus
---@field _listeners table<string, function[]> event name -> callback list
---@overload fun():self
local M = Class "EventBus"

---@return self
function M:__init()
    self._listeners = {}
    return self
end

---Subscribe to events
---@param event string event name
---@param callback function Callback function
---@return function unsubscribe function
function M:on(event, callback)
    if not event or not callback then
        log.warn("[EventBus] on(): The event and callback cannot be empty")
        return function() end
    end

    if not self._listeners[event] then
        self._listeners[event] = {}
    end
    table.insert(self._listeners[event], callback)

    --Return the unsubscribe function
    local removed = false
    return function()
        if not removed then
            removed = true
            self:off(event, callback)
        end
    end
end

---One-time subscription (automatically cancelled after triggering once)
---@param event string event name
---@param callback function Callback function
---@return function unsubscribe function
function M:once(event, callback)
    local unsubscribe
    unsubscribe = self:on(event, function(...)
        unsubscribe()
        callback(...)
    end)
    return unsubscribe
end

---Unsubscribe
---@param event string event name
---@param callback function The callback function to be cancelled
function M:off(event, callback)
    local list = self._listeners[event]
    if not list then
        return
    end
    for i = #list, 1, -1 do
        if list[i] == callback then
            table.remove(list, i)
            break
        end
    end
    --If the list is empty, clear the references
    if #list == 0 then
        self._listeners[event] = nil
    end
end

---Release event
---@param event string event name
---@param ... The parameter passed to the callback by any
function M:emit(event, ...)
    local list = self._listeners[event]
    if not list then
        return
    end
    --Copy a list to prevent the list from being modified in the callback (such as off caused by once)
    local snapshot = {}
    for i, cb in ipairs(list) do
        snapshot[i] = cb
    end
    for _, cb in ipairs(snapshot) do
        xpcall(cb, log.error, ...)
    end
end

---Clear all listeners for a certain event
---@param event string event name
function M:clear(event)
    self._listeners[event] = nil
end

---Clear all listeners for all events
function M:clearAll()
    self._listeners = {}
end

---Obtain the number of listeners for a certain event (for debugging purposes)
---@param event string event name
---@return number
function M:listenerCount(event)
    local list = self._listeners[event]
    return list and #list or 0
end

return M
