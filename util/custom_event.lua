---@class CustomEvent
---@field private custom_event_manager? EventManager
---@overload fun(): self
local M = Class 'CustomEvent'

--[[
Register a custom event and, when triggered, execute a callback function。

```lua
Obj:event_on('input', function (trigger, ...)
    print('The input event was triggered', ...)
end)

Obj:event_notify('input', '123', '456')
```

The above will print：

```
The input event was triggered 123 456
```

---

You can specify parameters for the event during registration：

```lua
Obj:event_on('input', {'123'}, function (trigger, ...)
    print('The input event was triggered', ...)
end)

Obj:event_notify('input', 1) --Untriggered event
Obj:event_notify_with_args('input', {'123'}, 2) --Can trigger event
Obj:event_notify_with_args('input', {'456'}, 3) --Untriggered event
Obj:event_notify_with_args('input', {'123', '666'}, 4) --Can trigger event
```
]]
---@overload fun(self: self, event_name:string, callback:Trigger.CallBack):Trigger
---@overload fun(self: self, event_name:string, args:any[] | any, callback:Trigger.CallBack):Trigger
function M:event_on(...)
    if not rawget(self, 'custom_event_manager') then
        self.custom_event_manager = New 'EventManager' (self)
    end
    local event_name, args, callback = ...
    if not callback then
        callback = args
        args = nil
    end
    assert(event_name, 'Missing event name')
    assert(type(callback) == 'function', 'The callback function is missing')
    local trigger = self.custom_event_manager:event(event_name, args, callback)
    return trigger
end

--[[
When a custom event is initiated (notification mode), only one event is executed on the same object，
When an insert settlement occurs, subsequent events are queued

```lua
Obj:event_on('obtained', function ()
    print('Trigger acquisition')
    print('Before removal')
    Obj:event_notify('Remove') --In real business, maybe the buff you get kills yourself, and death clears the buff
    print('After removal')
end)

Obj:event_on('Remove', function ()
    print('Trigger removal')
end)

Obj:event_notify('obtained')
```

This code will print：

```
Trigger acquisition
Before removal
After removal
Trigger removal
```
]]
---@param event_name string
---@param ... any
function M:event_notify(event_name, ...)
    if not self.custom_event_manager then
        return
    end
    self.custom_event_manager:notify(event_name, nil, ...)
end

--Initiating custom events with event parameters (notification mode)
---@param event_name string
---@param args any[]
---@param ... any
function M:event_notify_with_args(event_name, args, ...)
    if not self.custom_event_manager then
        return
    end
    self.custom_event_manager:notify(event_name, args, ...)
end

--[[
Initiate custom events (receipt mode), which, unlike notification mode, allows for insert billing。
The return value of the event can be accepted, and the event is called in the order of registration when there are multiple registrations，
When any event callback returns a non-nil value, subsequent triggers are not called。

```lua
Obj:event_on('Acquire', function (trigger,...)
    print('Acquired 1')
    return 1
end)
Obj:event_on('Acquire', function (trigger,...)
    print('Acquired 2')
    return 2
end)

local result = Obj:event_dispatch('Acquire')

print('The result is:', result)
```

The above code will print：

```
Acquire1
Turn out：    1
```
]]
---@param event_name string
---@param ... any
---@return any, any, any, any
function M:event_dispatch(event_name, ...)
    if not self.custom_event_manager then
        return
    end
    return self.custom_event_manager:dispatch(event_name, nil, ...)
end

--Initiating a custom event with event parameters (receipt mode)
---@param event_name string
---@param args any[] | any
---@param ... any
---@return any, any, any, any
function M:event_dispatch_with_args(event_name, args, ...)
    if not self.custom_event_manager then
        return
    end
    return self.custom_event_manager:dispatch(event_name, args, ...)
end

---@return EventManager?
function M:get_custom_event_manager()
    return self.custom_event_manager
end

return M
