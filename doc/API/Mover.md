# Mover

## get_by_handle

```lua
function Mover.get_by_handle(py_mover: py.Mover)
  -> Mover
```

## handle

```lua
py.Mover
```

Motor type
## init

```lua
(method) Mover:init(mover_data: Mover.CreateData.Base)
```

## mover_curve

```lua
function Mover.mover_curve(mover_unit: Projectile|Unit, mover_data: Mover.CreateData.Curve)
  -> Mover
```

## mover_line

```lua
function Mover.mover_line(mover_unit: Projectile|Unit, mover_data: Mover.CreateData.Line)
  -> Mover
```

## mover_round

```lua
function Mover.mover_round(mover_unit: Projectile|Unit, mover_data: Mover.CreateData.Round)
  -> Mover
```

## mover_target

```lua
function Mover.mover_target(mover_unit: Projectile|Unit, mover_data: Mover.CreateData.Target)
  -> Mover
```

## remove

```lua
(method) Mover:remove()
```

 Removal motor
## stop

```lua
(method) Mover:stop()
```

 interrupter
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

## wrap_base_args

```lua
function Mover.wrap_base_args(builder: py.MoverBaseBuilder, args: Mover.CreateData.Base)
```

## wrap_callbacks

```lua
function Mover.wrap_callbacks(mover_data: Mover.CreateData.Base)
  -> fun(mover: Mover)
  2. fun()?
  3. fun()?
  4. fun()?
  5. fun()?
  6. fun()
```

@*return* — update mover

@*return* — on_hit

@*return* — on_block

@*return* — on_finish

@*return* — on_break

@*return* — on_remove
## wrap_curve_args

```lua
function Mover.wrap_curve_args(args: Mover.CreateData.Curve)
  -> table
```

## wrap_line_args

```lua
function Mover.wrap_line_args(args: Mover.CreateData.Line)
  -> table
```

## wrap_round_args

```lua
function Mover.wrap_round_args(args: Mover.CreateData.Round)
  -> table
```

## wrap_target_args

```lua
function Mover.wrap_target_args(args: Mover.CreateData.Target)
  -> table
```


# Mover.CreateData.Base

## ability

```lua
Ability
```

Relevance skill
## absolute_height

```lua
boolean
```

Whether absolute height is used
## block_interval

```lua
number
```

The interval at which a terrain blocking event is triggered
## face_angle

```lua
boolean
```

Whether to always face the direction of motion
## hit_interval

```lua
number
```

Collision with the same unit interval
## hit_radius

```lua
number
```

Collision range
## hit_same

```lua
boolean
```

Whether to repeatedly collide with the same unit
## hit_type

```lua
integer
```

Collision type 0: enemy; 1: Allies; 2: All
## on_block

```lua
fun(self: Mover)
```

Collision terrain callback
## on_break

```lua
fun(self: Mover)
```

Motion interrupt callback
## on_finish

```lua
fun(self: Mover)
```

End of motion callback
## on_hit

```lua
fun(self: Mover, unit: Unit)
```

Collision unit callback
## on_remove

```lua
fun(self: Mover)
```

Motion remove callback
## priority

```lua
integer
```

priority
## terrain_block

```lua
boolean
```

Whether it will be blocked by terrain
## unit

```lua
Unit
```

Associated unit

# Mover.CreateData.Curve

## ability

```lua
Ability
```

Relevance skill
## absolute_height

```lua
boolean
```

Whether absolute height is used
## acceleration

```lua
number
```

acceleration
## angle

```lua
number
```

Direction of motion
## block_interval

```lua
number
```

The interval at which a terrain blocking event is triggered
## distance

```lua
number
```

Motion distance
## face_angle

```lua
boolean
```

Whether to always face the direction of motion
## fin_height

```lua
number
```

Terminal height
## hit_interval

```lua
number
```

Collision with the same unit interval
## hit_radius

```lua
number
```

Collision range
## hit_same

```lua
boolean
```

Whether to repeatedly collide with the same unit
## hit_type

```lua
integer
```

Collision type 0: enemy; 1: Allies; 2: All
## init_height

```lua
number
```

Initial altitude
## max_speed

```lua
number
```

Maximum speed
## min_speed

```lua
number
```

Minimum speed
## on_block

```lua
fun(self: Mover)
```

Collision terrain callback
## on_break

```lua
fun(self: Mover)
```

Motion interrupt callback
## on_finish

```lua
fun(self: Mover)
```

End of motion callback
## on_hit

```lua
fun(self: Mover, unit: Unit)
```

Collision unit callback
## on_remove

```lua
fun(self: Mover)
```

Motion remove callback
## path

```lua
(Point|py.FixedVec2)[]
```

waypoint
## priority

```lua
integer
```

priority
## speed

```lua
number
```

Initial velocity
## terrain_block

```lua
boolean
```

Whether it will be blocked by terrain
## unit

```lua
Unit
```

Associated unit

# Mover.CreateData.Line

## ability

```lua
Ability
```

Relevance skill
## absolute_height

```lua
boolean
```

Whether absolute height is used
## acceleration

```lua
number
```

acceleration
## angle

```lua
number
```

Direction of motion
## block_interval

```lua
number
```

The interval at which a terrain blocking event is triggered
## distance

```lua
number
```

Motion distance
## face_angle

```lua
boolean
```

Whether to always face the direction of motion
## fin_height

```lua
number
```

Terminal height
## hit_interval

```lua
number
```

Collision with the same unit interval
## hit_radius

```lua
number
```

Collision range
## hit_same

```lua
boolean
```

Whether to repeatedly collide with the same unit
## hit_type

```lua
integer
```

Collision type 0: enemy; 1: Allies; 2: All
## init_height

```lua
number
```

Initial altitude
## max_speed

```lua
number
```

Maximum speed
## min_speed

```lua
number
```

Minimum speed
## on_block

```lua
fun(self: Mover)
```

Collision terrain callback
## on_break

```lua
fun(self: Mover)
```

Motion interrupt callback
## on_finish

```lua
fun(self: Mover)
```

End of motion callback
## on_hit

```lua
fun(self: Mover, unit: Unit)
```

Collision unit callback
## on_remove

```lua
fun(self: Mover)
```

Motion remove callback
## parabola_height

```lua
number
```

Height of the vertex of the parabola
## priority

```lua
integer
```

priority
## speed

```lua
number
```

Initial velocity
## terrain_block

```lua
boolean
```

Whether it will be blocked by terrain
## unit

```lua
Unit
```

Associated unit

# Mover.CreateData.Round

## ability

```lua
Ability
```

Relevance skill
## absolute_height

```lua
boolean
```

Whether absolute height is used
## angle_speed

```lua
number
```

Circling velocity
## block_interval

```lua
number
```

The interval at which a terrain blocking event is triggered
## clock_wise

```lua
boolean
```

Clockwise or not
## face_angle

```lua
boolean
```

Whether to always face the direction of motion
## height

```lua
number
```

Circling height
## hit_interval

```lua
number
```

Collision with the same unit interval
## hit_radius

```lua
number
```

Collision range
## hit_same

```lua
boolean
```

Whether to repeatedly collide with the same unit
## hit_type

```lua
integer
```

Collision type 0: enemy; 1: Allies; 2: All
## init_angle

```lua
number
```

Initial Angle
## lifting_speed

```lua
number
```

Lifting speed
## on_block

```lua
fun(self: Mover)
```

Collision terrain callback
## on_break

```lua
fun(self: Mover)
```

Motion interrupt callback
## on_finish

```lua
fun(self: Mover)
```

End of motion callback
## on_hit

```lua
fun(self: Mover, unit: Unit)
```

Collision unit callback
## on_remove

```lua
fun(self: Mover)
```

Motion remove callback
## priority

```lua
integer
```

priority
## radius

```lua
number
```

Circumferential radius
## radius_speed

```lua
number
```

Velocity of radius change
## round_time

```lua
number
```

Circling time
## target

```lua
Point|Unit
```

Circling target
## target_point

```lua
Point
```

Target point
## terrain_block

```lua
boolean
```

Whether it will be blocked by terrain
## unit

```lua
Unit
```

Associated unit

# Mover.CreateData.Target

## ability

```lua
Ability
```

Relevance skill
## absolute_height

```lua
boolean
```

Whether absolute height is used
## acceleration

```lua
number
```

acceleration
## bind_point

```lua
string
```

Binding point
## block_interval

```lua
number
```

The interval at which a terrain blocking event is triggered
## face_angle

```lua
boolean
```

Whether to always face the direction of motion
## height

```lua
number
```

Initial altitude
## hit_interval

```lua
number
```

Collision with the same unit interval
## hit_radius

```lua
number
```

Collision range
## hit_same

```lua
boolean
```

Whether to repeatedly collide with the same unit
## hit_type

```lua
integer
```

Collision type 0: enemy; 1: Allies; 2: All
## max_speed

```lua
number
```

Maximum speed
## min_speed

```lua
number
```

Minimum speed
## on_block

```lua
fun(self: Mover)
```

Collision terrain callback
## on_break

```lua
fun(self: Mover)
```

Motion interrupt callback
## on_finish

```lua
fun(self: Mover)
```

End of motion callback
## on_hit

```lua
fun(self: Mover, unit: Unit)
```

Collision unit callback
## on_remove

```lua
fun(self: Mover)
```

Motion remove callback
## parabola_height

```lua
number
```

Height of the vertex of the parabola
## priority

```lua
integer
```

priority
## speed

```lua
number
```

Initial velocity
## target

```lua
Destructible|Item|Unit
```

Tracking target
## target_distance

```lua
number
```

The distance to the target
## terrain_block

```lua
boolean
```

Whether it will be blocked by terrain
## unit

```lua
Unit
```

Associated unit

