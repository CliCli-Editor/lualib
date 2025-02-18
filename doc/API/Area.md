# Area

region

## add_tag

```lua
(method) Area:add_tag(tag: string)
```

Label the area

@*param* `tag` — tag
## create_circle_area

```lua
function Area.create_circle_area(point: Point, radius: number)
  -> Circular region: Area
```

Create a circle

@*param* `point` — 点

@*param* `radius` — radius
## create_polygon_area_by_points

```lua
function Area.create_polygon_area_by_points(...Point)
  -> polygon: Area
```

Create polygons along points

@*return* `polygon` — Polygon region
## create_rectangle_area

```lua
function Area.create_rectangle_area(point: Point, horizontal_length: number, vertical_length: number)
  -> area: Area
```

Create a rectangular area

@*param* `point` — 点

@*param* `horizontal_length` — Length

@*param* `vertical_length` — breadth

@*return* `area` — Rectangular region
## create_rectangle_area_from_two_points

```lua
function Area.create_rectangle_area_from_two_points(point_one: Point, point_two: Point)
  -> area: Area
```

Creates a rectangular area with a starting and ending point

@*param* `point_one` — 点1

@*param* `point_two` — 点2

@*return* `area` — Rectangular region
## edit_area_collision

```lua
(method) Area:edit_area_collision(collision_layer: integer, is_add: boolean)
```

Edit area collision

@*param* `collision_layer` — Collision type

@*param* `is_add` — Add/remove
## edit_area_fov_block

```lua
(method) Area:edit_area_fov_block(fov_block_type: integer, is_add: boolean)
```

Edit area field of view blocked

@*param* `fov_block_type` — Visual field blocking type

@*param* `is_add` — Add/remove
## event

```lua
fun(self: Area, event: "Area - Enter ", callback: fun(trg: Trigger, data: EventParam. zone-access)):Trigger
```

## get_all_unit_in_area

```lua
(method) Area:get_all_unit_in_area()
  -> Unit group: Unit[]
```

All units in the area
## get_by_handle

```lua
function Area.get_by_handle(py_area: py.Area, shape?: Area.Shape)
  -> Area
```

Create a region based on the py object

@*param* `py_area` — pyLayer object

@*param* `shape` — 见area.enum
## get_by_res_id

```lua
function Area.get_by_res_id(res_id: py.AreaID, shape?: Area.Shape)
  -> Area
```

@*param* `res_id` — Edit sceneid

@*param* `shape` — 见area.enum
## get_center_point

```lua
(method) Area:get_center_point()
  -> Central point: Point
```

 Get center point
## get_circle_areas_by_tag

```lua
function Area.get_circle_areas_by_tag(tag: string)
  -> area: Area[]
```

Get all the circular areas by label

@*param* `tag` — tag

@*return* `area` — Rectangular region
## get_circle_by_res_id

```lua
function Area.get_circle_by_res_id(res_id: py.AreaID)
  -> Area
```

Get the circle area based on the scene id

@*param* `res_id` — Edit sceneid
## get_map_area

```lua
function Area.get_map_area()
  -> Area
```

Get the full map area
## get_max_x

```lua
(method) Area:get_max_x()
  -> Xcoordinate: number
```

Gets the maximum X coordinate in the region
## get_max_y

```lua
(method) Area:get_max_y()
  -> Ycoordinate: number
```

Gets the maximum Y coordinate in the region
## get_min_x

```lua
(method) Area:get_min_x()
  -> Xcoordinate: number
```

Gets the minimum X-coordinate in the region
## get_min_y

```lua
(method) Area:get_min_y()
  -> Ycoordinate: number
```

Gets the minimum Y coordinate in the region
## get_polygon_areas_by_tag

```lua
function Area.get_polygon_areas_by_tag(tag: string)
  -> area: Area[]
```

Get all polygon areas by label

@*param* `tag` — tag

@*return* `area` — Polygon area table
## get_polygon_areas_point_list

```lua
function Area.get_polygon_areas_point_list(polygon: Area)
  -> area: table
```

Gets all the vertices of the polygon

@*param* `polygon` — Polygon region

@*return* `area` — Polygon vertex table
## get_polygon_by_res_id

```lua
function Area.get_polygon_by_res_id(res_id: py.AreaID)
  -> Area
```

Get the polygon area based on the scene id

@*param* `res_id` — Edit sceneid
## get_radius

```lua
(method) Area:get_radius()
  -> radius: number
```

Obtain the radius of the circular area
## get_rect_areas_by_tag

```lua
function Area.get_rect_areas_by_tag(tag: string)
  -> area: Area[]
```

Gets all rectangular areas by label

@*param* `tag` — tag

@*return* `area` — Rectangular region table
## get_rectangle_area_last_created

```lua
function Area.get_rectangle_area_last_created()
  -> Area
```

Gets the last rectangular area created
## get_rectangle_by_res_id

```lua
function Area.get_rectangle_by_res_id(res_id: py.AreaID)
  -> Area
```

Gets a rectangular area based on the scene id

@*param* `res_id` — Edit sceneid
## get_unit_group_in_area

```lua
(method) Area:get_unit_group_in_area(player: Player)
  -> Unit group: UnitGroup
```

Intra-area player units (unit groups)

@*param* `player` — Player
## get_unit_in_area_by_camp

```lua
(method) Area:get_unit_in_area_by_camp(camp: py.Camp)
  -> Unit group: Unit[]
```

All units of the camp in the area
## get_unit_num_in_area

```lua
(method) Area:get_unit_num_in_area()
  -> quantity: integer
```

The number of units in the region
## get_weather

```lua
(method) Area:get_weather()
  -> Weather enumeration: integer
```

Obtain regional weather
## handle

```lua
py.Area
```

region
## has_tag

```lua
(method) Area:has_tag(tag: string)
  -> Whether the area hastag: boolean
```

Whether the area hastag

@*param* `tag` — tag
## is_point_in_area

```lua
(method) Area:is_point_in_area(point: Point)
  -> boolean
```

 Whether the point is in the area

@*param* `point` — 点
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
## map

```lua
{ [py.AreaID]: Area }
```

## object_event_manager

```lua
EventManager?
```

## random_point

```lua
(method) Area:random_point()
  -> Point
```

 Get random points
## ref_manager

```lua
unknown
```

## remove

```lua
(method) Area:remove()
```

Delete area
## remove_tag

```lua
(method) Area:remove_tag(tag: string)
```

Remove the label from the area

@*param* `tag` — tag
## res_id

```lua
integer?
```

## set_collision

```lua
(method) Area:set_collision(is_collision_effect: boolean, is_land_effect: boolean, is_air_effect: boolean)
```

Set area collision

@*param* `is_collision_effect` — Effect of collision

@*param* `is_land_effect` — Ground collision switch

@*param* `is_air_effect` — Air collision switch
## set_radius

```lua
(method) Area:set_radius(radius: number)
```

Set the radius of the circle area

@*param* `radius` — radius
## set_size

```lua
(method) Area:set_size(horizontal_length: number, vertical_length: number)
```

Sets the radius of the rectangular area

@*param* `horizontal_length` — Length

@*param* `vertical_length` — breadth
## set_visible

```lua
(method) Area:set_visible(player: Player, is_visibility: boolean, is_real_visibility: boolean)
```

Set the polygon area visible to the player

@*param* `player` — Player

@*param* `is_visibility` — Open vision or not

@*param* `is_real_visibility` — Whether to open the real vision
## shape

```lua
Area.Shape
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


# Area.Shape

```lua
{
    CIRCLE: integer = 1,
    RECTANGLE: integer = 2,
    POLYGON: integer = 3,
}
```


