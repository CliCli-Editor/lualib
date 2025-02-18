# Point

点

## create

```lua
function Point.create(x: number, y: number, z?: number)
  -> Point
```

Coordinates are converted to points

@*param* `x` — Point X coordinate

@*param* `y` — Point Y coordinate

@*param* `z` — Point Z coordinate
## get_angle_with

```lua
(method) Point:get_angle_with(other: Point)
  -> number
```

 Gets the direction with another point
## get_by_handle

```lua
function Point.get_by_handle(py_point: Point.HandleType)
  -> Point
```

Create points based on the py object
## get_distance_with

```lua
(method) Point:get_distance_with(other: Point)
  -> number
```

 Gets the distance from another point
## get_point

```lua
(method) Point:get_point()
  -> Point
```

## get_point_by_res_id

```lua
function Point.get_point_by_res_id(res_id: integer)
  -> Point
```

## get_point_in_path

```lua
function Point.get_point_in_path(path: table, index: integer)
  -> Point
```

Point in the path

@*param* `path` — Target path

@*param* `index` — index
## get_point_offset_vector

```lua
function Point.get_point_offset_vector(point: Point, direction: number, offset: number)
  -> Point
```

The point is shifting in the direction

@*param* `point` — 点

@*param* `direction` — Offset point

@*param* `offset` — offset
## get_random_point

```lua
(method) Point:get_random_point(radius: any)
  -> Point
```

Gets random points in a circle range
## get_x

```lua
(method) Point:get_x()
  -> number
```

The x-coordinate of the point
## get_y

```lua
(method) Point:get_y()
  -> number
```

The y coordinate of the point
## get_z

```lua
(method) Point:get_z()
  -> number
```

The z coordinate of the point
## handle

```lua
Point.HandleType
```

点
## map

```lua
table
```

## move

```lua
(method) Point:move(x?: number, y?: number, z?: number)
  -> Point
```

 Moving point
## res_id

```lua
integer?
```

## type

```lua
string
```

## x

```lua
number
```

## y

```lua
number
```

## z

```lua
number
```


# Point.HandleType

点


```lua
py.FPoint
```


