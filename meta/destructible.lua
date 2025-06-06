--This file is generated by tools/genGameAPI, do not modify it manually.
---@meta

---@class py.Destructible
local Destructible = {}

--Move destructible objects to the point
---@param point py.Point # point
function Destructible:api_transmit(point) end

--Kill the destructible
---@param unit py.Unit # Killer unit
function Destructible:api_kill(unit) end

--Deplete destructible material
---@param unit py.Unit # Collection unit
function Destructible:api_set_dest_dry(unit) end

--Remove destructible objects
function Destructible:api_delete() end

--Resurrection destructible
---@param point py.Point # Revival point
function Destructible:api_revivie(point) end

--Show and hide destructible objects
---@param is_show boolean # Show or not
function Destructible:api_show_hide(is_show) end

--Set destructible health
---@param hp_value py.Fixed # Vitality
function Destructible:api_set_hp(hp_value) end

--Set the maximum destructible health
---@param hp_value py.Fixed # Max health
function Destructible:api_set_max_hp(hp_value) end

--Set the name of the destructible
---@param name string # name
function Destructible:api_set_name(name) end

--Sets the amount of destructible resources
---@param num integer # Resource quantity
function Destructible:api_set_source_num(num) end

--Set the destructible size
---@param x py.Fixed # x size
---@param y py.Fixed # y Size
---@param z py.Fixed # z size
function Destructible:api_set_scale(x, y, z) end

--Set the destructible Angle
---@param angle py.Fixed # Angle
function Destructible:api_set_face_angle(angle) end

--Gets the integer attribute of the destructible
---@param attr_name string # Attribute name
---@return integer? # Integer type Return value
function Destructible:api_get_int_attr(attr_name) end

--Get the number of the destructible
---@return py.DestructibleKey? # Destructible number
function Destructible:api_get_key() end

--Gets the string property of the destructible
---@param attr_name string # Attribute name
---@return string? # String type Return value
function Destructible:api_get_str_attr(attr_name) end

--Sets the string property of the destructor
---@param attr_name string # Attribute name
---@param value string # Attribute value
function Destructible:api_set_str_attr(attr_name, value) end

--Gets the Boolean value property of the destructible
---@param attr_name string # Attribute name
---@return boolean? # Boolean type return value
function Destructible:api_get_bool_attr(attr_name) end

--Gets the floating-point attribute of the destructible
---@param attr_name string # Attribute name
---@return py.Fixed? # Floating-point type return value
function Destructible:api_get_float_attr(attr_name) end

--Gets the destructible is camp id
---@return py.CampID? # Camp ID
function Destructible:api_get_camp_id() end

--Get destructible location
---@return py.FVector3? # Unit position
function Destructible:api_get_position() end

--Gets the id of the destructible
---@return py.DestructibleID? # Destructible object id
function Destructible:api_get_id() end

--Gets the X-axis scaling of the destructible
---@return number? # Scaled value
function Destructible:api_get_x_scale() end

--Gets the Y-axis scaling of the destructible
---@return number? # Scaled value
function Destructible:api_get_y_scale() end

--Gets the Z-axis scaling of the destructible
---@return number? # Scaled value
function Destructible:api_get_z_scale() end

--Gets the rotation Angle of the destructible
---@return number? # Angular value
function Destructible:api_get_angle() end

--Get the destructible model
---@return py.ModelKey? # Model number
function Destructible:api_get_dest_model() end

--Whether destructible objects are selected by the skill indicator
---@return boolean? # Boolean value
function Destructible:api_is_ability_target() end

--Destructible object can be attacked by normal
---@return boolean? # Boolean value
function Destructible:api_is_attacked() end

--Whether destructible objects can be selected
---@return boolean? # Boolean value
function Destructible:api_is_selected() end

--Whether the destructible material can be collected
---@return boolean? # Boolean value
function Destructible:api_is_collected() end

--Whether the destructible is visible
---@return boolean? # Boolean value
function Destructible:api_is_visible() end

--Whether the destructible is alive
---@return boolean? # Boolean value
function Destructible:api_is_alive() end

--Gets the current resources of destructible
---@return integer? # Boolean value
function Destructible:api_get_dest_cur_source_nums() end

--Get the maximum resource of destructible objects
---@return integer? # Boolean value
function Destructible:api_get_dest_max_source_nums() end

--Gets destructible player attributes
---@return py.RoleResKey? # Player attributes
function Destructible:api_get_role_res_of_dest() end

--Gets the item type of destructible
---@return py.ItemKey? # Item type
function Destructible:api_get_item_type_of_dest() end

--Get the destructible oriented Angle
---@return py.Fixed? # The Angle of destructibility
function Destructible:api_get_dest_face_angle() end

--Get the height of destructible
---@return py.Fixed? # The height of the destructible
function Destructible:api_get_dest_height_offset() end

--Resurrection destructible
function Destructible:api_revivie_new() end

--Sets whether destructible objects can be selected by the skill indicator
---@param bool_value boolean # Boolean value
function Destructible:api_set_dest_is_ability_target(bool_value) end

--Sets whether destructors can be attacked by normal attacks
---@param bool_value boolean # Boolean value
function Destructible:api_set_dest_is_attacked(bool_value) end

--Sets whether destructors can be selected
---@param bool_value boolean # Boolean value
function Destructible:api_set_dest_is_selected(bool_value) end

--Sets whether destructible objects can be collected
---@param bool_value boolean # Boolean value
function Destructible:api_set_dest_is_collected(bool_value) end

--Add labels to destructible objects
---@param tag string # TAG
function Destructible:api_add_tag(tag) end

--Destructible removal tag
---@param tag string # TAG
function Destructible:api_remove_tag(tag) end

--Sets the current number of resources for destructible energy
---@param sp_value py.Fixed # Resource number
function Destructible:api_set_cur_source_nums(sp_value) end

--Set the maximum number of resources for destructible energy
---@param sp_value py.Fixed # Resource number
function Destructible:api_set_max_source_nums(sp_value) end

--Increases the current health of destructible energy
---@param delta py.Fixed # Current health
function Destructible:api_add_hp_cur_value(delta) end

--Increases the maximum health of destructible energy
---@param delta py.Fixed # Max health
function Destructible:api_add_hp_max_value(delta) end

--Increase the current amount of destructible energy resources
---@param delta py.Fixed # Current resource number
function Destructible:api_add_sp_cur_value(delta) end

--Increased the maximum amount of destructible energy resources
---@param delta py.Fixed # Maximum resource number
function Destructible:api_add_sp_max_value(delta) end

--Destructible play animation
---@param name string # Animation name
---@param init_time? number # Start time (s)
---@param end_time? number # End time (s). A positive number -1 indicates that the end is not finished
---@param loop? boolean # Cyclic or not
---@param rate? number # Playback ratio
function Destructible:api_play_animation(name, init_time, end_time, loop, rate) end

--Destructible stops playing animation
---@param name string # Animation name
function Destructible:api_stop_animation(name) end

--Destructible replacement model
---@param target_model py.ModelKey # Target model number
function Destructible:api_replace_model(target_model) end

--Cancel the destructible replacement model
---@param target_model py.ModelKey # Target model name
function Destructible:api_cancel_replace_model(target_model) end

--Set the height of destructible
---@param height_value py.Fixed # Altitude value
function Destructible:api_set_height_offset(height_value) end

--Increase the height of destructible objects
---@param delta py.Fixed # Height change
function Destructible:api_add_height_offset(delta) end

--Destructible replacement map
---@param material_id integer # Material id
---@param layer_id integer # layer id
---@param texture py.Texture # chartlet
function Destructible:api_replace_texture(material_id, layer_id, texture) end
