# Light

illumination

Used to modify lighting, shadows, and other effects

## create_lua_light_by_py

```lua
function Light.create_lua_light_by_py(py_light: py.Light)
  -> light: Light
```

## create_point_light_at_point

```lua
function Light.create_point_light_at_point(point: Point, deviation_height: number)
  -> Light
```

Create point light source to point

@*param* `point` — Target point

@*param* `deviation_height` — Offset height
## create_point_light_at_unit_socket

```lua
function Light.create_point_light_at_unit_socket(unit: Unit, socket_name: string, deviation_height: number)
  -> Light
```

Create a point light source to the unit mount contact

@*param* `unit` — Target unit

@*param* `socket_name` — Hanging contact

@*param* `deviation_height` — Offset height
## create_spot_light_at_unit_socket

```lua
function Light.create_spot_light_at_unit_socket(unit: Unit, socket_name: string, pos_offset_y?: number, target_unit?: Unit, target_offset_y?: number)
  -> Light
```

Create a directional light source to the unit mount contact

@*param* `unit` — Target unit

@*param* `socket_name` — Hanging contact

@*param* `pos_offset_y` — Offset height

@*param* `target_unit` — Target unit

@*param* `target_offset_y` — Target offset height
## create_spot_light_to_point

```lua
function Light.create_spot_light_to_point(point: Point, pos_offset_y?: number, unit_point_projectile?: Point|Projectile|Unit, target_offset_y?: number)
  -> Light
```

Create directional light source to point

@*param* `point` — Target point

@*param* `pos_offset_y` — Offset height

@*param* `unit_point_projectile` — goal

@*param* `target_offset_y` — Target offset height
## get_light_attribute

```lua
(method) Light:get_light_attribute(key: string)
  -> Attribute value: number
```

Get light source properties

@*param* `key` — Attribute name
## get_light_cast_shadow_state

```lua
(method) Light:get_light_cast_shadow_state()
  -> Whether shadow is generated: boolean
```

Gets whether the light source produces shadows
## get_point_light_by_res_id

```lua
function Light.get_point_light_by_res_id(res_id: py.LightID)
  -> Light
```

Obtain a point light source based on the scene id

@*param* `res_id` — Edit sceneid
## get_spot_light_by_res_id

```lua
function Light.get_spot_light_by_res_id(res_id: py.LightID)
  -> Light
```

Get the spotlight based on the scene id

@*param* `res_id` — Edit sceneid
## handle

```lua
py.Light
```

illuminant
## map

```lua
table
```

## remove_light

```lua
(method) Light:remove_light()
```

Remove light source
## res_id

```lua
(py.LightID)?
```

illuminantID
## set_directional_light_attribute

```lua
(method) Light:set_directional_light_attribute(light_attr_type: string, value: number)
```

Set the directional light source properties

@*param* `light_attr_type` — Attribute name

@*param* `value` — Attribute value
## set_point_light_attribute

```lua
(method) Light:set_point_light_attribute(light_attr_type: string, value: number)
```

Set the point light properties

@*param* `light_attr_type` — Attribute name

@*param* `value` — Attribute value
## set_shadow_casting_status

```lua
(method) Light:set_shadow_casting_status(value: boolean)
```

Sets whether the light source produces shadows

@*param* `value` — Whether shadow is generated
## type

```lua
string
```


