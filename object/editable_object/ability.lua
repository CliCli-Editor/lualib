--skill
---@class Ability
---@field handle py.Ability
---@field private _removed_by_py boolean
---@overload fun(id: integer, py_ability: py.Ability): self
local M = Class 'Ability'

---@class Ability: GCHost
Extends('Ability', 'GCHost')
---@class Ability: Storage
Extends('Ability', 'Storage')
---@class Ability: CustomEvent
Extends('Ability', 'CustomEvent')
---@class Ability: CoreObjectEvent
Extends('Ability', 'CoreObjectEvent')
---@class Ability: KV
Extends('Ability', 'KV')

function M:__tostring()
    return string.format('{ability|%s|%s} @ %s'
        , self:get_name()
        , self.handle
        , self:get_owner()
    )
end

---@param id integer
---@param py_ability py.Ability
---@return self
function M:__init(id, py_ability)
    self.id     = id
    self.handle = py_ability
    return self
end

function M:__del()
    self:remove()
end

function M:__encode()
    return {
        unit = self:get_owner(),
        seq  = self:get_seq(),
    }
end

function M:__decode(value)
    local skill = value.unit:get_ability_by_seq(value.seq)
    return skill
end

---@private
---@param id integer
---@param py_ability py.Ability
---@return Ability
M.ref_manager = New 'Ref' ('Ability', function (id, py_ability)
    return New 'Ability' (id, py_ability)
end)

---Obtain the lua layer skill instance from the py layer skill instance
---@param py_ability py.Ability # py layer skill instance
---@return Ability? ability # Returns the lua layer skill instance after being initialized at the lua layer
function M.get_by_handle(py_ability)
    if not py_ability then
        return nil
    end
    local id = py_ability:api_get_ability_global_id()
    return M.ref_manager:get(id, py_ability)
end

---@private
---@param id integer
---@return Ability
function M.get_by_id(id)
    return M.ref_manager:fetch(id)
end

clicli.py_converter.register_py_to_lua('py.Ability', M.get_by_handle)
clicli.py_converter.register_lua_to_py('py.Ability', function (lua_value)
    return lua_value.handle
end)

---@package
M._cache_key = nil
function M:get_key()
    if not self._cache_key then
        self._cache_key = self.handle:api_get_ability_id()
    end
    return self._cache_key
end

---Whether it is affected by cooling loss
---@return boolean is_influenced Whether cooling reduction is affected
function M:is_cd_reduce()
    return self.handle:api_get_influenced_by_cd_reduce() or false
end

---Consuming life will lead to death
---@return boolean is_cost Whether life will die if consumed
function M:is_cost_hp_can_die()
    return self.handle:api_get_cost_hp_can_die() or false
end

---Whether life deficiency can be released
---@return boolean can_cast Specifies whether to release the lives that are insufficient
function M:can_cast_when_hp_insufficient()
    return self.handle:api_get_can_cast_when_hp_insufficient() or false
end

---Tagged or not
---@param tag string Tag
---@return boolean
function M:has_tag(tag)
    return GlobalAPI.has_tag(self.handle,tag)
end

---Gets all labels for skill types
---@param item_key py.ItemKey
---@return string[]
function M.get_tags_by_key(item_key)
    local utags = clicli.object.ability[item_key].data.tags
    return clicli.helper.unpack_list(utags)
end

---Whether the skill type has a label
---@param item_key py.ItemKey
---@param tag string Tag
---@return boolean
function M.has_tag_by_key(item_key, tag)
    local tags = M.get_tags_by_key(item_key)
    for _, v in ipairs(tags) do
        if v == tag then
            return true
        end
    end
    return false
end

--Add tag
---@param tag string Tag
function M:add_tag(tag)
    self.handle:api_add_tag(tag)
end

---Remove tag
---@param tag string Tag
function M:remove_tag(tag)
    self.handle:api_remove_tag(tag)
end

---Enabling skill
function M:enable()
    self.handle:api_enable()
end

---Forbidden skill
function M:disable()
    self.handle:api_disable()
end

---Entry cooling
function M:restart_cd()
    self.handle:api_restart_cd()
end

---Complete cooling
function M:complete_cd()
    self.handle:api_immediately_clear_cd()
end

---Stop casting skills
function M:stop_cast()
    self.handle:api_ability_stop()
end

---Remove skill
function M:remove()
    if not self._removed then
        self._removed = true
        self:stop_cast()
        if not self._removed_by_py then
            --Calling the removal interface again while removing a skill will cause the game to crash
            self.handle:api_remove()
        end
    end
end

---Set skill level
---@param level integer Specifies the level
function M:set_level(level)
    self.handle:api_set_level(level)
end

--Gain skill level
---@return integer level Indicates the level
function M:get_level()
    return self.handle:api_get_level() or 0
end

---Increased cooldown
---@param value number Cool down
function M:add_cd(value)
    self.handle:api_change_ability_cd_cold_down(Fix32(value))
end

---Set the number of charging layers
---@param value integer Specifies the number of layers
function M:set_stack(value)
    self.handle:api_set_ability_stack_count(value)
end

---@package
M._cache_name = nil

function M:get_name()
    if not self._cache_name then
        self._cache_name = self.handle:api_get_name()
    end
    return self._cache_name
end

---Sets the real number property
---@ param key clicli. Const. AbilityFloatAttr | key string attribute
---@param value number Attribute value
function M:set_float_attr(key, value)
    self.handle:api_set_float_attr(clicli.const.AbilityFloatAttr[key] or key, Fix32(value))
end

---Set integer properties
---@ param key clicli. Const. AbilityIntAttr | key string attribute
---@param value integer Specifies the value of the attribute
function M:set_int_attr(key, value)
    self.handle:api_set_int_attr(clicli.const.AbilityIntAttr[key] or key, value)
end

---Set the remaining cooldown time
---@param value number Remaining cooling time
function M:set_cd(value)
    self.handle:api_set_ability_cd(Fix32(value))
end

---Increase skill level
---@param value integer Specifies the level
function M:add_level(value)
    self.handle:api_add_level(value)
end

---Increased the number of skill recharge levels
---@param value integer Specifies the number of layers
function M:add_stack(value)
    self.handle:api_add_ability_stack_count(value)
end

---Increased the skill's remaining cooldown
---@param value number Remaining cooling time
function M:add_remaining_cd(value)
    self.handle:api_add_ability_cd(Fix32(value))
end

---Added real attribute
---@param key string Attribute key
---@param value number Attribute value
function M:add_float_attr(key, value)
    self.handle:api_add_float_attr(key, Fix32(value))
end

---Increment integer attribute
---@param key string Attribute key
---@param value integer Specifies the value of the attribute
function M:add_int_attr(key, value)
    self.handle:api_add_int_attr(key, value)
end

---Set skill name
---@param name string Skill name
function M:set_name(name)
    self.handle:api_set_name(name)
end

---Set skill description
---@param des string Description
function M:set_description(des)
    --TODO see question 1
    ---@diagnostic disable-next-line: param-type-mismatch
    self.handle:api_set_str_attr("desc", des)
end

--Get skill description
---@return string
function M:get_description()
    ---@diagnostic disable-next-line: param-type-mismatch
    return self.handle:api_get_str_attr("desc") or ''
end

---Learning skill
function M:learn()
    self.handle:api_learn_ability()
end

---Set the remaining charge time of a skill
---@param value number Remaining charging time
function M:set_charge_time(value)
    self.handle:api_set_ability_cur_stack_cd(Fix32(value))
end

---Set the scope of a skill cast
---@param value number Casting range
function M:set_range(value)
    self.handle:api_set_ability_cast_range(Fix32(value))
end

---Gain skill casting scope
---@return number # Scope of casting
function M:get_range()
    return clicli.helper.tonumber(self.handle:api_get_ability_cast_range()) or 0.0
end

---Set skill player stat cost
---@param key string Attribute key
---@param value number Attribute value
function M:set_player_attr_cost(key, value)
    self.handle:api_set_ability_player_attr_cost(key, Fix32(value))
end

---Increased skill player stat cost
---@param key string Attribute key
---@param value number Attribute value
function M:add_player_attr_cost(key, value)
    self.handle:api_add_ability_player_attr_cost(key, Fix32(value))
end

---Sets whether skills are affected by cooldown reduction
---@param is_influenced boolean attribute key
function M:set_cd_reduce(is_influenced)
    self.handle:api_set_influenced_by_cd_reduce(is_influenced)
end

---Set whether consuming life will result in death
---@param can_die boolean Specifies whether to die
function M:set_is_cost_hp_can_die(can_die)
    self.handle:api_set_cost_hp_can_die(can_die)
end

---Sets whether skills can be released when life is low
---@param can_cast boolean Specifies whether the value can be released
function M:set_can_cast_when_hp_insufficient(can_cast)
    self.handle:api_set_can_cast_when_hp_insufficient(can_cast)
end

---Set the fan indicator radius
---@param value number Radius
function M:set_sector_radius(value)
    self.handle:api_set_ability_sector_radius(Fix32(value))
end

---Set the Angle of the sector indicator
---@param value number Angle
function M:set_sector_angle(value)
    self.handle:api_set_ability_sector_angle(Fix32(value))
end

---Sets the arrow/multi-segment indicator length
---@param value number Length
function M:set_arrow_length(value)
    self.handle:api_set_ability_arrow_length(Fix32(value))
end

---Set the arrow/multi-segment indicator width
---@param value number Width
function M:set_arrow_width(value)
    self.handle:api_set_ability_arrow_width(Fix32(value))
end


---Set arrow circle indicator radius
---@param value number Radius
function M:set_circle_radius(value)
    self.handle:api_set_ability_circle_radius(Fix32(value))
end

---Set the skill indicator type
---@ param type clicli. Const. AbilityPointerType skill type indicator
function M:set_pointer_type(type)
    self.handle:api_set_ability_pointer_type(type)
end

---Gets the remaining charge time of the skill
---@return number
function M:get_charge_time()
    return clicli.helper.tonumber(self.handle:api_get_stack_cd_left_time()) or 0.0
end

---Acquire skill types
---@return clicli.Const.AbilityType type of the skill
function M:get_type()
    return self.handle:api_get_type() or 0
end

---Obtain the skill bit where the skill resides
---@ return clicli. Const. AbilityIndex index in skills
function M:get_slot()
    return self.handle:api_get_ability_index() or 0
end

---Gets the serial number of the skill on the unit
---@returnpy.AbilitySeq Indicates the seq skill number
function M:get_seq()
    return self.handle:api_get_ability_seq() or 0
end

---Gets the player attribute value for skill cost
---@param key clicli.Const.PlayerAttr | string Attribute key
---@return number cost Player attribute value
function M:get_player_attr_cost(key)
    key = clicli.const.PlayerAttr[key] or key
    return clicli.helper.tonumber(self.handle:api_get_ability_player_attr_cost(key)) or 0.0
end

---Obtains the skill release type AbilityCastType
---@returnpy. AbilityCastType type of skill release
function M:get_cast_type()
    return self.handle:api_get_ability_cast_type() or 0
end

---Whether automatic casting is enabled
---@return boolean Whether is_enabled is enabled
function M:is_autocast_enabled()
    return self.handle:api_is_autocast_enabled() or false
end

---Get skill formula type kv
---@param key string key value
---@return number value Indicates the value
function M:get_formula_kv(key)
    return clicli.helper.tonumber(self.handle:api_calc_ability_formula_kv(key)) or 0.0
end

---Gets the real number attribute
---@ param key clicli. Const. AbilityFloatAttr | string keys key
---@return number value Indicates the value
function M:get_float_attr(key)
    return clicli.helper.tonumber(self.handle:api_get_float_attr(clicli.const.AbilityFloatAttr[key] or key)) or 0.0
end

---Get integer properties
---@ param key clicli. Const. AbilityIntAttr | string keys key
---@return number value Indicates the value
function M:get_int_attr(key)
    return self.handle:api_get_int_attr(clicli.const.AbilityIntAttr[key] or key) or 0
end

---Get string attribute
---@param key string key value
---@return string value Indicates the value
function M:get_string_attr(key)
    ---@diagnostic disable-next-line: param-type-mismatch
    return self.handle:api_get_str_attr(key) or ''
end

---Acquire the owner of the skill
---@return Unit? owner Skill owner
function M:get_owner()
    local py_unit = self.handle:api_get_owner()
    if not py_unit then
        return nil
    end
    return clicli.unit.get_by_handle(py_unit)
end

---Gets the current cooldown time
---@return number time Current cooling time
function M:get_cd()
    return clicli.helper.tonumber(self.handle:api_get_cd_left_time()) or 0.0
end

---Existence or not
---@return boolean is_exist Whether it exists
function M:is_exist()
    return GameAPI.ability_is_exist(self.handle)
end

---@param cast integer Cast ID
---@return Unit|Destructible|Item|Point|nil target
function M:get_target(cast)
    local unit = GameAPI.get_target_unit_in_ability(self.handle,cast)
    if unit then
        return clicli.unit.get_by_handle(unit)
    end

    local dest = GameAPI.get_target_dest_in_ability(self.handle, cast)
    if dest then
        return clicli.destructible.get_by_handle(dest)
    end

    local item = GameAPI.get_target_item_in_ability(self.handle,cast)
    if item then
        return clicli.item.get_by_handle(item)
    end

    local point = self.handle:api_get_release_position(cast)
    if point then
        return clicli.point.get_by_handle(point)
    end

    return nil
end

---Display skill indicator
---@param player Player
function M:show_indicator(player)
    GameAPI.create_preview_skill_pointer(player.handle, self.handle)
end

---Switch automatically casts spells
---@param enable boolean switch
function M:set_autocast(enable)
    self.handle:api_set_autocast_enabled(enable)
end

----- -- -- -- -- -- -- -- -- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - class method - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

---Check the preconditions for the skill type
---@param player Player
---@param ability_key py.AbilityKey Skill type id (Object id)
---@return boolean is_meet Whether the preconditions for the skill type are met
function M.check_precondition_by_key(player, ability_key)
    return GameAPI.check_ability_key_precondition(player.handle, ability_key)
end

---Whether the skill type is affected by cooldown reduction
---@param ability_key py.AbilityKey Skill type id (Object id)
---@return boolean is_influenced Whether the skill type is affected by cooldown reduction
function M.is_cd_reduce_by_key(ability_key)
    return GameAPI.api_get_influenced_by_cd_reduce(ability_key)
end

--Gets the real attribute of the skill type
--> Use 'clicli.object.ability[ability_key].data' instead
---@deprecated
---@param ability_key py.AbilityKey Skill type id (Object id)
---@param key string key value
---@return number value Indicates the value
function M.get_float_attr_by_key(ability_key, key)
    return clicli.helper.tonumber(GameAPI.get_ability_conf_float_attr(ability_key, key)) or 0.0
end

--Gets the integer attribute of the skill type
--> Use 'clicli.object.ability[ability_key].data' instead
---@deprecated
---@param ability_key py.AbilityKey Skill type id (Object id)
---@param key string key value
---@return integer value Specifies the value
function M.get_int_attr_by_key(ability_key, key)
    return GameAPI.get_ability_conf_int_attr(ability_key,key)
end

---Set the player's attack preview status
---@param player Player
---@param state boolean Status On/off
function M.set_normal_attack_preview_state(player, state)
    GameAPI.set_preview_common_atk_range(player.handle, state)
end

---Sets whether the player's indicator is displayed while smart casting
---@param player Player
---@param state boolean Status On/off
function M.set_smart_cast_with_pointer(player, state)
    GameAPI.set_smart_cast_with_pointer(player.handle, state)
end

---Turn off skill indicator
---@param player Player
function M.hide_pointer(player)
    GameAPI.clear_preview_skill_pointer(player.handle)
end

---Gets the picture ID of the icon icon for the skill type
---@param ability_key py.AbilityKey Skill type id (Object id)
---@returnpy. Texture id Image ID
function M.get_icon_by_key(ability_key)
    return GameAPI.get_icon_id_by_ability_type(ability_key) --[[@as py.Texture]]
end

--Get skill icon
---@returnpy. Texture id Image ID
function M:get_icon()
    return M.get_icon_by_key(self:get_key())
end

---Gets the skill type formula properties
---@param ability_id py.AbilityKey Skill type id(object id)
---@param attr_name string Attribute name
---@param level integer Skill level
---@param stack_count integer Specifies the number of skill layers
---@param unit_hp_max number Maximum life of a unit
---@param unit_hp_cur number The current life of the unit
---@return number value Indicates the value
function M.get_formula_attr_by_key(ability_id, attr_name, level, stack_count, unit_hp_max, unit_hp_cur)
    return clicli.helper.tonumber(GameAPI.get_ability_conf_formula_attr(ability_id, attr_name, level, stack_count, Fix32(unit_hp_max), Fix32(unit_hp_cur))) or 0.0
end

--Gets the skill type string property
--> Please use 'clicli.object.ability[ability_key].data' instead
---@deprecated
---@param ability_key py.AbilityKey Skill type id (Object id)
---@param key py.AbilityStrAttr key value key
---@return string str value
function M.get_str_attr_by_key(ability_key, key)
    return GameAPI.get_ability_conf_str_attr(ability_key, key)
end

--Get the skill name based on the skill key
---@param ability_key py.AbilityKey
---@return string name Skill name
function M.get_name_by_key(ability_key)
    ---@diagnostic disable-next-line: param-type-mismatch
    return GameAPI.get_ability_conf_str_attr(ability_key, 'name')
end

--Obtain the skill description based on the skill key
---@param ability_key py.AbilityKey
---@return string des description
function M.get_description_by_key(ability_key)
    ---@diagnostic disable-next-line: param-type-mismatch
    return GameAPI.get_ability_conf_str_attr(ability_key, 'description')
end

---Set skill icon
---@param icon_id integer Image id
function M:set_icon(icon_id)
    self.handle:api_set_ability_icon(icon_id)
end

---Set the building orientation of the skill
---@param angle number Indicates the Angle
function M:set_build_rotate(angle)
    self.handle:api_set_ability_build_rotate(Fix32(angle))
end

---Gets the indicator type of the skill
---@return clicli.Const.AbilityPointerType
function M:get_skill_pointer()
    return self.handle:api_get_ability_skill_pointer() or 0
end

---Gets the indicator type for the skill type
---@param name py.AbilityKey
---@return clicli.Const.AbilityPointerType
function M.get_skill_type_pointer(name)
    return GameAPI.get_ability_key_skill_pointer(name)
end

---Set the skill Max CD
---@param value number
function M:set_max_cd(value)
    self:set_float_attr("cold_down_time", value)
end

--Get the skill Max CD
---@return number
function M:get_max_cd()
    return self:get_float_attr("cold_down_time")
end

---Enter skill ready to cast
---@param player Player
function M:pre_cast(player)
    GameAPI.start_skill_pointer(player.handle, self.handle)
end

---Block spells that are about to begin, and can only be used during the "Spell - About to Begin" event
function M:prevent_cast()
    self.handle:api_break_ability_in_cs()
end

--Get the item that the skill is bound to (which item object the skill object is on)
---@return Item?
function M:get_item()
    local py_item = self.handle:api_get_item()
    if not py_item then
        return nil
    end
    return clicli.item.get_by_handle(py_item)
end

--Set the skill is build target type (build_id)
---@param build_id py.UnitKey # Unit object ID
function M:set_ability_build_id(build_id)
    self.handle:api_set_ability_build_id(build_id or 0)
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
