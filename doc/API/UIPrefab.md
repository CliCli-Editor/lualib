# UIPrefab

Interface element

## create

```lua
function UIPrefab.create(player: Player, prefab_name: string, parent_ui: UI)
  -> UIPrefab
```

Example Create an interface module instance

@*param* `player` — Player

@*param* `prefab_name` — Interface moduleid

@*param* `parent_ui` — Parent control
## get_by_handle

```lua
function UIPrefab.get_by_handle(player: Player, prefab_name: string)
  -> UIPrefab
```

Obtain the interface instance of the lua layer from the interface instance of the py layer

@*param* `player` — Player

@*return* — Returns the lua layer skill instance after being initialized at the lua layer
## get_child

```lua
(method) UIPrefab:get_child(child_path?: string)
  -> UI?
```

Gets the UI instance of UIPrefab
>Attention! The path here is relative to the node after the first layer (that is, there is a node in the node list that cannot be deleted by default, that is the first layer)）

@*param* `child_path` — Path, the default is the root node。
## get_ui

```lua
(method) UIPrefab:get_ui(player: Player)
  -> UI
```

 Gets the UI instance of UIPrefab
>Use the get_child method instead

@*param* `player` — Player
## handle

```lua
string
```

## key

```lua
integer?
```

## kv_has

```lua
(method) KV:kv_has(key: string)
  -> boolean
```

 Whether the specified key - value pair is owned. Interwork with ECA。
## kv_key

```lua
string?
```

## kv_load

```lua
(method) KV:kv_load(key: string, lua_type: 'boolean'|'integer'|'number'|'string'|'table'...(+1))
  -> any
```

```lua
lua_type:
    | 'boolean'
    | 'number'
    | 'integer'
    | 'string'
    | 'table'
```
## kv_remove

```lua
(method) KV:kv_remove(key: any)
```

## kv_save

```lua
(method) KV:kv_save(key: string, value: KV.SupportType)
```

 Save custom key-value pairs. Interwork with ECA。
## player

```lua
Player
```

Player
## remove

```lua
(method) UIPrefab:remove()
```

Example Delete an interface module instance
## type

```lua
string
```


