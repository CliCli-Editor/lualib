# Cast

Casting example

Will be passed during spell-related events

## ability

```lua
Ability
```

skill
## cast_id

```lua
integer
```

## get

```lua
function Cast.get(ability: Ability, cast_id: integer)
  -> Cast
```

## get_ability

```lua
(method) Cast:get_ability()
  -> Ability
```

 Acquire skills
## get_angle

```lua
(method) Cast:get_angle()
  -> number
```

 Get casting directions
## get_target_destructible

```lua
(method) Cast:get_target_destructible()
  -> Destructible?
```

 Gets destructible objects from the casting target
## get_target_item

```lua
(method) Cast:get_target_item()
  -> Item?
```

 Get the target item
## get_target_point

```lua
(method) Cast:get_target_point()
  -> Point?
```

 Gets the casting target point
## get_target_unit

```lua
(method) Cast:get_target_unit()
  -> Unit?
```

 Gets the cast target unit
## storage_all

```lua
(method) Storage:storage_all()
  -> table
```

 Gets the container for storing data
## storage_get

```lua
(method) Storage:storage_get(key: any)
  -> any
```

 Gets the stored value
## storage_set

```lua
(method) Storage:storage_set(key: any, value: any)
```

 Store arbitrary values
## storage_table

```lua
table
```


