---@class SceneUI
---@field handle py.SceneNode
---@field res_id? integer
---@overload fun(py_scene_node: py.SceneNode): self
local M = Class 'SceneUI'

M.type = 'scene_ui'

---@param py_scene_node py.SceneNode
---@return self
function M:__init(py_scene_node)
    self.handle = py_scene_node
    return self
end

function M:__del()
    GameAPI.delete_scene_node(self.handle)
end

function M:__eq(other)
    return IsInstanceOf(other, 'SceneUI')
        and self.handle == other.handle
end

M.map = {}

---Obtain the interface instance of the lua layer from the interface instance of the py layer
---@param py_scene_node py.SceneNode
---@return SceneUI
function M.get_by_handle(py_scene_node)
    local scene_ui = New 'SceneUI' (py_scene_node)
    return scene_ui
end

clicli.py_converter.register_type_alias('py.SceneNode', 'SceneUI')
clicli.py_converter.register_py_to_lua('py.SceneNode', M.get_by_handle)
clicli.py_converter.register_lua_to_py('py.SceneNode', function (lua_value)
    return lua_value.handle
end)

---Create scene interface to scene attraction
---@param sceneui string | clicli.Const.SceneUI control
---@param point Point
---@param  range? number visible distance
---@param  height? number height off the ground
---@return SceneUI scene_ui Scene ui
function M.create_scene_ui_at_point(sceneui, point, range, height)
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    local py_scene_node = GameAPI.create_scene_node_on_point(clicli.const.SceneUI[sceneui] or sceneui, point.handle, range or 10000, height or 0)
    local scene_ui = M.get_by_handle(py_scene_node)
    return scene_ui
end

--Gets controls in the ui of the specified player scene
---@param comp_path string # Control path
---@param player Player
---@return UI # UI control
function M:get_ui_comp_in_scene_ui(player, comp_path)
    local temp_ui = GameAPI.get_ui_comp_in_scene_ui(self.handle, comp_path)
    return clicli.ui.get_by_handle(player, temp_ui)
end

--Create a scene interface to the player unit hanging point
---@param scene_ui_type string | clicli.Const.SceneUI Scene ui type
---@param player Player
---@param unit Unit Unit
---@param socket_name string Name of the mount contact
---@param distance? number visible distance
---@param follow_scale? boolean Whether to follow scaling
---@return SceneUI scene_ui Scene ui
function M.create_scene_ui_at_player_unit_socket(scene_ui_type, player, unit, socket_name, distance, follow_scale)
    if follow_scale == nil then
        follow_scale = true
    end
    local py_scene_node = GameAPI.create_scene_node_on_unit_ex(clicli.const.SceneUI[scene_ui_type] or scene_ui_type, player.handle, unit.handle, socket_name, follow_scale, distance or 100000)
    return M.get_by_handle(py_scene_node)
end

--Delete scene interface
function M:remove_scene_ui()
    Delete(self)
end

--Set the visible distance of the scene interface to the player
---@param player Player
---@param dis number Visible distance
function M:set_scene_ui_visible_distance(player,dis)
    GameAPI.set_scene_node_visible_distance(self.handle,player.handle,dis)
end

return M
