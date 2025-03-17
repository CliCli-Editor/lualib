--unit
---@class Unit
---@field handle py.Unit # Unit object of layer py
---@field id integer
---@field private _removed_by_py boolean
---@overload fun(py_unit_id: py.UnitID, py_unit: py.Unit): self
local M = Class 'Unit'

M.type = 'unit'

---@class Unit: GCHost
Extends('Unit', 'GCHost')
---@class Unit: Storage
Extends('Unit', 'Storage')
---@class Unit: CustomEvent
Extends('Unit', 'CustomEvent')
---@class Unit: CoreObjectEvent
Extends('Unit', 'CoreObjectEvent')
---@class Unit: KV
Extends('Unit', 'KV')

function M:__tostring()
    return string.format('{unit|%s|%d}'
        , self:get_name()
        , self.id
    )
end

---@param py_unit_id py.UnitID
---@param py_unit py.Unit
---@return self
function M:__init(py_unit_id, py_unit)
    self.handle = py_unit
    self.id     = py_unit_id
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
---@param id py.UnitID
---@return Unit?
M.ref_manager = New 'Ref' ('Unit', function (id)
    local py_unit = GameAPI.get_unit_by_id(id)
    if not py_unit then
        return nil
    end
    return New 'Unit' (id, py_unit)
end)

---Get the unit instance of the lua layer from the unit instance of the py layer
---@param py_unit py.Unit
---@return Unit?
function M.get_by_handle(py_unit)
    if not py_unit then
        return nil
    end
    local id = py_unit:api_get_id()
    local unit = M.ref_manager:get(id)
    return unit
end

clicli.py_converter.register_py_to_lua('py.Unit', M.get_by_handle)
clicli.py_converter.register_lua_to_py('py.Unit', function (lua_value)
    return lua_value.handle
end)

--Gets units based on unique ids.
---@param id py.UnitID
---@return Unit?
function M.get_by_id(id)
    local unit = M.ref_manager:get(id)
    return unit
end

--Gets the units placed on the scene
---@param res_id integer
---@return Unit
function M.get_by_res_id(res_id)
    local u = M.get_by_id(res_id--[[@as py.UnitID]])
    if not u then
        error(('The unit with ID %d could not be found'):format(res_id))
    end
    return u
end

--Get the Unit from the string, which is via 'tostring(Unit)'
--Or using the "Convert any variable to string" in ECA.
---@param str string
---@return Unit?
function M.get_by_string(str)
    local id = str:match('^{unit|.+|(%d+)}$')
            or str:match('<LCreature%((%d+)%)>')
            or str:match('^Unit:(%d+)')
    if not id then
        return nil
    end
    return M.get_by_id(tonumber(id)--[[@as py.UnitID]])
end

clicli.py_converter.register_py_to_lua('py.UnitID', M.get_by_id)

---Existence or not
---@return boolean is_exist Whether it exists
function M:is_exist()
    return GameAPI.unit_is_exist(self.handle)
end

--Get a unique ID
---@return integer
function M:get_id()
    return self.id
end

--Remove skills (specified type)
--> If you misspell it, use 'Unit:remove_ability_by_key' instead
---@deprecated
---@ param type clicli. Const. AbilityType | clicli. Const. AbilityTypeAlias skill type
---@param ability_key py.AbilityKey Object id
function M:remove_abilitiy_by_key(type, ability_key)
    self.handle:api_remove_abilities_in_type(clicli.const.AbilityType[type] or type, ability_key)
end

--Remove skills (specified type)
---@ param type clicli. Const. AbilityType | clicli. Const. AbilityTypeAlias skill type
---@param ability_key py.AbilityKey Object id
function M:remove_ability_by_key(type, ability_key)
    self.handle:api_remove_abilities_in_type(clicli.const.AbilityType[type] or type, ability_key)
end

---Unit addition
---@param item_id py.ItemKey id of the item
---@param slot_type? Clicli. Const. ShiftSlotTypeAlias slot type
---@return Item?
function M:add_item(item_id, slot_type)
    local py_item = self.handle:api_add_item(item_id, clicli.const.ShiftSlotType[slot_type])
    if not py_item then
        return nil
    end
    return clicli.item.get_by_handle(py_item)
end

---Unit removal items
---@param item_id py.ItemKey id of the item
---@param num? integer quantity
function M:remove_item(item_id, num)
    self.handle:api_delete_item(item_id, num or 1)
end

---Moving items
---@param item Item item
---@param type clicli.Const.ShiftSlotTypeAlias
---@param index? integer slot
---@param force? boolean Whether to force a move, 'true' : If the target has an item, move to another space; 'false' : If the target has an item, the item to be moved will drop
function M:shift_item(item, type, index, force)
    self.handle:api_shift_item_new(item.handle, clicli.const.ShiftSlotType[type], index or 0, force or false)
end

--barter
--If the target location is empty, it is equivalent to moving the item
---@param item Item item
---@param type clicli.Const.ShiftSlotTypeAlias
---@param index integer Specifies the slot
function M:exchange_item(item, type, index)
    self.handle:api_shift_item(item.handle, clicli.const.ShiftSlotType[type], index)
end

---Gets all skills for a specified type
---@param type clicli.Const.AbilityType
---@return Ability[]
function M:get_abilities_by_type(type)
    ---@type Ability[]
    local abilities = {}
    local py_list = self.handle:api_get_abilities_by_type(type)
    if not py_list then
        return abilities
    end
    for i = 0, python_len(py_list) - 1 do
        local lua_ability = clicli.ability.get_by_handle(python_index(py_list, i))
        abilities[#abilities+1] = lua_ability
    end
    return abilities
end

---Gain magic effects on units
---@return Buff[] # Magic effect table
function M:get_buffs()
    ---@type Buff[]
    local buffs = {}
    local py_list = self.handle:api_get_all_modifiers()
    if not py_list then
        return buffs
    end
    for i = 0, python_len(py_list) - 1 do
        local lua_buff = clicli.buff.get_by_handle(python_index(py_list, i))
        buffs[#buffs+1] = lua_buff
    end
    return buffs
end

---Swap skill positions
---@param ability_1 Ability First skill
---@param ability_2 Ability Second skill
function M:switch_ability(ability_1, ability_2)
    self.handle:api_switch_ability(ability_1.handle, ability_2.handle)
end

---Trade skills based on pit position
---@param type_1 clicli.Const.AbilityType Indicates the first skill type
---@ param slot_1 clicli. Const. AbilityIndex skills first pit
---@param type_2 clicli.Const.AbilityType Second skill type
---@ param slot_2 clicli. Const. AbilityIndex skills the second pit
function M:switch_ability_by_slot(type_1, slot_1, type_2, slot_2)
    self.handle:api_switch_ability_by_index(type_1, slot_1, type_2, slot_2)
end

---Stop all skills
function M:stop_all_abilities()
    self.handle:api_stop_all_abilities()
end

---Add skills
---@ param type clicli. Const. AbilityType | clicli. Const. AbilityTypeAlias skill type
---@param id py.AbilityKey Object id
---@param slot? Clicli. Const. AbilityIndex skills
---@param level? integer level
---@return Ability?
function M:add_ability(type, id, slot, level)
    local py_ability = self.handle:api_add_ability(clicli.const.AbilityType[type] or type, id, slot or -1, level or 1)
    if not py_ability then
        return nil
    end
    local ability = clicli.ability.get_by_handle(py_ability)
    return ability
end

---Remove skill
---@param type clicli.Const.AbilityType Skill type
---@ param slot clicli. Const. AbilityIndex skills
function M:remove_ability(type, slot)
    self.handle:api_remove_ability_by_index(type, slot)
end

---Find skills by skill name
---@ param type clicli. Const. AbilityType | clicli. Const. AbilityTypeAlias skill type
---@param id py.AbilityKey Object id
---@return Ability? ability skills
function M:find_ability(type, id)
    local py_ability = self.handle:api_get_ability_by_type(clicli.const.AbilityType[type] or type, id)
    if not py_ability then
        return nil
    end
    return clicli.ability.get_by_handle(py_ability)
end

---Acquire the skill of a certain skill level
---@ param type clicli. Const. AbilityType | clicli. Const. AbilityTypeAlias skill type
---@param slot integer Specifies the skill bit
---@return Ability? ability skills
function M:get_ability_by_slot(type, slot)
    ---@diagnostic disable-next-line: param-type-mismatch
    local py_ability = self.handle:api_get_ability(clicli.const.AbilityType[type] or type, slot)
    if not py_ability then
        return nil
    end
    return clicli.ability.get_by_handle(py_ability)
end

--Get skills according to skill number
---@param seq py.AbilitySeq
---@return Ability?
function M:get_ability_by_seq(seq)
    local py_ability = self.handle:api_get_ability_by_seq(seq)
    if not py_ability then
        return nil
    end
    return clicli.ability.get_by_handle(py_ability)
end

---comment Gain general attack skills
---@return Ability?
function M:get_common_attack()
    local py_ability = self.handle:api_get_common_atk_ability()

    if py_ability then
        return clicli.ability.get_by_handle(py_ability)
    end
end

---Get the items in the unit backpack slot
---@ param type clicli. Const. SlotType | clicli. Const. ShiftSlotTypeAlias slot type
---@param slot integer Specifies the location
---@return Item? item
function M:get_item_by_slot(type, slot)
    local py_item = self.handle:api_get_item_by_slot(clicli.const.ShiftSlotType[type] or type, slot)
    if not py_item then
        return nil
    end
    return clicli.item.get_by_handle(py_item)
end

---All items of the unit
---@return ItemGroup item_group All items
function M:get_all_items()
    local py_item_group = self.handle:api_get_all_item_pids()
    if not py_item_group then
        return clicli.item_group.create()
    end
    return clicli.item_group.create_lua_item_group_from_py(py_item_group)
end

---Unit acquisition of technology
---@param tech_key py.TechKey Technology type
function M:unit_gains_tech(tech_key)
    self.handle:api_add_tech(tech_key)
end

---Create unit
---@param owner Player|Unit
---@param unit_id py.UnitKey Unit type
---@param point Point
---@param direction number Indicates the direction
---@return Unit
function M.create_unit(owner, unit_id, point, direction)
    local py_unit = GameAPI.create_unit(
        unit_id,
        point.handle,
        Fix32(direction),
        --TODO see question 4
        ---@diagnostic disable-next-line: param-type-mismatch
        owner.handle
    )
    return M.get_by_handle(py_unit) --[[@as Unit]]
end

---Kill unit
---@param killer? Unit The killer is unit.
function M:kill_by(killer)
    self.handle:api_kill(killer and killer.handle or nil)
end

---Whether the unit has a skill that is being released
---@return boolean
function M:is_casting()
    return self.handle:api_unit_has_running_ability() or false
end

---Get the skills that are being unleashed
---@return Ability?
function M:get_casting_ability()
    local py_ability = self.handle:api_get_cur_record_ability()
    if not py_ability then
        return nil
    end
    return clicli.ability.get_by_handle(py_ability)
end

---Create illusion
---@param illusion_unit Unit for phantom replication
---@param call_unit Unit Calls the unit
---@param player Player
---@param point Point
---@param direction number Indicates the direction
---@param clone_hp_mp boolean Copies the current health and mana
---@return Unit?
function M.create_illusion(illusion_unit, call_unit, player, point, direction, clone_hp_mp)
    local py_unit = GameAPI.create_illusion(illusion_unit.handle, call_unit.handle, player.handle, point.handle, Fix32(direction), clone_hp_mp)
    if not py_unit then
        return nil
    end
    return clicli.unit.get_by_handle(py_unit)
end

---Delete unit
function M:remove()
    if not self._removed then
        self._removed = true
        if not self._removed_by_py then
            self.handle:api_delete()
        end
    end
end

---Transfer to point
---@param point Point
function M:blink(point)
    self.handle:api_transmit(point.handle)
end

---Force transfer to point
---@param point Point
---@param isSmooth boolean Specifies whether it is smooth
function M:set_point(point, isSmooth)
    self.handle:api_force_transmit_new(point.handle, isSmooth)
end

---Reactivation unit
---@param point? Point
function M:reborn(point)
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    self.handle:api_revive(point and point.handle or nil)
end

---Cause treatment
---@param value number Treatment value
---@param skill? Ability skills
---@param source_unit? Unit
---@param text_type? string Indicates the hop type
function M:heals(value, skill, source_unit, text_type)
    ---@diagnostic disable-next-line: missing-parameter
    self.handle:api_heal(Fix32(value), text_type ~= nil, skill and skill.handle or nil, source_unit and source_unit.handle or nil, text_type or '')
end

---Add tag
---@param tag string Tag
function M:add_tag(tag)
    self.handle:api_add_tag(tag)
end

---Remove tag
---@param tag string Tag
function M:remove_tag(tag)
    self.handle:api_remove_tag(tag)
end

---Add state
---@ param state_enum integer | clicli. Const. UnitEnumState state name
function M:add_state(state_enum)
    self.handle:api_add_state(clicli.const.UnitEnumState[state_enum] or state_enum)
end

---Removed state
--The status can be removed only when the number of removals is the same as the number of additions
---@ param state_enum integer | clicli. Const. UnitEnumState state name
function M:remove_state(state_enum)
    self.handle:api_remove_state(clicli.const.UnitEnumState[state_enum] or state_enum)
end

---Add multiple states
---Use ` clicli. Const. UnitEnumState ` the enumeration values
---@param state_enum integer Indicates the status
function M:add_multi_state(state_enum)
    self.handle:api_add_multi_state(state_enum)
end

---Remove multiple states
---Use ` clicli. Const. UnitEnumState ` the enumeration values
---@param state_enum integer Indicates the status
function M:remove_multi_state(state_enum)
    self.handle:api_remove_multi_state(state_enum)
end

---Whether there is a state
---@ param state_enum integer | clicli. Const. UnitEnumState state name
---@return boolean?
function M:has_state(state_enum)
    return self.handle:api_has_state(clicli.const.UnitEnumState[state_enum] or state_enum)
end

---Add state
---@ param state_enum integer | clicli. Const. UnitEnumState state name
---@return GCNode
function M:add_state_gc(state_enum)
    self:add_state(state_enum)
    return New 'GCNode' (function ()
        self:remove_state(state_enum)
    end)
end

---Learning skill
---@param ability_key py.AbilityKey Indicates the skill id
function M:learn(ability_key)
    self.handle:api_unit_learn_ability(ability_key)
end

---Issue an order
---@param command py.UnitCommand Indicates the command
function M:command(command)
    self.handle:api_release_command(command)
end

--Command move
---@param point Point
---@param range? number range
---@return py.UnitCommand # command
function M:move_to_pos(point, range)
    local command = GameAPI.create_unit_command_move_to_pos(point.handle, Fix32(range or 0))
    self:command(command)
    return command
end

--Stop order
---@return py.UnitCommand # command
function M:stop()
    local command = GameAPI.create_unit_command_stop()
    self:command(command)
    return command
end

--Command garrison
---@param point Point
---@return py.UnitCommand # command
function M:hold(point)
    local command = GameAPI.create_unit_command_hold(point.handle)
    self:command(command)
    return command
end

--Command attack move
---@param point Point
---@param range? number range
---@return py.UnitCommand # command
function M:attack_move(point, range)
    local command = GameAPI.create_unit_command_attack_move(point.handle, Fix32(range or 0))
    self:command(command)
    return command
end

--Command attack target
---@param target Unit Target
---@param range number Indicates the range
---@return py.UnitCommand # command
function M:attack_target(target, range)
    local command = GameAPI.create_unit_command_attack_target(target.handle, Fix32(range or 0))
    self:command(command)
    return command
end

--The command moves along the path
---@param road Road path
---@ param patrol_mode clicli. Const. RoadPatrolType movement mode
---@param can_attack boolean Specifies whether to automatically attack
---@param start_from_nearest boolean Specifies the nearest start point
---@param back_to_nearest boolean Returns nearest deviation
---@return py.UnitCommand # command
function M:move_along_road(road, patrol_mode, can_attack, start_from_nearest, back_to_nearest)
    local command = GameAPI.create_unit_command_move_along_road(road.handle, clicli.const.RoadPatrolType[patrol_mode] or patrol_mode, can_attack, start_from_nearest, back_to_nearest)
    self:command(command)
    return command
end

--Command activation skill
---@param ability Ability # skill
---@param target? Point|Unit|Item|Destructible # goal
---@param extra_target? Point # Extra target
---@return py.UnitCommand
function M:cast(ability, target, extra_target)
    local tar_pos_1, tar_pos_2, tar_unit, tar_item, tar_dest
    if target then
        if target.type == 'point' then
            ---@cast target Point
            tar_pos_1 = target.handle
        elseif target.type == 'unit' then
            ---@cast target Unit
            tar_unit = target.handle
        elseif target.type == 'item' then
            ---@cast target Item
            tar_item = target.handle
        elseif target.type == 'destructible' then
            ---@cast target Destructible
            tar_dest = target.handle
        end
    end
    if extra_target then
        tar_pos_2 = extra_target.handle
    end
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    local command = GameAPI.create_unit_command_use_skill(ability.handle, tar_pos_1, tar_pos_2, tar_unit, tar_item, tar_dest)
    self:command(command)
    return command
end

--Command to pick up items
---@param item Item
---@return py.UnitCommand
function M:pick_item(item)
    local command = GameAPI.create_unit_command_pick_item(item.handle)
    self:command(command)
    return command
end

--Order to discard items
---@param item Item
---@param point Point
---@return py.UnitCommand
function M:drop_item(item, point)
    local command = GameAPI.create_unit_command_drop_item(item.handle, point.handle)
    self:command(command)
    return command
end

--Order to give goods
---@param item Item
---@param target Unit
---@return py.UnitCommand
function M:give_item(item, target)
    local command = GameAPI.create_unit_command_transfer_item(item.handle, target.handle)
    self:command(command)
    return command
end

--Command use item
---@param item Item
---@param target? Point|Unit|Item|Destructible
---@param extra_target? Point
---@return py.UnitCommand
function M:use_item(item, target, extra_target)
    local tar_pos_1, tar_pos_2, tar_unit, tar_item, tar_dest
    if target then
        if target.type == 'point' then
            ---@cast target Point
            tar_pos_1 = target.handle
        elseif target.type == 'unit' then
            ---@cast target Unit
            tar_unit = target.handle
        elseif target.type == 'item' then
            ---@cast target Item
            tar_item = target.handle
        elseif target.type == 'destructible' then
            ---@cast target Destructible
            tar_dest = target.handle
        end
    end

    if extra_target then
        tar_pos_2 = extra_target.handle
    end

    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    local command = GameAPI.create_unit_command_use_item(item.handle, tar_pos_1, tar_pos_2, tar_unit, tar_item, tar_dest)
    self:command(command)
    return command
end

--Command follower unit
---@param target Unit
---@param refresh_interval? number refresh interval
---@param near_offset? number following distance
---@param far_offset? number Refollow distance
---@param follow_angle? number following Angle
---@param follow_dead_target? boolean Whether to follow dead units
---@return py.UnitCommand
function M:follow(target, refresh_interval, near_offset, far_offset, follow_angle, follow_dead_target)
    local command = GameAPI.create_unit_command_follow(target.handle
        , Fix32(refresh_interval or 0.5)
        , Fix32(near_offset or -1)
        , Fix32(far_offset or -1)
        , Fix32(follow_angle or -10000)
        , follow_dead_target or false
    )
    self:command(command)
    return command
end

---orientation
---@param direction number Indicates the direction
---@param turn_time number Turning time
function M:set_facing(direction, turn_time)
    self.handle:api_set_face_angle(Fix32(direction), math.floor(turn_time * 1000))
end

---Set name
---@param name string Name
function M:set_name(name)
    self.handle:api_set_name(name)
end

---Set the name display mode
---@ param show_type clicli. Const. BarNameShowType name display mode
function M:set_name_show_type(show_type)
    self.handle:api_set_bar_name_show_type(clicli.const.BarNameShowType[show_type] or show_type)
end

---Set description
---@param description string Description
function M:set_description(description)
    self.handle:api_set_str_attr("desc", description)
end

---Set attribute
---@param attr_name string | clicli.Const.UnitAttr attribute name
---@param value number Attribute value
---@param attr_type? String | clicli. Const. UnitAttrType attribute types, the default value is "base"
function M:set_attr(attr_name, value, attr_type)
    attr_name = clicli.const.UnitAttr[attr_name] or attr_name
    if attr_name == 'main' then
        attr_name = self:get_main_attr()
        if not attr_name then
            error('The primary attribute of this unit is null')
        end
    end
    if attr_name == 'hp_cur' then
        self:set_hp(value)
        return
    end
    if attr_name == 'mp_cur' then
        self:set_mp(value)
        return
    end
    if attr_type == nil then
        attr_type = 'Basics'
    end
    self.handle:api_set_attr_by_attr_element(clicli.const.UnitAttr[attr_name] or attr_name, Fix32(value), clicli.const.UnitAttrType[attr_type] or attr_type)
end

---Add attribute
---@param attr_name string | clicli.Const.UnitAttr attribute name
---@param value number Attribute value
---@param attr_type? String | clicli. Const. UnitAttrType attribute types, defaults to "gain"
function M:add_attr(attr_name, value, attr_type)
    attr_name = clicli.const.UnitAttr[attr_name] or attr_name
    if attr_name == 'main' then
        attr_name = self:get_main_attr()
        if not attr_name then
            error('The primary attribute of this unit is null')
        end
    end
    if attr_name == 'hp_cur' then
        self:add_hp(value)
        return
    end
    if attr_name == 'mp_cur' then
        self:add_mp(value)
        return
    end
    if attr_type == nil then
        attr_type = 'gain'
    end
    self.handle:api_add_attr_by_attr_element(attr_name, Fix32(value), clicli.const.UnitAttrType[attr_type] or attr_type)
end

---Add attribute
---@param attr_name string | clicli.Const.UnitAttr attribute name
---@param value number Attribute value
---@ param attr_type string | clicli. Const. UnitAttrType attribute type
---@return GCNode
function M:add_attr_gc(attr_name, value, attr_type)
    self:add_attr(attr_name, value, attr_type)
    return New 'GCNode' (function ()
        self:add_attr(attr_name, - value, attr_type)
    end)
end

---Set level
---@param level integer Specifies the level
function M:set_level(level)
    self.handle:api_set_level(level)
end

---Increase level
---@param level integer Specifies the level
function M:add_level(level)
    self.handle:api_add_level(level)
end

---Setup experience
---@param exp number Experience
function M:set_exp(exp)
    self.handle:api_set_exp(Fix32(exp))
end

---Increase experience
---@param exp number Experience
function M:add_exp(exp)
    self.handle:api_add_exp(Fix32(exp))
end

---Set the current health
---@param hp number Current health
function M:set_hp(hp)
    self.handle:api_set_attr("hp_cur", Fix32(hp))
end

---Increases current health
---@param hp number Current health
function M:add_hp(hp)
    self.handle:api_add_attr_base("hp_cur", Fix32(hp))
end

---Sets the current mana value
---@param mp number Current mana value
function M:set_mp(mp)
    self.handle:api_set_attr("mp_cur", Fix32(mp))
end

---Increases current mana
---@param mp number Current mana value
function M:add_mp(mp)
    self.handle:api_add_attr_base("mp_cur", Fix32(mp))
end

---Set skill points
---@param skill_point integer Specifies the skill point
function M:set_ability_point(skill_point)
    self.handle:api_set_ability_point(skill_point)
end

---Increase skill points
---@param skill_point integer Specifies the skill point
function M:add_ability_point(skill_point)
    self.handle:api_add_ability_point(skill_point)
end

---Change players
---@param player Belongs to the Player
function M:change_owner(player)
    GameAPI.change_unit_role(self.handle, player.handle)
end

---Set altitude
---@param height number Height
---@param trans_time number Transition time
function M:set_height(height, trans_time)
    self.handle:api_raise_height(Fix32(height), Fix32(trans_time))
end

---Set life cycle
---@param time number Indicates the life cycle
function M:set_life_cycle(time)
    self.handle:api_set_life_cycle(time)
end

---The life cycle is suspended
---@param is_stop boolean Life cycle pause status
function M:pause_life_cycle(is_stop)
    self.handle:api_pause_life_cycle(is_stop)
end

---Set an alert
---@param range number Indicates the range
function M:set_alert_range(range)
    self.handle:api_set_unit_alarm_range(range)
end

---Set a de-alert zone
---@param range number Cancel the alert
function M:set_cancel_alert_range(range)
    self.handle:api_set_unit_cancel_alarm_range(range)
end

---Set the number of slots for the backpack bar
---@param number integer Specifies the number of slots
function M:set_pkg_cnt(number)
    self.handle:api_set_unit_pkg_cnt(number)
end

---Sets the number of slots in the inventory
---@param number integer Specifies the number of slots
function M:set_bar_cnt(number)
    self.handle:api_set_unit_bar_cnt(number)
end

---Set the default unit behavior
---@param behavior py.UnitBehavior Unit behavior
function M:set_behavior(behavior)
    self.handle:api_set_default_switch_behavior(behavior)
end

--******************************************
---Set attribute growth
---@param unit_key py.UnitKey Unit id
---@param attr_name string Attribute name
---@param value number Attribute growth
function M.set_attr_growth(unit_key, attr_name, value)
    GameAPI.api_set_attr_growth(unit_key, attr_name, Fix32(value))
end

---Set the XP bonus for being killed
---@param exp number Experience
function M:set_reward_exp(exp)
    self.handle:api_set_unit_reward_exp(Fix32(exp))
end

---Set the player stat bonus for being killed
---@param player_attr_name py.RoleResKey attribute name
---@param value number Attribute reward
function M:set_reward_res(player_attr_name, value)
    self.handle:api_set_unit_reward_res(player_attr_name, Fix32(value))
end

---Setting attack type
---@param attack_type integer Specifies the attack type
function M:set_attack_type(attack_type)
    self.handle:api_set_attack_type(attack_type)
end

---Set the armor type
---@param armor_type integer Specifies the type of the armor
function M:set_armor_type(armor_type)
    self.handle:api_set_armor_type(armor_type)
end

--************************ Shadow optimization
---Open shadow
---@param red number Red
---@param green number Green
---@param blue number Blue
---@param alpha number Transparency
---@param interval number Indicates the interval
---@param duration number Indicates the duration
---@param start_time number Start time
---@param end_time number End time
---@param is_origin_martial boolean Uses a native material
function M:start_ghost(red, green, blue, alpha, interval, duration, start_time, end_time, is_origin_martial)
    self.handle:api_start_ghost(
        Fix32(red),
        Fix32(green),
        Fix32(blue),
        Fix32(alpha),
        Fix32(interval),
        Fix32(duration),
        Fix32(start_time),
        Fix32(end_time),
        is_origin_martial
    )
end

---Close shadow
function M:stop_ghost()
    self.handle:api_stop_ghost()
end

---Set the shadow color
---@param red number Green
---@param green number Green
---@param blue number Blue
---@param alpha number Transparency
function M:set_ghost_color(red, green, blue, alpha)
    self.handle:api_set_ghost_color(Fix32(red), Fix32(green), Fix32(blue), Fix32(alpha))
end

---Set the shadow time
---@param interval number Indicates the interval
---@param duration number Indicates the duration
---@param start_time number Start time
---@param end_time number End time
function M:set_afterimage_time(interval, duration, start_time, end_time)
    self.handle:api_set_ghost_time(Fix32(interval), Fix32(duration), Fix32(start_time), Fix32(end_time))
end

---Set the unit profile picture
---@param img_id py.Texture Unit profile picture
function M:set_icon(img_id)
    self.handle:api_set_unit_icon(img_id)
end

---Set the blood bar style
---@param bar_type integer Specifies the blood bar style
function M:set_blood_bar_type(bar_type)
    self.handle:api_set_blood_bar_type(bar_type)
end

---Set the blood bar text
---@param node_name string # Blood stripe naming
---@param text string # text
---@param role? Player Visible Player
---@param font? string # typeface
function M:set_blood_bar_text(node_name, text, role, font)
    GameAPI.set_billboard_text(self.handle, node_name, text, role and role.handle or nil, font)
end

---Set the blood bar progress
---@param node_name string # Blood stripe naming
---@param progress number # schedule
---@param role? Player Visible Player
---@param transition_time? number # Transition time
function M:set_billboard_progress(node_name, progress, role, transition_time)
    GameAPI.set_billboard_progress(self.handle, node_name, progress, role and role.handle or nil, transition_time or 0)
end

---Set the blood bar display mode
---@param bar_show_type integer Specifies the blood bar display mode
function M:set_health_bar_display(bar_show_type)
    self.handle:api_set_blood_bar_show_type(bar_show_type)
end

--*************** Merge one with the enemy
---Set the unit minimap avatar
---@param img_id py.Texture Unit map profile picture
function M:set_minimap_icon(img_id)
    self.handle:api_set_mini_map_icon(img_id)
end

---Set enemy unit minimap avatars
---@param img_id py.Texture Enemy unit minimap avatar
function M:set_enemy_minimap_icon(img_id)
    self.handle:api_set_enemy_mini_map_icon(img_id)
end

--Sets the visibility of the unit selection box
---@param bool boolean # Boolean value
function M:set_select_effect_visible(bool)
    self.handle:api_set_unit_select_effect_visible(bool)
end

---Set model scaling
---@param scale number Model scaling
function M:set_scale(scale)
    self.handle:api_set_scale(scale)
end

---Set unit triaxial scaling
---@param sx number X axis scaling
---@param sy number Y-axis scaling
---@param sz number Z-axis scaling
function M:set_unit_scale(sx, sy, sz)
    self.handle:api_set_unit_scale(sx, sy, sz)
end

---Set unit stroke on
---@param bool boolean # Boolean value
function M:set_outline_visible(bool)
    self.handle:set_unit_outlined_enable(bool)
end

---Sets the unit stroke color
---@param color_r number # R
---@param color_g number # G
---@param color_b number # B
function M:set_outlined_color(color_r, color_g, color_b)
    self.handle:set_unit_outlined_color(color_r, color_g, color_b)
end

---Set turn speed
---@param speed number Turn speed
function M:set_turning_speed(speed)
    self.handle:api_set_turn_speed(Fix32(speed))
end

---Replacement model
---@param model_id py.ModelKey Model id
function M:replace_model(model_id)
    self.handle:api_replace_model(model_id)
end

---Cancel model replacement
---@param model_id py.ModelKey Model id
function M:cancel_replace_model(model_id)
    self.handle:api_cancel_replace_model(model_id)
end

--********************** What is this
---Sets whether to be translucent when invisible
---@param is_visible boolean Specifies whether it is translucent
function M:set_transparent_when_invisible(is_visible)
    self.handle:api_set_transparent_when_invisible(is_visible)
end

---Set whether to retrieve the body after it disappears
---@param is_recycle boolean Specifies whether to recycle
function M:set_recycle_on_remove(is_recycle)
    self.handle:api_set_recycle_on_remove(is_recycle)
end

---Set perspective
---@param is_open boolean Specifies whether to view
function M:set_Xray_is_open(is_open)
    self.handle:api_set_Xray_is_open(is_open)
end

---Unit addition technology
---@param tech_id py.TechKey Technology id
function M:add_tech(tech_id)
    self.handle:api_add_tech(tech_id)
end

---Unit deletion technology
---@param tech_id py.TechKey Technology id
function M:remove_tech(tech_id)
    self.handle:api_remove_tech(tech_id)
end

---Research technology
---@param tech_id py.TechKey Technology id
function M:research_tech(tech_id)
    self.handle:api_upgrade_tech(tech_id)
end

---Access to all the technology that the unit can research
---@return py.TechKey[]
function M:get_tech_list()
    local lua_table = {}
    local py_list = self.handle:api_get_tech_list()
    if not py_list then
        return lua_table
    end
    for i = 0, python_len(py_list) - 1 do
        local tech = python_index(py_list, i)
        table.insert(lua_table, tech)
    end
    return lua_table
end

---Get all technologies affected by the unit
---@return py.TechKey[]
function M:get_affect_techs()
    local lua_table = {}
    local py_list = self.handle:api_get_affect_techs()
    if not py_list then
        return lua_table
    end
    for i = 0, python_len(py_list) - 1 do
        local tech = python_index(py_list, i)
        table.insert(lua_table, tech)
    end
    return lua_table
end


--Set the daytime field of view
---@param value number
function M:set_day_vision(value)
    self.handle:api_set_unit_day_vision(value)
end

--Set your view at night
---@param value number
function M:set_night_value(value)
    self.handle:api_set_unit_night_vision(value)
end

--******************* Playback animations are unified globally
---Play animation
---@param anim_name string Animation name
---@param speed? number speed
---@param start_time? number Start time
---@param end_time? number End time (Default: -1 indicates the last playback)
---@param is_loop? boolean loop or not
---@param is_back_normal? boolean Whether to return the default state
---@param transition_time? number transition time
---@param force_play? boolean # Even in death
function M:play_animation(anim_name, speed, start_time, end_time, is_loop, is_back_normal, transition_time, force_play)
    self.handle:api_play_animation(
        anim_name,
        speed or 1,
        start_time or 0,
        end_time or -1,
        is_loop or false,
        is_back_normal or false,
        transition_time or -1,
        force_play or false
    )
end

---Stop animation
---@param anim_name string Animation name
function M:stop_animation(anim_name)
    self.handle:api_stop_animation(anim_name)
end

---Replacement animation
---@param replace_anim_name string Animation name
---@param bereplace_anim_name string Animation name
function M:change_animation(replace_anim_name, bereplace_anim_name)
    self.handle:api_change_animation(replace_anim_name, bereplace_anim_name)
end

---Unanimate replace
---@param replace_anim_name string Animation name
---@param bereplace_anim_name string Animation name
function M:cancel_change_animation(replace_anim_name, bereplace_anim_name)
    self.handle:api_cancel_change_animation(replace_anim_name, bereplace_anim_name)
end

---Reset animation replacement
---@param anim_name string Animation name
function M:clear_change_animation(anim_name)
    self.handle:api_clear_change_animation(anim_name)
end

---Stop the animation that is currently playing
function M:stop_cur_animation()
    self.handle:api_stop_cur_animation()
end

---Set the animation playback rate
---@param speed number Speed
function M:set_animation_speed(speed)
    self.handle:api_set_animation_speed(Fix32(speed))
end

---Set the walking animation benchmark speed
---@param speed number Speed
function M:set_base_speed(speed)
    self.handle:api_set_base_speed(Fix32(speed))
end

---Add merchantable items
---@param tag_name py.TabName Label name
---@param item_key py.ItemKey Item id
function M:add_goods(tag_name, item_key)
    self.handle:api_add_shop_item(tag_name, item_key)
end

---Remove merchantable goods
---@param item_name py.TabName Name of the item
---@param item_key py.ItemKey Item id
function M:remove_goods(item_name, item_key)
    self.handle:api_remove_shop_item(item_name, item_key)
end

---Set inventory
---@param tag_name py.TabName Label name
---@param item_key py.ItemKey Item id
---@param number integer Item inventory
function M:set_goods_stack(tag_name, item_key, number)
    self.handle:api_set_shop_item_stock(tag_name, item_key, number)
end

---Units sell items to shops
---@param unit Unit Unit
---@param item Item item
function M:sell(unit, item)
    self.handle:api_sell_item(unit.handle, item.handle)
end

---Buy goods from the store
---@param unit Unit Unit
---@param tag_num py.TabIdx TAB id
---@param item_key py.ItemKey Item id
function M:buy(unit, tag_num, item_key)
    self.handle:api_buy_item_with_tab_name(unit.handle, tag_num, item_key)
end

---@class Buff.AddData
---@field key py.ModifierKey Magic Effect id
---@field source? Unit Source unit
---@field ability? Ability related skills
---@field time? number duration
---@field pulse? number Heartbeat cycle
---@field stacks? integer Number of layers
---@field data? table User-defined data

---Adds magic effects to units
---@param data Buff.AddData
---@return Buff?
function M:add_buff(data)
    local py_buff = self.handle:api_add_modifier(
        data.key,
        data.source and data.source.handle or nil,
        data.ability and data.ability.handle or nil,
        Fix32(data.time or -1),
        Fix32(data.pulse or 0.0),
        data.stacks or 1,
        data.data or nil
    )
    if not py_buff then
        return nil
    end
    return clicli.buff.get_by_handle(py_buff)
end

---Removes all magic effects with the specified id
---@param buff_key py.ModifierKey affects type magic effects
function M:remove_buffs_by_key(buff_key)
    self.handle:api_remove_modifier_type(buff_key)
end

---Removes all magic effects of the specified type
---@param effect_type clicli.Const.EffectType affects the magic effects of a type
function M:remove_buffs_by_effect_type(effect_type)
    self.handle:api_delete_all_modifiers_by_effect_type(effect_type)
end

---Gets the magic effect for the unit specified id
---@param buff_key py.ModifierKey Magic Effect id
---@param index? integer Specifies the number
---@return Buff? # Unit specifies the type of magic effect
function M:find_buff(buff_key, index)
    local py_modifier = self.handle:api_get_modifier(index or -1, buff_key)
    if not py_modifier then
        return nil
    end
    return clicli.buff.get_by_handle(py_modifier)
end

---Get inventory intervals for store items
---@param page py.TabIdx TAB id
---@param index integer Specifies the serial number
---@return number Default cd interval
function M:get_goods_cd(page, index)
    return clicli.helper.tonumber(self.handle:api_get_shop_item_default_cd(page, index)) or 0.0
end

---Gets the remaining recovery time for store items
---@param page py.TabIdx TAB id
---@param index integer Specifies the serial number
---@return number recovery_time Remaining recovery time
function M:get_goods_remaining_cd(page, index)
    return clicli.helper.tonumber(self.handle:api_get_shop_item_residual_cd(page, index)) or 0.0
end

---Get all store items
---@param page py.TabIdx TAB
---@return py.ItemKey[]
function M:get_shop_item_list(page)
    local lua_table = {}
    local py_list = self.handle:api_get_shop_item_list(page)
    if not py_list then
        return lua_table
    end
    for i = 0, python_len(py_list) - 1 do
        local item_key = python_index(py_list, i)
        lua_table[#lua_table+1] = item_key
    end
    return lua_table
end

---Gets the current health
---@return number current_unit_hp Current life value
function M:get_hp()
    return clicli.helper.tonumber(self.handle:api_get_float_attr("hp_cur")) or 0.0
end

---Gets the current mana
---@return number current_mp Current magic value
function M:get_mp()
    return clicli.helper.tonumber(self.handle:api_get_float_attr("mp_cur")) or 0
end

---Get final attribute
---@param attr_name string | clicli.Const.UnitAttr attribute name
---@return number
function M:get_final_attr(attr_name)
    return clicli.helper.tonumber(self.handle:api_get_float_attr(clicli.const.UnitAttr[attr_name] or attr_name)) or 0.0
end

---Get Properties (extra)
---@param attr_name string | clicli.Const.UnitAttr attribute name
---@return number
function M:get_attr_other(attr_name)
    return clicli.helper.tonumber(self.handle:api_get_attr_other(clicli.const.UnitAttr[attr_name] or attr_name)) or 0.0
end

---Get a single attribute (base)
---@param attr_name string | clicli.Const.UnitAttr
---@return number attr_base Attribute of the unit base attribute type
function M:get_attr_base(attr_name)
    return clicli.helper.tonumber(self.handle:api_get_attr_base(clicli.const.UnitAttr[attr_name] or attr_name)) or 0.0
end

---Get properties (Base bonus)
---@param attr_name string | clicli.Const.UnitAttr
---@return number
function M:get_attr_base_ratio(attr_name)
    return clicli.helper.tonumber(self.handle:api_get_attr_base_ratio(clicli.const.UnitAttr[attr_name] or attr_name)) or 0.0
end

---Get properties (gain)
---@param attr_name string | clicli.Const.UnitAttr
---@return number
function M:get_attr_bonus(attr_name)
    return clicli.helper.tonumber(self.handle:api_get_attr_bonus(clicli.const.UnitAttr[attr_name] or attr_name)) or 0.0
end

---Get properties (final bonus)
---@param attr_name string | clicli.Const.UnitAttr
---@return number
function M:get_attr_all_ratio(attr_name)
    return clicli.helper.tonumber(self.handle:api_get_attr_all_ratio(clicli.const.UnitAttr[attr_name] or attr_name)) or 0.0
end

---Get properties (Gain bonus)
---@param attr_name string | clicli.Const.UnitAttr
---@return number
function M:get_attr_bonus_ratio(attr_name)
    return clicli.helper.tonumber(self.handle:api_get_attr_bonus_ratio(clicli.const.UnitAttr[attr_name] or attr_name)) or 0.0
end

---Get the property (default is the actual property)
---@param attr_name clicli.Const.UnitAttr
---@param attr_type? 'real' | 'extra' | clicli. Const. UnitAttrType
---@return number
function M:get_attr(attr_name, attr_type)
    if attr_name == 'Primary attribute' then
        attr_name = self:get_main_attr()
        if not attr_name then
            error('The primary attribute of this unit is null')
        end
    end
    if attr_type == 'actual'
    or attr_type == nil then
        return self:get_final_attr(attr_name)
    end
    if attr_type == 'Additional' then
        return self:get_attr_other(attr_name)
    end
    if attr_type == 'Basics' then
        return self:get_attr_base(attr_name)
    end
    if attr_type == 'Base markup' then
        return self:get_attr_base_ratio(attr_name)
    end
    if attr_type == 'gain' then
        return self:get_attr_bonus(attr_name)
    end
    if attr_type == 'Gain addition' then
        return self:get_attr_bonus_ratio(attr_name)
    end
    if attr_type == 'Final markup'
    or attr_type == 'Gross addition' then
        return self:get_attr_all_ratio(attr_name)
    end
    error('Unknown attribute types:' .. tostring(attr_type))
end

---Gets unit attribute growth
---@param unit_key py.UnitKey
---@param attr_name string | clicli.Const.UnitAttr
---@return number unit_attribute_growth Unit attribute growth
function M.get_attr_growth_by_key(unit_key, attr_name)
    return clicli.helper.tonumber(GameAPI.api_get_attr_growth(unit_key, clicli.const.UnitAttr[attr_name] or attr_name)) or 0.0
end

---Gets the remaining life cycle of a unit
---@return number
function M:get_life_cycle()
    return clicli.helper.tonumber(self.handle:api_get_life_cycle()) or 0.0
end

---Gain unit altitude
---@return number height Indicates the height of the flight
function M:get_height()
    return clicli.helper.tonumber(self.handle:api_get_height()) or 0.0
end

---Gets unit turn speed
---@return number turning_speed Unit Turning speed
function M:get_turning_speed()
    return clicli.helper.tonumber(self.handle:api_get_turn_speed()) or 0.0
end

---Get a unit alert
---@return number alert_range Unit alert range
function M:get_alert_range()
    return clicli.helper.tonumber(self.handle:api_get_unit_alarm_range()) or 0.0
end

---Get the range of units to de-alert
---@return number cancel_alert_range Cancel_alert_range of a unit
function M:get_cancel_alert_range()
    return clicli.helper.tonumber(self.handle:api_get_unit_cancel_alarm_range()) or 0.0
end

---Gets the unit collision radius
---@return number collision_radius Unit collision radius
function M:get_collision_radius()
    return clicli.helper.tonumber(self.handle:api_get_unit_collision_radius()) or 0.0
end

---Set the unit collision radius
---@deprecated
---@param radius number
function M:set_collision_radius(radius)
    ---@diagnostic disable-next-line: undefined-field
    self.handle:api_set_unit_collision_radius(radius)
end

---Gets the player the unit belongs to
---@return Player player The player to which the unit belongs
function M:get_owner()
    local py_player = self.handle:api_get_role()
    if not py_player then
        return clicli.player(31)
    end
    return clicli.player.get_by_handle(py_player)
end

---Get resources spent building this unit (Player stats)
---@param unit_id py.UnitKey Unit type
---@param player_attr_name py.RoleResKey Player attribute name
---@return integer player_attr Player attributes of the unit killed
function M:get_unit_resource_cost(unit_id, player_attr_name)
    return GameAPI.get_role_attr_by_unit_type(unit_id, player_attr_name)
end

---Get resources available to kill (Player stats)
---@param player_attr_name py.RoleResKey Player attribute name
---@return number player_attr unit killed player attributes
function M:get_reward_res(player_attr_name)
    return clicli.helper.tonumber(self.handle:api_get_unit_reward_res(player_attr_name)) or 0.0
end

---Get unit scaling
---@return number model_scale Unit scaling
function M:get_scale()
    return clicli.helper.tonumber(self.handle:api_get_model_scale()) or 0.0
end

---Gets unit selection circle scaling
---@return number range_scale Select circle scaling
function M:get_unit_selection_range_scale()
    return clicli.helper.tonumber(GameAPI.get_select_circle_scale(self.handle)) or 0.0
end

---Gets the X-axis scaling of the unit
---@return number xaxis X axis scaling
function M:get_x_scale()
    return self.handle:api_get_x_scale() or 0
end

---Gets the z-axis scaling of the unit
---@return number zaxis Scaling the Z axis
function M:get_z_scale()
    return self.handle:api_get_y_scale() or 0
end

---Gets the Y-axis scaling of the unit
---@return number yaxis Scaling the Y axis
function M:get_y_scale()
    return self.handle:api_get_z_scale() or 0
end

---Get the store's purchase range
---@return number purchase_range Purchase range
function M:get_shop_range()
    return clicli.helper.tonumber(self.handle:api_get_shop_range()) or 0.0
end

---Get unit level
---@return integer unit_level Unit level
function M:get_level()
    return self.handle:api_get_level() or 0
end

---Gets the unit type ID of the unit
---@returnpy. UnitType unit_type Unit type ID
function M:get_type()
    return self.handle:api_get_type() or 0
end

---Gets the ID of the unit type
---@returnpy. UnitKey type_id Specifies the ID of the unit type
function M:get_key()
    return self.handle:api_get_key() or 0
end

---Gets the unit's current experience
---@return integer exp Indicates the current experience value
function M:get_exp()
    return self.handle:api_get_exp() or 0
end

---Gain experience required for the current upgrade of your organization
---@return number exp Unit Experience required for the current upgrade
function M:get_upgrade_exp()
    return self.handle:api_get_upgrade_exp() or 0
end

---Gain the number of skill points the hero has
---@return integer hero_ability_point_number Number of hero skill points
function M:get_ability_point()
    return self.handle:api_get_ability_point() or 0
end

---Gets the number of slots in the unit backpack field
---@return integer slot_number Number of slots in the unit knapsack column
function M:get_pkg_cnt()
    return self.handle:api_get_unit_pkg_cnt() or 0
end

---Gets the number of slots in the unit inventory
---@return integer slot_number Number of slots in the unit inventory
function M:get_bar_cnt()
    return self.handle:api_get_unit_bar_cnt() or 0
end

---Gets the number of item types owned by a unit
---@param item_key py.ItemKey id of the item type
---@return integer item_type_number Specifies the number of item types
function M:get_item_type_number_of_unit(item_key)
    return self.handle:api_get_num_of_item_type(item_key) or 0
end

---Gain unit kill experience
---@return integer exp kill experience per unit
function M:get_exp_reward()
    return self.handle:api_get_unit_reward_exp() or 0
end

---Gets the shield value for the unit's specified shield type
---@param shield_type integer Specifies the shield type
---@return integer shield_value Specifies the shield value of the shield type
function M:get_shield(shield_type)
    return self.handle:api_get_unit_shield_value(shield_type) or 0
end

---Gets the number of store tabs
---@return number tab_number Number of tabs
function M:get_shop_tab_number()
    return self.handle:api_get_shop_tab_cnt() or 0
end

---Get the store's inventory of items
---@param tag_index py.TabIdx TAB
---@param item_key py.ItemKey Item type
---@return integer item_stock Item inventory
function M:get_goods_stack(tag_index, item_key)
    return self.handle:api_get_shop_item_stock(tag_index, item_key) or 0
end

---Get unit name
---@return string unit_name Unit name
function M:get_name()
    if not self.handle.api_get_name then
        return 'Invalid unit'
    end
    return self.handle:api_get_name() or ''
end

---Gets a description of the unit
---@return string unit_description Unit description
function M:get_description()
    return self.handle:api_get_str_attr("desc") or ''
end

---Gets the name of the unit type
---@param unit_key py.UnitKey
---@return string type_name Specifies the name of the unit type
function M.get_name_by_key(unit_key)
    return GameAPI.get_unit_name_by_type(unit_key)
end

---Gets a description of the unit type
---@param unit_key py.UnitKey Unit type
---@return string des Description of the unit type
function M.get_description_by_key(unit_key)
    return GameAPI.get_unit_desc_by_type(unit_key)
end

---Get the page signature for the store
---@param tag_index py.TabIdx TAB
---@return string tab_name page signature
function M:get_shop_tab_name(tag_index)
    return self.handle:api_get_shop_tab_name(tag_index) or ''
end

---Acquisition unit classification
---@returnpy. UnitType unit_subtype Unit classification
function M:get_subtype()
    return self.handle:api_get_type() or 0
end

---Be a hero or not
---@returr boolean
function M:is_hero()
    return self.handle:api_get_type() == clicli.const.UnitCategory['HERO']
end

--Get the unit's avatar
---@return py.Texture image Indicates the unit profile picture
function M:get_icon()
    return GameAPI.get_icon_id_by_unit_type(self:get_key()) --[[@as py.Texture]]
end

---Building or not
---@return boolean
function M:is_building()
    return self.handle:api_get_type() == clicli.const.UnitCategory['BUILDING']
end

---Gets the avatar of the unit type
---@param unit_key py.UnitKey Unit type
---@return py.Texture image The profile picture of the unit type
function M.get_icon_by_key(unit_key)
    return GameAPI.get_icon_id_by_unit_type(unit_key) --[[@as py.Texture]]
end

---Last created unit
---@return Unit? unit The last unit created
function M.get_last_created_unit()
    local py_unit = GameAPI.get_last_created_unit()
    if not py_unit then
        return nil
    end
    return clicli.unit.get_by_handle(py_unit)
end

---Get the owner of the unit (unit)
---@return Unit? unit Indicates the owner of the unit
function M:get_parent_unit()
    local py_unit = self.handle:api_get_parent_unit()
    if not py_unit then
        return nil
    end
    return clicli.unit.get_by_handle(py_unit)
end

---The summoner of the vision
---@return Unit? unit Summoner of the vision
function M:get_illusion_owner()
    local py_unit = GameAPI.get_illusion_caller_unit(self.handle)
    if not py_unit then
        return nil
    end
    return clicli.unit.get_by_handle(py_unit)
end

---Gets the orientation of the unit
---@return number angle Orientation of the unit
function M:get_facing()
    return clicli.helper.tonumber(self.handle:get_face_angle()) or 0.0
end

---Get armor type
---@return integer DAMAGE_ARMOR_TYPE Type of the armor
function M:get_armor_type()
    return self.handle:api_get_armor_type() or 0
end

---Get attack type
---@return integer DAMAGE_ATTACK_TYPE Attack type
function M:get_attack_type()
    return self.handle:api_get_atk_type() or 0
end

---Get the store's item id
---@param tag_index py.TabIdx TAB
---@param item_index integer Specifies the serial number
---@returnpy.ItemKey item Type of the item
function M:get_goods_key(tag_index, item_index)
    return self.handle:api_get_shop_tab_item_type(tag_index, item_index) or 0
end

---Gets the current model of the unit
---@return py.ModelKey model Current model
function M:get_model()
    return self.handle:api_get_model() or 0
end

---Gets the original model of the unit
---@return py.ModelKey model Original model
function M:get_source_model()
    return self.handle:api_get_source_model() or 0
end

---Get the point where the unit resides
---@return Point unit_point Indicates the point where the unit resides
function M:get_point()
    local py_point = self.handle:api_get_position()
    if not py_point then
        return clicli.point(6553600, 6553600)
    end
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    return clicli.point.get_by_handle(py_point)
end

---Gets the nearest passable point of the unit
---@return Point point Indicates the nearest passable point of the unit
function M:get_nearest_valid_point()
    local py_point = self.handle:api_find_nearest_valid_position()
    if not py_point then
        return clicli.point(6553600, 6553600)
    end
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    return clicli.point.get_by_handle(py_point)
end

---Get units for the team
---@return py.Camp team The team that gets units
function M:get_team()
    return self.handle:api_get_camp() or 0--[[@as py.Camp]]
end

---Tagged or not
---@param tag_name string Tag
---@return boolean has_tag Specifies a tag
function M:has_tag(tag_name)
    return GlobalAPI.has_tag(self.handle, tag_name)
end

---Survive or not
---@return boolean Specifies whether alive
function M:is_alive()
    return GlobalAPI.is_unit_alive(self.handle)
end

---Visible or not
---@param target_unit Unit Target unit
---@return boolean visibility Whether the target is visible
function M:can_visible(target_unit)
    --TODO see question 5
    ---@diagnostic disable-next-line: param-type-mismatch
    return GameAPI.get_visibility_of_unit(self.handle, target_unit.handle)
end

---Are you moving?
---@return boolean is_moving is moving
function M:is_moving()
    return self.handle:api_is_moving() or false
end

---Whether it is near another unit or point
---@param other Unit|Point. @param other unit | point
---@param range number Indicates the range
---@return boolean in_radius near the unit
function M:is_in_radius(other, range)
    if other.type == 'unit' then
        ---@cast other Unit
        return self.handle:api_is_in_range(other.handle, range) or false
    else
        ---@cast other Point
        --TODO see question 2
        ---@diagnostic disable-next-line: param-type-mismatch
        return self.handle:api_is_point_in_range(other.handle, range) or false
    end
end

---Shop or not
---@return boolean is_shop is a store
function M:is_shop()
    return self.handle:api_is_shop() or false
end

---Phantom unit or not
---@return boolean illusion is the phantom unit
function M:is_illusion()
    return GameAPI.is_unit_illusion(self.handle)
end

---Whether it is in the unit group
---@param group UnitGroup Unit group
---@return boolean in_group In the unit group
function M:is_in_group(group)
    return GameAPI.judge_unit_in_group(self.handle, group.handle)
end

---Whether in combat mode
---@return boolean in_battle in the battle state
function M:is_in_battle()
    return self.handle:api_is_in_battle_state() or false
end

---Whether the specified status exists
--> Use the has_state method instead
---@deprecated
---@param state_name integer Indicates the status
---@return boolean has_buff_status Specifies the status
function M:has_buff_status(state_name)
    return self.handle:api_has_state(state_name) or false
end

---Whether the skill with the specified id exists
---@param ability_key py.AbilityKey Skill type
---@return boolean has_ability_type Specifies the type of skill
function M:has_ability_by_key(ability_key)
    return self.handle:api_check_has_ability_type(ability_key) or false
end

---Whether there is a specified item
---@param item Item item
---@return boolean has_item Has an item
function M:has_item(item)
    return self.handle:api_has_item(item.handle) or false
end

---Whether there are items of the specified type
---@param item_key py.ItemKey Item type
---@return boolean has_item_name has an item of the specified type
function M:has_item_by_key(item_key)
    return self.handle:api_has_item_key(item_key) or false
end

---Whether there is a magic effect with a specified id
---@param buff_key py.ModifierKey Magic Effect id
---@return boolean has_modifier Has a magic effect
function M:has_buff_by_key(buff_key)
    return self.handle:api_has_modifier(buff_key) or false
end

---Whether there is a specified type of magic effect
---@param effect_type clicli.Const.EffectType Magic effect type
---@return boolean has_modifier_style Specifies the type of magic effect
function M:has_buff_by_effect_type(effect_type)
    return self.handle:api_has_modifier_type(effect_type) or false
end

---Whether there is a magic effect for the specified label
---@param tag_name string Tag
---@return boolean has_modifier_tag Specifies the magic effect of the tag
function M:unit_has_modifier_tag(tag_name)
    return self.handle:api_has_modifier_with_tag(tag_name) or false
end

---Unit Type Preconditions Whether it passes
---@param player Player
---@param unit_key py.UnitKey Unit type
---@return boolean unit_precondition Whether the precondition condition of the unit type passes
function M.check_precondition_by_key(player, unit_key)
    return GameAPI.check_unit_key_precondition(player.handle, unit_key) or false
end

---Friendly or not
---@param target_unit Unit Target unit
---@return boolean is_enemy indicates a hostile relationship
function M:is_ally(target_unit)
    return GameAPI.is_ally(self.handle, target_unit.handle)
end

---Enemy or not
---@param target_unit Unit Target unit
---@return boolean is_enemy indicates a hostile relationship
function M:is_enemy(target_unit)
    return GameAPI.is_enemy(self.handle, target_unit.handle)
end

---Can transmit to the point
---@param point Point
---@return boolean can_teleport Whether to send to a point
function M:can_blink_to(point)
    return self.handle:api_can_teleport_to(point.handle) or false
end

---Whether it collided with the point
---@param point Point
---@param range number Indicates the range
---@return boolean Whether can_collide collides with a point
function M:is_collided_with_point(point, range)
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    return GameAPI.unit_can_collide_with_point(self.handle, point.handle, range)
end

---Whether it is routable
---@param start_point Indicates the start Point
---@param end_point Indicates the end Point
---@return boolean Indicates whether path finding is possible for is_reach
function M:can_walk_to(start_point, end_point)
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    return GameAPI.can_point_reach_point(self.handle, start_point.handle, end_point.handle)
end

---Whether the specified collision type exists
---@ param collision_layer integer | clicli. Const. CollisionLayers collision types
---@return boolean # Whether the specified collision type exists
function M:has_move_collision(collision_layer)
    return self.handle:api_get_move_collision(clicli.const.CollisionLayers[collision_layer] or collision_layer) or false
end

---Sets whether the unit counts a collision type
---@param collision_layer integer | clicli.Const.CollisionLayers # Collision mask
---@param enable boolean # On state
function M:set_move_collision(collision_layer, enable)
    ---@diagnostic disable-next-line: undefined-field
    self.handle:api_set_move_collision(clicli.const.CollisionLayers[collision_layer] or collision_layer, enable)
end

--Get a player
---@return Player
function M:get_owner_player()
    local role_id = self.handle:api_get_role_id()
    if not role_id then
        return clicli.player(31)
    end
    return clicli.player.get_by_id(role_id)
end

---Whether the player can purchase items from the store
---@param player Player
---@return boolean
function M:player_shop_check(player)
    return self.handle:api_shop_check_camp(player.handle) or false
end

---Gets the model for the unit type
---@param unit_key py.UnitKey Unit id
---@return py.ModelKey model Model
function M.get_model_by_key(unit_key)
    return GameAPI.api_get_unit_type_model(unit_key)
end

---Gets the classification of the unit type
---@param unit_key py.UnitKey Unit id
---@return integer
function M.get_type_by_id(unit_key)
    return GameAPI.api_get_unit_type_category(unit_key)
end

---Unit attribute to unit attribute name
---@param key string Attribute key
---@return string Attribute name
function M.attr_to_name(key)
    return GameAPI.unit_attr_to_str(key):match("%((.-)%)")
end

---Cause injury
---@class Unit.DamageData
---@field target Unit|Item|Destructible
---@field type clicli.Const.DamageType | integer # You can also pass any number
---@field damage number
---@field ability? Ability # Relevance skill
---@field text_type? clicli.Const.DamageTextType | clicli.Const.FloatTextType # Hop type
---@field text_track? clicli.Const.FloatTextJumpType | integer # Skip trace type
---@field common_attack? boolean # Regarded as a general attack
---@field critical? boolean # Certain critical strike
---@field no_miss? boolean # Sure hit
---@field particle? py.SfxKey # VFX
---@field socket? string # Special effect peg
---@field attack_type? integer # Attack type
---@field pos_socket? string # Target hanging point

---@param data Unit.DamageData
function M:damage(data)
    ---@diagnostic disable-next-line: missing-parameter
    GameAPI.apply_damage(
        self.handle,
        data.ability and data.ability.handle or nil,
        --TODO refer to question 3
        ---@diagnostic disable-next-line: param-type-mismatch
        data.target.handle,
        clicli.const.DamageTypeMap[data.type] or data.type,
        Fix32(data.damage),
        data.text_type ~= nil,
        nil,
        data.common_attack or false,
        data.critical or false,
        data.no_miss or false,
        data.particle or nil,
        data.socket or '',
        ---@diagnostic disable-next-line: param-type-mismatch
        clicli.const.FloatTextType[data.text_type] or data.text_type or 'physics',
        clicli.const.FloatTextJumpType[data.text_track] or data.text_track or 0,
        data.attack_type or 0,
        data.pos_socket or ''
    )
end

---Get unit primary properties (composite properties required)
---@return string
function M:get_main_attr()
    return self.handle:api_get_main_attr() or ''
end

---Set the movement type of the unit to ground
---@param land_limitation? boolean # Land restriction
---@param item_limitation? boolean # Object restriction
---@param water_limitation? boolean # Marine limitation
function M:set_move_channel_land(land_limitation, item_limitation, water_limitation)
    self.handle:set_move_channel_land(land_limitation, item_limitation, water_limitation)
end

---Set the movement type of the unit to air
---@param air_limitation? boolean # Air restriction
function M:set_move_channel_air(air_limitation)
    self.handle:set_move_channel_air(air_limitation)
end

---Gets the unit camp ID
---@return py.CampID
function M:get_camp_id()
    return self.handle:api_get_camp_id() or 0
end

---@param model py.ModelKey # Target model number
---@param material integer # Material id
---@param layer integer # layer id
---@param texture py.Texture # chartlet
function M:change_model_texture(model, material, layer, texture)
    self.handle:change_model_texture(model, material, layer, texture)
end

---@class Unit.TransformationOptions
---@field inherit_composite_attr? boolean # Whether to inherit compound attributes
---@field inherit_unit_attr? boolean # Whether to inherit the unit attribute
---@field inherit_kv? boolean # Whether to inherit kv
---@field inherit_hero_ability? boolean # Whether to inherit hero skills
---@field inherit_common_ability? boolean # Whether to inherit common skills
---@field inherit_passive_ability? boolean # Whether to inherit hidden skills

---shapeshift
---@param unit_key py.UnitKey # Unit type key
---@param options? Unit.TransformationOptions
function M:transformation(unit_key, options)
    self.handle:api_unit_transformation(unit_key
        , options and options.inherit_composite_attr or false
        , options and options.inherit_unit_attr or false
        , options and options.inherit_kv or false
        , options and options.inherit_hero_ability or false
        , options and options.inherit_common_ability or false
        , options and options.inherit_passive_ability or false
    )
end

function M:is_destroyed()
    local yes = self.handle:api_is_destroyed()
    if yes == nil then
        return true
    end
    return yes
end

return M
