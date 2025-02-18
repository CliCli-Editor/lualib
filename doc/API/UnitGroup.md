# UnitGroup

Unit group

## add_unit

```lua
(method) UnitGroup:add_unit(unit: Unit)
```

Add unit

@*param* `unit` — unit
## clear

```lua
(method) UnitGroup:clear()
```

Empty unit group
## count

```lua
(method) UnitGroup:count()
  -> unit_group_num: integer
```

Gets the number of units in a unit group

@*return* `unit_group_num` — Unit quantity
## count_by_key

```lua
(method) UnitGroup:count_by_key(unit_key: py.UnitKey)
  -> num_of_unit: integer
```

The number of unit types in a unit group

@*return* `num_of_unit` — The number of unit types
## create

```lua
function UnitGroup.create()
  -> UnitGroup
```

Example Create an empty unit group
## get_by_handle

```lua
function UnitGroup.get_by_handle(py_unit_group: py.UnitGroup)
  -> UnitGroup
```

## get_first

```lua
(method) UnitGroup:get_first()
  -> unit: Unit?
```

Gets the first unit in the unit group

@*return* `unit` — Unit The first unit in a group
## get_last

```lua
(method) UnitGroup:get_last()
  -> unit: Unit?
```

Gets the last unit in the unit group

@*return* `unit` — Last unit
## get_random

```lua
(method) UnitGroup:get_random()
  -> unit: Unit?
```

Gets a random unit in a unit group

@*return* `unit` — A random unit in the unit group
## handle

```lua
py.UnitGroup
```

Unit group
## pick

```lua
(method) UnitGroup:pick()
  -> Unit[]
```

Converts a group of units to an array of units in Lua
## pick_by_key

```lua
function UnitGroup.pick_by_key(unit_key: py.UnitKey)
  -> unit_group: UnitGroup
```

Selects the unit for the specified unit type

@*param* `unit_key` — Unit typeid

@*return* `unit_group` — Unit group
## pick_random_n

```lua
(method) UnitGroup:pick_random_n(count: integer)
  -> unit_group: UnitGroup
```

A random integer in a unit group

@*return* `unit_group` — Random integer units
## remove_unit

```lua
(method) UnitGroup:remove_unit(unit: Unit)
```

Remove unit

@*param* `unit` — unit
## remove_units_by_key

```lua
(method) UnitGroup:remove_units_by_key(unit_key: py.UnitKey)
```

Remove unit type

@*param* `unit_key` — Unit typeid
## select_units

```lua
(method) UnitGroup:select_units()
```

Select units by unit group

