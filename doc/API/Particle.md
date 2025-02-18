# Particle

Particle effect

## create

```lua
function Particle.create(data: Particle.Param.Create)
  -> Particle
```

Create effects to units or points
## create_screen

```lua
function Particle.create_screen(data: Particle.Param.Screen)
  -> Particle
```

Create screen effects
## get_by_handle

```lua
function Particle.get_by_handle(py_sfx: py.Sfx)
  -> Particle
```

## get_handle

```lua
(method) Particle:get_handle()
  -> py.Sfx
```

## handle

```lua
py.Sfx
```

VFX
## remove

```lua
(method) Particle:remove()
```

Deletion particle
## set_animation_speed

```lua
(method) Particle:set_animation_speed(speed: number)
```

Set animation speed

@*param* `speed` — speed
## set_color

```lua
(method) Particle:set_color(x: number, y: number, z: number, w: number)
```

Set effects color

@*param* `x` — x

@*param* `y` — y

@*param* `z` — z

@*param* `w` — w
## set_facing

```lua
(method) Particle:set_facing(direction: number)
```

orientation

@*param* `direction` — direction
## set_height

```lua
(method) Particle:set_height(height: number)
```

Set height

@*param* `height` — Altitude
## set_point

```lua
(method) Particle:set_point(point: Point)
```

Set coordinates

@*param* `point` — 点
## set_rotate

```lua
(method) Particle:set_rotate(x: number, y: number, z: number)
```

Set rotation Angle

@*param* `x` — XShaft Angle

@*param* `y` — YShaft Angle

@*param* `z` — ZShaft Angle
## set_scale

```lua
(method) Particle:set_scale(x: number, y: number, z: number)
```

Set scale

@*param* `x` — XAxis scaling

@*param* `y` — YAxis scaling

@*param* `z` — ZAxis scaling
## set_time

```lua
(method) Particle:set_time(duration: number)
```

Set duration

@*param* `duration` — duration
## set_visible

```lua
(method) Particle:set_visible(visible: boolean)
```

Set effects display

@*param* `visible` — Switch
## type

```lua
string
```


# Particle.Param.Create

## angle

```lua
number
```

direction
## follow_rotation

```lua
integer|y3.Const.SfxRotateType
```

Pattern that follows unit rotation, only valid if the type of 'target' is unit
## follow_scale

```lua
boolean
```

Whether to scale with units is valid only if the type of 'target' is units
## height

```lua
number
```

Height, valid only if the type of 'target' is a point
## immediate

```lua
boolean
```

When destroyed, whether to remove the display effect immediately
## scale

```lua
number
```

Zoom
## socket

```lua
string
```

The effect is only valid if the type of 'target' is in units
## target

```lua
Point|Unit
```

点
## time

```lua
number
```

duration
## type

```lua
py.SfxKey
```

Special effect typeid

# Particle.Param.Screen

## is_on_fog

```lua
boolean
```

Above the fog
## target

```lua
Player
```

Player
## time

```lua
number
```

duration
## type

```lua
py.SfxKey
```

VFXid

