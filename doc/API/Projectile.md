# Projectile

projectile

## add_tag

```lua
(method) Projectile:add_tag(tag: string)
```

Projectiles add labels

@*param* `tag` — tag
## add_time

```lua
(method) Projectile:add_time(duration: number)
```

Increase duration

@*param* `duration` — duration
## break_mover

```lua
(method) Projectile:break_mover()
```

interrupter
## create

```lua
function Projectile.create(data: Projectile.CreateData)
  -> Projectile
```

 Create projectiles

@*param* `data` — Projectiles create data
## event

```lua
fun(self: Projectile, event: ""Projectile-create ", callback: fun(trg: Trigger, data: EventParam. Projectiles - Created)):Trigger
```

## get_ability

```lua
(method) Projectile:get_ability()
  -> ability: Ability?
```

Acquire relevant skills

@*return* `ability` — The ability to associate projectiles or magic effects
## get_by_handle

```lua
function Projectile.get_by_handle(py_projectile: py.ProjectileEntity)
  -> projectile: Projectile?
```

## get_by_id

```lua
function Projectile.get_by_id(id: py.ProjectileID)
  -> Projectile
```

## get_facing

```lua
(method) Projectile:get_facing()
  -> angle: number
```

Gets projectile orientation

@*return* `angle` — Projectile orientation
## get_height

```lua
(method) Projectile:get_height()
  -> height: number
```

Gets projectile height

@*return* `height` — Altitude
## get_key

```lua
(method) Projectile:get_key()
  -> projectile_key: py.ProjectileKey
```

Gets the type of projectileID
## get_left_time

```lua
(method) Projectile:get_left_time()
  -> duration: number
```

Gets the remaining duration of the projectile

@*return* `duration` — The remaining duration of the projectile
## get_owner

```lua
(method) Projectile:get_owner()
  -> unit: Unit?
```

Gets the owner of the projectile

@*return* `unit` — The owner of the projectile
## get_point

```lua
(method) Projectile:get_point()
  -> point: Point
```

Get the point where the projectile is

@*return* `point` — The point where the projectile is
## handle

```lua
py.ProjectileEntity
```

Projectile object
## has_tag

```lua
(method) Projectile:has_tag(tag: string)
  -> is_has_tag: boolean
```

Have a label or not

@*param* `tag` — tag

@*return* `is_has_tag` — Have a label or not
## id

```lua
integer
```

## is_destroyed

```lua
(method) Projectile:is_destroyed()
  -> boolean|unknown
```

## is_exist

```lua
(method) Projectile:is_exist()
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
## mover_curve

```lua
(method) Projectile:mover_curve(mover_data: Mover.CreateData.Curve)
  -> Mover
```

Create a curve mover
## mover_line

```lua
(method) Projectile:mover_line(mover_data: Mover.CreateData.Line)
  -> Mover
```

Create a linear motion device
## mover_round

```lua
(method) Projectile:mover_round(mover_data: Mover.CreateData.Round)
  -> Mover
```

Create a surround motion
## mover_target

```lua
(method) Projectile:mover_target(mover_data: Mover.CreateData.Target)
  -> Mover
```

Create a tracker
## object_event_manager

```lua
EventManager?
```

## phandle

```lua
py.ProjectileEntity
```

Projectile object
## ref_manager

```lua
unknown
```

## remove

```lua
(method) Projectile:remove()
```

destroy
## remove_mover

```lua
(method) Projectile:remove_mover()
```

Removal motor
## remove_tag

```lua
(method) Projectile:remove_tag(tag: string)
```

Projectile removal tag

@*param* `tag` — tag
## set_ability

```lua
(method) Projectile:set_ability(ability: Ability)
```

Set associated skills

@*param* `ability` — Relevance skill
## set_animation_speed

```lua
(method) Projectile:set_animation_speed(speed: number)
```

Set animation speed
## set_facing

```lua
(method) Projectile:set_facing(direction: number)
```

orientation

@*param* `direction` — orientation
## set_height

```lua
(method) Projectile:set_height(height: number)
```

Set height

@*param* `height` — Altitude
## set_owner

```lua
(method) Projectile:set_owner(unit: Unit)
```

Set a unit

@*param* `unit` — Affiliated unit
## set_point

```lua
(method) Projectile:set_point(point: Point)
```

Set coordinates

@*param* `point` — Point coordinates
## set_rotation

```lua
(method) Projectile:set_rotation(x: number, y: number, z: number)
```

Set rotation

@*param* `x` — x轴

@*param* `y` — y轴

@*param* `z` — z轴
## set_scale

```lua
(method) Projectile:set_scale(x: number, y: number, z: number)
```

Set scale

@*param* `x` — x轴

@*param* `y` — y轴

@*param* `z` — z轴
## set_time

```lua
(method) Projectile:set_time(duration: number)
```

Set duration

@*param* `duration` — duration
## set_visible

```lua
(method) Projectile:set_visible(visible: boolean, player_or_group?: Player|PlayerGroup)
```

Sets the visibility of the projectile

@*param* `visible` — Visible or not

@*param* `player_or_group` — To which players, default is all players
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


# Projectile.CreateData

## ability

```lua
Ability
```

Projectile association skills
## angle

```lua
number
```

Projectile orientation
## height

```lua
number
```

Projectile height
## key

```lua
py.ProjectileKey
```

Projectile typeID
## owner

```lua
Player|Unit
```

Projectile owner
## remove_immediately

```lua
boolean
```

Whether to remove the representation immediately, if not filled will read the table
## socket

```lua
string
```

Projectiles associated with bones, effective only if 'target' is the unit
## target

```lua
Point|Unit
```

Create location
## time

```lua
number
```

Projectile duration
## visible_rule

```lua
integer|y3.Const.VisibleType
```

Particle effects visibility rules, default is`1`

