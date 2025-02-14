--Player group
---@class PlayerGroup
---@field handle py.RoleGroup
---@field private _removed? boolean
---@overload fun(py_player_group?: py.RoleGroup): self
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
    return python_len(self.handle)
end

--Converts the player group to Lua's player array
---@return Player[]
function M:pick()
    local lua_table = {}
    for i = 1, python_len(self.handle) do
        local iter_player = python_index(self.handle,i-1)
        table.insert(lua_table, clicli.player.get_by_id(iter_player))
    end
    return lua_table
end

---遍历玩家组，请勿在遍历过程中修改玩家组。
---```lua
---for player in PlayerGroup:pairs() do
---    print(player)
---end
---```
---也可以直接用 `pairs` 遍历：
---```lua
---for player in pairs(PlayerGroup) do
---    print(player)
---end
---```
---@return fun(): Player?
function M:pairs()
    local i = -1
    local len = python_len(self.handle)
    return function ()
        i = i + 1
        if i >= len then
            return
        end
        local id = python_index(self.handle, i)
        local p = clicli.player.get_by_id(id)
        return p
    end
end

--Add a player
---@param player Player 玩家
function M:add_player(player)
    GameAPI.add_role_to_group(player.handle, self.handle)
end

--Remove the player
---@param player Player 玩家
function M:remove_player(player)
    GameAPI.rem_role_from_group(player.handle, self.handle)
end

--Clear player group
function M:clear()
    GlobalAPI.clear_group(self.handle)
end

---@private
M.ALL_PLAYERS = M.get_by_handle(GameAPI.get_all_role_ids())

---获取所有玩家
---@return PlayerGroup player_group 单位组
function M.get_all_players()
    return M.ALL_PLAYERS
end

---阵营內所有玩家
---@param camp py.Camp 阵营
---@return PlayerGroup player_group 单位组
function M.get_player_group_by_camp(camp)
    local py_player_group = GameAPI.get_role_ids_by_camp(camp)
    return M.get_by_handle(py_player_group)
end

---玩家的所有敌对玩家
---@param player Player 玩家
---@return PlayerGroup player_group 单位组
function M.get_enemy_player_group_by_player(player)
    local py_player_group = GameAPI.get_enemy_ids_by_role(player.handle)
    return M.get_by_handle(py_player_group)
end

---玩家的所有同盟玩家
---@param player Player 玩家
---@return PlayerGroup player_group 单位组
function M.get_ally_player_group_by_player(player)
    local py_player_group = GameAPI.get_ally_ids_by_role(player.handle)
    return M.get_by_handle(py_player_group)
end

---获取所有胜利的玩家
---@return PlayerGroup player_group 单位组
function M.get_victorious_player_group()
    local py_player_group = GameAPI.get_victorious_role_ids()
    return M.get_by_handle(py_player_group)
end

---获取所有失败的玩家
---@return PlayerGroup player_group 单位组
function M.get_defeated_player_group()
    local py_player_group = GameAPI.get_defeated_role_ids()
    return M.get_by_handle(py_player_group)
end

---所有非中立玩家
---@return PlayerGroup player_group 单位组
function M.get_neutral_player_group()
    local py_player_group = GameAPI.get_role_ids_by_type(1)
    return M.get_by_handle(py_player_group)
end

return M
