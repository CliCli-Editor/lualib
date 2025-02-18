# Buff

Magic effect

## add_aura_range

```lua
(method) Buff:add_aura_range(range: number)
```

Increases the range of magic aura effects

@*param* `range` — Sphere of influence
## add_cycle_time

```lua
(method) Buff:add_cycle_time(time: number)
```

Increased magic effect cycle

@*param* `time` — Change time
## add_shield

```lua
(method) Buff:add_shield(value: number)
```

Increased shield value

@*param* `value` — Shield Value
## add_stack

```lua
(method) Buff:add_stack(stack: integer)
```

Increase the number of stacking layers

@*param* `stack` — Number of floors
## add_time

```lua
(method) Buff:add_time(time: number)
```

Increases the remaining duration

@*param* `time` — Residual duration
## custom_event_manager

```lua
EventManager?
```

## event

```lua
fun(self: Buff, event: "Effect - Get ", callback: fun(trg: Trigger, data: EventParam). Effect - gain)):Trigger
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

## get_ability

```lua
(method) Buff:get_ability()
  -> ability: Ability|nil
```

Acquire relevant skills

@*return* `ability` — The ability to associate projectiles or magic effects
## get_aura

```lua
(method) Buff:get_aura()
  -> aura: Buff?
```

Acquire a halo

@*return* `aura` — Owning ring
## get_buff_aura_effect_key

```lua
(method) Buff:get_buff_aura_effect_key()
  -> type: py.ModifierKey
```

Get the halo effect type for magic effectsID

@*return* `type` — Halo effect typeID
## get_buff_aura_range

```lua
(method) Buff:get_buff_aura_range()
  -> range: number
```

Get the aura range of magic effects

@*return* `range` — Ring range
## get_buff_effect_type

```lua
(method) Buff:get_buff_effect_type()
  -> type: y3.Const.EffectType
```

Gets the Magic effect effect type

@*return* `type` — Magic effects affect type
## get_buff_type

```lua
(method) Buff:get_buff_type()
  -> type: y3.Const.ModifierType
```

Get the Magic effect type

@*return* `type` — Magic effect type
## get_by_handle

```lua
function Buff.get_by_handle(py_buff: py.ModifierEntity)
  -> Buff?
```

Get the magic effect instance of lua layer by using the magic effect instance of py layer

@*param* `py_buff` — pyLayer of magic effects instance

@*return* — Returns the lua Layer magic effect instance after the lua layer is initialized
## get_by_id

```lua
function Buff.get_by_id(id: integer)
  -> Buff
```

## get_custom_event_manager

```lua
(method) CustomEvent:get_custom_event_manager()
  -> EventManager?
```

## get_cycle_time

```lua
(method) Buff:get_cycle_time()
  -> time: number
```

Get Magic effect cycle

@*return* `time` — Cycle period
## get_description

```lua
(method) Buff:get_description()
  -> description: string
```

Gets a description of the magic effect object

@*return* `description` — Description
## get_description_by_key

```lua
function Buff.get_description_by_key(buff_key: py.ModifierKey)
  -> description: string
```

Get a description of the type of magic effect

@*param* `buff_key` — type

@*return* `description` — Description
## get_icon_by_key

```lua
function Buff.get_icon_by_key(buff_key: py.ModifierKey)
  -> py.Texture
```

Get a picture of the icon icon of the Magic effect type

@*param* `buff_key` — type

@*return* — pictureid
## get_key

```lua
(method) Buff:get_key()
  -> buff_key: py.ModifierKey
```

Get the class of magic effects

@*return* `buff_key` — category
## get_level

```lua
(method) Buff:get_level()
  -> level: integer
```

Acquisition level

@*return* `level` — Lv.
## get_max_stack

```lua
(method) Buff:get_max_stack()
  -> stack: integer
```

The maximum number of stacks to get magic effects

@*return* `stack` — Number of floors
## get_name

```lua
(method) Buff:get_name()
  -> name: string
```

Gets the name of the magic effect object

@*return* `name` — Name
## get_owner

```lua
(method) Buff:get_owner()
  -> owner: Unit?
```

A carrier to obtain magical effects

@*return* `owner` — carrier
## get_passed_time

```lua
(method) Buff:get_passed_time()
  -> duration: number
```

The duration of a magic effect

@*return* `duration` — duration
## get_shield

```lua
(method) Buff:get_shield()
  -> shield: number
```

Obtain a shield for magic effects

@*return* `shield` — Shield Value
## get_source

```lua
(method) Buff:get_source()
  -> provider: Unit?
```

The caster who gains magic effects

@*return* `provider` — inflictor
## get_stack

```lua
(method) Buff:get_stack()
  -> stack: integer
```

Get the stack number of magic effects

@*return* `stack` — Number of floors
## get_time

```lua
(method) Buff:get_time()
  -> time: number
```

Gets the remaining duration of the magic effect

@*return* `time` — Residual duration
## handle

```lua
py.ModifierEntity
```

pyLayer of magic effect objects
## has_tag

```lua
(method) Buff:has_tag(tag: string)
  -> boolean
```

Tagged or not

@*param* `tag` — tag
## id

```lua
integer
```

## is_destroyed

```lua
(method) Buff:is_destroyed()
  -> boolean|unknown
```

## is_exist

```lua
(method) Buff:is_exist()
  -> is_exist: boolean
```

Existence or not

@*return* `is_exist` — Existence or not
## is_icon_visible

```lua
(method) Buff:is_icon_visible()
  -> is_visible: boolean
```

Whether the magic effect icon is visible

@*return* `is_visible` — Visible or not
## is_icon_visible_by_key

```lua
function Buff.is_icon_visible_by_key(buff_key: py.ModifierKey)
  -> is_visible: boolean
```

Whether the icon of the magic effect type is visible

@*param* `buff_key` — type

@*return* `is_visible` — Visible or not
## key

```lua
integer?
```

## kv_has

```lua
(method) KV:kv_has(key: string)
  -> boolean
```

 Whether the specified key - value pair is owned. Interwork with ECA。
## kv_key

```lua
string?
```

## kv_load

```lua
(method) KV:kv_load(key: string, lua_type: 'boolean'|'integer'|'number'|'string'|'table'...(+1))
  -> any
```

```lua
lua_type:
    | 'boolean'
    | 'number'
    | 'integer'
    | 'string'
    | 'table'
```
## kv_remove

```lua
(method) KV:kv_remove(key: any)
```

## kv_save

```lua
(method) KV:kv_save(key: string, value: KV.SupportType)
```

 Save custom key-value pairs. Interwork with ECA。
## object_event_manager

```lua
EventManager?
```

## phandle

```lua
py.ModifierEntity
```

Proxy objects, using this to call the engine's methods will be much faster
## ref_manager

```lua
unknown
```

All magic effect instances
## remove

```lua
(method) Buff:remove()
```

Remove
## set_aura_range

```lua
(method) Buff:set_aura_range(range: number)
```

Set the halo influence range for magic effects

@*param* `range` — Sphere of influence
## set_cycle_time

```lua
(method) Buff:set_cycle_time(time: number)
```

Set the magic effect cycle

@*param* `time` — Cycle period
## set_description

```lua
(method) Buff:set_description(description: string)
```

Sets the description of the magic effect object

@*param* `description` — Description
## set_name

```lua
(method) Buff:set_name(name: string)
```

Set the name of the magic effect

@*param* `name` — Name
## set_shield

```lua
(method) Buff:set_shield(value: number)
```

Set the shield value

@*param* `value` — Shield Value
## set_stack

```lua
(method) Buff:set_stack(stack: integer)
```

Set the number of stacking layers

@*param* `stack` — Number of floors
## set_time

```lua
(method) Buff:set_time(time: number)
```

Set the remaining duration

@*param* `time` — Residual duration
## storage_all

```lua
(method) Storage:storage_all()
  -> table
```

 Gets the container for storing data
## storage_get

```lua
(method) Storage:storage_get(key: any)
  -> any
```

 Gets the stored value
## storage_set

```lua
(method) Storage:storage_set(key: any, value: any)
```

 Store arbitrary values
## storage_table

```lua
table
```

## subscribe_event

```lua
(method) ObjectEvent:subscribe_event(event_name: string, ...any)
  -> any[]?
  2. Trigger.CallBack
  3. Unsubscribe: function
```

## type

```lua
string
```


# Buff.AddData

## ability

```lua
Ability
```

Relevance skill
## data

```lua
table
```

Custom data
## key

```lua
py.ModifierKey
```

Magic effectid
## pulse

```lua
number
```

Heartbeat cycle
## source

```lua
Unit
```

Source unit
## stacks

```lua
integer
```

Number of floors
## time

```lua
number
```

duration

