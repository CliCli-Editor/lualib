# Beam

Lightning effects (Beams）

## create

```lua
function Beam.create(data: Beam.CreateData)
  -> Beam
```

## create_lua_beam_by_py

```lua
function Beam.create_lua_beam_by_py(py_beam: py.LinkSfx)
  -> beam: Beam
```

## handle

```lua
py.LinkSfx
```

Link effect
## remove

```lua
(method) Beam:remove()
```

Link effects - Destroy
## set

```lua
(method) Beam:set(data: Beam.LinkData)
```

Link Effects - Set the location
## show

```lua
(method) Beam:show(is_show: boolean)
```

@*param* `is_show` — Show or not

Link effects - Show/Hide
## type

```lua
string
```


# Beam.CreateData

## follow_scale

```lua
boolean
```

Whether to follow scaling (only if the starting point is a unit）
## immediate

```lua
boolean
```

When destroyed, whether there is excessive
## key

```lua
py.SfxKey
```

VFXid
## source

```lua
Point|Unit
```

goal
## source_height

```lua
number
```

Height (Only effective if the target is a point）
## source_socket

```lua
string
```

Hang contact (Only effective if the target is a unit）
## target

```lua
Point|Unit
```

goal
## target_height

```lua
number
```

Height (Only effective if the target is a point）
## target_socket

```lua
string
```

Hang contact (Only effective if the target is a unit）
## time

```lua
number
```

Time of existence

# Beam.LinkData

## height

```lua
number
```

Height (Only effective if the target is a point）
## point_type

```lua
y3.Const.LinkSfxPointType
```

Start or end
## socket

```lua
string
```

Hang contact (Only effective if the target is a unit）
## target

```lua
Point|Unit
```

goal

