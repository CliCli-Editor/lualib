# Selector

chooser

Used to select units within a region

## count

```lua
(method) Selector:count(count: integer)
  -> Selector
```

 Options - The number of selections
## create

```lua
function Selector.create()
  -> Selector
```

 Create picker
## get

```lua
(method) Selector:get()
  -> UnitGroup
```

 Make selection
## in_range

```lua
(method) Selector:in_range(cent: Item|Point|Unit, radius: number)
  -> Selector
```

 Shape - In a circular area
## in_shape

```lua
(method) Selector:in_shape(pos: Point, shape: Shape)
  -> Selector
```

 Shape - Adds shape objects
## in_state

```lua
(method) Selector:in_state(state: integer|y3.Const.UnitEnumState)
  -> Selector
```

 Condition - Having a certain state
## include_dead

```lua
(method) Selector:include_dead()
  -> Selector
```

 Option - Contains dead units
## ipairs

```lua
(method) Selector:ipairs()
  -> fun(table: <V>[], i?: integer):integer, <V>
  2. Unit[]
  3. integer
```

 traversal
## is_ally

```lua
(method) Selector:is_ally(p: Player)
  -> Selector
```

 Condition - Is an ally of a player
## is_enemy

```lua
(method) Selector:is_enemy(p: Player)
  -> Selector
```

 Condition - Is an enemy of a player
## is_unit_key

```lua
(method) Selector:is_unit_key(unit_key: py.UnitKey)
  -> Selector
```

 Condition - Is a specific unit type
## is_unit_type

```lua
(method) Selector:is_unit_type(unit_type: py.UnitType)
  -> Selector
```

 Condition - Is a specific unit type
## is_visible

```lua
(method) Selector:is_visible(p: Player)
  -> Selector
```

 Condition - Visible to a player
## not_in_group

```lua
(method) Selector:not_in_group(ug: UnitGroup)
  -> Selector
```

 Condition - Not in a unit group
## not_in_state

```lua
(method) Selector:not_in_state(state: integer|y3.Const.UnitEnumState)
  -> Selector
```

 Condition - Does not possess a particular state
## not_is

```lua
(method) Selector:not_is(u: Unit)
  -> Selector
```

 Condition - Not a specific unit
## not_visible

```lua
(method) Selector:not_visible(p: Player)
  -> Selector
```

 Condition - Not visible to a player
## of_player

```lua
(method) Selector:of_player(p: Player|PlayerGroup)
  -> Selector
```

 Condition - Belongs to a player or a group of players
## pick

```lua
(method) Selector:pick()
  -> Unit[]
```

 Make selection
## sort_type

```lua
(method) Selector:sort_type(st: Selector.SortType)
  -> Selector
```

 Sort - Sort in a certain way
## with_tag

```lua
(method) Selector:with_tag(tag: string)
  -> Selector
```

 Condition - Have a specific label
## without_tag

```lua
(method) Selector:without_tag(tag?: string)
  -> Selector
```

 Condition - Do not own a specific label

# Selector.SortType

```lua
"From near to far "|" from far to near "|" random"
```


