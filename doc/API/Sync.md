# Sync

 Sync local data to all players

## onSync

```lua
function Sync.onSync(id: string, callback: fun(data: Serialization.SupportTypes, source: Player))
```

 The data is received synchronously, and the callback function is executed after synchronization  
 Only one callback function can be registered with the same id, and the later ones will overwrite the earlier ones
## send

```lua
function Sync.send(id: string, data: Serialization.SupportTypes)
```

 Send local messages and use 'onSync' to synchronize receiving data  
 Use this function in your local environment

@*param* `id` — Ids beginning with '$' are reserved for internal use
## syncMap

```lua
table
```


