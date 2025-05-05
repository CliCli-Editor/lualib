--Player
---@class Player
---@field handle py.Role
---@field id integer
---@overload fun(py_player? : py.Role): self
---@overload fun(id: py.RoleID | integer): self
local M = Class 'Player'

M.type = 'player'

---@class Player: Storage
Extends('Player', 'Storage')
---@class Player: CustomEvent
Extends('Player', 'CustomEvent')
---@class Player: CoreObjectEvent
Extends('Player', 'CoreObjectEvent')
---@class Player: KV
Extends('Player', 'KV')

---@package
---@param key py.RoleID
---@return Player?
M.ref_manager = New 'Ref' ('Player', function (key)
    local py_player = GameAPI.get_role_by_role_id(key)
    if not py_player then
        return nil
    end
    assert(type(py_player) == 'userdata', 'Parameter type error:' .. tostring(py_player))
    return New 'Player' (py_player)
end)

---@param py_player py.Role
---@return self
function M:__init(py_player)
    self.handle = py_player
    self.id     = py_player:get_role_id_num() or 0
    return self
end

function M:__tostring()
    return string.format('{player|%s|%d}'
        , self:get_name()
        , self.id
    )
end

---Convert player ID to player
---@param id integer Specifies the player ID
---@return Player player Player
function M:__alloc(id)
    return M.get_by_id(id)
end

function M:__encode()
    return self.id
end

function M:__decode(id)
    return M.get_by_id(id)
end

---Convert player ID to player
---@param id integer Specifies the player ID
---@return Player player Player
function M.get_by_id(id)
    local player = M.ref_manager:get(id)
    return player
end

--Get the Player based on a string, which is via 'tostring(Player)'
--Or using the "Convert any variable to string" in ECA.
---@param str string
---@return Player?
function M.get_by_string(str)
    local id = str:match('^{player|.+|(%d+)}$')
            or str:match('<Camp.-%(%d+%),id%((%d+)%)')
            or str:match('^Player:(%d+)')
    if not id then
        return nil
    end
    return M.get_by_id(tonumber(id)--[[@as integer]])
end

clicli.py_converter.register_type_alias('py.Role', 'Player')
clicli.py_converter.register_py_to_lua('py.RoleID', M.get_by_id)

---@param py_player py.Role
---@return Player
function M.get_by_handle(py_player)
    if type(py_player) ~= 'userdata' then
        error('Parameter type error:' .. tostring(py_player))
    end
    ---@cast py_player py.Role
    local id = py_player:get_role_id_num() or 0
    return M.get_by_id(id)
end

clicli.py_converter.register_py_to_lua('py.Role', M.get_by_handle)
clicli.py_converter.register_lua_to_py('py.Role', function (lua_value)
    return lua_value.handle
end)

--Local players, be aware that this may cause out-of-sync!
---@private
M.LOCAL_PLAYER = M.get_by_handle(GameAPI.get_client_role())

function M:get_camp()
    return self.handle:api_get_camp()
end

---Boolean player save data
---@deprecated
---@param index integer Specifies the archive key
---@return boolean bool_value Save data for Boolean players
function M:get_save_data_bool_value(index)
    return self.handle:get_save_data_bool_value(index) or false
end

---Whether the player joins halfway
---@return boolean is_middle_join Whether to join in the process
function M:is_middle_join()
    return self.handle:is_middle_join() or false
end

---Whether the relationship between players is hostile
---@param player Player
---@return boolean Whether is_enemy is a hostile relationship
function M:is_enemy(player)
    return self.handle:players_is_enemy(player.handle) or false
end

---Set name
---@param name string Name
function M:set_name(name)
    self.handle:set_role_name(name)
end

---Set the team ID
---@param id py.Camp
function M:set_team(id)
    self.handle:api_set_camp(id)
end

---Set attribute value
---@param key clicli.Const.PlayerAttr | string Attribute name
---@param value number Specifies the value
function M:set(key, value)
    key = clicli.const.PlayerAttr[key] or key
    ---@cast key py.RoleResKey
    self.handle:set_role_res(key, Fix32(value))
end

---Increment attribute value
---@param key clicli.Const.PlayerAttr | string Attribute name
---@param value number Specifies the value
function M:add(key, value)
    key = clicli.const.PlayerAttr[key] or key
    ---@cast key py.RoleResKey
    self.handle:change_role_res(key, Fix32(value))
end

---Get player attributes
---@param key clicli.Const.PlayerAttr | string # Attribute name
---@return number role_res Player attribute
function M:get(key)
    key = clicli.const.PlayerAttr[key] or key
    ---@cast key py.RoleResKey
    return clicli.helper.tonumber(self.handle:get_role_res(key)) or 0.0
end

---Get player attributes
---@param key clicli.Const.PlayerAttr | string # Attribute name
---@return number role_res Player attribute
function M:get_attr(key)
    key = clicli.const.PlayerAttr[key] or key
    ---@cast key py.RoleResKey
    return clicli.helper.tonumber(self.handle:get_role_res(key)) or 0.0
end

---Set the experience gain rate
---@param rate number Experience gain rate
function M:set_exp_rate(rate)
    self.handle:set_role_exp_rate(rate)
end

---antagonize
---@param player Player
---@param is_hostile boolean Specifies whether to be hostile
function M:set_hostility(player, is_hostile)
    self.handle:set_role_hostility(player.handle, is_hostile)
end

---Set group pathfinding strict mode
---@param is_strict boolean Specifies whether the value is strict
function M:set_strict_group_navigation(is_strict)
    self.handle:set_group_navigate_mode(is_strict)
end

---Select the unit/unit group
---@param unit_or_group Unit|UnitGroup Unit/unit group
function M:select_unit(unit_or_group)
    self.handle:role_select_unit(unit_or_group.handle)
end

---Set following distance
---@param distance number Indicates the distance
function M:set_follow_distance(distance)
    self.handle:api_set_follow_distance(Fix32(distance))
end

---Click on/off for the player
---@param is_enable boolean Whether to open a mouse click
function M:set_mouse_click_selection(is_enable)
    self.handle:set_role_mouse_left_click(is_enable)
end

---Open/close the mouse box for the player
---@param is_enable boolean Whether to select with the mouse box
function M:set_mouse_drag_selection(is_enable)
    self.handle:set_role_mouse_move_select(is_enable)
end

---Turn the mouse wheel on/off for the player
---@param is_enable boolean Whether to turn on mouse wheel
function M:set_mouse_wheel(is_enable)
    self.handle:set_role_mouse_wheel(is_enable)
end

---Whether the player base action shortcuts are occupied
--TODO: Function key lua layer indicates that processing is required
---@param key py.NormalKey Indicates the key name
---@param assist_key py.RecordKey Secondary key name
---@return boolean Whether is_conf is occupied
function M:is_operation_key_occupied(key,assist_key)
    return self.handle:api_is_conf_of_editable_game_func(key, assist_key) or false
end

---Set the player's basic action shortcuts (filter out forbidden Settings)
--TODO:operation Indicates the operation mode on the lua layer to be sorted. Method Name English to be confirmed
---@param operation py.EditableGameFunc can be edited
---@param key py.NormalKey Function key
---@param assist_key py.RecordKey Auxiliary key
function M:set_operation_key(operation, key, assist_key)
    self.handle:api_set_role_editable_game_func(operation, key, assist_key)
end

---Set the player's base action switch (includes all base actions)
--TODO:operation Indicates the operation mode on the lua layer to be sorted. Method Name English to be confirmed
---@param operation py.AllGameFunc can be edited
---@param is_enable boolean Specifies whether to enable
function M:set_all_operation_key(operation, is_enable)
    self.handle:api_set_role_all_game_func_enable(operation, is_enable)
end

---Get the basic actions of the player in response to keyboard keystrokes (filter out the forbidden Settings)
---@param key py.NormalKey Indicates the key name
---@param assist_key py.RecordKey keypad keys
---@return py.EditableGameFunc shortcut Basic operation
function M:get_operation_key(key, assist_key)
    return self.handle:api_get_editable_game_func_of_shortcut(key, assist_key) or 0
end

---Set technology level
---@param tech_type py.TechKey Technology level
---@param level integer Specifies the level
function M:set_tech_level(tech_type, level)
    self.handle:api_set_tech_level(tech_type, level)
end

---Upgrade technology
---@param tech_type py.TechKey Technology level
---@param level integer Specifies the level
function M:add_tech_level(tech_type, level)
    self.handle:api_change_tech_level(tech_type, level)
end

---Open your eyes to the player
---@param target_player Player
---@param share boolean
function M:share_vision_with_player(target_player, share)
    if share then
        self.handle:share_source_player_vision_to_target(target_player.handle)
    else
        self.handle:close_source_player_vision_to_target(target_player.handle)
    end
end

---Get the unit's view
---@param unit Unit Unit
---@param share boolean
function M:share_vision_of_unit(unit, share)
    if share then
        self.handle:share_source_unit_vision_to_target(unit.handle)
    else
        self.handle:close_source_unit_vision_to_target(unit.handle)
    end
end

---Upload archive
function M:upload_save_data()
    self.handle:upload_save_data()
end

---Add global archive
---@param key string Indicates the key
---@param value integer Specifies the value
function M:add_global_save_data(key, value)
    self.handle:add_global_map_archive_data(key, value)
end

---Cost the player platform items
---@param count integer Specifies the number of integers
---@param item_id py.StoreKey Platform item id
function M:use_store_item(count, item_id)
    self.handle:api_use_store_item(count, item_id)
end

---Request to purchase platform items
---@param id py.StoreKey Platform item id
function M:open_platform_shop(id)
    GameAPI.open_platform_shop(self.handle, id)
end

---Whether the player can see a location
---@param point Point
---@return boolean visible points are visible to the player
function M:is_visible(point)
    ---@diagnostic disable-next-line: param-type-mismatch
    return self.handle:is_point_visible_to_player(point.handle) and true or false
end

---Whether a location is in the player's fog
---@param point Point
---@return boolean is_point_in_fog The point is in the fog
function M:is_in_fog(point)
    ---@diagnostic disable-next-line: param-type-mismatch
    return self.handle:is_point_in_fog(point.handle) or false
end

---Whether a location is in the player's black shadow
---@param point Point
---@return boolean is_point_in_shadow The point is in a black shadow
function M:is_in_shadow(point)
    ---@diagnostic disable-next-line: param-type-mismatch
    return self.handle:is_point_in_shadow(point.handle) or false
end

---Get a player ID
---@return integer role_id_num Player ID
function M:get_id()
    return self.id
end

---Get player colors
---@return string HEX color
function M:get_color()
    return self.handle:api_get_role_color() or ''
end

---Get the player's game status
---@see clicli.Const.RoleStatus
---@return clicli.Const.RoleStatus role_status The player's game status
function M:get_state()
    return self.handle:get_role_status() or 2
end

---Gets the player controller type
---@return clicli.Const.RoleType role_type Player controller type
function M:get_controller()
    if not self._cotroller then
        ---@private
        self._cotroller = self.handle:get_role_type() or 0
    end
    return self._cotroller
end

---Is it a living player (a real player in the game)?
---@return boolean
function M:is_alive()
    return  self:get_state() == clicli.const.RoleStatus['PLAYING']
        and self:get_controller() == clicli.const.RoleType.USER
end

---Get player name
---@return string role_name Player name
function M:get_name()
    return self.handle:get_role_name() or ''
end

---Gain experience gain rate
---@return number exp_rate Experience gain rate
function M:get_exp_rate()
    return clicli.helper.tonumber(self.handle:get_role_exp_rate()) or 0.0
end

---Get team ID
---@return integer camp_id Specifies the ID of the team
function M:get_team_id()
    return self.handle:get_camp_id_num() or 0
end

---Tabular player save data
---@deprecated
---@param key integer Specifies the archive key
---@return table? table_value Table player archive data
function M:get_save_data_table(key)
    return self.handle:get_save_data_table_value(key)
end

---String type player save data
---@deprecated
---@param key integer Specifies the archive key
---@return string str_value String Player archive data
function M:get_save_data_string(key)
    return self.handle:get_save_data_str_value(key) or ''
end

---Real type archive data
---@deprecated
---@param key integer Specifies the archive key
---@return number int_value Archive data of the real number
function M:get_save_data_float(key)
    return clicli.helper.tonumber(self.handle:get_save_data_fixed_value(key)) or 0.0
end

---Gets integer archive data
---@deprecated
---@param key integer Specifies the archive key
---@return integer int_value Specifies the integer archive data
function M:get_save_data_int(key)
    return self.handle:get_save_data_int_value(key) or 0
end

---Get integer save player rank
---@param key integer Specifies the archive key
---@return integer rank_num Integer rank of saved players
function M:get_rank_num(key)
    return self.handle:get_player_archive_rank_num(key) or 0
end

---Obtain technology grade
---@param tech_id py.TechKey Technology id
---@return integer tech_level Technology level
function M:get_tech_level(tech_id)
    return self.handle:api_get_tech_level(tech_id) or 0
end

---@private
---@type string
M._platform_icon = nil

---Get the player platform avatar
---@return string icon Platform profile picture
function M:get_platform_icon()
    if not self._platform_icon then
        local suc, res = pcall(GameAPI.get_role_platform_icon, self.handle)
        if suc then
            self._platform_icon = res --[[@as string]]
        else
            self._platform_icon = ''
        end
    end
    return self._platform_icon
end

---Get the player platform avatar download address
---@return string icon_url Platform profile picture download address
function M:get_platform_icon_url()
    ---@diagnostic disable-next-line: undefined-field
    local get_url = GameAPI.get_role_platform_url
    if not get_url then
        return ''
    end
    local url = get_url(self.handle) --[[@as string]]
    return url or ''
end

--Gets the player is platform unique ID
---@return integer plat_aid Unique platform ID
function M:get_platform_id()
    return math.tointeger(GameAPI.get_player_plat_aid(self.handle)) or 0
end

--Get the player's platform level for this map
---@return integer
function M:get_map_level()
    return self.handle:api_get_map_level() or 0
end

--Get the player's platform rank in the local chart
---@return integer
function M:get_map_level_rank()
    return self.handle:api_get_map_level_rank() or 0
end

--Gets the player's accumulated game count on the local graph
function M:get_played_times()
    return self.handle:api_get_played_times() or 0
end

--Get achievement points for the player's current map
function M:get_achieve_point()
    return self.handle:api_get_role_achieve_point() or 0
end

--Determines whether the specified achievement is unlocked
---@param id string
---@return boolean
function M:is_achieve_unlock(id)
    return self.handle:api_get_role_achieve_unlock(id) or false
end

---The number of items on the player's platform
---@param id py.StoreKey Platform item id
---@return integer store_item_cnt Number of platform items
function M:get_store_item_number(id)
    return self.handle:get_store_item_cnt(id) or 0
end

---Player platform item expiration time stamp
---@param id py.StoreKey Platform item id
---@return integer store_item_end_time Indicates the expiration time of a platform item
function M:get_store_item_end_time(id)
    return self.handle:get_store_item_expired_time(id) or 0
end

---Gain the player platform level
---@return integer map_level Platform level
function M:get_platform_level()
    return self.handle:get_role_plat_map_level() or 0
end

---The player is in the player group
---@param player_group PlayerGroup Player group
---@return boolean is_in_group The player is in the player group
function M:is_in_group(player_group)
    return GlobalAPI.judge_role_in_group(self.handle, player_group.handle)
end

---All units belonging to a player
---@return UnitGroup unit_group Unit group
function M:get_all_units()
    local py_unit_group = self.handle:get_all_unit_id()
    if not py_unit_group then
        return clicli.unit_group.create()
    end
    return clicli.unit_group.get_by_handle(py_unit_group)
end

---Create unit
---@param unit_id py.UnitKey Unit type
---@param point? Point unit
---@param facing? number orientation
---@return Unit
function M:create_unit(unit_id, point, facing)
    local unit = clicli.unit.create_unit(self, unit_id, point or clicli.point(0.0, 0.0), facing or 0.0)
    return unit
end

---Forced kick
---@param reason string Indicates the reason for kicking out
function M:kick(reason)
    GameAPI.role_force_quit(self.handle, reason)
end

---Set the player properties icon
---@param key py.RoleResKey attribute name
---@param id py.Texture Icon id
function clicli.set_res_icon(key, id)
    GameAPI.change_role_res_icon_with_icon(key, id)
end

---Get the player platform appearance model
---@return py.ModelKey model id of the model
function M:get_platform_model()
    return GameAPI.get_role_platform_model(self.handle)
end

--Gets the point of the mouse in the game.
--You must first set 'clicli.config.sync.mouse = true'.
---@return Point point
function M:get_mouse_pos()
    if not clicli.config.sync.mouse then
        error('You must first set `clicli.config.sync.mouse = true`')
    end
    local py_point = GameAPI.get_player_pointing_pos(self.handle)
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    return clicli.point.get_by_handle(py_point)
end

---Gets the percentage of the player's mouse screen coordinate X.
--You must first set 'clicli.config.sync.mouse = true'.
---@return number x_per X ratio
function M:get_mouse_ui_x_percent()
    if not clicli.config.sync.mouse then
        error('You must first set `clicli.config.sync.mouse = true`')
    end
    return clicli.helper.tonumber(GameAPI.get_role_ui_x_per(self.handle)) or 0.0
end

---Gets the percentage of the player's mouse screen coordinate y.
--You must first set 'clicli.config.sync.mouse = true'.
---@return number number of y_per Y
function M:get_mouse_ui_y_percent()
    if not clicli.config.sync.mouse then
        error('You must first set `clicli.config.sync.mouse = true`')
    end
    return clicli.helper.tonumber(GameAPI.get_role_ui_y_per(self.handle)) or 0.0
end

---Gets the X-coordinate of the mouse on the screen
---@return number pos_x X coordinates
function M:get_mouse_pos_x()
    return GameAPI.get_player_ui_pos_x(self.handle)
end

---Gets the y coordinate of the mouse on the screen
---@return number pos_y Y coordinates
function M:get_mouse_pos_y()
    return GameAPI.get_player_ui_pos_y(self.handle)
end

---Whether the player's button is pressed
---@param key clicli.Const.KeyboardKey | clicli.Const.MouseKey | integer Keys
---@return boolean Specifies whether the Boolean is pressed
function M:is_key_pressed(key)
    if not clicli.config.sync.key then
        error('You must first set `clicli.config.sync.key = true`')
    end
    key =  clicli.const.KeyboardKey[key]
        or clicli.const.MouseKey[key]
        or key
    return GameAPI.player_key_is_pressed(self.handle, key)
end

---Get the player's unique name
---@return string name Attribute name
function M:get_platform_name()
    return self.handle:get_role__unique_name() or ''
end

---Get the player's encrypted UUID
---@return string
function M:get_platform_uuid()
    ---@diagnostic disable-next-line: return-type-mismatch
    return self.handle:get_encry_uuid()
end

---Send hints to the player
---@param msg string Message
---@param localize? boolean Specifies whether locale is supported
function M:display_info(msg, localize)
    GameAPI.show_msg_to_role(self.handle, msg, localize)
end

---Gets currency ICONS for player attributes
---@param key py.RoleResKey attribute name
---@return integer icon Icon id
function M.get_res_icon(key)
    return GameAPI.get_role_res_icon(key)
end

---Gets the player attribute name
---@param key py.RoleResKey attribute name
---@return string name Attribute name
function M.get_res_name(key)
    return GameAPI.get_role_res_name(key)
end

--Set filter
---@param value integer Filter
function M:set_color_grading(value)
    GameAPI.set_role_color_grading(self.handle, value)
end

---Show/hide the player's surface texture
---@param is_visible boolean Show/hide
function M:set_local_terrain_visible(is_visible)
    GameAPI.set_local_terrain_visible(self.handle, is_visible)
end

---@param player Player
---@param is_enable boolean switch
---Set the dark corner switch
function M.enable_vignetting(player, is_enable)
    player.handle:set_role_vignetting_enable(is_enable)
end

---Set the dark Angle size
---@param size number Size
function M:set_vignetting_size(size)
    self.handle:set_role_vignetting_size(size)
end

---Set the dark Angle breathing cycle
---@param circle_time number Respiratory cycle
function M:set_role_vignetting_breath_rate(circle_time)
    self.handle:set_role_vignetting_breath_rate(circle_time)
end

---Set the amplitude of the dark Angle change
---@param range number Range
function M:set_vignetting_change_range(range)
    self.handle:set_role_vignetting_change_range(range)
end

---Set the dark corner color
---@param red number Color r
---@param green number Color g
---@param blue number Color b
---@param time number Transition time
function M:set_vignetting_color(red, green, blue, time)
    self.handle:set_role_vignetting_color(red, green, blue, time)
end

--Quit the game
function M:exit_game()
    GameAPI.exit_game(self.handle)
end

--Get local players, be aware that this may cause out-of-sync!
--Warning: If you are not sure what this function is doing, do not use it!
--
--> Obsolete: use 'clicli.player.with_local' instead
---@deprecated
---@return Player
function M.get_local()
    return M.LOCAL_PLAYER
end

--Gets attribute names for all player attributes
---@param only_coin boolean # Only gets player attributes for currency types
---@return py.RoleResKey[]
function M.get_res_keys(only_coin)
    local py_list = GameAPI.iter_role_res(only_coin)
    return clicli.helper.unpack_list(py_list)
end

--Displays a text message to the player
---@param message string # message
---@param localize? boolean # Whether locale is supported
function M:display_message(message, localize)
    GameAPI.show_msg_to_role(self.handle, message, localize or false)
end

--Upload the buried data
---@param key string
---@param cnt integer
function M:upload_tracking_data(key, cnt)
    GameAPI.api_upload_user_tracking_data(self.handle, key, cnt)
end

---Get data on how players interact with the community
---@param community_type clicli.Const.PlatFormRoleCommunityType
---@return integer
function M:get_community_value(community_type)
    return self.handle:api_get_community_value(clicli.const.PlatFormRoleCommunityType[community_type] or community_type) or 0
end

---Gets the sign-in days for the player's current map
---@param sign_type? clicli.Const.SignInDaysType
---@return integer
function M:get_sign_in_days(sign_type)
    return self.handle:api_get_sign_in_days_of_platform(clicli.const.SignInDaysType[sign_type] or sign_type or 0) or 0
end

---Whether the player saves the current map
---@return boolean
function M:is_bookmark_current_map()
    return self.handle:api_is_bookmark_current_map() or false
end

---Request execution of random pool drop
---After the execution is complete, the callback function is called with the following parameters:
---* 'code' : result code
---+ '0' : success
---+ '1' : The trigger interval is not met
---+ '2' : The daily limit is not met
---+ '999' : The server cannot be connected and must be on the platform to test
---* 'result' : Result table, 'key' represents the affected archive number, 'value' represents the changed value
---@param id integer # Number of the random pool
---@param callback fun(code: 0|1|2|999, result: { [integer]: integer }) # Callback function after execution
function M:request_random_pool(id, callback)
    local response = {}
    GameAPI.lua_request_server_random_pool_result(self.handle, id, function ()
        local code = response['__random_pool_ret_code']
        local result = clicli.helper.dict_to_table(response['__random_pool_result_dict'])
        xpcall(callback, log.error, code, result)
    end, response)
end

---Request to use Mall items
---After the execution is complete, the callback function is called to notify whether it was successful
---@param count integer # Quantity used
---@param item_id py.StoreKey # Shop item id
---@param callback fun(suc: boolean) # Callback function after execution
function M:request_use_item(count, item_id, callback)
    GameAPI.lua_request_server_role_use_item(self.handle, count, item_id, function (_, suc)
        callback(suc)
    end, {})
end

---Request to purchase Mall currency
---@param goods_id string
---@param callback? fun(suc: boolean, sn? : string, error_code? : integer)
function M:request_buy_mall_coin(goods_id, callback)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_buy_mall_coin(self.handle, goods_id, function (context)
        if callback then
            local error_code = context['__error_code']
            if error_code then
                xpcall(callback, log.error, false, nil, error_code)
                return
            end
            --Order number
            local sn = context['__str1']
            local status = context['__int1']
            xpcall(callback, log.error, status == 0, sn, status)
        end
    end, {})
end

---@class MallGoodsInfo
---@field is_exist boolean # Existence or not
---@field effective_time integer # Effective time
---@field expiration_time integer # Expiration time
---@field left_token integer # Quantity of surplus money

---Get information about a player's store items
---@param goods_id string
---@param callback fun(info: MallGoodsInfo)
function M:request_mall_goods_info(goods_id, callback)
    ---@diagnostic disable-next-line: param-type-mismatch
    GameAPI.lua_request_server_mall_goods_info(self.handle, tostring(goods_id), function (context)
        xpcall(callback, log.error, {
            is_exist = context['__bool1'],
            effective_time = context['__mall_goods_effective_time'],
            expiration_time = context['__mall_goods_expiration_time'],
            left_token = context['__float1']
        })
    end, {})
end

---Request to purchase mall items
---@param count integer # quantity
---@param goods_id integer # Shop item id
---@param callback? fun(suc: boolean, error_code: integer) # Callback function after execution
function M:request_mall_purchase_goods(count, goods_id, callback)
    ---@diagnostic disable-next-line: undefined-field, param-type-mismatch
    GameAPI.lua_request_server_mall_purchase_goods(self.handle, count, goods_id, function (context)
        if callback then
            local error_code = context['__error_code']
            xpcall(callback, log.error, error_code == 0, error_code)
        end
    end, {})
end

---Request to generate random numbers
---@param group_id integer # id of a random read-only archive group
---@param key string # The key of a random number
---@param callback fun(value: integer) # Callback function after execution
function M:request_random_number(group_id, key, callback)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_generate_random_number(self.handle, key, group_id, function (context)
        local result = context['__random_number_err_code']
        xpcall(callback, log.error, result)
    end, {})
end

---Request the player's open save data
---@param callback fun(archive: any) # Callback function after execution
function M:request_open_archive(callback)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_role_open_archive(self.handle, function (context)
        xpcall(callback, log.error, context['__role_open_archive'])
    end, {})
end

---Update archive leaderboard
---@param save_index integer # Archive field
function M:update_save_rank(save_index)
    self.handle:update_player_save_rank(save_index)
end

return M
