# Ground

ground

Ground collision correlation method

## get_collision

```lua
function Ground.get_collision(point: Point)
  -> integer
```

Gets the collision type of the map at that point

@*param* `point` — Impact point
## get_height_level

```lua
function Ground.get_height_level(point: Point)
  -> level: integer
```

Gets the hierarchy of the map's position at that point

@*param* `point` — 点

@*return* `level` — hierarchy
## get_view_block_type

```lua
function Ground.get_view_block_type(point: Point)
  -> integer
```

Gets the view type of the map at that point
## set_collision

```lua
function Ground.set_collision(point: Point, is_collision_effect: boolean, is_land_effect: boolean, is_air_effect: boolean)
```

Set collision

@*param* `point` — Impact point

@*param* `is_collision_effect` — Effect of collision

@*param* `is_land_effect` — Ground collision switch

@*param* `is_air_effect` — Air collision switch

