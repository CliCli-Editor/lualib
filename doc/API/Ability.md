# Ability

skill

## add_cd

```lua
(method) Ability:add_cd(value: number)
```

Increased cooldown

@*param* `value` — cooling
## add_float_attr

```lua
(method) Ability:add_float_attr(key: string, value: number)
```

Added real attribute

@*param* `key` — Statskey

@*param* `value` — Attribute value
## add_int_attr

```lua
(method) Ability:add_int_attr(key: string, value: integer)
```

Increment integer attribute

@*param* `key` — Statskey

@*param* `value` — Attribute value
## add_level

```lua
(method) Ability:add_level(value: integer)
```

Increase skill level

@*param* `value` — Lv.
## add_player_attr_cost

```lua
(method) Ability:add_player_attr_cost(key: string, value: number)
```

Increased skill player stat cost

@*param* `key` — Statskey

@*param* `value` — Attribute value
## add_remaining_cd

```lua
(method) Ability:add_remaining_cd(value: number)
```

Increased the skill's remaining cooldown

@*param* `value` — Remaining cooling time
## add_stack

```lua
(method) Ability:add_stack(value: integer)
```

Increased the number of skill recharge levels

@*param* `value` — Number of floors
## add_tag

```lua
(method) Ability:add_tag(tag: string)
```

Add tag

@*param* `tag` — tag
## can_cast_when_hp_insufficient

```lua
(method) Ability:can_cast_when_hp_insufficient()
  -> can_cast: boolean
```

Whether life deficiency can be released

@*return* `can_cast` — Whether life deficiency can be released
## check_precondition_by_key

```lua
function Ability.check_precondition_by_key(player: Player, ability_key: py.AbilityKey)
  -> is_meet: boolean
```

Check the preconditions for the skill type

@*param* `player` — Player

@*param* `ability_key` — Skill type id (object compilationid)

@*return* `is_meet` — Whether the preconditions for the skill type are met
## complete_cd

```lua
(method) Ability:complete_cd()
```

Complete cooling
## custom_event_manager

```lua
EventManager?
```

## disable

```lua
(method) Ability:disable()
```

Forbidden skill
## enable

```lua
(method) Ability:enable()
```

Enabling skill
## event

```lua
fun(self: Ability, event: "Skill - Build Complete ", callback: fun(trg: Trigger, data: EventParam). Skill - Built complete)):Trigger
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

## get_by_handle

```lua
function Ability.get_by_handle(py_ability: py.Ability)
  -> ability: Ability?
```

Obtain the lua layer skill instance from the py layer skill instance

@*param* `py_ability` — pyLayer skill instance

@*return* `ability` — Returns the lua layer skill instance after being initialized at the lua layer
## get_by_id

```lua
function Ability.get_by_id(id: integer)
  -> Ability
```

## get_cast_type

```lua
(method) Ability:get_cast_type()
  -> type: py.AbilityCastType
```

Gets the skill release type AbilityCastType

@*return* `type` — Skill release type
## get_cd

```lua
(method) Ability:get_cd()
  -> time: number
```

Gets the current cooldown time

@*return* `time` — Current cooling time
## get_charge_time

```lua
(method) Ability:get_charge_time()
  -> number
```

Gets the remaining charge time of the skill
## get_custom_event_manager

```lua
(method) CustomEvent:get_custom_event_manager()
  -> EventManager?
```

## get_description

```lua
(method) Ability:get_description()
  -> string
```

Get skill description
## get_description_by_key

```lua
function Ability.get_description_by_key(ability_key: py.AbilityKey)
  -> des: string
```

Obtain the skill description based on the skill key

@*return* `des` — Description
## get_float_attr

```lua
(method) Ability:get_float_attr(key: string|y3.Const.AbilityFloatAttr)
  -> value: number
```

Gets the real number attribute

@*param* `key` — Key valuekey

@*return* `value` — 值
## get_float_attr_by_key

```lua
function Ability.get_float_attr_by_key(ability_key: py.AbilityKey, key: string)
  -> value: number
```

Gets the real attribute of the skill type
> Use 'y3.object.ability[ability_key].data' instead

@*param* `ability_key` — Skill type id (object compilationid)

@*param* `key` — Key valuekey

@*return* `value` — 值
## get_formula_attr_by_key

```lua
function Ability.get_formula_attr_by_key(ability_id: py.AbilityKey, attr_name: string, level: integer, stack_count: integer, unit_hp_max: number, unit_hp_cur: number)
  -> value: number
```

Gets the skill type formula properties

@*param* `ability_id` — Skill type id(object compilationid)

@*param* `attr_name` — Attribute name

@*param* `level` — Skill level

@*param* `stack_count` — Skill level

@*param* `unit_hp_max` — Maximum life per unit

@*param* `unit_hp_cur` — Unit current life

@*return* `value` — 值
## get_formula_kv

```lua
(method) Ability:get_formula_kv(key: string)
  -> value: number
```

Gets skill formula typekv

@*param* `key` — Key valuekey

@*return* `value` — 值
## get_icon

```lua
(method) Ability:get_icon()
  -> id: py.Texture
```

Get skill icon

@*return* `id` — pictureID
## get_icon_by_key

```lua
function Ability.get_icon_by_key(ability_key: py.AbilityKey)
  -> id: py.Texture
```

Gets a picture of the icon icon for the skill typeID

@*param* `ability_key` — Skill type id (object compilationid)

@*return* `id` — pictureID
## get_int_attr

```lua
(method) Ability:get_int_attr(key: string|y3.Const.AbilityIntAttr)
  -> value: number
```

Get integer properties

@*param* `key` — Key valuekey

@*return* `value` — 值
## get_int_attr_by_key

```lua
function Ability.get_int_attr_by_key(ability_key: py.AbilityKey, key: string)
  -> value: integer
```

Gets the integer attribute of the skill type
> Use 'y3.object.ability[ability_key].data' instead

@*param* `ability_key` — Skill type id (object compilationid)

@*param* `key` — Key valuekey

@*return* `value` — 值
## get_item

```lua
(method) Ability:get_item()
  -> Item?
```

Gets the item that the skill is bound to (which item object the skill object is on）
## get_key

```lua
(method) Ability:get_key()
  -> py.AbilityKey
```

## get_level

```lua
(method) Ability:get_level()
  -> level: integer
```

 Gain skill level

@*return* `level` — Lv.
## get_max_cd

```lua
(method) Ability:get_max_cd()
  -> number
```

Gain skills MaxCD
## get_name

```lua
(method) Ability:get_name()
  -> string
```

## get_name_by_key

```lua
function Ability.get_name_by_key(ability_key: py.AbilityKey)
  -> name: string
```

Get the skill name based on the skill key

@*return* `name` — Skill name
## get_owner

```lua
(method) Ability:get_owner()
  -> owner: Unit?
```

Acquire the owner of the skill

@*return* `owner` — Skill holder
## get_player_attr_cost

```lua
(method) Ability:get_player_attr_cost(key: string)
  -> cost: number
```

Gets the player attribute value for skill cost

@*param* `key` — Statskey

@*return* `cost` — Player attribute value
## get_range

```lua
(method) Ability:get_range()
  -> number
```

Gain skill casting scope

@*return* — Scope of casting
## get_skill_pointer

```lua
(method) Ability:get_skill_pointer()
  -> y3.Const.AbilityPointerType
```

Gets the indicator type of the skill
## get_skill_type_pointer

```lua
function Ability.get_skill_type_pointer(name: py.AbilityKey)
  -> y3.Const.AbilityPointerType
```

Gets the indicator type for the skill type
## get_slot

```lua
(method) Ability:get_slot()
  -> index: y3.Const.AbilityIndex
```

Obtain the skill bit where the skill resides

@*return* `index` — Skill Indicates the skill bit
## get_str_attr_by_key

```lua
function Ability.get_str_attr_by_key(ability_key: py.AbilityKey, key: py.AbilityStrAttr)
  -> str: string
```

Gets the skill type string property
> Use 'y3.object.ability[ability_key].data' instead

@*param* `ability_key` — Skill type id (object compilationid)

@*param* `key` — Key valuekey

@*return* `str` — 值
## get_string_attr

```lua
(method) Ability:get_string_attr(key: string)
  -> value: string
```

Get string attribute

@*param* `key` — Key valuekey

@*return* `value` — 值
## get_target

```lua
(method) Ability:get_target(cast: integer)
  -> target: Destructible|Item|Point|Unit|nil
```

@*param* `cast` — conjureID

@*return* `target` — goal
## get_type

```lua
(method) Ability:get_type()
  -> type: y3.Const.AbilityType
```

Acquire skill types

@*return* `type` — Skill type
## handle

```lua
py.Ability
```

Skill object
## has_tag

```lua
(method) Ability:has_tag(tag: string)
  -> boolean
```

Tagged or not

@*param* `tag` — tag
## hide_pointer

```lua
function Ability.hide_pointer(player: Player)
```

Turn off skill indicator

@*param* `player` — Player
## id

```lua
integer
```

## is_autocast_enabled

```lua
(method) Ability:is_autocast_enabled()
  -> is_enabled: boolean
```

Whether automatic casting is enabled

@*return* `is_enabled` — Enable or not
## is_cd_reduce

```lua
(method) Ability:is_cd_reduce()
  -> is_influenced: boolean
```

Whether it is affected by cooling loss

@*return* `is_influenced` — Whether it is affected by cooling loss
## is_cd_reduce_by_key

```lua
function Ability.is_cd_reduce_by_key(ability_key: py.AbilityKey)
  -> is_influenced: boolean
```

Whether the skill type is affected by cooldown reduction

@*param* `ability_key` — Skill type id (object compilationid)

@*return* `is_influenced` — Whether the skill type is affected by cooldown reduction
## is_cost_hp_can_die

```lua
(method) Ability:is_cost_hp_can_die()
  -> is_cost: boolean
```

Consuming life will lead to death

@*return* `is_cost` — Consuming life will lead to death
## is_destroyed

```lua
(method) Ability:is_destroyed()
  -> boolean|unknown
```

## is_exist

```lua
(method) Ability:is_exist()
  -> is_exist: boolean
```

Existence or not

@*return* `is_exist` — Existence or not
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
## learn

```lua
(method) Ability:learn()
```

Learning skill
## object_event_manager

```lua
EventManager?
```

## phandle

```lua
py.Ability
```

Skill object
## pre_cast

```lua
(method) Ability:pre_cast(player: Player)
```

Enter skill ready to cast

@*param* `player` — Player
## ref_manager

```lua
unknown
```

## remove

```lua
(method) Ability:remove()
```

Remove skill
## remove_tag

```lua
(method) Ability:remove_tag(tag: string)
```

Remove tag

@*param* `tag` — tag
## restart_cd

```lua
(method) Ability:restart_cd()
```

Entry cooling
## set_arrow_length

```lua
(method) Ability:set_arrow_length(value: number)
```

Sets the arrow/multi-segment indicator length

@*param* `value` — Length
## set_arrow_width

```lua
(method) Ability:set_arrow_width(value: number)
```

Set the arrow/multi-segment indicator width

@*param* `value` — breadth
## set_autocast

```lua
(method) Ability:set_autocast(enable: boolean)
```

Switch automatically casts spells

@*param* `enable` — Switch
## set_build_rotate

```lua
(method) Ability:set_build_rotate(angle: number)
```

Set the building orientation of the skill

@*param* `angle` — Angle
## set_can_cast_when_hp_insufficient

```lua
(method) Ability:set_can_cast_when_hp_insufficient(can_cast: boolean)
```

Sets whether skills can be released when life is low

@*param* `can_cast` — Can be released
## set_cd

```lua
(method) Ability:set_cd(value: number)
```

Set the remaining cooldown time

@*param* `value` — Remaining cooling time
## set_cd_reduce

```lua
(method) Ability:set_cd_reduce(is_influenced: boolean)
```

Sets whether skills are affected by cooldown reduction

@*param* `is_influenced` — Statskey
## set_charge_time

```lua
(method) Ability:set_charge_time(value: number)
```

Set the remaining charge time of a skill

@*param* `value` — Remaining charging time
## set_circle_radius

```lua
(method) Ability:set_circle_radius(value: number)
```

Set arrow circle indicator radius

@*param* `value` — radius
## set_description

```lua
(method) Ability:set_description(des: string)
```

Set skill description

@*param* `des` — Description
## set_float_attr

```lua
(method) Ability:set_float_attr(key: string|y3.Const.AbilityFloatAttr, value: number)
```

Sets the real number property

@*param* `key` — Statskey

@*param* `value` — Attribute value
## set_icon

```lua
(method) Ability:set_icon(icon_id: integer)
```

Set skill icon

@*param* `icon_id` — pictureid
## set_int_attr

```lua
(method) Ability:set_int_attr(key: string|y3.Const.AbilityIntAttr, value: integer)
```

Set integer properties

@*param* `key` — Statskey

@*param* `value` — Attribute value
## set_is_cost_hp_can_die

```lua
(method) Ability:set_is_cost_hp_can_die(can_die: boolean)
```

Set whether consuming life will result in death

@*param* `can_die` — Will you die?
## set_level

```lua
(method) Ability:set_level(level: integer)
```

Set skill level

@*param* `level` — Lv.
## set_max_cd

```lua
(method) Ability:set_max_cd(value: number)
```

Set skill MaxCD
## set_name

```lua
(method) Ability:set_name(name: string)
```

Set skill name

@*param* `name` — Skill name
## set_normal_attack_preview_state

```lua
function Ability.set_normal_attack_preview_state(player: Player, state: boolean)
```

Set the player's attack preview status

@*param* `player` — Player

@*param* `state` — Status On/Off
## set_player_attr_cost

```lua
(method) Ability:set_player_attr_cost(key: string, value: number)
```

Set skill player stat cost

@*param* `key` — Statskey

@*param* `value` — Attribute value
## set_pointer_type

```lua
(method) Ability:set_pointer_type(type: y3.Const.AbilityPointerType)
```

Set the skill indicator type

@*param* `type` — Skill indicator type
## set_range

```lua
(method) Ability:set_range(value: number)
```

Set the scope of a skill cast

@*param* `value` — Scope of casting
## set_sector_angle

```lua
(method) Ability:set_sector_angle(value: number)
```

Set the Angle of the sector indicator

@*param* `value` — Angle
## set_sector_radius

```lua
(method) Ability:set_sector_radius(value: number)
```

Set the fan indicator radius

@*param* `value` — radius
## set_smart_cast_with_pointer

```lua
function Ability.set_smart_cast_with_pointer(player: Player, state: boolean)
```

Sets whether the player's indicator is displayed while smart casting

@*param* `player` — Player

@*param* `state` — Status On/Off
## set_stack

```lua
(method) Ability:set_stack(value: integer)
```

Set the number of charging layers

@*param* `value` — Number of floors
## show_indicator

```lua
(method) Ability:show_indicator(player: Player)
```

Display skill indicator

@*param* `player` — Player
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


