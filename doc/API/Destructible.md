# Destructible

destructible

## add_height

```lua
(method) Destructible:add_height(height: number)
```

Gain height

@*param* `height` — Altitude
## add_hp

```lua
(method) Destructible:add_hp(value: number)
```

@*param* `value` — Vitality

Increases current health
## add_max_hp

```lua
(method) Destructible:add_max_hp(value: number)
```

@*param* `value` — Vitality

Increases maximum health
## add_max_resource

```lua
(method) Destructible:add_max_resource(value: number)
```

@*param* `value` — Resource number

Increase the maximum number of resources
## add_resource

```lua
(method) Destructible:add_resource(value: number)
```

@*param* `value` — Resource number

Example Increase the number of current resources
## add_tag

```lua
(method) Destructible:add_tag(tag: string)
```

Add label

@*param* `tag` — tag
## can_be_ability_target

```lua
(method) Destructible:can_be_ability_target()
  -> is_lockable: boolean
```

Whether destructible objects are selected by the skill indicator

@*return* `is_lockable` — Be selected or not
## can_be_attacked

```lua
(method) Destructible:can_be_attacked()
  -> is_attackable: boolean
```

Whether destructible objects can be attacked

@*return* `is_attackable` — Can be attacked
## can_be_collected

```lua
(method) Destructible:can_be_collected()
  -> is_collectable: boolean
```

Whether the destructible material can be collected

@*return* `is_collectable` — Can be collected
## can_be_selected

```lua
(method) Destructible:can_be_selected()
  -> is_selectable: boolean
```

Whether destructible objects can be selected

@*return* `is_selectable` — Be selected or not
## cancel_replace_model

```lua
(method) Destructible:cancel_replace_model(model_id: py.ModelKey)
```

Cancel replacement model

@*param* `model_id` — modelid
## create_destructible

```lua
function Destructible.create_destructible(type_id: py.DestructibleKey, point: Point, angle: number, scale_x?: number, scale_y?: number, scale_z?: number, height?: number)
  -> destructible: Destructible
```

Create destructible objects

@*param* `type_id` — Destructible typeid

@*param* `point` — Create to point

@*param* `angle` — Angle oriented

@*param* `scale_x` — Zoomx

@*param* `scale_y` — Zoomy

@*param* `scale_z` — Zoomz

@*param* `height` — Altitude

@*return* `destructible` — destructible
## event

```lua
fun(self: Destructible, event: "Destruction-create, callback: fun(trg: Trigger, data: EventParam). Destructible - Create)):Trigger
```

## get_by_handle

```lua
function Destructible.get_by_handle(py_destructible: py.Destructible)
  -> Destructible?
```

Get the destructible object of the lua layer through the destructible instance of the py layer
## get_by_id

```lua
function Destructible.get_by_id(id: py.DestructibleID)
  -> Destructible?
```

 Gets lua's destructible object by the destructible's unique ID
## get_description

```lua
(method) Destructible:get_description()
  -> description: string
```

Get destructible description

@*return* `description` — Description
## get_description_by_key

```lua
function Destructible.get_description_by_key(key: py.DestructibleKey)
  -> description: string
```

Gets a description of the destructible type

@*param* `key` — typeid

@*return* `description` — Description
## get_facing

```lua
(method) Destructible:get_facing()
  -> rotation: number
```

Get the destructible oriented Angle

@*return* `rotation` — Angle oriented
## get_height

```lua
(method) Destructible:get_height()
  -> height: number
```

Get the height of destructible

@*return* `height` — Altitude
## get_hp

```lua
(method) Destructible:get_hp()
  -> cur_hp: number
```

Gain the health of destructible objects

@*return* `cur_hp` — Vitality
## get_id

```lua
(method) Destructible:get_id()
  -> integer
```

 Get uniqueID
## get_item_type

```lua
(method) Destructible:get_item_type()
  -> item_key: py.ItemKey
```

Gets the item type of destructibleID

@*return* `item_key` — Item typeID
## get_key

```lua
(method) Destructible:get_key()
  -> type: py.DestructibleKey
```

Gets the destructible type

@*return* `type` — Destructible type
## get_max_hp

```lua
(method) Destructible:get_max_hp()
  -> hp: number
```

Gain the health of destructible objects

@*return* `hp` — The health of destructible objects
## get_max_resource

```lua
(method) Destructible:get_max_resource()
  -> max_number: number
```

Gets the maximum number of resources for destructible objects

@*return* `max_number` — Maximum resource number
## get_model

```lua
(method) Destructible:get_model()
  -> model_key: py.ModelKey
```

Get a destructible model

@*return* `model_key` — modelid
## get_model_by_type

```lua
function Destructible.get_model_by_type(key: py.DestructibleKey)
  -> model: py.ModelKey
```

Gets a model of the destructible type

@*param* `key` — typeid

@*return* `model` — modelid
## get_name

```lua
(method) Destructible:get_name()
  -> name: string
```

Gets the name of the destructible

@*return* `name` — The name of a destructible object
## get_name_by_key

```lua
function Destructible.get_name_by_key(key: py.DestructibleKey)
  -> name: string
```

Gets the name of the destructible type

@*param* `key` — typeid

@*return* `name` — name
## get_position

```lua
(method) Destructible:get_position()
  -> point: Point
```

Gets the location of the destructible object

@*return* `point` — Location of destructible objects
## get_resource

```lua
(method) Destructible:get_resource()
  -> source_number: number
```

Gets the current number of resources for destructible

@*return* `source_number` — Current resource number
## get_resource_name

```lua
(method) Destructible:get_resource_name()
  -> source_name: string
```

Gets the resource name of the destructible

@*return* `source_name` — Resource name
## get_resource_type

```lua
(method) Destructible:get_resource_type()
  -> player_res_key: py.RoleResKey
```

Gets the destructible player attribute name

@*return* `player_res_key` — Player attributes
## handle

```lua
py.Destructible
```

Destructible object
## id

```lua
integer
```

## is_alive

```lua
(method) Destructible:is_alive()
  -> is_alive: boolean
```

Whether the destructible is alive

@*return* `is_alive` — Survive or not
## is_destroyed

```lua
(method) Destructible:is_destroyed()
  -> boolean|unknown
```

## is_exist

```lua
(method) Destructible:is_exist()
  -> is_exist: boolean
```

Existence or not

@*return* `is_exist` — Existence or not
## is_visible

```lua
(method) Destructible:is_visible()
  -> is_visible: boolean
```

Whether the destructible is visible

@*return* `is_visible` — Visible or not
## key

```lua
integer?
```

## kill

```lua
(method) Destructible:kill(killer_unit: Unit)
```

@*param* `killer_unit` — murderer

Kill the destructible
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
py.Destructible
```

Destructible object
## pick

```lua
function Destructible.pick(area: Area)
  -> Destructible[]
```

Traverse all destructible objects in the area

@*param* `area` — Area object
## pick_in_shape

```lua
function Destructible.pick_in_shape(point: Point, shape: Shape)
  -> destructible_list: table
```

@*param* `point` — 点

@*param* `shape` — region

@*return* `destructible_list` — List of destructible objects

Gets a list of destructible objects in different shape ranges
## play_animation

```lua
(method) Destructible:play_animation(anim_name: string, start_time?: number, end_time?: number, is_loop?: boolean, speed?: number)
```

Play animation

@*param* `anim_name` — Animation name

@*param* `start_time` — Start time

@*param* `end_time` — End time (Default -1 means play to the end)

@*param* `is_loop` — Cyclic or not

@*param* `speed` — speed
## reborn

```lua
(method) Destructible:reborn()
```

Resurrection destructible
## ref_manager

```lua
unknown
```

## remove

```lua
(method) Destructible:remove()
```

Remove destructible objects
## remove_tag

```lua
(method) Destructible:remove_tag(tag: string)
```

Remove tag

@*param* `tag` — tag
## replace_model

```lua
(method) Destructible:replace_model(model_id: py.ModelKey)
```

Replacement model

@*param* `model_id` — modelid
## set_can_be_ability_target

```lua
(method) Destructible:set_can_be_ability_target(can_be_ability_target: boolean)
```

Sets whether the skill indicator can be locked

@*param* `can_be_ability_target` — Can be locked by the skill indicator
## set_can_be_attacked

```lua
(method) Destructible:set_can_be_attacked(is_attackable: boolean)
```

Set whether to be attacked

@*param* `is_attackable` — Can be attacked
## set_can_be_collected

```lua
(method) Destructible:set_can_be_collected(is_collectable: boolean)
```

Sets whether to be collected

@*param* `is_collectable` — Can be collected
## set_can_be_selected

```lua
(method) Destructible:set_can_be_selected(is_selectable: boolean)
```

Sets whether to be selected

@*param* `is_selectable` — Be selected or not
## set_description

```lua
(method) Destructible:set_description(description: string)
```

@*param* `description` — Description

Set description
## set_facing

```lua
(method) Destructible:set_facing(angle: number)
```

orientation

@*param* `angle` — Orientation Angle
## set_height

```lua
(method) Destructible:set_height(height: number)
```

Set height

@*param* `height` — Altitude
## set_hp

```lua
(method) Destructible:set_hp(value: number)
```

Set health

@*param* `value` — Vitality
## set_max_hp

```lua
(method) Destructible:set_max_hp(value: number)
```

@*param* `value` — Vitality

Set the maximum health
## set_max_resource

```lua
(method) Destructible:set_max_resource(value: number)
```

@*param* `value` — Resource number

Set the maximum number of resources
## set_name

```lua
(method) Destructible:set_name(name: string)
```

@*param* `name` — Name

Set name
## set_point

```lua
(method) Destructible:set_point(point: Point)
```

Move to point

@*param* `point` — Target point
## set_resource

```lua
(method) Destructible:set_resource(value: number)
```

@*param* `value` — Resource number

Set the number of current resources
## set_scale

```lua
(method) Destructible:set_scale(x: number, y: number, z: number)
```

Set scale

@*param* `x` — xAxis scaling

@*param* `y` — yAxis scaling

@*param* `z` — zAxis scaling
## set_visible

```lua
(method) Destructible:set_visible(is_visible: boolean)
```

Show/hide

@*param* `is_visible` — Show or not
## stop_animation

```lua
(method) Destructible:stop_animation(anim_name: string)
```

Stop animation

@*param* `anim_name` — Animation name
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


