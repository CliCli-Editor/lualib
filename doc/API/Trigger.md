# Trigger

flip-flop

## add_tag

```lua
(method) Trigger:add_tag(tag: any)
```

Add tag
## all_triggers

```lua
table
```

## disable

```lua
(method) Trigger:disable()
```

Disable trigger
## disable_once

```lua
(method) Trigger:disable_once()
```

Disable this trigger in this event
## enable

```lua
(method) Trigger:enable()
```

## event_manager

```lua
EventManager?
```

## execute

```lua
(method) Trigger:execute(...any)
  -> any
  2. any
  3. any
  4. any
```

 Run the trigger to return up to 4 return values
## get_include_name

```lua
(method) Trigger:get_include_name()
  -> string?
```

## has_tag

```lua
(method) Trigger:has_tag(tag: any)
  -> boolean
```

Label or not
## is_enable

```lua
(method) Trigger:is_enable()
  -> boolean
```

## is_match_args

```lua
(method) Trigger:is_match_args(fire_args?: any[])
  -> boolean
```

 Check that the parameters of the event match the parameters of the trigger，
 The number of allowed event parameters exceeds the number of trigger parameters。
## on_remove

```lua
(method) Trigger:on_remove(callback: any)
```

## recover_disable_once

```lua
(method) Trigger:recover_disable_once()
```

## remove

```lua
(method) Trigger:remove()
```

## remove_tag

```lua
(method) Trigger:remove_tag(tag: any)
```

Remove tag
## type

```lua
string
```


# Trigger.CallBack


```lua
fun(trg: Trigger, ...any):any, any, any, any
```


