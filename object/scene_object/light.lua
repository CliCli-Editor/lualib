--illumination
--
--Used to modify lighting, shadows, and other effects
---@class Light
---@field handle py.Light
---@field res_id? py.LightID
---@overload fun(py_light: py.Light): self
local M = Class 'Light'

M.type = 'light'

---@param py_light py.Light
---@return self
function M:__init(py_light)
    self.handle = py_light
    return self
end

---@private
M.map = {}

---Obtain a point light source based on the scene id
---@param res_id py.LightID id in the edit scene
---@return Light
function M.get_point_light_by_res_id(res_id)
    if not M.map[res_id] then
        local py_light = GameAPI.get_point_light_res_by_res_id(res_id)
        local light = M.create_lua_light_by_py(py_light)
        light.res_id = res_id
        M.map[res_id] = light
    end
    return M.map[res_id]
end

---Get the spotlight based on the scene id
---@param res_id py.LightID id in the edit scene
---@return Light
function M.get_spot_light_by_res_id(res_id)
    if not M.map[res_id] then
        local py_light = GameAPI.get_spot_light_res_by_res_id(res_id)
        local light = M.create_lua_light_by_py(py_light)
        light.res_id = res_id
        M.map[res_id] = light
    end
    return M.map[res_id]
end

---@param py_light py.Light
---@return Light light
function M.create_lua_light_by_py(py_light)
    local light = New 'Light' (py_light)
    return light
end

clicli.py_converter.register_py_to_lua('py.Light', M.create_lua_light_by_py)
clicli.py_converter.register_lua_to_py('py.Light', function (lua_value)
    return lua_value.handle
end)

--TODO: Point source attribute enumeration needs to be handled in the Lua layer

---Get light source properties
---@param key string Attribute name
---@return number Attribute value
function M:get_light_attribute(key)
    return clicli.helper.tonumber(GameAPI.get_light_float_attr_value(self.handle, key)) or 0.0
end


---Gets whether the light source produces shadows
---@return boolean Specifies whether to generate a shadow
function M:get_light_cast_shadow_state()
    return GameAPI.get_light_cast_shadow_attr_value(self.handle)
end


--Create point light source to point
---@param point Point Target point
---@param deviation_height number Indicates the offset height
---@return Light
function M.create_point_light_at_point(point, deviation_height)
    local py_light = GameAPI.create_point_light_to_point(
        --TODO see question 2
        ---@diagnostic disable-next-line: param-type-mismatch
        point.handle,
        Fix32(deviation_height)
    )
    return M.create_lua_light_by_py(py_light)
end


--Create a point light source to the unit mount contact
---@param unit Unit Target unit
---@param socket_name string Mount contact
---@param deviation_height number Indicates the offset height
---@return Light
function M.create_point_light_at_unit_socket(unit, socket_name, deviation_height)
    local py_obj = GameAPI.create_point_light_to_unit_socket(unit.handle, socket_name, Fix32(deviation_height))
    return M.create_lua_light_by_py(py_obj)
end


--Create directional light source to point
---@param point Point Target point
---@param pos_offset_y? number offset height
---@param unit_point_projectile? Unit|Point|Projectile target
---@param target_offset_y? number Indicates the offset height of the target point
---@return Light
function M.create_spot_light_to_point(point, pos_offset_y, unit_point_projectile, target_offset_y)
    local py_obj = GameAPI.create_spot_light_to_point(
        --TODO see question 2
        ---@diagnostic disable-next-line: param-type-mismatch
        point.handle,
        pos_offset_y and Fix32(pos_offset_y) or nil,
        --TODO see question 6
        ---@diagnostic disable-next-line: param-type-mismatch
        unit_point_projectile and unit_point_projectile.handle or nil,
        target_offset_y and Fix32(target_offset_y) or nil
    )
    return M.create_lua_light_by_py(py_obj)
end


--Create a directional light source to the unit mount contact
---@param unit Unit Target unit
---@param socket_name string Mount contact
---@param pos_offset_y? number offset height
---@param target_unit? Unit Target unit
---@param target_offset_y? number Indicates the offset height of the target point
---@return Light
function M.create_spot_light_at_unit_socket(unit,socket_name,pos_offset_y,target_unit,target_offset_y)
    local py_obj = GameAPI.create_spot_light_to_unit_socket(
        unit.handle,
        socket_name,
        pos_offset_y and Fix32(pos_offset_y) or nil,
        target_unit and target_unit.handle or nil,
        target_offset_y and Fix32(target_offset_y) or nil
    )
    return M.create_lua_light_by_py(py_obj)
end

--Remove light source
function M:remove_light()
    GameAPI.remove_light(self.handle)
end

--Sets whether the light source produces shadows
---@param value boolean Specifies whether to generate shadow
function M:set_shadow_casting_status(value)
    GameAPI.set_light_cast_shadow_attr_value(self.handle, value)
end

--Set the point light properties
---@param light_attr_type string Attribute name
---@param value number Attribute value
function M:set_point_light_attribute(light_attr_type,value)
    GameAPI.set_light_float_attr_value(self.handle, light_attr_type, Fix32(value))
end

--Set the directional light source properties
---@param light_attr_type string Attribute name
---@param value number Attribute value
function M:set_directional_light_attribute(light_attr_type,value)
    GameAPI.set_light_float_attr_value(self.handle, light_attr_type, Fix32(value))
end

return M
