--destructible
---@class Destructible
---@field handle py.Destructible
---@field id integer
---@field private _removed_by_py boolean
---@overload fun(py_destructible: py.Destructible): self
local M = Class 'Destructible'
M.type = 'destructible'

---@class Destructible: CoreObjectEvent
Extends('Destructible', 'CoreObjectEvent')
---@class Destructible: KV
Extends('Destructible', 'KV')

function M:__tostring()
    return string.format('{destructible|%s|%s}'
        , self:get_name()
        , self.handle
    )
end

---@param py_destructible py.Destructible
---@return self
function M:__init(py_destructible)
    self.handle = py_destructible
    self.id     = py_destructible:api_get_id() or 0
    return self
end

function M:__del()
    self:remove()
end

function M:__encode()
    return self.id
end

function M:__decode(id)
    local obj = M.get_by_id(id)
    return obj
end

---@package
M.ref_manager = New 'Ref' ('Destructible', function (id)
    local py_destructible = GameAPI.get_dest_by_id(id)
    if not py_destructible then
        return nil
    end
    return New 'Destructible' (py_destructible)
end)

---Get the destructible object of the lua layer through the destructible instance of the py layer
---@param  py_destructible py.Destructible
---@return Destructible?
function M.get_by_handle(py_destructible)
    if not py_destructible then
        return nil
    end
    local id = py_destructible:api_get_id()
    local dest = M.ref_manager:get(id)
    return dest
end

clicli.py_converter.register_py_to_lua('py.Destructible', M.get_by_handle)
clicli.py_converter.register_lua_to_py('py.Destructible', function (lua_value)
    return lua_value.handle
end)

--Gets lua is destructible object by the destructible is unique ID
---@param id py.DestructibleID
---@return Destructible?
function M.get_by_id(id)
    local py_destructible = GameAPI.get_dest_by_id(id)
    return M.get_by_handle(py_destructible)
end

clicli.py_converter.register_py_to_lua('py.DestructibleID', M.get_by_id)

---Existence or not
---@return boolean is_exist Whether it exists
function M:is_exist()
    return  GameAPI.destructible_is_exist(self.handle)
end

--Get a unique ID
---@return integer
function M:get_id()
    return self.id
end

---Whether destructible objects are selected by the skill indicator
---@return boolean Whether is_lockable can be selected
function M:can_be_ability_target()
    return self.handle:api_is_ability_target() or false
end

---Whether destructible objects can be attacked
---@return boolean Whether is_attackable can be attacked
function M:can_be_attacked()
    return self.handle:api_is_attacked() or false
end

---Whether destructible objects can be selected
---@return boolean Whether is_selectable can be selected
function M:can_be_selected()
    return self.handle:api_is_selected() or false
end

---Whether the destructible material can be collected
---@return boolean Whether is_collectable can be collected
function M:can_be_collected()
    return self.handle:api_is_collected() or false
end

---Whether the destructible is visible
---@return boolean is_visible Whether it is visible
function M:is_visible()
    return self.handle:api_is_visible() or false
end

---Whether the destructible is alive
---@return boolean Whether is_alive is alive
function M:is_alive()
    return self.handle:api_is_alive() or false
end

---@param killer_unit Unit The killer
---Kill the destructible
function M:kill(killer_unit)
    self.handle:api_kill(killer_unit.handle)
end

---Remove destructible objects
function M:remove()
    if not self._removed then
        self._removed = true
        if not self._removed_by_py then
            self.handle:api_delete()
        end
    end
end

---Resurrection destructible
function M:reborn()
    self.handle:api_revivie_new()
end

---Move to point
---@param point Point Target point
function M:set_point(point)
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    self.handle:api_transmit(point.handle)
end

---Set health
---@param value number Health value
function M:set_hp(value)
    self.handle:api_set_hp(Fix32(value))
end

---@param value number Health value
---Increases current health
function M:add_hp(value)
    self.handle:api_add_hp_cur_value(Fix32(value))
end

---@param value number Health value
---Set the maximum health
function M:set_max_hp(value)
    self.handle:api_set_max_hp(Fix32(value))
end

---@param value number Health value
---Increases maximum health
function M:add_max_hp(value)
    self.handle:api_add_hp_max_value(Fix32(value))
end

---@param value number Number of resources
---Set the number of current resources
function M:set_resource(value)
    self.handle:api_set_cur_source_nums(Fix32(value))
end

---@param value number Number of resources
---Example Increase the number of current resources
function M:add_resource(value)
    self.handle:api_add_sp_cur_value(Fix32(value))
end

---@param value number Number of resources
---Set the maximum number of resources
function M:set_max_resource(value)
    self.handle:api_set_max_source_nums(Fix32(value))
end

---@param value number Number of resources
---Increase the maximum number of resources
function M:add_max_resource(value)
    self.handle:api_add_sp_max_value(Fix32(value))
end

---@param name string Name
---Set name
function M:set_name(name)
    self.handle:api_set_name(name)
end

---@param description string Description
---Set description
function M:set_description(description)
    self.handle:api_set_str_attr("description", description)
end

---Set scale
---@param x number x axis scaling
---@param y number Scaling the Y-axis
---@param z number Z-axis scaling
function M:set_scale(x, y, z)
    self.handle:api_set_scale(Fix32(x), Fix32(y), Fix32(z))
end

---orientation
---@param angle number Indicates the orientation Angle
function M:set_facing(angle)
    self.handle:api_set_face_angle(Fix32(angle))
end

---Set height
---@param height number Height
function M:set_height(height)
    self.handle:api_set_height_offset(Fix32(height))
end

---Gain height
---@param height number Height
function M:add_height(height)
    self.handle:api_add_height_offset(Fix32(height))
end

---Sets whether the skill indicator can be locked
---@param can_be_ability_target boolean Specifies whether it can be locked by the skill indicator
function M:set_can_be_ability_target(can_be_ability_target)
    self.handle:api_set_dest_is_ability_target(can_be_ability_target)
end

---Set whether to be attacked
---@param is_attackable boolean Indicates whether the value can be attacked
function M:set_can_be_attacked(is_attackable)
    self.handle:api_set_dest_is_attacked(is_attackable)
end

---Sets whether to be selected
---@param is_selectable boolean Whether the value can be selected
function M:set_can_be_selected(is_selectable)
    self.handle:api_set_dest_is_selected(is_selectable)
end

---Sets whether to be collected
---@param is_collectable boolean Whether the value can be collected
function M:set_can_be_collected(is_collectable)
    self.handle:api_set_dest_is_collected(is_collectable)
end

---Add label
---@param tag string Tag
function M:add_tag(tag)
    self.handle:api_add_tag(tag)
end

---Remove tag
---@param tag string Tag
function M:remove_tag(tag)
    self.handle:api_remove_tag(tag)
end

---Tagged or not
---@param tag_name string Tag
---@return boolean has_tag Specifies a tag
function M:has_tag(tag_name)
    return GlobalAPI.has_tag(self.handle, tag_name)
end

---Play animation
---@param anim_name string Animation name
---@param start_time? number Start time
---@param end_time? number End time (Default -1 indicates last playback)
---@param is_loop? boolean loop or not
---@param speed? number speed
function M:play_animation(anim_name, start_time, end_time, is_loop, speed)
    self.handle:api_play_animation(
        anim_name,
        start_time or 0,
        end_time or -1,
        is_loop or false,
        speed or 1
    )
end

---Stop animation
---@param anim_name string Animation name
function M:stop_animation(anim_name)
    self.handle:api_stop_animation(anim_name)
end

---Replacement model
---@param model_id py.ModelKey Model id
function M:replace_model(model_id)
    self.handle:api_replace_model(model_id)
end

---Cancel replacement model
---@param model_id py.ModelKey Model id
function M:cancel_replace_model(model_id)
    self.handle:api_cancel_replace_model(model_id)
end

---Show/hide
---@param is_visible boolean Specifies whether to display
function M:set_visible(is_visible)
    self.handle:api_show_hide(is_visible)
end

---Gets the destructible type
---@return py.DestructibleKey type Destructible type
function M:get_key()
    return GameAPI.get_dest_type(self.handle)
end

---Gets the name of the destructible
---@return string name Name of the destructible
function M:get_name()
    return self.handle:api_get_str_attr("name") or ''
end

---Get destructible description
---@return string description Indicates the description
function M:get_description()
    return self.handle:api_get_str_attr("description") or ''
end

---Gain the health of destructible objects
---@return number cur_hp health
function M:get_hp()
    return clicli.helper.tonumber(self.handle:api_get_float_attr("hp_cur")) or 0.0
end

---Gets the resource name of the destructible
---@return string source_name Resource name
function M:get_resource_name()
    return self.handle:api_get_str_attr("source_desc") or ''
end

---Gain the health of destructible objects
---@return number hp Destructible health
function M:get_max_hp()
    return clicli.helper.tonumber(self.handle:api_get_float_attr("hp_max")) or 0.0
end

---Gets the current number of resources for destructible
---@return number source_number Number of the current resource
function M:get_resource()
    return self.handle:api_get_dest_cur_source_nums() or 0.0
end

---Gets the maximum number of resources for destructible objects
---@return number max_number Maximum number of resources
function M:get_max_resource()
    return self.handle:api_get_dest_max_source_nums() or 0.0
end

---Gets the destructible player attribute name
---RoleResKey player_res_key Player attribute
function M:get_resource_type()
    return self.handle:api_get_role_res_of_dest() or ''
end

---Gets the item type ID of the destructible
---@returnpy. ItemKey item_key ID of the item type
function M:get_item_type()
    return self.handle:api_get_item_type_of_dest() or 0
end

---Get a destructible model
---@returnpy. ModelKey model_key Model id
function M:get_model()
    return self.handle:api_get_dest_model() or 0
end

---Get the height of destructible
---@return number height Height
function M:get_height()
    return clicli.helper.tonumber(self.handle:api_get_dest_height_offset()) or 0.0
end

---Get the destructible oriented Angle
---@return number rotation Angle oriented
function M:get_facing()
    return clicli.helper.tonumber(self.handle:api_get_dest_face_angle()) or 0.0
end

---Gets the location of the destructible object
---@return point Indicates the location of the destructible object
function M:get_position()
    local py_point = self.handle:api_get_position()
    if not py_point then
        return clicli.point(6553600, 6553600)
    end
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    return clicli.point.get_by_handle(py_point)
end

----- -- -- -- -- -- -- -- -- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - class method - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

---Create destructible objects
---@param type_id py.DestructibleKey id of the destructible type
---@param point Point Creates a point to point
---@param angle number Indicates the Angle orientation
---@param scale_x? number Scale x
---@param scale_y? number scale y
---@param scale_z? number scale z
---@param height? number height
---@return Destructible destructible. Destructible
function M.create_destructible(type_id, point, angle, scale_x, scale_y, scale_z, height)
    if not scale_x then scale_x = 1 end
    if not scale_y then scale_y = 1 end
    if not scale_z then scale_z = 1 end
    if not height then height = 0 end
    local py_destructible = GameAPI.create_destructible_new(type_id, point.handle, Fix32(angle), Fix32(scale_x), Fix32(scale_y), Fix32(scale_z), Fix32(height))

    return clicli.destructible.get_by_handle(py_destructible) --[[@as Destructible]]
end

---Gets the name of the destructible type
---@param key py.DestructibleKey Type id
---@return string name Indicates the name
function M.get_name_by_key(key)
    return GameAPI.get_dest_name_by_type(key)
end

---Gets a description of the destructible type
---@param key py.DestructibleKey Type id
---@return string description Indicates the description
function M.get_description_by_key(key)
    return GameAPI.get_dest_desc_by_type(key)
end

---Gets a model of the destructible type
---@param key py.DestructibleKey Type id
---@return py.ModelKey model id of the model
function M.get_model_by_type(key)
    return GameAPI.get_model_key_of_dest_key(key)
end

---Traverse all destructible objects in the area
---@param area Area Area object
---@return Destructible[]
function M.pick(area)
    ---@type Destructible[]
    local destructibles = {}
    local py_list = GameAPI.get_all_dest_in_area(area.handle)
    for _, iter_destructible in pairs(py_list) do
        table.insert(destructibles,clicli.destructible.get_by_handle(iter_destructible))
    end
    return destructibles
end

---@param point Point
---@param shape Shape area
---@return table destructible_list List of destructible objects
---Gets a list of destructible objects in different shape ranges
function M.pick_in_shape(point, shape)
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    local py_list = GameAPI.get_all_dest_in_shapes(point.handle, shape.handle)
    local lua_table = {}
    for _, iter_destructible in pairs(py_list) do
        table.insert(lua_table,clicli.destructible.get_by_handle(iter_destructible))
    end
    return lua_table
end

function M:is_destroyed()
    ---@diagnostic disable-next-line: undefined-field
    local yes = self.handle:api_is_destroyed()
    if yes == nil then
        return true
    end
    return yes
end

return M
