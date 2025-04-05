require 'clicli.game.game_event'

--Game interface
---@class Game
local M = Class 'Game'

---Sets the material of the object
---@deprecated
---@param obj Unit|Item|Destructible
---@param mat integer Material
---@param r number Red
---@param g number Green
---@param b number Blue
---@param intensity number Intensity
---@param alpha number Transparency
function M.set_material_param(obj, mat, r, g, b, intensity, alpha)
    GameAPI.set_material_param(
        obj.handle,
        mat,
        r,
        g,
        b,
        intensity,
        alpha
    )
end

---Clear the unit type key value
---@param unit_key py.UnitKey Unit id
---@param key string Indicates the key
function M.remove_unit_kv(unit_key, key)
    GameAPI.del_unit_key_kv(unit_key, key)
end

---Clear item type key value
---@param item_key py.ItemKey Item id
---@param key string Indicates the key
function M.remove_item_kv(item_key, key)
    GameAPI.del_item_key_kv(item_key, key)
end

---Clear skill type key value
---@param ability_key py.AbilityKey Indicates the skill id
---@param key string Indicates the key
function M.remove_ability_kv(ability_key, key)
    GameAPI.del_ability_key_kv(ability_key, key)
end

---Acquisition camp
---@param id py.CampID Camp id
---@return py.Camp
function M.get_camp_by_id(id)
    return GameAPI.get_camp_by_camp_id(id)
end

---Set shadow distance
---@param dis number Distance
function M.set_cascaded_shadow_distance(dis)
    GameAPI.set_cascaded_shadow_distance(dis)
end

---Character string to unit command type
---@param str string A character string
---@return py.UnitCommandType # Unit command type
function M.str_to_unit_command_type(str)
    return GlobalAPI.str_to_unit_command_type(str)
end

---String to skill release type
---@param str string A character string
---@return py.AbilityCastType # Skill release type
function M.str_to_ability_cast_type(str)
    return GlobalAPI.str_to_ability_cast_type(str)
end

---String to link effect
---@param str string A character string
---@return py.SfxKey # Link effect
function M.str_to_link_sfx_key(str)
    return GameAPI.str_to_link_sfx_key(str)
end

---String to player relationship
---@param str string A character string
---@return py.RoleRelation # Player relationship
function M.str_to_role_relation(str)
    return GlobalAPI.str_to_role_relation(str)
end

---String to unit classification
---@param str string A character string
---@return py.UnitType # Unit classification
function M.str_to_unit_type(str)
    return GlobalAPI.str_to_unit_type(str)
end

---It is a string to a unit type
---@param str string A character string
---@return py.UnitKey # Unit type
function M.str_to_unit_key(str)
    return GameAPI.str_to_unit_key(str)
end

---String to unit property
---@param str string A character string
---@return string # Unit attribute
function M.str_to_unit_name(str)
    return GameAPI.str_to_unit_attr(str)
end

---String to item type
---@param str string A character string
---@return py.ItemKey # Item type
function M.str_to_item_key(str)
    return GameAPI.str_to_item_key(str)
end

---String to player properties
---@param str string A character string
---@returnpy. RoleResKey 3 Player attributes
function M.str_to_role_res(str)
    return GameAPI.str_to_role_res(str)
end

---Word player status to string
---@param status py.RoleStatus
---@return string
function M.str_to_role_status(status)
    return GlobalAPI.role_status_to_str(status)
end

---String to player control state
---@param str string A character string
---@return py.RoleType # Player control state
function M.str_to_role_type(str)
    return GlobalAPI.str_to_role_type(str)
end

---The string is converted to the skill type
---@param str string A character string
---@return py.AbilityKey # Skill type
function M.str_to_ability_key(str)
    return GameAPI.str_to_ability_key(str)
end

---The character string is converted to the slot type
---@param str string A character string
---@return py.AbilityType # Skill Slot type
function M.str_to_ability_type(str)
    return GlobalAPI.str_to_ability_type(str)
end

---String to destructible type
---@param str string A character string
---@return py.DestructibleKey # Destructible type
function M.str_to_dest_key(str)
    return GameAPI.str_to_dest_key(str)
end

---String transprojectile type
---@param str string A character string
---@return py.ProjectileKey # Projectile type
function M.str_to_project_key(str)
    return GameAPI.str_to_project_key(str)
end

---String conversion effect
---@param str string A character string
---@return py.SfxKey # VFX
function M.str_to_particle_sfx_key(str)
    return GameAPI.str_to_particle_sfx_key(str)
end

---String to technology type
---@param str string A character string
---@return py.TechKey # Science and technology type
function M.str_to_tech_key(str)
    return GameAPI.str_to_tech_key(str)
end

---String to model type
---@param str string A character string
---@return py.ModelKey # Model type
function M.str_to_model_key(str)
    return GameAPI.str_to_model_key(str)
end

---String to magic effect type
---@param str string A character string
---@return py.ModifierKey # Magic effect type
function M.str_to_modifier_key(str)
    return GameAPI.str_to_modifier_key(str)
end

---String to magic effect effect type
---@param str string A character string
---@return py.ModifierEffectType # Magic effects affect type
function M.str_to_modifier_effect_type(str)
    return GlobalAPI.str_to_modifier_effect_type(str)
end

---String to magic effect category
---@param str string A character string
---@return py.ModifierType # Magic effect categories
function M.str_to_modifier_type(str)
    return GlobalAPI.str_to_modifier_type(str)
end

---String to camp
---@param str string A character string
---@return py.Camp # Factions
function M.str_to_camp(str)
    return GameAPI.str_to_camp(str)
end

---String to keyboard key
---@param str string A character string
---@return py.KeyboardKey # Keyboard key
function M.str_to_keyboard_key(str)
    return GlobalAPI.str_to_keyboard_key(str)
end

---String turn mouse button
---@param str string A character string
---@return py.MouseKey # Mouse button
function M.str_to_mouse_key(str)
    return GlobalAPI.str_to_mouse_key(str)
end

---String turn mouse wheel
---@param str string A character string
---@return py.MouseWheel # Mouse wheel
function M.str_to_mouse_wheel(str)
    return GlobalAPI.str_to_mouse_wheel(str)
end

---String to platform item type
---@param str string A character string
---@returnpy.StoreKey store_key Platform item type
function M.str_to_store_key(str)
    return GameAPI.str_to_store_key(str)
end

---Character string transfer damage type
---@param str string A character string
---@return integer # Injury type
function M.str_to_damage_type(str)
    return GlobalAPI.str_to_damage_type(str)
end

---String to unit attribute type
---@param str string A character string
---@return string # Unit attribute type
function M.str_to_unit_attr_type(str)
    return GlobalAPI.str_to_unit_attr_type(str)
end

---String to sound type
---@param str string A character string
---@return py.AudioKey # Sound type
function M.str_to_audio_key(str)
    return GameAPI.str_to_audio_key(str)
end

---Get the picture based on the picture ID
---@param id integer
---@return py.Texture texture
---@deprecated Please use the image ID directly
function M.get_icon_id(id)
    ---@type py.Texture
    return id
end

---Get any object picture
---@param obj ? Unit|Item|Ability|Buff Unit| item | ability | magic effects
---@return py.Texture texture
function M.get_obj_icon(obj)
    --If it is empty, return the empty picture
    ---@type py.Texture
    return obj and GameAPI.get_icon_id(obj.handle) or 999
end

---Set the terrain texture for a point
---@param point Point
---@param terrain_type integer Specifies the texture type
---@param range integer Specifies the range
---@param area_type integer Specifies the shape
function M.modify_point_texture(point, terrain_type, range, area_type)
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    GameAPI.modify_point_texture(point.handle, terrain_type, range, area_type)
end

---Get terrain texture
---@param point Point
---@return integer
function M.get_point_texture(point)
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    return GameAPI.get_texture_type(point.handle)
end

---Alternate terrain texture
---@param area Area
---@param old_texture integer Specifies the texture type
---@param new_texture integer Specifies the texture type
function M.replace_area_texture(area, old_texture, new_texture)
    GameAPI.replace_point_texture(area.handle, old_texture, new_texture)
end

---Set area weather
---@param area Area
---@param weather integer | clicli.Const.WeatherType Weather
function M.set_area_weather(area, weather)
    GameAPI.update_area_weather(area.handle, clicli.const.WeatherType[weather] or weather)
end

---Set global weather
---@param weather integer | clicli.Const.WeatherType Weather
function M.set_global_weather(weather)
    GameAPI.update_global_weather(clicli.const.WeatherType[weather] or weather)
end

---Set the fog effect property
---@param fog table Local fog
---@param direction number Indicates the direction
---@param pos_x number Position x
---@param pos_y number Position y
---@param pos_z number Location z
---@param scale_x number Scaling x
---@param scale_y number Scaling y
---@param scale_z number Scale z
---@param red number Color r
---@param green number Color g
---@param blue number Color b
---@param concentration number Concentration number
---@param speed number Indicates the flow rate
function M.set_fog_attribute(fog, direction, pos_x, pos_y, pos_z, scale_x, scale_y, scale_z, red, green, blue, concentration, speed)
    GameAPI.set_fog_attr(fog, 4095, direction, pos_x, pos_y, pos_z, scale_x, scale_y, scale_z, red, green, blue, concentration, speed)
end

---Set Fog Effect Properties (New)
---@param fog table Local fog
---@param attr string Orientation
---@param value number Location x
function M.set_fog_attr(fog,attr,value)
    GameAPI.set_fog_attr_new(fog,attr,value)
end

---Set shadow distance
---@param distance number Indicates the distance
function M.set_cascaded_shadow_distanc(distance)
    GameAPI.set_cascaded_shadow_distance(distance)
end

---Switch cascade shadow
---@param is_enable boolean switch
function M.set_cascaded_shadow_enable(is_enable)
    GameAPI.set_cascaded_shadow_enable(is_enable)
end

---Switch styles for the player
---@param player Player
---@param processing py.PostEffect
function M.set_post_effect(player, processing)
    GameAPI.set_post_effect(player.handle, processing)
end

---Get the maximum level of technology
---@param tech_id py.TechKey Technology id
---@return integer level Maximum level
function M.get_tech_max_level(tech_id)
    return GameAPI.get_tech_max_level(tech_id)
end

---Get Technology ICONS
---@param tech_id py.TechKey Technology
---@param index integer Specifies the level
---@returnpy. Texture texture Indicates the icon id
function M.get_tech_icon(tech_id, index)
    return GameAPI.api_get_tech_icon(tech_id, index)
end

---Get a description of the technology type
---@param tech_id py.TechKey Technology type
---@return string description Indicates the description
function M.get_tech_description(tech_id)
    return GameAPI.get_tech_desc_by_type(tech_id)
end

---Get the name of the technology type
---@param tech_id py.TechKey Technology type
---@return string name Indicates the name
function M.get_tech_name(tech_id)
    return GameAPI.get_tech_name_by_type(tech_id)
end

---End player game
---@param player Player
---@param result string Result
---@param is_show boolean Specifies whether to display the interface
function M.end_player_game(player, result, is_show)
    GameAPI.set_melee_result_by_role(player.handle, result, is_show, false, 0, false)
end

---Pause the game
function M.pause_game()
    GameAPI.pause_game()
end

---Start a new game
function M.restart_game()
    M.switch_level(M.get_level())
end

---Set the game speed
---@param speed number Indicates the speed
function M.set_game_speed(speed)
    ---@diagnostic disable-next-line: param-type-mismatch
    GameAPI.api_change_time_scale(speed)
end

---Enable soft pause
function M.enable_soft_pause()
    GameAPI.api_soft_pause_game()
end

---Resume soft pause
function M.resume_soft_pause()
    GameAPI.api_soft_resume_game()
end

---Switch to level
---@param level_id_str py.Map | string # Level ID
function M.switch_level(level_id_str)
    M:event_notify('$CliCli- About to switch levels')
    ---@diagnostic disable-next-line: param-type-mismatch
    GameAPI.request_switch_level(level_id_str)
end

---Get current level
---@return py.Map # Current level
function M.get_level()
    return GameAPI.get_current_level()
end

---Set damage coefficient
---@param attack_type integer Specifies the attack type
---@param armor_type integer Specifies the type of the armor
---@param ratio number coefficient
function M.set_damage_factor(attack_type, armor_type, ratio)
    GameAPI.set_damage_ratio(attack_type, armor_type, Fix32(ratio))
end

---Set compound properties
---@param primary_attribute string Primary attribute
---@param secondary_attr string Secondary attribute
---@param value number Attribute value
function M.set_compound_attributes(primary_attribute, secondary_attr, value)
    GameAPI.set_slave_coeff(primary_attribute, secondary_attr, Fix32(value))
end

---Get the influence coefficient of the three-dimensional attribute
---@param primary_attribute string Primary attribute
---@param secondary_attr string Secondary attribute
---@return number coefficient
function M.get_compound_attributes(primary_attribute, secondary_attr)
    return clicli.helper.tonumber(GameAPI.get_slave_coeff(primary_attribute, secondary_attr)) or 0.0
end

---Whether to enable 3D properties
---@return boolean is_open Whether is_open is enabled
function M.is_compound_attributes_enabled()
    return GameAPI.api_if_pri_attr_state_open()
end

---Set the speed at which the game time passes
---@param speed number Speed
function M.set_day_night_speed(speed)
    GameAPI.set_day_and_night_time_speed(Fix32(speed))
end

---Set play time
---@param time number Time
function M.set_day_night_time(time)
    GameAPI.set_day_and_night_time(Fix32(time))
end

---Create artificial time
---@param time number Time
---@param dur number Duration
function M.create_day_night_human_time(time, dur)
    GameAPI.create_day_and_night_human_time(Fix32(time), Fix32(dur))
end

---Set the random number seed
---@param seed integer Indicates the random seed
function M.set_random_seed(seed)
    GameAPI.set_random_seed(seed)
end

---Switch time lapse
---@param is_on boolean Switch
function M.toggle_day_night_time(is_on)
    GameAPI.open_or_close_time_speed(is_on)
end

---Switch the grass at the target point
---@param is_on boolean Switch
---@param point Point
function M.enable_grass_by_pos(is_on, point)
    ---@diagnostic disable-next-line: param-type-mismatch
    GameAPI.set_grass_enable_by_pos(is_on, point.handle)
end

---Gets the current game mode
---@returnpy. GameMode game_mode Game mode
function M.get_current_game_mode()
    return GameAPI.get_game_mode()
end

---The time the game has been running
---@return number time Time
function M.current_game_run_time()
    return clicli.helper.tonumber(GameAPI.get_cur_game_time()) or 0.0
end

---Gets the game's current day and night time
---@return number time Time
function M.get_day_night_time()
    return clicli.helper.tonumber(GameAPI.get_cur_day_and_night_time()) or 0.0
end

---Gain damage coefficient
---@param attack_type integer Specifies the attack type
---@param area_type integer Specifies the type of the armor
---@return number factor Damage factor
function M.get_damage_ratio(attack_type, area_type)
    return clicli.helper.tonumber(GameAPI.get_damage_ratio(attack_type, area_type)) or 0.0
end

---Get the local game environment
---@return integer game_mode Game environment, where 1 is the editor and 2 is the platform
function M.get_start_mode()
    return GameAPI.api_get_start_mode()
end

--Debug mode or not
---@param ignore_config? boolean # Whether to ignore user Settings
---@return boolean
function M.is_debug_mode(ignore_config)
    if ignore_config then
        return M.get_start_mode() == 1
    end
    if clicli.config.debug == true then
        return true
    end
    if clicli.config.debug == false then
        return false
    end
    if clicli.config.debug == 'auto' then
        return M.get_start_mode() == 1
    end
    return false
end

---Get global archive
---@param name string Archive name
---@return integer archive Archive
function M.get_global_archive(name)
    return GameAPI.get_global_map_archive(name)
end

---Gets the integer save leaderboard player save value
---@param file integer Archive
---@param index integer Specifies the serial number
---@return integer value Archive value
function M.get_archive_rank_player_archive_value(file, index)
    return GameAPI.get_archive_rank_player_archive_value(file, index)
end

---Get global weather
---@return integer weather Weather
function M.get_global_weather()
    return GameAPI.get_global_weather()
end

---Get multilingual content
---@param key integer|string Multi-language key
---@return string Multi-language content
function M.locale(key)
    ---@diagnostic disable-next-line: param-type-mismatch
    return GameAPI.get_text_config(key)
end

---Get the game start time stamp
---@return integer time_stamp Indicates the time stamp
function M.get_game_init_time_stamp()
    return GameAPI.get_game_init_time_stamp()
end

---@class ServerTime: osdate
---@field timestamp integer # timestamp
---@field time_zone_stamp integer # Calculate the timestamp after the obsolescence zone. You should not use this field under any circumstances, just keep it for compatibility.
---@field msec integer # ms
---@field time_zone integer # Time zone

--Gets the current server time. In order to ensure the consistency of the results you need to specify your own time zone.
---@param time_zone? integer # Time zone. The default value is 0. To get the time of China, please pass in 8.
---@return ServerTime
function M.get_current_server_time(time_zone)
    local init_time_stamp = GameAPI.get_game_init_time_stamp()
    local runned_sec, runned_ms = math.modf(GameAPI.get_cur_game_time():float())
    local time_stamp = init_time_stamp + runned_sec
    local time_zone_stamp = time_stamp + (time_zone or 0) * 3600
    local result = os.date('!*t', time_zone_stamp) --[[@as ServerTime]]
    result.msec = math.floor(runned_ms * 1000)
    result.timestamp = time_stamp
    result.time_zone_stamp = time_zone_stamp
    result.time_zone = time_zone or 0
    return result
end

---Request real time. In order to ensure the consistency of the results you need to specify your own time zone.
---@param time_zone integer # Time zone. The default value is 0. To get the time of China, please pass in 8.
---@param callback fun(time: ServerTime)
function M.request_time(time_zone, callback)
    local context = {}
    GameAPI.lua_request_message_from_server(function ()
        local time_stamp = context.__time
        local time_zone_stamp = time_stamp + (time_zone or 0) * 3600
        local result = os.date('!*t', time_zone_stamp) --[[@as ServerTime]]
        result.msec = 0
        result.timestamp = time_stamp
        result.time_zone_stamp = time_zone_stamp
        result.time_zone = time_zone or 0
        xpcall(callback, log.error, result)
    end, context)
end

---Gets the initial horizontal resolution
---@return integer x_resolution Horizontal resolution
function M.get_game_x_resolution()
    return GameAPI.get_game_x_resolution()
end

---Gets the initial vertical resolution
---@return integer y_resolution Vertical resolution
function M.get_game_y_resolution()
    return GameAPI.get_game_y_resolution()
end

---Get the initial game quality
---@return 'low' | 'medium' | 'high' quality
function M.get_graphics_quality()
    return GameAPI.get_graphics_quality()
end

---@alias Game.WindowMode
---| "full_screen" # Full screen
---| "window_mode" # windowing
---| "window_mode_full_screen" # Windowing full screen

---Gets the windowed category
---@return Game.WindowMode mode Windowing category
function M.get_window_mode()
    return GameAPI.get_window_mode()
end

---Send signal
---@param player Player
---@param signal_enum clicli.Const.SignalType Signal enumeration value
---@param point Point
---@param visible_enum clicli.Const.VisibleType Visibility enumeration value
function M.send_signal(player, signal_enum, point, visible_enum)
    GameAPI.send_signal(
        player:get_id() --[[@as py.RoleID]],
        clicli.const.SignalType[signal_enum] or signal_enum,
        --TODO see question 2
        ---@diagnostic disable-next-line: param-type-mismatch
        point.handle,
        clicli.const.VisibleType[visible_enum] or visible_enum
    )
end

--Send custom events to ECA
---@param id integer Specifies the id of the event
---@param table table Event data
function M.send_custom_event(id, table)
    GameAPI.send_event_custom(id, table)
end

---The string to interface event
---@param str string A character string
---@return string
function M.str_to_ui_event(str)
    return GlobalAPI.str_to_ui_event(str)
end

---Acquisition list
---@param name string Table name
---@param as_lua? boolean Whether to convert the data in the table to a Lua data type, such as Fix32 to number
---@return table tb table
function M.get_table(name, as_lua)
    local t = GameAPI.get_table(name)
    if as_lua then
        t = clicli.helper.as_lua(t, true)
    end
    return t
end

---Whether the table has fields
---@param table table
---@param key string
---@return boolean
function M.table_has_key(table, key)
    return GameAPI.table_has_key(table, key)
end

---Clear list
function M.clear_table(table)
    GameAPI.clear_table(table)
end

--Enable Full view (always visible)
---@param enable boolean
function M.set_globale_view(enable)
    GameAPI.enable_fow_for_player(enable)
end

---Sets the object base material color
---@param obj Unit|Item|Destructible
---@param r integer # Red (0~255)
---@param g integer # Green (0 to 255)
---@param b integer # Blue (0~255)
---@param a? integer # Strength (0~100)
---@param o? number # Opacity (0~1)
function M.set_object_color(obj, r, g, b, a, o)
    ---@diagnostic disable-next-line: param-type-mismatch
    GameAPI.api_change_obj_base_color(obj.handle, r, g, b, a or 50, o or -1)
end

---Sets the Fresnel effect of an object
---@param obj Unit|Item|Destructible
---@param b boolean
function M.set_object_fresnel_visible(obj, b)
    GameAPI.api_set_obj_fresnel_visible(obj.handle, b)
end

---Sets the Fresnel effect of an object
---@param obj Unit|Item|Destructible
---@param r? integer # R
---@param g? integer # G
---@param b? integer # B
---@param alpha? number # alpha
---@param exp? number # exp
---@param strength? number # strength
function M.set_object_fresnel(obj, r, g, b, alpha, exp, strength)
    GameAPI.api_set_obj_fresnel_parameters(obj.handle, r, g, b, alpha, exp, strength)
end

---Set the logical frame rate
---Do not change the frame rate in the middle of the game, it is recommended to change it directly in the map Settings
---@param fps integer Specifies the frame rate
function M.set_logic_fps(fps)
    GameAPI.api_change_logic_fps(fps)
    clicli.config.logic_frame = fps
end

---Encrypted list
---@param tab table
function M.encrypt_table(tab)
    GameAPI.encrypt_table(tab)
end

---Turn off localplayer's presentation layer hops
---@param enable boolean Specifies whether to disable
function M.set_jump_word(enable)
    GameAPI.set_local_player_jump_word_close(enable)
end

---Special effect switch
---@param player Player
---@param switch boolean Specifies whether to disable
function M.sfx_switch(player, switch)
    GameAPI.set_player_sfx_switch(player.handle, switch)
end

---Sign up area for nearby voice channels
---@param area Area
function M.reg_sound_area(area)
    GameAPI.reg_sound_area(area.handle)
end

---The nearby voice channel of the unregistered area
---@param area Area
function M.unreg_sound_area(area)
    GameAPI.unreg_sound_area(area.handle)
end

--Set the area mode switch for nearby voices
---@param switch boolean Specifies whether to disable
function M.set_nearby_voice_mode(switch)
    GameAPI.set_nearby_voice_mode(switch)
end

--Set the player's nearby voice chat listening switch
---@param player Player
---@param switch boolean Specifies whether to disable
function M.set_nearby_sound_switch(player, switch)
    GameAPI.set_nearby_sound_switch(player.handle, switch)
end

--Set the player's nearby voice chat speech switch
---@param player Player
---@param switch boolean Specifies whether to disable
function M.set_nearby_micro_switch(player, switch)
    GameAPI.set_nearby_micro_switch(player.handle, switch)
end

---Set up the player's sound master unit
---@param player Player
---@param unit Indicates whether Unit is disabled
function M.set_role_micro_unit(player, unit)
    GameAPI.set_role_micro_unit(player.handle, unit.handle)
end

---Turn off player's nearby voice chat
---@param player Player
function M.close_role_micro_unit(player)
    GameAPI.close_role_micro_unit(player.handle)
end

---Set the player's peer voice chat listening switch
---@param player Player
---@param switch boolean Specifies whether to disable
function M.set_role_camp_sound_switch(player, switch)
    GameAPI.set_role_camp_sound_switch(player.handle, switch)
end

---Set the player's peer group voice chat speech switch
---@param player Player
---@param switch boolean Specifies whether to disable
function M.set_role_camp_micro_switch(player, switch)
    GameAPI.set_role_camp_micro_switch(player.handle, switch)
end

---Set the player's everyone voice chat listening switch
---@param player Player
---@param switch boolean Specifies whether to disable
function M.set_role_all_sound_switch(player, switch)
    GameAPI.set_role_all_sound_switch(player.handle, switch)
end

---Set the player's all voice chat speech switch
---@param player Player
---@param switch boolean Specifies whether to disable
function M.set_role_all_micro_switch(player, switch)
    GameAPI.set_role_all_micro_switch(player.handle, switch)
end

---World coordinates Convert screen coordinates
---@param world_pos Point World coordinates
---@return number x, number y Screen coordinates
function M.world_pos_to_camera_pos(world_pos)
    ---@diagnostic disable-next-line: param-type-mismatch
    local pos = GameAPI.api_world_pos_to_camera_pos(world_pos.handle)
    ---@diagnostic disable-next-line: param-type-mismatch
    local x = GlobalAPI.get_fixed_coord_index(pos, 0):float() / 100
    ---@diagnostic disable-next-line: param-type-mismatch
    local y = GlobalAPI.get_fixed_coord_index(pos, 2):float() / 100
    y = y - 2 * (y - clicli.ui:get_window_height() / 2)
    return x, y
end

---World coordinates convert screen edge coordinates
---@param world_pos Point
---@param delta_dis number
---@return number x, number y
function M.world_pos_to_screen_edge_pos(world_pos, delta_dis)
    ---@diagnostic disable-next-line: param-type-mismatch
    local pos = GameAPI.api_world_pos_to_screen_edge_pos(world_pos.handle, delta_dis)
    ---@diagnostic disable-next-line: param-type-mismatch
    local x = GlobalAPI.get_fixed_coord_index(pos, 0):float() / 100
    ---@diagnostic disable-next-line: param-type-mismatch
    local y = GlobalAPI.get_fixed_coord_index(pos, 2):float() / 100
    y = y - 2 * (y - clicli.ui.get_window_height() / 2)
    return x, y
end

---Create terrain presets
---@param point Point # point
---@param level_id string # Level ID, obtained by 'clicli.game.get_level()'
---@param rotate? integer # Rotation Angle
---@param has_light? boolean # Carry lights or not
---@param has_decoration? boolean # Whether to carry decorations
---@param has_fog? boolean # Whether to carry fog effect
---@param has_collision? boolean # Carry or not collision
---@param has_projectile? boolean # Whether to carry projectiles
---@param has_item? boolean # Whether to bring goods
---@param has_destructible? boolean # Whether to carry destructible material
function M.load_sub_scene(point, level_id, rotate, has_light, has_decoration, has_fog, has_collision, has_projectile, has_item, has_destructible)
    ---@diagnostic disable-next-line: param-type-mismatch
    GameAPI.load_sub_scene(point.handle, level_id
        , has_light or false
        , has_decoration or false
        , has_fog or false
        , has_projectile or false
        , has_item or false
        , has_destructible or false
        , has_collision or false
        , rotate or 0
    )
end

--The local client calls back this function every frame
--Only one callback can be registered. The later one overwrites the earlier one.
--Distribute it in the callback if necessary
--
--> Warning: The callback function is executed on the local player is client, take care to avoid the problem of asynchronism.
---@param callback fun(local_player: Player)
function M.on_client_tick(callback)
    if type(callback) ~= 'function' then
        error('on_client_tick: callback must be a function')
    end
    ---@private
    M._client_tick_callback = callback
end


---@class HttpRequestOptions
---@field post? boolean # post request or get request
---@field port? integer # Port number
---@field timeout? number # The default timeout period is 2 seconds
---@field headers? table | py.Dict # Request header

--Sending an http request, success or failure triggers a callback,
--The parameter of the callback is the body returned by http on success, and 'nil' on failure
---@param url string
---@param body? string
---@param callback? fun(body? : string)
---@param options? HttpRequestOptions
function M:request_url(url, body, callback, options)
    local headers = options and options.headers
    if type(headers) == 'table' then
        headers = clicli.helper.py_dict(headers)
    end
    request_url(url
        , options and options.post or false
        , body
        , options and options.port
        , options and options.timeout or 2
        , headers
        , callback
    )
end

local download_icon_queue = {}

---Download the player platform avatar, call the callback function after downloading
---@param url string # Avatar download address
---@param icon string # Avatar path, if the local avatar is not downloaded, but immediately call the callback function
---@param callback fun(real_path: string) # After downloading the callback function
function M.download_platform_icon(url, icon, callback)
    ---@diagnostic disable-next-line: undefined-field
    local download = GameAPI.download_avatar_head_url
    if not download then
        return
    end
    download_icon_queue[#download_icon_queue+1] = {
        url = url,
        icon = icon,
        callback = callback
    }
    if #download_icon_queue == 1 then
        local function download_one()
            local data = table.remove(download_icon_queue, 1)
            download(data.url, data.icon, function (real_path)
                xpcall(data.callback, log.error, real_path)
                if #download_icon_queue > 0 then
                    download_one()
                end
            end)
        end
        download_one()
    end
end

---Is the current hall level
---@return boolean
function M.is_lobby()
    return GameAPI.get_is_steam_lobby()
end

---Sets whether to render the scene
---@param flag boolean
function M.set_draw_scene(flag)
    GameAPI.set_draw_ui(flag)
end

---[Asynchronous] Get the local game client version number
---@return integer
function M.get_local_game_version()
    return GameAPI.get_local_game_version()
end

---@private
---@type function[]
M._fetching_game_version = nil

---【 Asynchronous 】 Get the latest game client version number. The version number is returned via the callback function after a successful retrieval
---@param callback fun(version: integer)
function M.get_latest_game_version(callback)
    if M._fetching_game_version then
        table.insert(M._fetching_game_version, callback)
        return
    end
    M._fetching_game_version = { callback }
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.update_latest_game_version()
    clicli.ctimer.loop(0.1, function (timer)
        ---@diagnostic disable-next-line: missing-parameter
        local version = GameAPI.get_latest_game_version()
        if version == 0 then
            return
        end
        timer:remove()
        local funcs = M._fetching_game_version
        M._fetching_game_version = nil
        for _, func in ipairs(funcs) do
            xpcall(func, log.error, version)
        end
    end)
end

---Asynchronous Requests the latest archived leaderboard data.
---The interface has a frequency limit of 10 minutes, and if it is to be used with uploading leaderboard data, the two logics are best separated by 5 minutes
---@param save_index integer # Archive field
---@param callback? fun() # Callback function after refreshing the leaderboard
function M.request_map_rank(save_index, callback)
    GameAPI.lua_request_get_map_rank(save_index, function ()
        if callback then
            xpcall(callback, log.error)
        end
    end)
end

---@param str string
---@return string
function M.md5(str)
    return GameAPI.api_get_string_md5(str)
end

---Get the current number of map reservations
---@return integer
function M.get_booked_number()
    return math.tointeger(GlobalAPI.api_get_booked_number()) or 0
end

_G['OnTick'] = function ()
    if M._client_tick_callback then
        clicli.player.with_local(M._client_tick_callback)
    end
    clicli.ctimer.update_frame()
end

return M
