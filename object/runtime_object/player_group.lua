--Player group
---@class PlayerGroup
---@field handle py.RoleGroup
---@field private _removed? boolean
---@overload fun(py_player_group? : py.RoleGroup): self
local M = Class 'PlayerGroup'

M.type = 'player_group'

function M:__tostring()
    return string.format('{PlayerGroup|%s}'
        , self.handle
    )
end

---@param py_player_group py.RoleGroup
---@return self
function M:__init(py_player_group)
    self.handle = py_player_group
    return self
end

function M:__len()
    return self:count()
end

function M:__pairs()
    return self:pairs()
end

---@param py_role_group py.RoleGroup
---@return PlayerGroup
function M.get_by_handle(py_role_group)
    local player_group = New 'PlayerGroup' (py_role_group)
    return player_group
end

clicli.py_converter.register_type_alias('py.RoleGroup', 'PlayerGroup')
clicli.py_converter.register_py_to_lua('py.RoleGroup', M.get_by_handle)
clicli.py_converter.register_lua_to_py('py.RoleGroup', function (lua_value)
    return lua_value.handle
end)

--Create an empty player group
---@return PlayerGroup
function M.create()
    return M.get_by_handle(GameAPI.create_role_group())
end

--Gets the number of players in the player group
---@return integer
function M:count()
    return #self.handle
end

--Converts the player group to Lua's player array
---@return Player[]
function M:pick()
    local lua_table = {}
    for _, iter_player in pairs(self.handle) do
        table.insert(lua_table, clicli.player.get_by_id(iter_player))
    end
    return lua_table
end

---Walk through the player group, do not modify the player group during the walk.
---```lua
---for player in PlayerGroup:pairs() do
---print(player)
---end
---```
---You can also iterate directly with 'pairs' :
---```lua
---for player in pairs(PlayerGroup) do
---print(player)
---end
---```
---@return fun(): Player?
function M:pairs()
    local i = -1
    local len = #self.handle
    return function ()
        i = i + 1
        if i >= len then
            return
        end
        local id = self.handle[i]
        local p = clicli.player.get_by_id(id)
        return p
    end
end

--Add a player
---@param player Player
function M:add_player(player)
    GameAPI.add_role_to_group(player.handle, self.handle)
end

--Remove the player
---@param player Player
function M:remove_player(player)
    GameAPI.rem_role_from_group(player.handle, self.handle)
end

--Clear player group
function M:clear()
    GlobalAPI.clear_group(self.handle)
end

---@private
M.ALL_PLAYERS = M.get_by_handle(GameAPI.get_all_role_ids())

---Get all players
---@return PlayerGroup player_group Indicates the unit group
function M.get_all_players()
    return M.ALL_PLAYERS
end

---All players in the camp
---@param camp py.Camp
---@return PlayerGroup player_group Indicates the unit group
function M.get_player_group_by_camp(camp)
    local py_player_group = GameAPI.get_role_ids_by_camp(camp)
    return M.get_by_handle(py_player_group)
end

---All enemy players of the player
---@param player Player
---@return PlayerGroup player_group Indicates the unit group
function M.get_enemy_player_group_by_player(player)
    local py_player_group = GameAPI.get_enemy_ids_by_role(player.handle)
    return M.get_by_handle(py_player_group)
end

---All allied players of the player
---@param player Player
---@return PlayerGroup player_group Indicates the unit group
function M.get_ally_player_group_by_player(player)
    local py_player_group = GameAPI.get_ally_ids_by_role(player.handle)
    return M.get_by_handle(py_player_group)
end

---The player who gets all the wins
---@return PlayerGroup player_group Indicates the unit group
function M.get_victorious_player_group()
    local py_player_group = GameAPI.get_victorious_role_ids()
    return M.get_by_handle(py_player_group)
end

---Get all failed players
---@return PlayerGroup player_group Indicates the unit group
function M.get_defeated_player_group()
    local py_player_group = GameAPI.get_defeated_role_ids()
    return M.get_by_handle(py_player_group)
end

---All non-neutral players
---@return PlayerGroup player_group Indicates the unit group
function M.get_neutral_player_group()
    local py_player_group = GameAPI.get_role_ids_by_type(1)
    return M.get_by_handle(py_player_group)
end

return M
