---All interfaces are asynchronous
---@class Steam
local M = {}

---[Asynchronous] Get the local player's party id in the party system. Return '0' if not in the team.
---@return integer
function M.get_team_id()
    return GameAPI.steam_get_team_id() or 0
end

---[Asynchronous] Gets the local player's player aid.
---@return integer
function M.get_player_aid()
    return GameAPI.steam_get_player_id() or 0
end

---[Asynchronous] Get the local player's avatar resource url
---@return string
function M.get_avatar_url()
    return GameAPI.steam_get_player_head_icon_url() or ''
end

---Asynchronous Request starts matching
---@param score integer # Matching score
---@param level_id string # Target map id
---@param game_mode? integer # Object map mode
function M.start_match(score, level_id, game_mode)
    M.request_start_match(score, level_id, game_mode)
end

---Asynchronous Requests to cancel a match
function M.cancel_match()
    M.request_cancel_match()
end

---@alias Steam.TeamState
---| 1 # Free
---| 2 # Matching

---Asynchronous: Gets the status of the current team
---@return Steam.TeamState state
function M.get_team_state()
    return GameAPI.steam_get_team_state()
end

---Asynchronous: Get the state of the local player
---@return clicli.Const.SteamOnlineState state
function M.get_player_state()
    return GameAPI.steam_get_player_state() --[[@as clicli.Const.SteamOnlineState]]
end

---Asynchronous: Get the nickname of the local player
---@return string
function M.get_nickname()
    return GameAPI.steam_get_player_nickname() or ''
end

---Get the player's store items
---@param player Player
---@return {
---item_id: integer,
---group_name: string,
---second_name: string,
---nickname: string,
---} []
function M.get_player_store_items(player)
    return GameAPI.steam_get_player_storm_items(player.handle)
end

---Asynchronous: Sets the global archive value
---@param key string
---@param value string|integer
function M.set_global_archive_data(key, value)
    ---@diagnostic disable-next-line: param-type-mismatch
    GameAPI.set_steam_global_archive_data(key, value)
end

---[Asynchronous] Adds a global archive value
---@param key string
---@param value integer
function M.add_global_archive_data(key, value)
    GameAPI.add_steam_global_archive_data(key, value)
end

---@alias Steam.FriendState.ShowState
---| 1 # is online
---| 2 # Busy
---| 3 # Invisibility

---@alias Steam.FriendState {
---group_id: integer,
---group_name: string,
---second_name: string,
---nickname: string,
---head_icon: string,
---online: clicli.Const.SteamOnlineState,
---level: integer,
---aid: integer,
---show_state: Steam.FriendState.ShowState,
---state: any,
---}

---Asynchronously request your own friend list
---@param callback fun(friends: Steam.FriendState[])
function M.request_friends(callback)
    local context = {}
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_mall_friends(function ()
        xpcall(callback, log.error, context['__lua_table'])
    end, context)
end

local function callback_with_error_code(callback, context, ...)
    if not callback then
        return
    end
    local ret = context['__error_code'] or context['__int1']
    if type(ret) == 'userdata' then
        ---@diagnostic disable-next-line: undefined-field
        ret = ret.errnu
    end
    local result = ...
    if select('#', ...) == 0 then
        result = ret == 0
    end
    xpcall(callback, log.error, result, ret)
end

---Asynchronous Request to add a friend
---@param aid integer # aid of the other party
---@param callback? fun(success: boolean, error_code? : integer)
function M.request_add_friend(aid, callback)
    local context = {}
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_mall_add_friend(aid, function ()
        if callback then
            callback_with_error_code(callback, context)
        end
    end, context)
end

---Asynchronous Request to delete a friend
---@param aid integer # aid of the other party
---@param callback? fun(success: boolean, error_code? : integer)
function M.request_delete_friend(aid, callback)
    local context = {}
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_delete_friend(aid, function ()
        if callback then
            callback_with_error_code(callback, context)
        end
    end, context)
end

---Asynchronous: Reply to a friend request
---@param aid integer # aid of the other party
---@param accept boolean # Whether to accept or not
---@param callback? fun(success: boolean, error_code? : integer)
function M.reply_friend_add(aid, accept, callback)
    local context = {}
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_reply_friend_add(aid, accept, function ()
        if callback then
            callback_with_error_code(callback, context)
        end
    end, context)
end

---Asynchronous request to start the game (mismatch), only the team leader can call
---@param level_id? string # Target map id
---@param game_mode? integer # Object map mode
---@param callback? fun(success? : boolean, error_code? : integer)
function M.request_start_game(level_id, game_mode, callback)
    local context = {}
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_steam_start_game(function ()
        if callback then
            callback_with_error_code(callback, context)
        end
    end, context, level_id or clicli.game:get_level(), game_mode or 1002)
end

---Asynchronous Requests to join a team
---@param team_id integer # Team id
---@param callback? fun(success: boolean, error_code? : integer)
function M.request_join_team(team_id, callback)
    local context = {}
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_join_team_by_team_id(team_id, function ()
        if callback then
            callback_with_error_code(callback, context)
        end
    end, context)
end

---Asynchronous Requests to join a team
---@param name string # The player name of the opposing team
---@param callback? fun(success: boolean, error_code? : integer)
function M.request_join_team_by_name(name, callback)
    local context = {}
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_join_team(name, function ()
        if callback then
            callback_with_error_code(callback, context)
        end
    end, context)
end

---【 Asynchronous 】 Invite players to join the party
---@param aid integer # aid of the other party
---@param callback? fun(success: boolean, error_code? : integer)
function M.request_invite_join_team(aid, callback)
    local context = {}
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_invite_join_team(aid, function ()
        if callback then
            callback_with_error_code(callback, context)
        end
    end, context)
end

---Asynchronous: Reply to a team invitation
---@param aid integer # aid of the other party
---@param team_id integer # Team id
---@param accept boolean # Whether to accept or not
---@param callback? fun(success: boolean, error_code? : integer)
function M.reply_team_invite(aid, team_id, accept, callback)
    local context = {}
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_team_invite(aid, team_id, accept, function ()
        if callback then
            callback_with_error_code(callback, context)
        end
    end, context)
end

---Asynchronous Request to exit the queue
---@param callback? fun(success: boolean, error_code? : integer)
function M.request_quit_team(callback)
    local context = {}
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_quit_team(function ()
        if callback then
            callback_with_error_code(callback, context)
        end
    end, context)
end

---@alias Steam.MemberInfo {
---account_id: integer,
---level: integer,
---nickname: string,
---head_icon: string,
---state: clicli.Const.SteamOnlineState,
---show_state: Steam.FriendState.ShowState,
---online: clicli.Const.SteamOnlineState,
---team_id: integer,
---is_captain: boolean,
---}

---Asynchronous: Requests team information for a specified player
---@param aid integer # aid of the other party
---@param callback fun(team_info? : Steam.MemberInfo[], error_code? : integer)
function M.request_team_info(aid, callback)
    local context = {}
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_mall_team_info_by_adi(aid, function ()
        xpcall(callback, log.error, context['__lua_table'], context['__error_code'])
    end, context)
end

---Asynchronous: Forward to the leader, only the leader can call
---@param aid integer # aid of the other party
---@param callback? fun(success: boolean, error_code? : integer)
function M.request_transfer_captain(aid, callback)
    local context = {}
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_transform_team_leader(aid, function ()
        if callback then
            callback_with_error_code(callback, context)
        end
    end, context)
end

---Asynchronous Request to kick a player from the team, only the team leader can call
---@param aid integer # aid of the other party
---@param callback? fun(success: boolean, error_code? : integer)
function M.request_kick_member(aid, callback)
    local context = {}
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_kick_from_team(aid, function ()
        if callback then
            callback_with_error_code(callback, context)
        end
    end, context)
end

---[Asynchronous] Queries the player's aid based on the player's nickname
---@param nickname string # Player nickname
---@param callback fun(aid? : integer, error_code? : integer)
function M.request_aid_by_nickname(nickname, callback)
    local context = {}
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_mall_player_adi_by_nickname(nickname, function ()
        xpcall(callback, log.error, context['__int1'], context['__error_code'])
    end, context)
end

---Asynchronous Request to create a queue
---@param team_num integer # Headcount ceiling
---@param callback? fun(success: boolean, error_code? : integer)
function M.request_create_team(team_num, callback)
    local context = {}
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_create_team(function ()
        if callback then
            callback_with_error_code(callback, context)
        end
    end, context, team_num)
end

---Asynchronous Request starts matching
---@param score integer # Matching score
---@param level_id? string # Target map id
---@param game_mode? integer # Object map mode
---@param callback? fun(success? : boolean, error_code? : integer)
function M.request_start_match(score, level_id, game_mode, callback)
    local context = {}
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_start_match(score, level_id or clicli.game:get_level(), game_mode or 1002, function ()
        if callback then
            callback_with_error_code(callback, context)
        end
    end, context)
end

---Asynchronous Requests to cancel a match
---@param callback? fun(success: boolean, error_code? : integer)
function M.request_cancel_match(callback)
    local context = {}
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_cancel_match(function ()
        if callback then
            callback_with_error_code(callback, context)
        end
    end, context)
end

---[Asynchronous] Request global archive data
---@param callback fun(data: (string | integer)[], error_code? : integer)
function M.request_global_archive_datas(callback)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_mall_global_archive(function (context)
        local data = context['__lua_table']
        callback_with_error_code(callback, context, data)
    end, {})
end

---Asynchronous: File path of the request profile picture
---@param url string # The network address of the profile picture
---@param callback fun(path: string) # Call back after the image is downloaded. The parameter is the file path after downloading
function M.request_icon(url, callback)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_team_icon(url, function (context)
        xpcall(callback, log.error, context['__IMAGE_KEY__'])
    end, {})
end

---[Asynchronous] Request to settle ladder points
---@param player Player
---@param params table<string, any> # Settlement parameter
---@param callback? fun(result: {
---id: integer,
---new_score: integer,
---delta_score: integer,
---})
function M.request_roll_settle_ladder_score(player, params, callback)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_roll_settle_ladder_score(player.handle, params, function (context)
        if callback then
            xpcall(callback, log.error, {
                id = context['__settle_role_id'],
                new_score = context['__new_value'],
                delta_score = context['__diff_value'],
            })
        end
    end, {})
end

---Asynchronous Request to create a room
---@param room_name string # Room name
---@param callback fun(room_info?: Steam.FullRoomInfo, error_code?: integer) # Callback after successful creation. The parameter is room id
---@param mode_id? integer # Mode id. The default value is 1002
---@param password? string # Room password, such as' nil 'or empty string, means that no password is required
function M.request_create_room(room_name, callback, mode_id, password)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_server_create_room(room_name, function (context)
        local room_info = context['__lua_table']
        room_info = M.convert_room_info(room_info)
        callback_with_error_code(callback, context, room_info)
    end, {}, mode_id, password)
end

---@class Steam.SimpleRoomInfo
---@field room_id integer
---@field room_name string
---@field curr_player_number integer
---@field max_player_number integer
---@field is_public boolean # A password is required to join non-public rooms
---@field room_state clicli.Const.SteamRoomState
---@field rooms_total_num integer

---Asynchronous Requests a list of rooms
---@param page integer # Which page, each page will have a maximum of 100 results
---@param callback fun(rooms? : Steam.SimpleRoomInfo[], error_code? : integer)
function M.request_room_list(page, callback)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_server_room_list_info(function (context)
        local rooms = context['__lua_table']
        callback_with_error_code(callback, context, rooms)
    ---@diagnostic disable-next-line: param-type-mismatch
    end, {}, page)
end

---Asynchronous Request to join a room
---@param room_id integer
---@param callback fun(room_info? : Steam.FullRoomInfo, error_code? : integer)
---@param password? string
function M.request_join_room(room_id, callback, password)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_server_join_room(room_id, function (context)
        local room_info = context['__lua_table']
        room_info = M.convert_room_info(room_info)
        callback_with_error_code(callback, context, room_info)
    ---@diagnostic disable-next-line: param-type-mismatch
    end, {}, password)
end

---@class steam.Room.BaseInfo
---@field room_name string
---@field passwd string
---@field is_public boolean
---@field lv_min integer
---@field lv_max integer
---@field room_client_id integer

---@class steam.Room.SlotInfo
---@field slot integer
---@field nickname string
---@field head_icon string
---@field locked boolean
---@field ai_type 5 | 6
---@field state clicli.Const.SteamRoomSlotState
---@field is_ready any
---@field is_owner boolean
---@field aid integer
---@field in_game boolean

---@private
function M.convert_room_info(info)
    if info and info['slot_info'] then
        for _, slot in ipairs(info['slot_info']) do
            if slot.locked then
                slot.state = clicli.const.SteamRoomSlotState['Off']
            else
                if slot.ai_type == 5 then
                    slot.state = clicli.const.SteamRoomSlotState['Simple computer']
                elseif slot.ai_type == 6 then
                    slot.state = clicli.const.SteamRoomSlotState['Hard computer']
                else
                    slot.state = clicli.const.SteamRoomSlotState['unpack']
                end
            end
        end
    end
    return info
end

---@class Steam.FullRoomInfo
---@field base_info steam.Room.BaseInfo
---@field slot_info steam.Room.SlotInfo[]

---Asynchronous Requests information about the room where the specified user resides
---@param aid integer
---@param callback fun(info? : Steam.FullRoomInfo, error_code? : integer)
function M.request_room_info(aid, callback)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_server_room_info(aid, function (context)
        local info = context['__lua_table']
        M.convert_room_info(info)
        callback_with_error_code(callback, context, info)
    end, {})
end

---[Asynchronous] Request the room to start the game
---@param callback fun(success: boolean, error_code? : integer)
function M.request_room_start_game(callback)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_server_room_strat_game(function (context)
        callback_with_error_code(callback, context)
    end, {})
end

---[Asynchronous] Invite the player to join the room
---@param aid integer
---@param callback fun(success: boolean, error_code? : integer)
function M.request_invite_join_room(aid, callback)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_server_invite_player_join_room(aid, function (context)
        callback_with_error_code(callback, context)
    end, {})
end

---[Asynchronous] Accept a room invitation
---@param aid integer
---@param room_id integer
---@param callback fun(success: boolean, error_code? : integer)
function M.reply_accpet_room_invite(aid, room_id, callback)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_server_reply_room_invite(aid, room_id, function (context)
        callback_with_error_code(callback, context)
    end, {})
end

---Asynchronous Requests to swap room slots
---@param slot integer # Target slot
---@param callback fun(success: boolean, error_code? : integer)
function M.request_change_room_slot(slot, callback)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_server_change_room_slot(slot, function (context)
        callback_with_error_code(callback, context)
    end, {})
end

---Asynchronous requests that the homeowner be handed over to another user
---@param aid integer # The aid of the target user
---@param callback fun(success: boolean, error_code? : integer)
function M.request_change_owner(aid, callback)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_server_change_owner(aid, function (context)
        callback_with_error_code(callback, context)
    end, {})
end

---Asynchronous: Request to exit the room you are in
---@param callback fun(success: boolean, error_code? : integer)
function M.request_exit_room(callback)
    local aid = M.get_player_aid()
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_server_exit_room(aid, function (context)
        callback_with_error_code(callback, context)
    end, {})
end

---Asynchronous Requests the user to be kicked out of the room
---@param aid integer # The aid of the target user
---@param callback fun(success: boolean, error_code? : integer)
function M.request_kick_from_room(aid, callback)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_server_kick_from_room(aid, function (context)
        callback_with_error_code(callback, context)
    end, {})
end

---Asynchronous Requests to change the state of a slot in a room
---@param slot integer # Target slot
---@param state clicli.Const.SteamRoomSlotState # Target state
---@param callback fun(success: boolean, error_code? : integer)
function M.request_change_slot_state(slot, state, callback)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_server_set_site_state(slot, state, function (context)
        callback_with_error_code(callback, context)
    end, {})
end

---[Asynchronous] Request to change the room password
---@param password? string # Room password, such as' nil 'or empty string, means that no password is required
---@param callback? fun(success: boolean, error_code? : integer)
function M.request_change_room_password(password, callback)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_server_change_room_password(password or '', function (context)
        callback_with_error_code(callback, context)
    end, {})
end

---[Asynchronous] Request to change the room name
---@param name string # Room name
---@param callback? fun(success: boolean, error_code? : integer)
function M.request_change_room_name(name, callback)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_change_room_name(name, function (context)
        callback_with_error_code(callback, context)
    end, {})
end

---【 Asynchronous 】 Get the currency used by local players on steam
---@return string | 'CNY'
function M.get_steam_currency()
    ---@diagnostic disable-next-line: undefined-field
    return GameAPI.get_steam_player_currency()
end

---【 Asynchronous 】 Gets the price of the specified steam item in the local player's current currency
---@param goods_id integer | string
---@return number?
function M.get_steam_goods_price(goods_id)
    ---@diagnostic disable-next-line: undefined-field
    return clicli.helper.tonumber(GameAPI.get_steam_goods_price(tostring(goods_id)))
end

return M
