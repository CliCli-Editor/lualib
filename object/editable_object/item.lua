--item
---@class Item
---@field handle py.Item
---@field id py.ItemID
---@field private _removed_by_py boolean
---@overload fun(id: py.ItemID, py_item: py.Item): self
local M = Class 'Item'

M.type = 'item'

---@class Item: Storage
Extends('Item', 'Storage')
---@class Item: GCHost
Extends('Item', 'GCHost')
---@class Item: CustomEvent
Extends('Item', 'CustomEvent')
---@class Item: CoreObjectEvent
Extends('Item', 'CoreObjectEvent')
---@class Item: KV
Extends('Item', 'KV')

function M:__tostring()
    return string.format('{item|%s|%s}'
        , self:get_name()
        , self.handle
    )
end

---@param id py.ItemID
---@param py_item py.Item # py layer item instance
---@return Item # Returns the lua layer item instance after being initialized in the lua layer
function M:__init(id, py_item)
    self.id     = id
    self.handle = py_item
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
---@param id py.ItemID
---@return Item?
M.ref_manager = New 'Ref' ('Item', function (id)
    local py_item = GameAPI.get_item(id)
    if not py_item then
        return nil
    end
    return New 'Item' (id, py_item)
end)

---Get an item instance in lua from a skill instance in py
---@param py_item py.Item py layer item instance
---@return Item? # Returns the lua layer item instance after being initialized in the lua layer
function M.get_by_handle(py_item)
    if not py_item then
        return nil
    end
    local id = py_item:api_get_id() or 0
    return M.get_by_id(id)
end

clicli.py_converter.register_py_to_lua('py.Item', M.get_by_handle)
clicli.py_converter.register_lua_to_py('py.Item', function (lua_value)
    return lua_value.handle
end)

--Get the item instance of the lua layer by id
---@param id py.ItemID
---@return Item # Returns the lua layer item instance after being initialized in the lua layer
function M.get_by_id(id)
    local item = M.ref_manager:get(id)
    return item
end

clicli.py_converter.register_py_to_lua('py.ItemID', M.get_by_id)

---Existence or not
---@return boolean is_exist Whether it exists
function M:is_exist()
    return  GameAPI.item_is_exist(self.handle)
end

--Get a unique ID
---@return integer
function M:get_id()
    return self.id
end

---Presence tag
---@param tag string Deletes a tag
---@return boolean is_has_tag Whether there is a tag
function M:has_tag(tag)
    return self.handle:api_has_tag(tag) or false
end

---Whether it is in the scene
---@return boolean Whether is_in_scene is in the scene
function M:is_in_scene()
    if not self:is_exist() then
        return false
    end
    return self.handle:api_is_in_scene() or false
end

---Items are in the inventory
---@return boolean Whether is_in_bar is in the inventory
function M:is_in_bar()
    return self.handle:api_is_in_bar() or false
end

---Items in the backpack bar
---@return boolean Whether is_in_bag is in the backpack column
function M:is_in_bag()
    return self.handle:api_is_in_pkg() or false
end

---Traverse the unit properties of the item
---@return string[] keys Attribute key
function M:attr_pick()
    --Remove the square brackets
    local tmp = tostring(GameAPI.iter_unit_attr_of_item(self.handle)):sub(2, -2)
    local result = {}
    for match in tmp:gmatch("'([^']+)'") do
        table.insert(result, match)
    end
    return result
end

---Iterate over the unit properties of the item type
---@param item_key py.ItemKey Item type
---@return string[] keys Attribute key
function M.attr_pick_by_key(item_key)
    --Remove the square brackets
    local tmp = tostring(GameAPI.iter_unit_attr_of_item_name(item_key)):sub(2, -2)
    local result = {}
    for match in tmp:gmatch("'([^']+)'") do
        table.insert(result, match)
    end
    return result
end

---Delete item
function M:remove()
    if not self._removed then
        self._removed = true
        if not self._removed_by_py then
            self.handle:api_remove()
        end
    end
end

---Discard items to point
---@param point Point Target point
---@param count integer Specifies the number of discarded items
function M:drop(point, count)
    ---@diagnostic disable-next-line: param-type-mismatch
    self.handle:api_drop_self(point.handle, count)
end

---Move to point
---@param point Point
function M:set_point(point)
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    self.handle:api_transmit(point.handle)
end

---Set the name of the item
---@param name string Name
function M:set_name(name)
    self.handle:set_name(name)
end

---Set the description of the item
---@param description string Description
function M:set_description(description)
    self.handle:api_set_desc(description)
end

---Set the item's icon
---@param picture_id py.Texture Image id
function M:set_icon(picture_id)
    self.handle:api_set_item_icon(picture_id)
end

---Gets the icon of the item
---@return py.Texture
function M:get_icon()
    return self.handle:api_get_item_icon() or 0
end

---Set owned players
---@param player Belongs to the Player
function M:set_owner_player(player)
    self.handle:api_set_creator(player.handle)
end

---Set level
---@param level integer Specifies the level
function M:set_level(level)
    self.handle:api_set_level(level)
end

---Set the charge amount
---@param charge integer Charge integer
function M:set_charge(charge)
    self.handle:api_set_charge_cnt(charge)
end

---Increase charge number
---@param charge integer Charge integer
function M:add_charge(charge)
    self.handle:api_add_charge(charge)
end

---Set the maximum charge number
---@param charge integer Maximum charge number
function M:set_max_charge(charge)
    self.handle:api_set_max_charge(charge)
end

---Set the number of stacks
---@param stack integer Specifies the number of stacks
function M:set_stack(stack)
    self.handle:api_set_stack_cnt(stack)
end

---Increase stack count
---@param stack integer Specifies the number of stacks
function M:add_stack(stack)
    self.handle:api_add_stack(stack)
end

---Set attribute
---@param attr_name string Attribute name
---@param value number Attribute value
---@param attr_type string Attribute type
function M:set_attr(attr_name, value, attr_type)
    self.handle:api_set_attr(attr_type, attr_name, value)
end

---Set base properties
---@param key string Attribute key
---@param value number Attribute value
function M:set_attribute(key, value)
    self.handle:api_set_attr("ATTR_BASE", key, value)
end

---Add base attributes
---@param key string Attribute key
---@param value number Attribute value
function M:add_attribute(key, value)
    self.handle:api_change_attr("ATTR_BASE", key, value)
end

---Gets the basic properties of an item
---@param key string Attribute key
---@return number
function M:get_attribute(key)
    return clicli.helper.tonumber(self.handle:api_get_attr("ATTR_BASE", key)) or 0.0
end

---Set gain attribute
---@param key string Attribute key
---@param value number Attribute value
function M:set_bonus_attribute(key, value)
    self.handle:api_set_attr("ATTR_BONUS", key, value)
end

---Increase gain attribute
---@param key string Attribute key
---@param value number Attribute value
function M:add_bonus_attribute(key, value)
    self.handle:api_change_attr("ATTR_BONUS", key, value)
end

---Gets the item's gain attribute
---@param key string Attribute key
---@return number
function M:get_bonus_attribute(key)
    return clicli.helper.tonumber(self.handle:api_get_attr("ATTR_BONUS", key)) or 0.0
end
---Set health
---@param value number Health value
function M:set_hp(value)
    self.handle:api_set_hp(value)
end

---Adds passive abilities to items
---@param ability_id py.AbilityKey Skill id
---@param level integer Specifies the level
function M:add_passive_ability(ability_id, level)
    self.handle:api_item_add_passive_ability(ability_id, level)
end

---Set discard state
---@param dropable boolean status
function M:set_droppable(dropable)
    self.handle:api_set_droppable(dropable)
end

---Add tag
---@param tag string Tag
function M:add_tag(tag)
    self.handle:api_add_tag(tag)
end

---@param tag string Tag
function M:remove_tag(tag)
    self.handle:api_remove_tag(tag)
end

---Sets whether items can be sold
---@param state boolean Whether to sell
function M:set_sale_state(state)
    self.handle:api_set_sale_state(state)
end

---Set item scale
---@param scale number Scaling
function M:set_scale(scale)
    self.handle:api_set_scale(scale)
end

--Set item visibility
---@param is_visible boolean # Visible or not
function M:set_visible(is_visible)
    self.handle:api_set_item_visible(is_visible)
end

---Orient items
---@param facing number one
function M:set_facing(facing)
    self.handle:api_set_face_angle(facing)
end

---Gets the item type id
---@returnpy.ItemKey Specifies the key type
function M:get_key()
    return self.handle:api_get_key() or 0
end

---Set item prices
---@param id py.ItemKey Item id
---@param player_attr_name py.RoleResKey Player attributes
---@param price number Price
function M.set_shop_price(id, player_attr_name, price)
    GameAPI.set_item_buy_price(id, player_attr_name, price)
end

---possessor
---@return Unit? owner
function M:get_owner()
    if not IsValid(self) then
        return nil
    end
    local py_owner = self.handle:api_get_owner()
    if not py_owner then
        return nil
    end
    return clicli.unit.get_by_handle(py_owner)
end

---Item location
---@return Point position The point where the item is located
function M:get_point()
    local py_point = self.handle:api_get_position()
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    return clicli.point.get_by_handle(py_point)
end

---Item stack
---@return integer stacks Number of stacks
function M:get_stack()
    return self.handle:api_get_stack_cnt() or 0
end

---Get stack type
---@return
---| 0 # None
---| 1 # Charge
---| 2 # Stack
function M:get_stack_type()
    return self.handle:api_get_stack_type() or 0
end

---Item charge number
---@return integer charges number of charges
function M:get_charge()
    return self.handle:api_get_charge_cnt() or 0
end

---Get the maximum charge number
---@return integer max_charge Maximum number of charged energies
function M:get_max_charge()
    return self.handle:api_get_max_charge() or 0
end

---Get item level
---@return integer level Item level
function M:get_level()
    return self.handle:api_get_level() or 0
end

---Gain item health
---@return number hp item health
function M:get_hp()
    return clicli.helper.tonumber(self.handle:api_get_hp()) or 0.0
end

---Get item name
---@return string name Item name
function M:get_name()
    return self.handle:get_name() or ''
end

---Get item description
---@return string description Item description
function M:get_description()
    return self.handle:api_get_desc() or ''
end

---Get item scaling
---@return number scale Item scaling
function M:get_scale()
    return clicli.helper.tonumber(self.handle:api_get_scale()) or 0.0
end

---Gets the orientation of the item
---@return number angel orientation
function M:get_facing()
    return clicli.helper.tonumber(self.handle:api_get_face_angle()) or 0.0
end

---The active skill of acquiring objects
---@return Ability? ability Active skills
function M:get_ability()
    local py_ability = self.handle:api_get_positive_ability()
    if not py_ability then
        return nil
    end
    return clicli.ability.get_by_handle(py_ability)
end

---Passive ability to acquire items
---@param index integer
---@return Ability? ability Passive skills
function M:get_passive_ability(index)
    local py_ability = self.handle:api_get_passive_ability(index)
    if not py_ability then
        return nil
    end
    return clicli.ability.get_by_handle(py_ability)
end

---Gets the grid position of the item on the body of the unit
---@return integer index Specifies the cell position
function M:get_slot()
    if not self.handle:api_get_owner() then
        return -1
    end
    return self.handle:api_get_item_slot_idx() or -1
end

---The owning player who acquires the item
---@return Player? player
function M:get_owner_player()
    if not IsValid(self) then
        return nil
    end
    local py_player = self.handle:api_get_creator()
    if not py_player then
        return nil
    end
    return clicli.player.get_by_handle(py_player)
end

---Get items on the unit body in the backpack slot type
---@returnpy. SlotType Indicates the slot type of a backpack
function M:get_slot_type()
    if not self.handle:api_get_owner() then
        return -1
    end
    return self.handle:api_get_item_slot_type() or -1
end

----- -- -- -- -- -- -- -- -- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - class method - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

---Check item type preconditions
---@param player Player
---@param item_key py.ItemKey ID of the item type
---@return boolean
function M.check_precondition_by_key(player, item_key)
    return GameAPI.check_item_key_precondition(player.handle, item_key)
end

---Create item to point
---@param point Point
---@param item_key py.ItemKey Item type
---@param player? Player
---@return Item
function M.create_item(point, item_key, player)
    if not player then
        player = clicli.player(31)
    end
    local py_item = GameAPI.create_item_by_id(point.handle, item_key, player.handle)
    return M.get_by_handle(py_item) --[[@as Item]]
end

---Get item purchase price
---@param item_key py.ItemKey type
---@param key clicli.Const.PlayerAttr | string # Player attributes
---@return number price Price
function M.get_item_buy_price_by_key(item_key, key)
    key = clicli.const.PlayerAttr[key] or key
    ---@cast key py.RoleResKey
    return clicli.helper.tonumber(GameAPI.get_item_buy_price(item_key, key)) or 0.0
end

---Get item selling price
---@param item_key py.ItemKey type
---@param key clicli.Const.PlayerAttr | string # Player attributes
---@return number price Price
function M.get_item_sell_price_by_key(item_key, key)
    key = clicli.const.PlayerAttr[key] or key
    ---@cast key py.RoleResKey
    return clicli.helper.tonumber(GameAPI.get_item_sell_price(item_key, key)) or 0.0
end

---Get all items in the area
---@param area Area
---@return ItemGroup
function M.get_item_group_in_area(area)
    local py_item_group = GameAPI.get_item_group_in_area(area.handle)
    return clicli.item_group.create_lua_item_group_from_py(py_item_group)
end

---Gets the item type name
---@param item_key py.ItemKey Item type
---@return string
function M.get_name_by_key(item_key)
    return GameAPI.get_item_conf_name(item_key)
end

---Gets the image id of the icon for the item type
---@param item_key py.ItemKey Item type
---@return py.Texture
function M.get_icon_id_by_key(item_key)
    return GameAPI.get_icon_id_by_item_type(item_key)--[[@as py.Texture]]
end

---Get a description of the item type
---@param item_key py.ItemKey Item type
---@return string
function M.get_description_by_key(item_key)
    return GameAPI.get_item_desc_by_type(item_key)
end

---Get item model
---@returnpy. ModelKey model_key Model type
function M:get_model()
    return self.handle:api_get_item_model() or 0
end

---Gets a model of the item type
---@param item_key py.ItemKey Item type
---@returnpy. ModelKey model_key Model type
function M.get_model_by_key(item_key)
    return GameAPI.api_get_item_type_model(item_key)
end

--Item Type The number of item types required for composition
---@param item_key py.ItemKey
---@param comp_item_key py.ItemKey
---@return integer
function M.get_num_of_item_mat(item_key, comp_item_key)
    return GameAPI.api_get_value_of_item_name_comp_mat(item_key, comp_item_key)
end

--The number of player attributes required for item type synthesis
---@param item_key py.ItemKey
---@param role_res_key py.RoleResKey
---@return number
function M.get_num_of_player_attr(item_key, role_res_key)
    return GameAPI.api_get_value_of_item_name_comp_res(item_key, role_res_key)
end

---Gets the base attributes of the item type
---@param key string Attribute key
---@param item_key py.ItemKey Item type
---@return number
function M.get_attribute_by_key(item_key, key)
    ---@diagnostic disable-next-line: return-type-mismatch
    return GameAPI.api_get_attr_of_item_key(item_key, "ATTR_BASE", key)
end

---Item type Whether a label exists
---@param tag string Tag
---@param item_key py.ItemKey Item type
---@return boolean is_has_tag Whether there is a tag
function M.has_tag_by_key(tag, item_key)
    return GameAPI.item_key_has_tag(item_key, tag)
end

--Get all labels for the item
---@param item_key py.ItemKey
---@return string[]
function M.get_tags_by_key(item_key)
    local utags = clicli.object.item[item_key].data.tags
    local tags = clicli.helper.unpack_list(utags)
    return tags
end

function M:is_destroyed()
    ---@diagnostic disable-next-line: undefined-field
    local yes = self.handle:is_destroyed()
    if yes == nil then
        return true
    end
    return yes
end

---Set the item name display style
---@param name_bar_type integer Specifies the name display style
function M:set_name_bar_type(name_bar_type)
    ---@diagnostic disable-next-line: undefined-field
    self.handle:api_set_name_bar_type(name_bar_type)
end

return M
