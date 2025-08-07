--Magic effect
---@class Buff
---@field handle py.ModifierEntity # py layer magic effect object
---@field id     integer
---@field data   any # The 'data' field passed in when adding magic effects
---@field private _removed_by_py boolean
---@overload fun(id: integer, py_modifier: py.ModifierEntity): Buff
local M = Class 'Buff'

M.type = 'buff'

---@class Buff: Storage
Extends('Buff', 'Storage')
---@class Buff: GCHost
Extends('Buff', 'GCHost')
---@class Buff: CustomEvent
Extends('Buff', 'CustomEvent')
---@class Buff: CoreObjectEvent
Extends('Buff', 'CoreObjectEvent')
---@class Buff: KV
Extends('Buff', 'KV')

function M:__tostring()
    return string.format('{buff|%s|%s} @ %s'
        , self:get_name()
        , self.handle
        , self:get_owner()
    )
end

---@param id integer
---@param py_modifier py.ModifierEntity
---@return Buff
function M:__init(id, py_modifier)
    self.id     = id
    self.handle = py_modifier
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

---All magic effect instances
---@private
---@param id integer
---@param py_buff py.ModifierEntity
---@return Buff
M.ref_manager = New 'Ref' ('Buff', function (id, py_buff)
    return New 'Buff' (id, py_buff)
end)

---Get the magic effect instance of lua layer by using the magic effect instance of py layer
---@param  py_buff py.ModifierEntity # py layer magic effect example
---@return Buff? # Returns the lua Layer magic effect instance after the lua layer is initialized
function M.get_by_handle(py_buff)
    if not py_buff then
        return nil
    end
    local id = py_buff:api_get_modifier_unique_id()
    return M.ref_manager:get(id, py_buff)
end

---@param id integer
---@return Buff
function M.get_by_id(id)
    return M.ref_manager:get(id)
end

clicli.py_converter.register_type_alias('py.ModifierEntity', 'Buff')
clicli.py_converter.register_py_to_lua('py.ModifierEntity', M.get_by_handle)
clicli.py_converter.register_lua_to_py('py.ModifierEntity', function (lua_value)
    return lua_value.handle
end)

---Tagged or not
---@param tag string Tag
---@return boolean
function M:has_tag(tag)
    return GlobalAPI.has_tag(self.handle, tag)
end

---Whether the magic effect icon is visible
---@return boolean is_visible Whether it is visible
function M:is_icon_visible()
    return self.handle:api_get_icon_is_visible() or false
end

---Remove
function M:remove()
    if not self._removed then
        self._removed = true
        if not self._removed_by_py then
            self.handle:api_remove()
        end
    end
end

---Existence or not
---@return boolean is_exist Whether it exists
function M:is_exist()
    return GameAPI.modifier_is_exist(self.handle)
end

---Set the name of the magic effect
---@param name string Name
function M:set_name(name)
    self.handle:api_set_buff_str_attr("name", name)
end

---Sets the description of the magic effect object
---@param description string Description
function M:set_description(description)
    self.handle:api_set_buff_str_attr("description", description)
end

---Set the remaining duration
---@param time number Remaining duration
function M:set_time(time)
    self.handle:api_set_buff_residue_time(Fix32(time))
end

---Increases the remaining duration
---@param time number Remaining duration
function M:add_time(time)
    self.handle:api_add_buff_residue_time(Fix32(time))
end

---Set the number of stacking layers
---@param stack integer Specifies the number of layers
function M:set_stack(stack)
    self.handle:api_set_buff_layer(stack)
end

---Increase the number of stacking layers
---@param stack integer Specifies the number of layers
function M:add_stack(stack)
    self.handle:api_add_buff_layer(stack)
end

---Set the shield value
---@param value number Shield value
function M:set_shield(value)
    self.handle:api_set_float_shield('', Fix32(value))
end

---Increased shield value
---@param value number Shield value
function M:add_shield(value)
    self.handle:api_add_float_shield('', Fix32(value))
end

---Get the stack number of magic effects
---@return integer Specifies the number of stack layers
function M:get_stack()
    return self.handle:api_get_modifier_layer() or 0
end

---Gets the remaining duration of the magic effect
---@return number time Remaining duration
function M:get_time()
    return clicli.helper.tonumber(self.handle:api_get_residue_time()) or 0.0
end

---Get the Magic effect type
---@ return clicli. Const. ModifierType type magic effect type
function M:get_buff_type()
    return self.handle:api_get_modifier_type("modifier_type") or 0
end

---Gets the Magic effect effect type
---@return clicli.Const.EffectType type of magic effect effect
function M:get_buff_effect_type()
    return self.handle:api_get_modifier_effect_type("modifier_effect") or 0
end

---The maximum number of stacks to get magic effects
---@return integer Specifies the number of stack layers
function M:get_max_stack()
    return self.handle:api_get_int_attr("layer_max") or 0
end

---Obtain a shield for magic effects
---@return number shield Shield value
function M:get_shield()
    return clicli.helper.tonumber(self.handle:api_get_float_attr("cur_properties_shield")) or 0.0
end

---Acquire a halo
---@return Buff? aura belongs to
function M:get_aura()
    local py_modifier = self.handle:api_get_halo_modifier_instance()
    if not py_modifier then
        return nil
    end
    return M.get_by_handle(py_modifier)
end

---Get Magic effect cycle
---@return number time Cycle period
function M:get_cycle_time()
    return clicli.helper.tonumber(self.handle:api_get_cycle_time()) or 0.0
end

---The duration of a magic effect
---@return number duration Duration
function M:get_passed_time()
    return clicli.helper.tonumber(self.handle:api_get_passed_time()) or 0.0
end

---Gets the Halo Effect type ID for magic effects
---@return py.ModifierKey type ID of the halo effect type
function M:get_buff_aura_effect_key()
    return self.handle:api_get_sub_halo_modifier_key() or 0
end

---Get the aura range of magic effects
---@return number range Range of the halo
function M:get_buff_aura_range()
    return self.handle:api_get_halo_inf_rng() or 0.0
end

---Gets the name of the magic effect type
---@param buff_key py.ModifierKey type
---@return string name Specifies the name
function M.get_name_by_key(buff_key)
    return GameAPI.get_modifier_name_by_type(buff_key)
end

---The caster who gains magic effects
---@return Unit? provider provider
function M:get_source()
    local py_unit = self.handle:api_get_releaser()
    if not py_unit then
        return nil
    end
    return clicli.unit.get_by_handle(py_unit)
end

---A carrier to obtain magical effects
---@return Unit? owner carrier
function M:get_owner()
    local py_unit = self.handle:api_get_owner()
    if not py_unit then
        return nil
    end
    return clicli.unit.get_by_handle(py_unit)
end

---Gets the name of the magic effect object
---@return string name Specifies the name
function M:get_name()
    return self.handle:api_get_str_attr("name") or ''
end

---Gets a description of the magic effect object
---@return string description Indicates the description
function M:get_description()
    return self.handle:api_get_str_attr("description") or ''
end

---Acquisition level
---@return integer level Indicates the level
function M:get_level()
    return self.handle:api_get_modifier_level() or 0
end

---Whether the icon of the magic effect type is visible
---@param buff_key py.ModifierKey type
---@return boolean is_visible Whether it is visible
function M.is_icon_visible_by_key(buff_key)
    return GameAPI.is_show_on_ui_by_buff_type(buff_key)
end

---Get the class of magic effects
---@returnpy. ModifierKey buff_key class
function M:get_key()
    return GameAPI.get_type_of_modifier_entity(self.handle)
end

---Get a description of the type of magic effect
---@param buff_key py.ModifierKey type
---@return string description Indicates the description
function M.get_description_by_key(buff_key)
    return GameAPI.get_modifier_desc_by_type(buff_key)
end

---Get a picture of the icon icon of the Magic effect type
---@param buff_key py.ModifierKey type
---@return py.Texture # Picture id
function M.get_icon_by_key(buff_key)
    return GameAPI.get_icon_id_by_buff_type(buff_key) --[[@as py.Texture]]
end

---Acquire relevant skills
---@return Ability|nil ability The ability to associate projectiles or magic effects
function M:get_ability()
    local py_ability = GlobalAPI.get_related_ability(self.handle)
    if py_ability then
        return clicli.ability.get_by_handle(py_ability)
    end
    return nil
end

---Increases the range of magic aura effects
---@param range number Influence range
function M:add_aura_range(range)
    self.handle:api_add_modifier_halo_influence_rng(Fix32(range))
end

---Set the halo influence range for magic effects
---@param range number Influence range
function M:set_aura_range(range)
    self.handle:api_set_modifier_halo_influence_rng(Fix32(range))
end

---Increased magic effect cycle
---@param time number Change time
function M:add_cycle_time(time)
    self.handle:api_add_cycle_time(Fix32(time))
end

---Set the magic effect cycle
---@param time number Cycle period
function M:set_cycle_time(time)
    self.handle:api_set_cycle_time(Fix32(time))
end

---Set the icon of the magic effect
---@param icon integer icon
function M:set_icon(icon)
    self.handle:api_set_modifier_icon(icon)
end

---Custom data can be set and accessed using 'Buff.data'
---@param data any
function M:set_data(data)
    self.data = data
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
