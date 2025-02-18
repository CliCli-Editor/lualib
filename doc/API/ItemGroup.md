# ItemGroup

Item group

## create

```lua
function ItemGroup.create()
  -> ItemGroup
```

## create_lua_item_group_from_py

```lua
function ItemGroup.create_lua_item_group_from_py(py_item_group: py.ItemGroup)
  -> ItemGroup
```

## get_all_items_in_shapes

```lua
function ItemGroup.get_all_items_in_shapes(point: Point, shape: Shape)
  -> ItemGroup
```

Sift through all items in the range

@*param* `point` — 点

@*param* `shape` — Screening range
## get_by_handle

```lua
function ItemGroup.get_by_handle(py_item_group: py.ItemGroup)
  -> ItemGroup
```

## handle

```lua
py.ItemGroup
```

Item group
## pick

```lua
(method) ItemGroup:pick()
  -> Item[]
```

Go through the item group and the player does the action
## type

```lua
string
```


