# SaveData

On file

## load_boolean

```lua
function SaveData.load_boolean(player: Player, slot: integer)
  -> boolean
```

 Get the player's saved data (Boolean）
## load_integer

```lua
function SaveData.load_integer(player: Player, slot: integer)
  -> integer
```

 Get the player's saved data (integers）
## load_real

```lua
function SaveData.load_real(player: Player, slot: integer)
  -> number
```

 Get the player's saved data (real numbers）
## load_string

```lua
function SaveData.load_string(player: Player, slot: integer)
  -> string
```

 Get the player's archive data (string）
## load_table

```lua
function SaveData.load_table(player: Player, slot: integer, disable_cover: boolean)
  -> table
```

 Get the player's saved data (table）

@*param* `disable_cover` — Whether to disable overwrite must be the same as in the archive Settings
## load_table_with_cover_disable

```lua
function SaveData.load_table_with_cover_disable(player: Player, slot: integer)
  -> table
```

## load_table_with_cover_enable

```lua
function SaveData.load_table_with_cover_enable(player: Player, slot: integer)
  -> table
```

## save_boolean

```lua
function SaveData.save_boolean(player: Player, slot: integer, value: boolean)
```

 Save the player's saved data (Boolean）
## save_integer

```lua
function SaveData.save_integer(player: Player, slot: integer, value: integer)
```

 Save the player's saved data (integers）
## save_real

```lua
function SaveData.save_real(player: Player, slot: integer, value: number)
```

 Save the player's saved data (real numbers）
## save_string

```lua
function SaveData.save_string(player: Player, slot: integer, value: string)
```

 Save the player's saved data (string）
## save_table

```lua
function SaveData.save_table(player: Player, slot: integer, t: table)
```

 Save the player's save data (table), the save Settings must use the allow overwrite mode
## table_cache

```lua
table
```

## timer_map

```lua
{ [Player]: LocalTimer }
```

## upload_save_data

```lua
function SaveData.upload_save_data(player: Player)
```


