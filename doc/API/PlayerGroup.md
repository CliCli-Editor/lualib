# PlayerGroup

Player group

## add_player

```lua
(method) PlayerGroup:add_player(player: Player)
```

Add a player

@*param* `player` — Player
## clear

```lua
(method) PlayerGroup:clear()
```

Clear player group
## count

```lua
(method) PlayerGroup:count()
  -> integer
```

Gets the number of players in the player group
## create

```lua
function PlayerGroup.create()
  -> PlayerGroup
```

Create an empty player group
## get_all_players

```lua
function PlayerGroup.get_all_players()
  -> player_group: PlayerGroup
```

Get all players

@*return* `player_group` — Unit group
## get_ally_player_group_by_player

```lua
function PlayerGroup.get_ally_player_group_by_player(player: Player)
  -> player_group: PlayerGroup
```

All allied players of the player

@*param* `player` — Player

@*return* `player_group` — Unit group
## get_by_handle

```lua
function PlayerGroup.get_by_handle(py_role_group: py.RoleGroup)
  -> PlayerGroup
```

## get_defeated_player_group

```lua
function PlayerGroup.get_defeated_player_group()
  -> player_group: PlayerGroup
```

Get all failed players

@*return* `player_group` — Unit group
## get_enemy_player_group_by_player

```lua
function PlayerGroup.get_enemy_player_group_by_player(player: Player)
  -> player_group: PlayerGroup
```

All enemy players of the player

@*param* `player` — Player

@*return* `player_group` — Unit group
## get_neutral_player_group

```lua
function PlayerGroup.get_neutral_player_group()
  -> player_group: PlayerGroup
```

All non-neutral players

@*return* `player_group` — Unit group
## get_player_group_by_camp

```lua
function PlayerGroup.get_player_group_by_camp(camp: py.Camp)
  -> player_group: PlayerGroup
```

All players in the camp

@*param* `camp` — Factions

@*return* `player_group` — Unit group
## get_victorious_player_group

```lua
function PlayerGroup.get_victorious_player_group()
  -> player_group: PlayerGroup
```

The player who gets all the wins

@*return* `player_group` — Unit group
## handle

```lua
py.RoleGroup
```

Player group
## pick

```lua
(method) PlayerGroup:pick()
  -> Player[]
```

Converts the player group to Lua's player array
## remove_player

```lua
(method) PlayerGroup:remove_player(player: Player)
```

Remove the player

@*param* `player` — Player
## type

```lua
string
```


