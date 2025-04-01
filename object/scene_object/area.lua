--region
---@class Area
---@field handle py.Area
---@field shape Area.Shape
---@field res_id? integer
---@overload fun(py_area: py.Area, shape: Area.Shape): self
local M = Class 'Area'

---@class Area: CoreObjectEvent
Extends('Area', 'CoreObjectEvent')
---@class Area: KV
Extends('Area', 'KV')
---@class Area: GCHost
Extends('Area', 'GCHost')

M.type = 'area'

---@package
---@param id py.AreaID
---@param shape Area.Shape See area.enum
---@return Area
M.ref_manager = New 'Ref' ('Area', function (id, shape)
    local py_area
    if shape == M.SHAPE.CIRCLE then
        py_area = GameAPI.get_circle_area_by_res_id(id)
    elseif shape == M.SHAPE.RECTANGLE then
        py_area = GameAPI.get_rec_area_by_res_id(id)
    elseif shape == M.SHAPE.POLYGON then
        py_area = GameAPI.get_polygon_area_by_res_id(id)
    elseif shape == nil then
        py_area = GameAPI.get_circle_area_by_res_id(id)
        if py_area then
            shape = M.SHAPE.CIRCLE
            goto FOUND
        end
        py_area = GameAPI.get_rec_area_by_res_id(id)
        if py_area then
            shape = M.SHAPE.RECTANGLE
            goto FOUND
        end
        py_area = GameAPI.get_polygon_area_by_res_id(id)
        if py_area then
            shape = M.SHAPE.POLYGON
            goto FOUND
        end
        error('Not found area:' .. tostring(id))
        ::FOUND::
    else
        error('The region type is not supported')
    end
    if not py_area then
        error(string.format('Area not found: %s, shape: %s', id, shape))
    end
    local area = New 'Area' (py_area, shape)
    return area
end)

---@param py_area py.Area
---@param shape Area.Shape
---@return self
function M:__init(py_area, shape)
    self.handle = py_area
    self.shape  = shape
    self._removed_by_py = false
    return self
end

function M:__del()
    if not self._removed_by_py then
        GameAPI.remove_area(self.handle)
        if self.res_id then
            M.map[self.res_id] = nil
        end
    end
end

---@private
---@type table<py.AreaID, Area>
M.map = {}

---@enum Area.Shape
M.SHAPE = {
    CIRCLE    = 1,
    RECTANGLE = 2,
    POLYGON   = 3,
}

---Create a region based on the py object
---@param py_area py.Area layer object
---@param shape? Area.Shape See area.enum
---@return Area
function M.get_by_handle(py_area, shape)
    local id = GameAPI.get_area_resource_id(py_area) --[[@as py.AreaID]]
    local area = M.get_by_res_id(id, shape)
    return area
end

clicli.py_converter.register_py_to_lua('py.Area', M.get_by_handle)
clicli.py_converter.register_lua_to_py('py.Area', function (lua_value)
    return lua_value.handle
end)

---@param res_id py.AreaID Specifies the id in the edit scene
---@param shape? Area.Shape See area.enum
---@return Area
function M.get_by_res_id(res_id, shape)
    local area = M.ref_manager:get(res_id, shape)
    return area
end

clicli.py_converter.register_py_to_lua('py.AreaID', M.get_by_res_id)

---Get the circle area based on the scene id
---@param res_id py.AreaID Specifies the id in the edit scene
---@return Area
function M.get_circle_by_res_id(res_id)
    return M.get_by_res_id(res_id, M.SHAPE.CIRCLE)
end

---Gets a rectangular area based on the scene id
---@param res_id py.AreaID Specifies the id in the edit scene
---@return Area
function M.get_rectangle_by_res_id(res_id)
    return M.get_by_res_id(res_id, M.SHAPE.RECTANGLE)
end

---Get the polygon area based on the scene id
---@param res_id py.AreaID Specifies the id in the edit scene
---@return Area
function M.get_polygon_by_res_id(res_id)
    return M.get_by_res_id(res_id, M.SHAPE.POLYGON)
end

---Delete area
function M:remove()
    Delete(self)
end

---Set area collision
---@param is_collision_effect boolean Specifies whether the collision takes effect
---@param is_land_effect boolean Ground collision switch
---@param is_air_effect boolean Indicates the air collision switch
function M:set_collision(is_collision_effect, is_land_effect, is_air_effect)
    GameAPI.set_area_collision(self.handle, is_collision_effect, is_land_effect, is_air_effect)
end

---Label the area
---@param tag string tag
function M:add_tag(tag)
    GameAPI.add_area_tag(self.handle, tag)
end

---Remove the label from the area
---@param tag string tag
function M:remove_tag(tag)
    GameAPI.remove_area_tag(self.handle, tag)
end

---Whether the area has a tag
---@param tag string tag
---@return boolean Specifies whether the area has a tag
function M:has_tag(tag)
    if M.SHAPE == M.SHAPE.CIRCLE then
        return GameAPI.if_cir_area_has_tag(self.handle, tag)
    elseif M.SHAPE == M.SHAPE.RECTANGLE then
        return GameAPI.if_rect_area_has_tag(self.handle, tag)
    end
    return false
end

---Set the polygon area visible to the player
---@param player Player
---@param is_visibility boolean Specifies whether to enable the field of view
---@param is_real_visibility boolean Specifies whether the real field of view is enabled
function M:set_visible(player, is_visibility, is_real_visibility)
    local handle = self.handle
    if self.shape == M.SHAPE.CIRCLE then
        ---@cast handle py.CirArea
        GameAPI.set_circle_vision_visibility(handle, player.handle, is_visibility, is_real_visibility)
    elseif self.shape == M.SHAPE.RECTANGLE then
        ---@cast handle py.RecArea
        GameAPI.set_rect_vision_visibility(handle, player.handle, is_visibility, is_real_visibility)
    elseif self.shape == M.SHAPE.POLYGON then
        ---@cast handle py.PolyArea
        GameAPI.set_poly_vision_visibility(handle, player.handle, is_visibility, is_real_visibility)
    end
end

---Set the radius of the circle area
---@param radius number Radius
function M:set_radius(radius)
    if self.shape == M.SHAPE.CIRCLE then
        GameAPI.set_cir_area_radius(self.handle--[[@as py.CirArea]], Fix32(radius))
    end
end

---Sets the radius of the rectangular area
---@param horizontal_length number Indicates the length
---@param vertical_length number Width
function M:set_size(horizontal_length, vertical_length)
    if self.shape == M.SHAPE.RECTANGLE then
        GameAPI.set_rect_area_radius(self.handle--[[@as py.RecArea]], Fix32(horizontal_length), Fix32(vertical_length))
    end
end

---Obtain the radius of the circular area
---@return number Radius
function M:get_radius()
    if self.shape == M.SHAPE.CIRCLE then
        return clicli.helper.tonumber(GameAPI.get_circle_area_radius(self.handle--[[@as py.CirArea]])) or 0.0
    end
    return 0
end

---Gets the minimum X-coordinate in the region
---@return number X coordinates
function M:get_min_x()
    if self.shape == M.SHAPE.CIRCLE then
        return clicli.helper.tonumber(GameAPI.get_circle_area_min_x(self.handle--[[@as py.CirArea]])) or 0.0
    end
    if self.shape == M.SHAPE.RECTANGLE then
        return clicli.helper.tonumber(GameAPI.get_rect_area_min_x(self.handle--[[@as py.RecArea]])) or 0.0
    end
    return 0
end

---Gets the minimum Y coordinate in the region
---@return number Y coordinates
function M:get_min_y()
    if self.shape == M.SHAPE.CIRCLE then
        return clicli.helper.tonumber(GameAPI.get_circle_area_min_y(self.handle--[[@as py.CirArea]])) or 0.0
    end
    if self.shape == M.SHAPE.RECTANGLE then
        return clicli.helper.tonumber(GameAPI.get_rect_area_min_y(self.handle--[[@as py.RecArea]])) or 0.0
    end
    return 0
end

---Gets the maximum X coordinate in the region
---@return number X coordinates
function M:get_max_x()
    if self.shape == M.SHAPE.CIRCLE then
        return clicli.helper.tonumber(GameAPI.get_circle_area_max_x(self.handle--[[@as py.CirArea]])) or 0.0
    end
    if self.shape == M.SHAPE.RECTANGLE then
        return clicli.helper.tonumber(GameAPI.get_rect_area_max_x(self.handle--[[@as py.RecArea]])) or 0.0
    end
    return 0
end

---Gets the maximum Y coordinate in the region
---@return number Y coordinates
function M:get_max_y()
    if self.shape == M.SHAPE.CIRCLE then
        return clicli.helper.tonumber(GameAPI.get_circle_area_max_y(self.handle--[[@as py.CirArea]])) or 0.0
    end
    if self.shape == M.SHAPE.RECTANGLE then
        return clicli.helper.tonumber(GameAPI.get_rect_area_max_y(self.handle--[[@as py.RecArea]])) or 0.0
    end
    return 0
end

--Get center point
---@return Point Indicates the center point
function M:get_center_point()
    if self.shape == M.SHAPE.CIRCLE then
        local py_point = GameAPI.get_circle_center_point(self.handle--[[@as py.CirArea]])
        --TODO see question 2
        ---@diagnostic disable-next-line: param-type-mismatch
        return clicli.point.get_by_handle(py_point)
    end
    if self.shape == M.SHAPE.RECTANGLE then
        local py_point = GameAPI.get_rec_center_point(self.handle--[[@as py.RecArea]])
        --TODO see question 2
        ---@diagnostic disable-next-line: param-type-mismatch
        return clicli.point.get_by_handle(py_point)
    end
    error('The region type is not supported')
end

--Get random points
---@return Point
function M:random_point()
    if self.shape == M.SHAPE.CIRCLE then
        local py_point = GameAPI.get_random_point_in_circular_area(self.handle--[[@as py.CirArea]])
        --TODO see question 2
        ---@diagnostic disable-next-line: param-type-mismatch
        return clicli.point.get_by_handle(py_point)
    end
    if self.shape == M.SHAPE.POLYGON then
        local py_point = GameAPI.get_random_point_in_poly_area(self.handle--[[@as py.PolyArea]])
        --TODO see question 2
        ---@diagnostic disable-next-line: param-type-mismatch
        return clicli.point.get_by_handle(py_point)
    end
    if self.shape == M.SHAPE.RECTANGLE then
        local py_point = GameAPI.get_random_point_in_rec_area(self.handle--[[@as py.RecArea]])
        --TODO see question 2
        ---@diagnostic disable-next-line: param-type-mismatch
        return clicli.point.get_by_handle(py_point)
    end
    error('The region type is not supported')
end


---Obtain regional weather
---@return integer Specifies the weather enumeration
function M:get_weather()
    return GameAPI.get_area_weather(self.handle)
end

---All units in the area
---@return Unit[] Unit group
function M:get_all_unit_in_area()
    local py_unit_list = GameAPI.get_unit_group_in_area(self.handle)
    local units = clicli.helper.unpack_list(py_unit_list, clicli.unit.get_by_id)
    return units
end

---All units of the camp in the area
---@param camp py.Camp
---@return Unit[] Unit group
function M:get_unit_in_area_by_camp(camp)
    local u = {}
    for _, player in ipairs(clicli.player_group.get_player_group_by_camp(camp):pick()) do
        for _, unit in ipairs(self:get_unit_group_in_area(player):pick()) do
            table.insert(u, unit)
        end
    end
    return u
end

---Regional player units (unit groups)
---@param player Player
---@return UnitGroup Unit group
function M:get_unit_group_in_area(player)
    local py_unit_group = GameAPI.get_unit_group_belong_to_player_in_area(self.handle, player.handle)
    return clicli.unit_group.get_by_handle(py_unit_group)
end

---The number of units in the region
---@return integer Specifies the number
function M:get_unit_num_in_area()
    return GameAPI.get_unit_num_in_area(self.handle)
end

---Edit area collision
---@param collision_layer integer Indicates the collision type
---@param is_add boolean Add/remove
function M:edit_area_collision(collision_layer, is_add)
    GameAPI.edit_area_collision(self.handle, collision_layer, is_add)
end

---Edit area field of view blocked
---@param fov_block_type integer Specifies the field of view blocking type
---@param is_add boolean Add/remove
function M:edit_area_fov_block(fov_block_type, is_add)
    GameAPI.edit_area_fov_block(self.handle, fov_block_type, is_add)
end

--Whether the point is in the area
---@param point Point
---@return boolean
function M:is_point_in_area(point)
    return GameAPI.judge_point_in_area(point.handle, self.handle)
end

----- -- -- -- -- -- -- -- -- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - class method - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

---Get the full map area
---@return Area
function M.get_map_area()
    local py_area = GameAPI.get_usable_map_range()
    return M.get_by_handle(py_area, M.SHAPE.RECTANGLE)
end

---Gets the last rectangular area created
---@return Area
function M.get_rectangle_area_last_created()
    local py_area = GameAPI.get_rec_area_last_created()
    return M.get_by_handle(py_area, M.SHAPE.RECTANGLE)
end

---Create a circle
---@param point Point
---@param radius number Radius
---@return Area Indicates the circle area
function M.create_circle_area(point, radius)
    local py_area = GameAPI.create_new_cir_area(point.handle, Fix32(radius))
    return M.get_by_handle(py_area, M.SHAPE.CIRCLE)
end

---Create a rectangular area
---@param point Point
---@param horizontal_length number Indicates the length
---@param vertical_length number Width
---@return Area area Indicates a rectangular area
function M.create_rectangle_area(point, horizontal_length, vertical_length)
    local py_area = GameAPI.create_rect_area_by_center(point.handle, Fix32(horizontal_length), Fix32(vertical_length))
    return M.get_by_handle(py_area, M.SHAPE.RECTANGLE)
end

---Creates a rectangular area with a starting and ending point
---@param point_one Point Point 1
---@param point_two Point Point 2
---@return Area area Indicates a rectangular area
function M.create_rectangle_area_from_two_points(point_one, point_two)
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    local py_area = GameAPI.create_rec_area_from_two_points(point_one.handle, point_two.handle)
    return M.get_by_handle(py_area, M.SHAPE.RECTANGLE)
end

---Create polygons along points
---@param ... Point
---@return Area polygon. @return area Polygon
function M.create_polygon_area_by_points(...)
    local points = {...}
    local py_points = {}
    for i, p in ipairs(points) do
        py_points[i] = p.handle
    end
    local py_area = GameAPI.create_polygon_area_new(table.unpack(py_points))
    return M.get_by_handle(py_area, M.SHAPE.POLYGON)
end

---Get all the circular areas by label
---@param tag string Tag
---@return Area[] area Indicates a rectangular area
function M.get_circle_areas_by_tag(tag)
    local py_list = GameAPI.get_cir_areas_by_tag(tag)
    local areas = clicli.helper.unpack_list(py_list, function (py_object)
        return M.get_by_handle(py_object, M.SHAPE.CIRCLE)
    end)
    return areas
end

---Gets all rectangular areas by label
---@param tag string Tag
---@return Area[] area Indicates the table of the rectangular area
function M.get_rect_areas_by_tag(tag)
    local py_list = GameAPI.get_rect_areas_by_tag(tag)
    local areas = clicli.helper.unpack_list(py_list, function (py_object)
        return M.get_by_handle(py_object, M.SHAPE.RECTANGLE)
    end)
    return areas
end

---Get all polygon areas by label
---@param tag string Tag
---@return Area[] area Indicates the polygon area
function M.get_polygon_areas_by_tag(tag)
    local py_list = GameAPI.get_polygon_areas_by_tag(tag)
    local areas = clicli.helper.unpack_list(py_list, function (py_object)
        return M.get_by_handle(py_object, M.SHAPE.POLYGON)
    end)
    return areas
end

---Gets all the vertices of the polygon
---@param polygon Area Polygon area
---@return table area Table of polygon vertices
function M.get_polygon_areas_point_list(polygon)
    assert(polygon.shape == M.SHAPE.POLYGON, 'Non-polygon region')
    local handle = polygon.handle
    ---@cast handle py.PolyArea
    local py_list = GameAPI.get_poly_area_point_list(handle)
    local points = clicli.helper.unpack_list(py_list, function (py_object)
        return clicli.point.get_by_handle(GameAPI.get_point_by_road_point(py_object))
    end)
    return points
end

return M
