# Pool

## add

```lua
(method) Pool:add(obj: any, w?: integer)
```

 Add object
## add_weight

```lua
(method) Pool:add_weight(obj: any, w: integer)
```

 Increases the weight of an object
## clear

```lua
(method) Pool:clear()
```

 Emptying tank
## del

```lua
(method) Pool:del(obj: any)
```

 Remove objects. Do not remove objects during traversal
## dump

```lua
(method) Pool:dump()
  -> string
```

 Displays the contents of the pool for debugging purposes only
## get_weight

```lua
(method) Pool:get_weight(obj: any)
  -> integer
```

 Gets the weight of the object
## has

```lua
(method) Pool:has(obj: any)
  -> boolean
```

 Include object or not
## order

```lua
table
```

## pairs

```lua
(method) Pool:pairs()
  -> fun():any, integer
```

 Iterate over the pool object
## pool

```lua
table<any, integer>
```

## random

```lua
(method) Pool:random(filter?: fun(obj: any):boolean)
  -> any
```

 Pick an object at random
## random_n

```lua
(method) Pool:random_n(num: integer, filter?: fun(obj: any):boolean)
  -> any[]
```

 Multiple random objects are extracted without repetition
## set_weight

```lua
(method) Pool:set_weight(obj: any, w: integer)
```

 Modify the weight of an object

