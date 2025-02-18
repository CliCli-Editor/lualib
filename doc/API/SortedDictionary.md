# SortedDictionary

## SortedPairs

```lua
(method) SortedDictionary:SortedPairs()
  -> fun():any, any
```

 Gets ordered iterators
## add

```lua
(method) SortedDictionary:add(key: any, value: any)
```

 Add or update key-value pairs
## containsKey

```lua
(method) SortedDictionary:containsKey(key: any)
  -> boolean
```

 Check whether keys are included
## dictionary

```lua
table<any, any>
```

## get

```lua
(method) SortedDictionary:get(key: any)
  -> any
```

 Fetch value
## getSortedKeys

```lua
(method) SortedDictionary:getSortedKeys()
  -> table
```

 Gets the sorted list of keys
## remove

```lua
(method) SortedDictionary:remove(key: any)
```

 Remove a key-value pair

# SortedDictionary.Clock

## SortedPairs

```lua
(method) SortedDictionary:SortedPairs()
  -> fun():any, any
```

 Gets ordered iterators
## add

```lua
fun(self: SortedDictionary.Clock, key: number, value: NPBehave.Clock.Timer)
```

## containsKey

```lua
(method) SortedDictionary:containsKey(key: any)
  -> boolean
```

 Check whether keys are included
## dictionary

```lua
table<any, any>
```

## get

```lua
fun(self: SortedDictionary.Clock, key: number):NPBehave.Clock.Timer
```

## getSortedKeys

```lua
(method) SortedDictionary:getSortedKeys()
  -> table
```

 Gets the sorted list of keys
## remove

```lua
(method) SortedDictionary:remove(key: any)
```

 Remove a key-value pair

