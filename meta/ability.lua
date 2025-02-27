--This file is generated by tools/genGameAPI, do not modify it manually.
---@meta

---@class py.Ability
local Ability = {}

--Gets the skill string property
---@param attr py.AbilityStrAttr # Tag name
---@return string? # String attribute
function Ability:api_get_str_attr(attr) end

--Set skill string properties
---@param attr py.AbilityStrAttr # Tag name
---@param value string # String value
function Ability:api_set_str_attr(attr, value) end

--Set skill name
---@param value string # String value
function Ability:api_set_name(value) end

--Acquired skill owner
---@return py.Unit? # Skill holder
function Ability:api_get_owner() end

--Gets the skill owner id
---@return py.UnitID? # Skill owner id
function Ability:api_get_owner_id() end

--Acquire skill types
---@return py.AbilityType? # Skill type
function Ability:api_get_type() end

--Acquire skill types
---@return py.AbilityIndex? # Skill sequence number
function Ability:api_get_ability_index() end

--Get skill serial number
---@return py.AbilitySeq? # Skills Seq
function Ability:api_get_ability_seq() end

--Gets the skill release type
---@return py.AbilityCastType? # Skill release type
function Ability:api_get_ability_cast_type() end

--Gets the globally unique id of a skill
---@return integer? # Unique global id of a skill
function Ability:api_get_ability_global_id() end

--Remove skill
function Ability:api_remove() end

--Gain skill levels
---@return integer? # Skill level
function Ability:api_get_level() end

--Possession or not
---@param tag string # Tag name
---@return boolean? # Whether there is a mark
function Ability:has_tag(tag) end

--Remove a key-value pair
---@param k string # key
function Ability:api_remove_kv(k) end

--Calculation formula type KV
---@param k string # key
---@return py.Fixed? # value
function Ability:api_calc_ability_formula_kv(k) end

--Add timer
---@param time py.Fixed # Timing duration
---@param callback function # Timeout function
function Ability:add_timer(time, callback) end

--Whether the skill object has a goal
---@param runtime_id? integer # runtime_id
---@return boolean? # Whether the skill object has a goal
function Ability:api_has_target(runtime_id) end

--Get skill release location
---@param runtime_id? integer # runtime_id
---@return py.FPoint? # Skill release position
function Ability:api_get_release_position(runtime_id) end

--Get the direction of skill release
---@param runtime_id? integer # runtime_id
---@return py.Fixed? # The direction of skill release
function Ability:api_get_release_direction(runtime_id) end

--Gets the skill real attribute value
---@param attr string # Attribute name
---@return py.Fixed? # Real attribute value
function Ability:api_get_float_attr(attr) end

--Gets the skill integer attribute value
---@param attr string # Attribute name
---@return integer? # Integer attribute value
function Ability:api_get_int_attr(attr) end

--Gets the skill Boolean attribute value
---@param attr string # Attribute name
---@return boolean? # Boolean attribute value
function Ability:api_get_bool_attr(attr) end

--Gets skill release range
---@return py.Fixed? # Release range
function Ability:api_get_ability_cast_range() end

--Set the skill release range
---@param value py.Fixed # Release range
function Ability:api_set_ability_cast_range(value) end

--Set the building orientation of the skill
---@param value py.Fixed # Construction orientation
function Ability:api_set_ability_build_rotate(value) end

--Set the fan indicator radius
---@param value py.Fixed # Indicator radius
---@param is_target? boolean # Whether it is the target size
function Ability:api_set_ability_sector_radius(value, is_target) end

--Set the sector indicator Angle
---@param value py.Fixed # Indicator Angle
---@param is_target? boolean # Whether it is the target size
function Ability:api_set_ability_sector_angle(value, is_target) end

--Set the arrow/multi-segment indicator width
---@param value py.Fixed # Release range
---@param is_target? boolean # Whether it is the target size
function Ability:api_set_ability_arrow_width(value, is_target) end

--Sets the arrow/multi-segment indicator length
---@param value py.Fixed # Release range
---@param is_target? boolean # Whether it is the target size
function Ability:api_set_ability_arrow_length(value, is_target) end

--Set the radius of the circular indicator
---@param value py.Fixed # Release range
---@param is_target? boolean # Whether it is the target size
function Ability:api_set_ability_circle_radius(value, is_target) end

--Set the skill indicator type
---@param pointer_type integer # Indicator type
function Ability:api_set_ability_pointer_type(pointer_type) end

--Gets the skill indicator type
---@return integer? # Indicator type
function Ability:api_get_ability_skill_pointer() end

--Set skill icon
---@param icon_id integer # icon
function Ability:api_set_ability_icon(icon_id) end

--Gets skill player stat cost
---@param attr string # Player attribute name
---@return py.Fixed? # Player attribute cost
function Ability:api_get_ability_player_attr_cost(attr) end

--Set skill player stat cost
---@param attr string # Player attribute name
---@param value py.Fixed # Player attribute cost
function Ability:api_set_ability_player_attr_cost(attr, value) end

--Increased skill player stat cost
---@param attr string # Player attribute name
---@param value py.Fixed # Player attribute cost
function Ability:api_add_ability_player_attr_cost(attr, value) end

--Set skill level
---@param level integer # Skill level
function Ability:api_set_level(level) end

--Learning skill
function Ability:api_learn_ability() end

--Increase skill level
---@param level integer # Skill level
function Ability:api_add_level(level) end

--Incrementally modifies the skill real attribute value
---@param attr string # Attribute name
---@param value py.Fixed # Real attribute value
function Ability:api_add_float_attr(attr, value) end

--Sets the skill real attribute value
---@param attr string # Attribute name
---@param value py.Fixed # Real attribute value
function Ability:api_set_float_attr(attr, value) end

--Incrementally modifies the skill integer attribute value
---@param attr string # Attribute name
---@param value integer # Integer attribute value
function Ability:api_add_int_attr(attr, value) end

--Set the skill integer attribute value
---@param attr string # Attribute name
---@param value integer # Integer attribute value
function Ability:api_set_int_attr(attr, value) end

--Sets the skill Boolean property value
---@param attr string # Attribute name
---@param value boolean # Boolean attribute value
function Ability:api_set_bool_attr(attr, value) end

--Prevents the current ability from casting spells
function Ability:api_break_ability_in_cs() end

--Get the most recent skill upgradable level
---@return integer? # Lv.
function Ability:api_get_ability_nearest_upgradable_unit_level() end

--Acquire skill number
---@return py.AbilityKey? # Skill number
function Ability:api_get_ability_id() end

--Is a melee skill
---@return boolean? # Boolean value
function Ability:api_is_melee_ability() end

--General attack or not
---@return boolean? # Boolean value
function Ability:api_is_common_atk() end

--Passive or not
---@return boolean? # Boolean value
function Ability:is_passive_ability() end

--Get life consuming whether it kills
---@return boolean? # Consume life whether death
function Ability:api_get_cost_hp_can_die() end

--Set cost life or death
---@param value boolean # Can be released
function Ability:api_set_cost_hp_can_die(value) end

--Gain life enough to cast
---@return boolean? # Lack of life can be cast
function Ability:api_get_can_cast_when_hp_insufficient() end

--Set life shortage can be cast
---@param value boolean # Can be released
function Ability:api_set_can_cast_when_hp_insufficient(value) end

--Get skill name
---@return string? # Skill name
function Ability:api_get_name() end

--Sets whether skills are affected by cooldown reduction
---@param value boolean # Boolean attribute value
function Ability:api_set_influenced_by_cd_reduce(value) end

--Whether it is affected by cooling loss
---@return boolean? # Boolean value
function Ability:api_get_influenced_by_cd_reduce() end

--Get the number of recharge levels for a skill
---@return integer? # Skill level
function Ability:api_get_ability_stack() end

--Increased the number of skill recharge levels
---@param value integer # Number of charging layers
function Ability:api_add_ability_stack_count(value) end

--Set the number of skill charge levels
---@param value integer # Number of charging layers
function Ability:api_set_ability_stack_count(value) end

--Gets the remaining cooldown of the current skill
---@return py.Fixed? # Remaining cooling time
function Ability:api_get_cd_left_time() end

--Ability instant cooldown
function Ability:api_immediately_clear_cd() end

--Change the cooldown of skills
---@param value py.Fixed # Cooling time
function Ability:api_change_ability_cd_cold_down(value) end

--Set the cooldown of skills
---@param value py.Fixed # Cooling time
function Ability:api_set_ability_cd(value) end

--Increased cooldown of skills
---@param value py.Fixed # Cooling time
function Ability:api_add_ability_cd(value) end

--De novo cooling
function Ability:api_restart_cd() end

--Change the secondary charge time
---@param value py.Fixed # Cooling time
function Ability:api_set_ability_cur_stack_cd(value) end

--Gets the remaining charge time of the skill
---@return py.Fixed? # Remaining charging time
function Ability:api_get_stack_cd_left_time() end

--Enabling skill
function Ability:api_enable() end

--Forbidden skill
function Ability:api_disable() end

--Play music for the player relationship of the skill unit
---@param camp_target py.RoleRelation # Player relationship
---@param sid py.AudioKey # Track number
---@param loop boolean # Cyclic or not
function Ability:api_play_sound_by_ability_for_role_relation(camp_target, sid, loop) end

--Switch automatically casts spells
---@param b boolean # Switch
function Ability:api_set_autocast_enabled(b) end

--Whether automatic casting is enabled
---@return boolean? # Enable or not
function Ability:api_is_autocast_enabled() end

--Set the skill is build target type (build_id)
---@param new_build_id py.UnitKey # Unit object ID
function Ability:api_set_ability_build_id(new_build_id) end

--Gain the ability to build target type
function Ability:api_get_ability_build_id() end

--Set the limits of the skill is build area
---@param area py.Area # Area object
function Ability:api_set_ability_build_area(area) end

--Pause skill cooldown
function Ability:api_pause_cd() end

--Restore skill cooldown
function Ability:api_resume_cd() end

--Get items tied to the skill
---@return py.Item? # Object entity
function Ability:api_get_item() end

--Skill Add a key-value pair
---@param tag string # TAG
function Ability:api_add_tag(tag) end

--Skill Removes key-value pairs
---@param tag string # TAG
function Ability:api_remove_tag(tag) end

--Clear key pairs
function Ability:api_clear_tag() end

--Set whether to be a permanent skill
---@param is_permanent_ability boolean # Whether it is a permanent skill
function Ability:api_set_ability_is_permanent(is_permanent_ability) end

--Adds skill to filter unit tag
---@param tag string # tag
function Ability:api_add_filter_unit_tag(tag) end

--Removes the skill is filter unit tag
---@param tag string # tag
---@return string? # tag
function Ability:api_remove_filter_unit_tag(tag) end

--Adds the ability to filter item tags
---@param tag string # tag
function Ability:api_add_filter_item_tag(tag) end

--Removes the tag of the skill is filter item
---@param tag string # tag
---@return string? # tag
function Ability:api_remove_filter_item_tag(tag) end

--Adds the ability to filter destructible object tags
---@param tag string # tag
function Ability:api_add_collection_destructible_tags(tag) end

--Removes the ability is filter destructible tag
---@param tag string # tag
---@return string? # tag
function Ability:api_remove_collection_destructible_tags(tag) end

--Skill stop
function Ability:api_ability_stop() end

--Set skill cache
---@param can_stash boolean # Cache or not
function Ability:api_ability_set_stash(can_stash) end

--Whether it can be filtered by current skills
---@param actor py.Actor # Unit/item/destructible
---@return boolean? # Whether it can be filtered
function Ability:api_can_be_filtered_by_ability(actor) end

--Advance skills to the next level
---@param runtime_id? integer # runtime_id
function Ability:api_ability_fast_forward_ability_state(runtime_id) end

--Whether the current skill is disabled
---@return boolean? # Whether the current skill is disabled
function Ability:api_get_is_ability_forbidden() end

--Set the skill indicator transition start time
---@param start_time py.Fixed # Transition start time
function Ability:api_set_ability_pointer_transition_start_time(start_time) end

--Set the skill indicator transition time
---@param duration py.Fixed # Transition time
function Ability:api_set_ability_pointer_transition_duration(duration) end

--Gain skill retention time
---@return py.Fixed? # How long a skill lasts
function Ability:api_get_charge_time() end
