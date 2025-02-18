# EditorObject

 Object editor

## ability

```lua
unknown
```

## buff

```lua
unknown
```

## callMethod

```lua
function EditorObject.callMethod(otype: string, mname: string, key: any, lock_obj: any, arg1: any, arg2: any)
```

## call_stack_map

```lua
table
```

## item

```lua
unknown
```

## lock_count_map

```lua
table
```

## projectile

```lua
unknown
```

## unit

```lua
unknown
```


# EditorObject.Ability

## data

```lua
Object.Ability
```

Skill's object data, you can read or modify any object from it (some fields cannot be modified)）  
> Warning: Make sure the data type is correct, otherwise it may cause a crash  
> Warning: If you modify the data after creating this skill, the behavior is undefined
## data_key

```lua
string
```

## event

```lua
fun(self: EditorObject.Ability, event: "Skill - Build Complete ", callback: fun(trg: Trigger, data: EventParam). Skill - Built complete)):Trigger
```

## event_manager

```lua
unknown
```

## get_key

```lua
fun(self: any):integer
```

## handle

```lua
unknown?
```

## key

```lua
py.AbilityKey
```

Skill number
## kv_has

```lua
(method) KV:kv_has(key: string)
  -> boolean
```

 Whether the specified key - value pair is owned. Interwork with ECA。
## kv_key

```lua
string
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
## new

```lua
(method) EditorObject.Ability:new(new_default_key?: py.AbilityKey, data?: table)
  -> EditorObject.Ability
```

Create a new skill set from this skill template
## on_add

```lua
fun(ability: Ability)
```

Execute after skills are acquired
## on_can_cast

```lua
fun(ability: Ability, cast: Cast)
```

Execute when the skill is about to cast
## on_cast_channel

```lua
fun(ability: Ability, cast: Cast)
```

Skills guide when casting
## on_cast_finish

```lua
fun(ability: Ability, cast: Cast)
```

The skill is executed when the spell is completed
## on_cast_shot

```lua
fun(ability: Ability, cast: Cast)
```

The skill is executed when casting spells
## on_cast_start

```lua
fun(ability: Ability, cast: Cast)
```

The skill is executed when the spell begins
## on_cast_stop

```lua
fun(ability: Ability, cast: Cast)
```

The skill is executed when it stops casting spells
## on_cooldown

```lua
fun(ability: Ability)
```

Execute when cooldown ends
## on_lose

```lua
fun(ability: Ability)
```

Skills lost after execution
## on_upgrade

```lua
fun(ability: Ability)
```

Execute after skill upgrade
## type

```lua
string
```


# EditorObject.Buff

## data

```lua
Object.Buff
```

Magic effect object data, you can read or modify any object from it (some fields cannot be modified）  
> Warning: Make sure the data type is correct, otherwise it may cause a crash  
> Warning: If you create this magic effect and then modify the data, the behavior is undefined
## data_key

```lua
string
```

## event

```lua
fun(self: EditorObject.Buff, event: "Effect - Get ", callback: fun(trg: Trigger, data: EventParam). Effect - gain)):Trigger
```

## event_manager

```lua
unknown
```

## get_key

```lua
fun(self: any):integer
```

## handle

```lua
unknown?
```

## key

```lua
py.ModifierKey
```

Effect number
## kv_has

```lua
(method) KV:kv_has(key: string)
  -> boolean
```

 Whether the specified key - value pair is owned. Interwork with ECA。
## kv_key

```lua
string
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
## new

```lua
(method) EditorObject.Buff:new()
  -> EditorObject.Buff
```

Create a new magic effect for the template from this magic effect
## on_add

```lua
fun(buff: Buff)
```

After the effect is obtained, execute
## on_can_add

```lua
fun(buff: Buff)
```

Execute when the effect is about to be obtained
## on_lose

```lua
fun(buff: Buff)
```

Effect lost after execution
## on_pulse

```lua
fun(buff: Buff)
```

The effect is executed after heartbeat
## on_stack_change

```lua
fun(buff: Buff)
```

Execute after the number of effect layers changes
## type

```lua
string
```


# EditorObject.DataModule

## data_key

```lua
string
```


# EditorObject.Event

## event

```lua
(method) EditorObject.Event:event(name: string, callback: function)
  -> Trigger
```

## event_manager

```lua
unknown
```

## get_key

```lua
fun(self: any):integer
```

## type

```lua
string
```


# EditorObject.Item

## data

```lua
Object.Item
```

The object's catalog data, from which you can read or modify any catalog (some fields cannot be modified)）  
> Warning: Make sure the data type is correct, otherwise it may cause a crash  
> Warning: If you create this item and then modify the data, the behavior is undefined
## data_key

```lua
string
```

## event

```lua
fun(self: EditorObject.Item, event: "Item - Get ", callback: fun(trg: Trigger, data: EventParam. Items - Get)):Trigger
```

## event_manager

```lua
unknown
```

## get_key

```lua
fun(self: any):integer
```

## handle

```lua
unknown?
```

## key

```lua
py.ItemKey
```

Item number
## kv_has

```lua
(method) KV:kv_has(key: string)
  -> boolean
```

 Whether the specified key - value pair is owned. Interwork with ECA。
## kv_key

```lua
string
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
## new

```lua
(method) EditorObject.Item:new()
  -> EditorObject.Item
```

Use this item as a template to create a new item
## on_add

```lua
fun(item: Item)
```

Execute after the item is acquired
## on_add_to_bar

```lua
fun(item: Item)
```

Execute after the item enters the equipment bar
## on_add_to_pkg

```lua
fun(item: Item)
```

Execute after the item enters the backpack
## on_create

```lua
fun(item: Item)
```

Item created after execution
## on_lose

```lua
fun(item: Item)
```

Item lost after execution
## on_remove

```lua
fun(item: Item)
```

Execute after item removal
## on_use

```lua
fun(item: Item)
```

Item is executed when used
## type

```lua
string
```


# EditorObject.Projectile

## data

```lua
Object.Projectile
```

The object compilation data of the projectile, you can read or modify any object compilation from it (some fields cannot be modified）  
> Warning: Make sure the data type is correct, otherwise it may cause a crash  
> Warning: If you create this projectile and then modify the data, the behavior is undefined
## data_key

```lua
string
```

## event

```lua
fun(self: EditorObject.Projectile, event: ""Projectile-create ", callback: fun(trg: Trigger, data: EventParam. Projectiles - Created)):Trigger
```

## event_manager

```lua
unknown
```

## get_key

```lua
fun(self: any):integer
```

## handle

```lua
unknown?
```

## key

```lua
py.ProjectileKey
```

Projectile number
## kv_has

```lua
(method) KV:kv_has(key: string)
  -> boolean
```

 Whether the specified key - value pair is owned. Interwork with ECA。
## kv_key

```lua
string
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
## new

```lua
(method) EditorObject.Projectile:new()
  -> EditorObject.Projectile
```

Create a new projectile from this projectile as a template
## on_create

```lua
fun(projectile: Projectile)
```

Executed when the projectile is created
## on_remove

```lua
fun(projectile: Projectile)
```

Execute when the projectile is destroyed
## type

```lua
string
```


# EditorObject.Unit

## data

```lua
Object.Unit
```

Unit of object data from which you can read or modify any object (some fields cannot be modified)）  
> Warning: Make sure the data type is correct, otherwise it may cause a crash  
> Warning: If you modify the data after creating this unit, the behavior is undefined
## data_key

```lua
string
```

## event

```lua
fun(self: EditorObject.Unit, event: "Unit - Research and development technology ", callback: fun(trg: Trigger, data: EventParam). Unit - Research and development technology)):Trigger
```

## event_manager

```lua
unknown
```

## get_key

```lua
fun(self: any):integer
```

## handle

```lua
unknown?
```

## key

```lua
py.UnitKey
```

Unit number
## kv_has

```lua
(method) KV:kv_has(key: string)
  -> boolean
```

 Whether the specified key - value pair is owned. Interwork with ECA。
## kv_key

```lua
string
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
## new

```lua
(method) EditorObject.Unit:new(new_default_key?: py.UnitKey, data?: table)
  -> EditorObject.Unit
```

Use this unit as a template to create a new unit object
## on_create

```lua
fun(unit: Unit)
```

Execute after the unit is created
## on_dead

```lua
fun(unit: Unit)
```

Executed after the death of the unit
## on_remove

```lua
fun(unit: Unit)
```

Execute after the unit is removed
## type

```lua
string
```


