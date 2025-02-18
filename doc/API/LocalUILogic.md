# LocalUILogic

Native UI logic framework

## apply_kv

```lua
(method) LocalUILogic:apply_kv(kv?: table)
```

## as_prefab

```lua
(method) LocalUILogic:as_prefab(prefab_name: string)
```

## attach

```lua
(method) LocalUILogic:attach(ui: UI, kv?: table)
  -> LocalUILogic
```

Attach to a UI

@*param* `kv` — The data is obtained using 'instance:storage_get'
## bind_prefab

```lua
(method) LocalUILogic:bind_prefab(child_name: string, prefab_logic: LocalUILogic, prefab_token?: any)
```

Binding element

@*param* `child_name` — The empty string represents the master device

@*param* `prefab_logic` — Component logic created using 'clicli.local_ui.prefab'

@*param* `prefab_token` — If you bind the same components under different controls and need to refresh them separately, you can set different ones for them token
## bind_unit_attr

```lua
(method) LocalUILogic:bind_unit_attr(child_name: string, ui_attr: y3.Const.UIAttr, unit_attr: string|y3.Const.UnitAttr)
```

Binds the properties of the child control to the properties of the unit
## detach

```lua
(method) LocalUILogic:detach()
```

## get_refresh_targets

```lua
(method) LocalUILogic:get_refresh_targets(name: string)
  -> LocalUILogic.OnRefreshInfo[]
```

## init

```lua
(method) LocalUILogic:init()
```

## make_instance

```lua
(method) LocalUILogic:make_instance(kv?: table)
  -> LocalUILogic
```

## on_event

```lua
(method) LocalUILogic:on_event(child_name: string, event: y3.Const.UIEvent, callback: fun(ui: UI, local_player: Player, instance: LocalUILogic))
```

Subscribe to the control's local events, and the callback function is executed in the * local player * environment。

@*param* `child_name` — The empty string represents the master device

```lua
event:
    | 'Left button. - Press it'
    | 'Left click - Lift'
    | 'Left - click'
    | 'Left - Double-click'
    | 'Mouse - Hover'
    | 'Mouse - Move in'
    | 'Mouse - Move out'
    | 'Mouse - right click'
    | 'Right - Press it'
    | 'right-right-lift'
    | 'right-click'
    | 'right-double-click'
```
## on_init

```lua
(method) LocalUILogic:on_init(child_name: string, on_init: fun(ui: UI, local_player: Player, instance: LocalUILogic))
```

Subscribe to the initialization event of the control, the callback function is executed in the local player environment。

@*param* `child_name` — The empty string represents the master device
## on_refresh

```lua
(method) LocalUILogic:on_refresh(child_name: string, on_refresh: fun(ui: UI, local_player: Player, instance: LocalUILogic))
```

Subscribe to the control refresh, the callback function is executed in the * local player * environment。

@*param* `child_name` — The empty string represents the master device
## refresh

```lua
(method) LocalUILogic:refresh(name: string, player?: Player)
```

The refresh control, the specified control, and its child controls receive a refresh message。
Refresh all controls when the parameter is' * '。

@*param* `player` — Refresh only for this player
## refresh_prefab

```lua
(method) LocalUILogic:refresh_prefab(prefab_token: any, count?: integer, on_create?: fun(index: integer, kv: table))
```

Refresh element

@*param* `prefab_token` — The component to refresh defaults to the component logic at binding time

@*param* `count` — Modify the number of components

@*param* `on_create` — When creating a new component callback, 'kv' defaults to set 'index' to which component it is。
## register_events

```lua
(method) LocalUILogic:register_events()
```

## remove

```lua
(method) LocalUILogic:remove()
```

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


# LocalUILogic.OnEventInfo

## event

```lua
y3.Const.UIEvent
```

## name

```lua
string
```

## on_event

```lua
fun(ui: UI, local_player: Player, instance: LocalUILogic)
```


# LocalUILogic.OnInitInfo

## name

```lua
string
```

## on_init

```lua
fun(ui: UI, local_player: Player, instance: LocalUILogic)
```


# LocalUILogic.OnRefreshInfo

## name

```lua
string
```

## on_refresh

```lua
fun(ui: UI, local_player: Player, instance: LocalUILogic)
```


# LocalUILogic.PrefabInfo

## child_name

```lua
string
```

## prefab_logic

```lua
LocalUILogic
```

Native UI logic framework
## prefab_token

```lua
any
```


