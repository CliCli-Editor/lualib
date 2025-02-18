# ProjectileGroup

Projectile set

## create_lua_projectile_group_from_py

```lua
function ProjectileGroup.create_lua_projectile_group_from_py(py_projectile_group: py.ProjectileGroup)
  -> ProjectileGroup
```

## get_all_projectile_in_shapes

```lua
function ProjectileGroup.get_all_projectile_in_shapes(point: Point, shape: Shape)
  -> ProjectileGroup
```

Screen all projectiles within range

@*param* `point` — 点

@*param* `shape` — Screening range
## get_all_projectiles_with_tag

```lua
function ProjectileGroup.get_all_projectiles_with_tag(tag: string)
  -> ProjectileGroup
```

Gets the projectile with the specified label

@*param* `tag` — 点
## handle

```lua
py.ProjectileGroup
```

Projectile set
## pick

```lua
(method) ProjectileGroup:pick()
  -> Projectile[]
```

Move through projectiles in the projectiles group
## type

```lua
string
```


