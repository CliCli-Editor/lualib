# Road

path

## add_point

```lua
(method) Road:add_point(index: integer, point: Point)
```

Add points to the path

@*param* `index` — Serial number

@*param* `point` — 点
## add_tag

```lua
(method) Road:add_tag(tag: string)
```

Label the path

@*param* `tag` — Serial number
## create_path

```lua
function Road.create_path(start_point: Point)
  -> Created path: Road
```

Create a path from a point

@*param* `start_point` — Starting point
## get_by_handle

```lua
function Road.get_by_handle(py_road: py.Road)
  -> Road
```

## get_path_areas_by_tag

```lua
function Road.get_path_areas_by_tag(tag: string)
  -> path: Road[]
```

Get all paths by label

@*param* `tag` — tag
## get_point_count

```lua
(method) Road:get_point_count()
  -> integer
```

Gets the number of points in a path
## get_road_by_res_id

```lua
function Road.get_road_by_res_id(res_id: integer)
  -> Road
```

## handle

```lua
py.Road
```

path
## has_tag

```lua
(method) Road:has_tag(tag: string)
  -> Whether the path hastag: boolean
```

Whether the path hastag

@*param* `tag` — tag
## map

```lua
table
```

## remove_path

```lua
(method) Road:remove_path()
```

Delete path
## remove_point

```lua
(method) Road:remove_point(index: integer)
```

Remove points from paths

@*param* `index` — Serial number
## remove_tag

```lua
(method) Road:remove_tag(tag: string)
```

Remove labels from paths

@*param* `tag` — Serial number
## res_id

```lua
integer
```


