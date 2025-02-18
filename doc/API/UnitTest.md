# UnitTest.EventObject

## custom_event_manager

```lua
EventManager?
```

## event_dispatch

```lua
(method) CustomEvent:event_dispatch(event_name: string, ...any)
  -> any
  2. any
  3. any
  4. any
```

Initiate custom events (receipt mode), which, unlike notification mode, allows for insert billing。
The return value of the event can be accepted, and the event is called in the order of registration when there are multiple registrations，
When any event callback returns a non-nil value, subsequent triggers are not called。

```lua
Obj:event_on('Acquire', function (trigger,...)
    print('Acquire1')
    return 1
end)
Obj:event_on('Acquire', function (trigger,...)
    print('Acquire2')
    return 2
end)

local result = Obj:event_dispatch('Acquire')

print('Turn out：', result)
```

The above code will print：

```
Acquire1
Turn out：    1
```

## event_dispatch_with_args

```lua
(method) CustomEvent:event_dispatch_with_args(event_name: string, args: any, ...any)
  -> any
  2. any
  3. any
  4. any
```

 Initiates custom events with event parameters (receipt mode）
## event_notify

```lua
(method) CustomEvent:event_notify(event_name: string, ...any)
```

When a custom event is initiated (notification mode), only one event is executed on the same object，
When an insert settlement occurs, subsequent events are queued

```lua
Obj:event_on('obtained', function ()
    print('Trigger acquisition')
    print('Before removal')
    Obj:event_notify('Remove ') - In real business, maybe the buff you get kills yourself and the death clearsbuff
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

## event_notify_with_args

```lua
(method) CustomEvent:event_notify_with_args(event_name: string, args: any[], ...any)
```

 Initiates custom events with event parameters (notification mode）
## event_on

```lua
(method) CustomEvent:event_on(...any)
  -> Trigger
```

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

Obj:event_notify('Enter ', 1) -- the event cannot be triggered
Obj:event_notify_with_args('Enter ', {'123'}, 2) -- to trigger the event
Obj:event_notify_with_args('Enter ', {'456'}, 3) -- cannot fire an event
Obj:event_notify_with_args('Enter ', {'123', '666'}, 4) -- to trigger the event
```

## get_custom_event_manager

```lua
(method) CustomEvent:get_custom_event_manager()
  -> EventManager?
```


