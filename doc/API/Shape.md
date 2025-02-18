# Shape

shape

## create_annular_shape

```lua
function Shape.create_annular_shape(in_radius: number, out_radius: number)
  -> Shape
```

Create a ring

@*param* `in_radius` — Inner radius

@*param* `out_radius` — External radius
## create_circular_shape

```lua
function Shape.create_circular_shape(radius: number)
  -> Shape
```

Create a circle

@*param* `radius` — radius
## create_rectangle_shape

```lua
function Shape.create_rectangle_shape(width: number, length: number, angle: number)
  -> Shape
```

Create a rectangular area

@*param* `width` — breadth

@*param* `length` — Length

@*param* `angle` — Angle
## create_sector_shape

```lua
function Shape.create_sector_shape(radius: number, angle: number, direction: number)
  -> Shape
```

sector

@*param* `radius` — radius

@*param* `angle` — Angle

@*param* `direction` — direction
## get_by_handle

```lua
function Shape.get_by_handle(py_shape: py.Shape)
  -> Shape
```

## handle

```lua
py.Shape
```

shape
## type

```lua
string
```


