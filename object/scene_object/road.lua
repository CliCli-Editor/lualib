--path
---@class Road
---@field handle py.Road
---@field res_id integer
---@overload fun(py_road: py.Road): self
local M = Class 'Road'

---@private
M.map = {}

---@param py_road py.Road
---@return self
function M:__init(py_road)
    self.handle = py_road
    return self
end

---@param res_id integer
---@return Road
function M.get_road_by_res_id(res_id)
    if not M.map[res_id] then
        local py_road = GameAPI.get_road_point_list_by_res_id(res_id)
        local road = M.get_by_handle(py_road)
        road.res_id = res_id
        M.map[res_id] = road
    end
    return M.map[res_id]
end

---@param py_road py.Road
---@return Road
function M.get_by_handle(py_road)
    local road = New 'Road' (py_road)
    return road
end

clicli.py_converter.register_py_to_lua('py.Road', M.get_by_handle)
clicli.py_converter.register_lua_to_py('py.Road', function (lua_value)
    return lua_value.handle
end)

---Whether the path has a tag
---@param tag string tag
---@return boolean Specifies whether the path has a tag
function M:has_tag(tag)
    return GameAPI.if_road_has_tag(self.handle, tag)
end

---Delete path
function M:remove_path()
    GameAPI.remove_road_point_list(self.handle)
end


---Add points to the path
---@param index integer Specifies the serial number
---@param point Point
function M:add_point(index, point)
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    GameAPI.add_road_point(self.handle, index, point.handle)
end


---Remove points from paths
---@param index integer Specifies the serial number
function M:remove_point(index)
    GameAPI.remove_road_point(self.handle, index)
end


---Label the path
---@param tag string Serial number
function M:add_tag(tag)
    GameAPI.add_road_tag(self.handle, tag)
end


---Remove labels from paths
---@param tag string Serial number
function M:remove_tag(tag)
    GameAPI.remove_road_tag(self.handle, tag)
end

---Gets the number of points in a path
---@return integer
function M:get_point_count()
    return GameAPI.get_road_point_num(self.handle)
end




----- -- -- -- -- -- -- -- -- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - class method - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


---Create a path from a point
---@param start_point Indicates the start Point of a point
---@return Road Specifies the path to be created
function M.create_path(start_point)
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    local py_path = GameAPI.create_road_point_list(start_point.handle)
    return M.get_by_handle(py_path)
end

---Get all paths by label
---@param tag string Tag
---@return Road[] Path
function M.get_path_areas_by_tag(tag)
    local py_list = GameAPI.get_roads_by_tag(tag)
    local roads = clicli.helper.unpack_list(py_list, function (road_id)
        return M.get_road_by_res_id(road_id)
    end)
    return roads
end

return M
