--This file is generated by tools/genGameAPI, do not modify it manually.
---@meta

---@class py.Item
local Item = {}

--Get item number
---@return py.ItemKey? # Item number
function Item:api_get_key() end

--Set item name
---@param name string # Item name
function Item:set_name(name) end

--Get item name
---@return string? # Item name
function Item:get_name() end

--Gets the item configuration name
---@return string? # Item name
function Item:api_get_conf_name() end

--Set item description
---@param desc string # Item description
function Item:api_set_desc(desc) end

--Get item description
---@return string? # Item description
function Item:api_get_desc() end

--Get the item configuration description
---@return string? # Item description
function Item:api_get_conf_desc() end

--Get item type
---@return integer? # Item type
function Item:api_get_type() end

--Get item level
---@return integer? # Item level
function Item:api_get_level() end

--Set item level
---@param level integer # Lv.
function Item:api_set_level(level) end

--discard
---@param pos py.FPoint # point
---@param stack_cnt? integer # quantity
function Item:api_drop_self(pos, stack_cnt) end

--Remove items from units
function Item:api_remove() end

--Set items for sale
---@param sale_state boolean # Availability for sale
function Item:api_set_sale_state(sale_state) end

--Set the number of items stacked
---@param stack_cnt integer # Stack number
function Item:api_set_stack_cnt(stack_cnt) end

--Set item charge number
---@param charge_cnt integer # Charge number
function Item:api_set_charge_cnt(charge_cnt) end

--Sets the maximum charge of the item
---@param max_charge integer # Maximum charge number
function Item:api_set_max_charge(max_charge) end

--The location of the item entity (if returning the player is location on the player)
---@return py.FVector3? # Item location
function Item:api_get_position() end

--Whether the item is in the scene
---@return boolean? # Whether it is in the scene
function Item:api_is_in_scene() end

--Gets the number of item stacks
---@return integer? # Stack number
function Item:api_get_stack_cnt() end

--Gets the item stack type
---@return integer? # Stack type
function Item:api_get_stack_type() end

--Get item charge number
---@return integer? # Charge number
function Item:api_get_charge_cnt() end

--Get item charge number
---@return integer? # Maximum charge number
function Item:api_get_max_charge() end

--Set item discard
---@param can_drop boolean # disposable
function Item:api_set_droppable(can_drop) end

--Set items for sale
---@param can_sell boolean # disposable
function Item:api_set_sellable(can_sell) end

--Sets item health
---@param hp number # Vitality
function Item:api_set_hp(hp) end

--Get items to discard
---@return boolean? # disposable
function Item:api_get_droppable() end

--Get things for sale
---@return boolean? # Availability for sale
function Item:api_get_sellable() end

--Gain item health
---@return py.Fixed? # Vitality
function Item:api_get_hp() end

--Sets item additional properties
---@param attr_element_field string # Attribute name
---@param attr_key string # Attribute component name
---@param val number # Attribute value
function Item:api_set_attr(attr_element_field, attr_key, val) end

--Adds additional attributes to items
---@param attr_element_field string # Attribute name
---@param attr_key string # Attribute component name
---@param delta number # Attribute value
function Item:api_change_attr(attr_element_field, attr_key, delta) end

--Gets additional properties for items
---@param attr_element_field string # Attribute component name
---@param attr_key string # Attribute name
---@return py.Fixed? # Attribute value
function Item:api_get_attr(attr_element_field, attr_key) end

--Set items for all players
---@param creator py.Role # owner
function Item:api_set_creator(creator) end

--Get items for all players
---@return py.Role? # owner
function Item:api_get_creator() end

--Acquired item owner
---@return py.Unit? # possessor
function Item:api_get_owner() end

--Add item stack count
---@param cnt integer # Stack number
function Item:api_add_stack(cnt) end

--Add item charge number
---@param cnt integer # Charge number
function Item:api_add_charge(cnt) end

--Get item scaling
---@return py.Fixed? # Zoom
function Item:api_get_scale() end

--Get item orientation
---@return py.Fixed? # Orientation Angle
function Item:api_get_face_angle() end

--Set item scale
---@param scale number # Zoom
function Item:api_set_scale(scale) end

--Set item location
---@param point py.Point # Item location
function Item:api_set_position(point) end

--Orient items
---@param face_angle number # Item orientation
function Item:api_set_face_angle(face_angle) end

--Whether it is in the area
---@param area py.Area # region
---@return boolean? # Whether in the region
function Item:api_is_in_area(area) end

--Move items to point
---@param point py.Point # point
function Item:api_transmit(point) end

--Item tagging
---@param tag string # tag
function Item:api_add_tag(tag) end

--Item removal tag
---@param tag string # tag
function Item:api_remove_tag(tag) end

--Whether the item has a label
---@param tag string # tag
---@return boolean? # Whether the item has a label
function Item:api_has_tag(tag) end

--Item removal key value pair
---@param k string # Key to remove
function Item:api_remove_kv(k) end

--Gets the object is corresponding entity in the scene
---@return py.Unit? # Entity in scene
function Item:api_get_item_unit() end

--Get item id
---@return py.ItemID? # Item id
function Item:api_get_id() end

--Whether the item is in the inventory
---@return boolean? # Whether it is in the inventory
function Item:api_is_in_bar() end

--Whether the item is in the backpack bar
---@return boolean? # Whether it is in the backpack bar
function Item:api_is_in_pkg() end

--Play music for the player relationship of the unit to which the item belongs
---@param camp_target py.RoleRelation # Player relationship
---@param sid py.AudioKey # Track number
---@param loop boolean # Cyclic or not
function Item:api_play_sound_by_item_for_role_relation(camp_target, sid, loop) end

--The active skill of acquiring objects
---@return py.Ability? # Skill object
function Item:api_get_positive_ability() end

--Passive ability to acquire items
---@param index? integer # index
---@return py.Ability? # Skill object
function Item:api_get_passive_ability(index) end

--Set the icon of the item to a picture
---@param icon_id py.Texture # icon
function Item:api_set_item_icon(icon_id) end

--Gets the icon of the item
---@return py.Texture? # icon
function Item:api_get_item_icon() end

--Backpack slot type where items are located
---@return py.SlotType? # Slot type
function Item:api_get_item_slot_type() end

--Index of the grid position of the item
---@return integer? # Lattice position
function Item:api_get_item_slot_idx() end

--Item instance adds passive ability
---@param ability_id py.AbilityKey # Skill id
---@param ability_level integer # Skill level
function Item:api_item_add_passive_ability(ability_id, ability_level) end

--Get a model of the item
---@return py.ModelKey? # Model number
function Item:api_get_item_model() end

--Set item visibility
---@param is_visible boolean # Visible or not
function Item:api_set_item_visible(is_visible) end

--Whether the item is visible
---@return boolean? # Visible or not
function Item:api_is_item_visible() end

--Item replacement model
---@param source_model py.ModelKey # Original model number
function Item:api_change_model(source_model) end

--Cancel item replacement model
---@param target_model py.ModelKey # Target model name
function Item:api_cancel_replace_model(target_model) end

--Get the resources you need to purchase items
---@param role_res_key py.RoleResKey # Player attribute key
---@return py.Fixed? # Resource requirements
function Item:api_get_item_res_cnt(role_res_key) end

--Gets the real properties of an item
---@param att_key string # Item real attribute key
---@return py.Fixed? # Real attribute value
function Item:api_get_item_float_attr(att_key) end

--Gets the integer properties of the item
---@param att_key string # Item integer property key
---@return integer? # Integer attribute value
function Item:api_get_item_int_attr(att_key) end

--Whether the item is used automatically
---@return boolean? # Whether to use automatically
function Item:api_is_item_auto_use() end

--Item instance removes passive skills
---@param ability_id py.AbilityKey # Skill id
function Item:api_item_delete_passive_ability(ability_id) end

--Item replacement map
---@param material_id integer # Material id
---@param layer_id integer # layer id
---@param texture py.Texture # chartlet
function Item:api_change_texture(material_id, layer_id, texture) end

--Set the item name display style
---@param name_bar_type integer # Name style
function Item:api_set_name_bar_type(name_bar_type) end
