# ECAFunction

Register ECA functions

You can use this feature to have lua functions called in ECA。

## call

```lua
(method) ECAFunction:call(func: function)
```

Executed function
## call_name

```lua
string
```

## func

```lua
function
```

## params

```lua
{ key: string, type: string, optional: boolean }[]
```

## returns

```lua
{ key: string, type: string }[]
```

## with_param

```lua
(method) ECAFunction:with_param(key: string, type_name: string)
  -> ECAFunction
```

Add parameter
## with_return

```lua
(method) ECAFunction:with_return(key: string, type_name: string)
  -> ECAFunction
```

Add return value

