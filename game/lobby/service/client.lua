require 'clicli.game.lobby.service.define'
local const = require "clicli.game.lobby.network.protocol"
local fsm = require "clicli.game.lobby.network.fsm"

---@class LobbyClient
---@field public ClientPush_ClientRegister fun(self: LobbyClient, aid: integer):boolean, string
---comment: 'Register the client. After successful registration, you will receive a push message from the server, which will be called during game initialization
---param aid player id
---return boolean, string
---@field public ClientPush_ClientUnregister fun(self: LobbyClient, aid: integer):boolean, string
---comment Log Out Client
---param aid player id
---return boolean, string
---@field public Team_UpdatePlayerInfo fun(self: LobbyClient, player_info: PlayerInfo):boolean, string
---comment: 'Report/Update player information. All business relies on player information. Report during game initialization
---param player_info Player information
---return boolean, string
---@field public Team_Login fun(self: LobbyClient, player_info: PlayerInfo): boolean, string
---comment 'Login
---param player_info Player information
---return boolean, string
---@field public Team_DelPlayerInfo fun(self: LobbyClient, aid: integer):boolean, string
---comment: 'Remove player information. Please call it before exiting the game'
---param aid player id
---return boolean, string
---------------- team related ----------------
---@field public Team_CreateTeam fun(self: LobbyClient, aid: integer, member_limit: integer):boolean, string
---comment: Request to create a team, with aid as the team leader
---param aid player id
---return boolean, string
---@field public Team_LeaveTeam fun(self: LobbyClient, aid: integer):boolean, string
---comment: 'Request to Leave the Team
---param aid player id
---return boolean, string
---@field public Team_JoinTeam fun(self: LobbyClient, aid: integer, team_id: integer):boolean, string
---comment: 'Request to Join the Team
---param aid player id
---param team_id team id
---return boolean, string
---@field public Team_TeamKick fun(self: LobbyClient, aid: integer, kicki_aid: integer):boolean, string
---comment: 'Request to Be Kicked Out of the Team
---param aid player id
---The target player id kicked out by param kicki_aid
---return boolean, string
---@field public Team_ChangeTeamLeader fun(self: LobbyClient, aid: integer, new_leader_aid: integer):boolean, string
---comment: 'Request to Transfer the Captain'
---param aid player id
---The captain player id transferred by param new_leader_aid
---return boolean, string
---@field public Team_GetTeamInfoByAid fun(self: LobbyClient, aid: integer):boolean, string
---comment: 'Request Information of the Player is team'
---param aid player id
---return boolean, string
---@field public Team_DismissTeam fun(self: LobbyClient, aid: integer):boolean, string
---comment: 'Request to Disband the team
---param aid player id
---return boolean, string
---------------- team related ----------------
---------------- matches related ----------------
---@field public Match_startMatch fun(self: LobbyClient, unit_id: integer, score: integer, is_team: boolean, match_info: MatchInfo):boolean, string
---comment: 'Request Begins Matching'
---param unit_id matches the unit id, with the player id for a single person and the team id for multiple people
---param score score
---param is_team is not a team
---param match_info matching information
---return boolean, string
---@field public Match_cancelMatch fun(self: LobbyClient, unit_id: integer):boolean, string
---comment: 'Request to Leave the Match
---param unit_id matches the unit id, with the player id for a single person and the team id for multiple people
---return boolean, string
---------------- matches related ----------------
---------------- chat-related ----------------
---@field public ApiRouter_SendChatMsg fun(self: LobbyClient, sender: integer, chat_msg: string, channel_type: integer, dst_id: integer, flag: integer):boolean, string
---@field public ApiRouter_UpdateChannel fun(self: LobbyClient, op_type: integer, channel_type: integer, channel_id: integer, members: integer[], game_play_id: integer):boolean, string
---comment: 'Send Chat Message
---param sender Sender player id
---param chat_msg chat message
---param channel_type chat channel type, fill in 4 ChannelType.Team for team channel
---param dst_id channel id, team chat is the team id
---The param flag is not needed for the time being. Just fill in 0
---return boolean, string
---------------- chat-related ----------------
---------------- start the game ----------------
---@field public BattleCreate_CreateMultiBattleSpace fun(self: LobbyClient, battle_info: MultiBattleField):boolean, string
---comment: 'Create a Multiplayer Battlefield (Local Multi-instance)'
---param battle_info battlefield information
---return boolean, string
---@class LobbyClient
---@field public DungeonManager_StartMatchPrivateDungeonGame fun(self: LobbyClient, dungeonSpaceInfo: DungeonSpaceField, players: DungeonPlayerField[]):boolean, string
---comment: 'Request Multiple People to Switch Copies
---param dungeonSpaceInfo copy information
---param players list Each item must include "aid" and "version". Currently, "version" is fixed to be passed as '2.0'.
---return boolean, string
---------------- start the game ----------------

---@class LobbyClient
---@field public call_table table<string, CallInfo> 'call table'
local M = Class 'LobbyClient'
local pb = require 'clicli.game.lobby.proto.proto_helper'
local msg_handler_api = require 'clicli.game.lobby.network.message_handler'
function M:__init(ip, port, aid, token, game_play_id)
    self.ip = ip
    self.port = port
    self.aid = aid
    self.token = token
    self.game_play_id = game_play_id
    self.call_table = {}
    self.event_handler = nil
    log.info("[Client] new client ", self.aid, self.token and "<redacted>" or "<missing>", self.ip, self.port)
    self.message_handler = msg_handler_api.new(self.ip, self.port, 60)
    self.message_handler:set_network_event_handle(function(event)
        M.handle_net_event(self, event)
    end)
    self.proto_helper = pb.init_pb()
    local mt = {
        __index = function(obj, func_name)
            if obj.proto_helper:is_service_method(func_name) then
                return function(...)
                    local args = {...}
                    local pb_args = {}
                    for i = 2, #args do
                        pb_args["arg" .. (i - 1)] = args[i]
                    end
                    local pb_type = "protocol." .. func_name ..'_args'
                    return M.send_data(obj, pb_type, pb_args)
                end
            else
                return M[func_name]
            end
        end
    }
    setmetatable(self, mt)
    self:init_state_machine()
end

---@private
--initialize the state machine
function M:init_state_machine()
    self.state_machine = fsm:new()

    self.state_machine:init()
    --add state
    self.state_machine:add_state("connecting", function() return self:do_connect() end, nil)
    self.state_machine:add_state("connected", function () return self:login_auth() end, nil)
    self.state_machine:add_state("login", function() return self:do_client_register() end, nil)
    self.state_machine:add_state("disconnect", function() return self:do_disconnect() end, nil)

    --add transition
    self.state_machine:add_transition("connecting", "connected")
    self.state_machine:add_transition("connected", "disconnect")
    self.state_machine:add_transition("disconnect", "connecting")
    self.state_machine:add_transition("connected", "login")
    self.state_machine:add_transition("login", "disconnect")
end

---Registration event callback
---@param event_handler fun(net_event, ...) # network event handle
function M:on_event(event_handler)
    self.event_handle = event_handler
end

---Call the event callback
---@param event string # event name
---@param ... any
function M:notify_event_handler(event, ...)
    if self.event_handle ~= nil then
        self.event_handle(event, ...)
    end
end

---@private
---client register
---@return boolean # success or false
function M:do_client_register()
    log.info("[Client] start client register ", self.ip, self.port)
    self:notify_event_handler("login")
    self:ClientPush_ClientRegister(self.aid)
    return true
end

---@private
---connect
---@return boolean # success or false
function M:do_connect()
    self:notify_event_handler("connecting")
    log.info("[Client] start connect ", self.ip, self.port)
    self.message_handler:start()
    return true
end

---@private
---disconnect
---@return boolean # success or false
function M:do_disconnect()
    self:notify_event_handler("disconnect")
    log.info("[Client] disconnect")
    if self._closing then
        return true
    end
    clicli.ltimer.wait_frame(1, function()
        if IsValid(self) then
            self:start()
        end
    end)
    return true
end

---Actively close the current connection and reconnect.
---@param reason? string
---@return boolean
function M:reconnect(reason)
    log.warn('[Client] reconnect:', reason or 'unknown')
    self._closing = false
    self.message_handler:shutdown()
    return self.state_machine:change_state('disconnect')
end

function M:start()
    if self._closing then
        return false
    end
    log.info("[Client] client start ", self.ip, self.port, self.aid)
    self.state_machine:change_state("connecting")
    return true
end

---Close the connection and do not reconnect automatically.
---@param reason? string
---@return boolean
function M:close(reason)
    if self._closing then
        return false
    end
    self._closing = true
    log.info('[Client] close:', reason or 'unknown')
    self.message_handler:shutdown()
    return true
end

function M:__del()
    self:close('delete')
    Delete(self.message_handler)
    return true
end

--Unique id generator
local function createUniqueIdGenerator()
    local id = 0
    return function()
        id = id + 1
        return id
    end
end
local generateUniqueId = createUniqueIdGenerator()

--Send a message
---@param pb_type string pb type
---@param data table pb data
---@return boolean, string|nil
function M:send_data(pb_type, data)
    local pb_encoded_data = self.proto_helper:encode(pb_type, data)
    local pb_desc = self.proto_helper:get_pb_desc(pb_type)
    if pb_desc == nil then
        log.warn("pb_type not found")
        return false, "pb_type not found"
    end
    local new_call_id = generateUniqueId()
    self.call_table[new_call_id] = {
        call_id = new_call_id,
        service_uuid = pb_desc['service_uuid'],
        method_index = pb_desc['method_index'],
        request_data = data
    }
    return self.message_handler:send_request(pb_desc['service_uuid'], new_call_id, pb_desc['method_index'], pb_encoded_data)
end

function M:handle_net_event(event)
    if event.protocol_type == const.msgtype.RPC_RETURN then
        local call_id = event.call_id
        local call_info = self.call_table[call_id]
        self.call_table[call_id] = nil
        if call_info == nil then
            log.warn("call_info not found")
            return
        end
        local ret_pb_type = self.proto_helper:get_pb_ret_type(call_info.service_uuid, call_info.method_index)
        if ret_pb_type == nil then
            log.warn("pb_desc not found", call_info.service_uuid, call_info.method_index)
            return
        end
        local pb_data = self.proto_helper:decode(ret_pb_type, event.proto_data)
        if pb_data == nil then
            log.warn("pb_data decode failed", ret_pb_type)
            return
        end
        local method_name = string.gsub(ret_pb_type, 'protocol.', '')
        M[method_name](self, event.error_id, call_info.request_data, pb_data)
        return
    end
    if event.protocol_type == const.msgtype.RPC_CALL then
        local method_info = self.proto_helper:get_method_info(event.message_id, event.method_id)
        if method_info == nil then
            log.warn("method_info not found", event.message_id, event.method_id)
            return
        end
        local pb_type = method_info['args_pb_name']
        local pb_data = self.proto_helper:decode(pb_type, event.proto_data)
        if pb_data == nil then
            log.warn("pb_data decode failed", pb_type)
            return
        end
        local method_name = method_info['method_name']
        M[method_name](self, pb_data)
        return
    end
    if event.protocol_type == const.msgtype.RPC_EVENT then
        if event.sub_type == const.event_subtype.ON_RUNNING then
            self.state_machine:change_state("connected")
            return
        elseif event.sub_type == const.event_subtype.LOSE_CONNECTION then
            --Disconnect the link and request to reconnect
            self.state_machine:change_state("disconnect")
        end
        return
    end
    if event.protocol_type == const.msgtype.RAW_PROTOCOL then
        self.state_machine:change_state("login")
    end
end

------------------- returns packet message -------------------
--Log back to the package
---@param error_id integer Error id
---@param request_data table request message
---@param response_data table packet return message
function M:Team_Login_ret(error_id, request_data, response_data)
    if error_id ~= 1 then
        log.warn("Team_Login_ret failed", error_id)
    end
    self:notify_event_handler('ret', 'Team_Login', error_id, request_data, response_data)
end


---Report the player information back package
---@param error_id integer Error id
---@param request_data table request message
---@param response_data table packet return message
function M:Team_UpdatePlayerInfo_ret(error_id, request_data, response_data)
    if error_id ~= 1 then
        log.warn("Team_UpdatePlayerInfo_ret failed", error_id)
    end
    self:notify_event_handler('ret', 'Team_UpdatePlayerInfo', error_id, request_data, response_data)
end

---Delete the player information return package
---@param error_id integer Error id
---@param request_data table request message
---@param response_data table packet return message
function M:Team_DelPlayerInfo_ret(error_id, request_data, response_data)
    if error_id ~= 1 then
        log.warn("Team_DelPlayerInfo_ret failed", error_id)
    end
    self:notify_event_handler('ret', 'Team_DelPlayerInfo', error_id, request_data, response_data)
end

---Create team backpacks
---@param error_id integer Error id
---@param request_data table request message
---@param response_data table packet return message
function M:Team_CreateTeam_ret(error_id, request_data, response_data)
    if error_id ~= 1 then
        log.warn("Team_CreateTeam_ret failed", error_id)
    end
    self:notify_event_handler('ret', 'Team_CreateTeam', error_id, request_data, response_data)
end

---Leave the team and return the package
---@param error_id integer Error id
---@param request_data table request message
---@param response_data table packet return message
function M:Team_LeaveTeam_ret(error_id, request_data, response_data)
    if error_id ~= 1 then
        log.warn("Team_LeaveTeam_ret failed", error_id)
    end
    self:notify_event_handler('ret', 'Team_LeaveTeam', error_id, request_data, response_data)
end

---Join the team and return the package
---@param error_id integer Error id
---@param request_data table request message
---@param response_data table packet return message
function M:Team_JoinTeam_ret(error_id, request_data, response_data)
    if error_id ~= 1 then
        log.warn("Team_JoinTeam_ret failed", error_id)
    end
    self:notify_event_handler('ret', 'Team_JoinTeam', error_id, request_data, response_data)
end

---Kick out of the team and return the package
---@param error_id integer Error id
---@param request_data table request message
---@param response_data table packet return message
function M:Team_TeamKick_ret(error_id, request_data, response_data)
    if error_id ~= 1 then
        log.warn("Team_TeamKick_ret failed", error_id)
    end
    self:notify_event_handler('ret', 'Team_TeamKick', error_id, request_data, response_data)
end

---Create team backpacks
---@param error_id integer Error id
---@param request_data table request message
---@param response_data table packet return message
function M:Team_ChangeTeamLeader_ret(error_id, request_data, response_data)
    if error_id ~= 1 then
        log.warn("Team_ChangeTeamLeader_ret failed", error_id)
    end
    self:notify_event_handler('ret', 'Team_ChangeTeamLeader', error_id, request_data, response_data)
end

---Obtain the team information return packet
---@param error_id integer Error id
---@param request_data table request message
---@param response_data table packet return message
function M:Team_GetTeamInfoByAid_ret(error_id, request_data, response_data)
    if error_id ~= 1 then
        log.warn("Team_GetTeamInfoByAid_ret failed", error_id)
    end
    self:notify_event_handler('ret', 'Team_GetTeamInfoByAid', error_id, request_data, response_data)
end

---Disband the team and return the package
---@param error_id integer Error id
---@param request_data table request message
---@param response_data table packet return message
function M:Team_DismissTeam_ret(error_id, request_data, response_data)
    if error_id ~= 1 then
        log.warn("Team_DismissTeam_ret failed", error_id)
    end
    self:notify_event_handler('ret', 'Team_DismissTeam', error_id, request_data, response_data)
end

---Start matching the return packages
---@param error_id integer Error id
---@param request_data table request message
---@param response_data table packet return message
function M:Match_startMatch_ret(error_id, request_data, response_data)
    if error_id ~= 1 then
        log.warn("Match_startMatch_ret failed", error_id)
    end
    self:notify_event_handler('ret', 'Match_startMatch', error_id, request_data, response_data)
end

---Cancel the matching return package
---@param error_id integer Error id
---@param request_data table request message
---@param response_data table packet return message
function M:Match_cancelMatch_ret(error_id, request_data, response_data)
    if error_id ~= 1 then
        log.warn("Match_cancelMatch_ret failed", error_id)
    end
    self:notify_event_handler('ret', 'Match_cancelMatch', error_id, request_data, response_data)
end

---Send a chat message reply package
---@param error_id integer Error id
---@param request_data table request message
---@param response_data table packet return message
function M:ApiRouter_SendChatMsg_ret(error_id, request_data, response_data)
    if error_id ~= 1 then
        log.warn("Chat_SendChatMsg_ret failed", error_id)
    end
    self:notify_event_handler('ret', 'Chat_SendChatMsg', error_id, request_data, response_data)
end

function M:ApiRouter_UpdateChannel_ret(error_id, request_data, response_data)
    if error_id ~= 1 then
        log.warn("ApiRouter_UpdateChannel_ret failed", error_id)
    end
    self:notify_event_handler('ret', 'Chat_UpdateChannel', error_id, request_data, response_data)
end

---Register the client is return package
---@param error_id integer Error id
---@param request_data table request message
---@param response_data table packet return message
function M:ClientPush_ClientRegister_ret(error_id, request_data, response_data)
    if error_id ~= 1 then
        log.warn("ClientPush_ClientRegister_ret failed", error_id)
    end
    self:notify_event_handler('ret', 'ClientPush_ClientRegister', error_id, request_data, response_data)
end

function M:BattleCreate_CreateMultiBattleSpace_ret(error_id, request_data, response_data)
    if error_id ~= 1 then
        log.warn("BattleCreate_CreateMultiBattleSpace_ret failed", error_id)
    end
    self:notify_event_handler('ret', 'BattleCreate_CreateMultiBattleSpace', error_id, request_data, response_data)
end

function M:DungeonManager_StartMatchPrivateDungeonGame_ret(error_id, request_data, response_data)
    if error_id ~= 1 then
        log.warn("DungeonManager_StartMatchPrivateDungeonGame_ret failed", error_id)
    end
    self:notify_event_handler('ret', 'DungeonManager_StartMatchPrivateDungeonGame', error_id, request_data, response_data)
end

------------------- returns packet message -------------------

------------------- push message -------------------
---Chat message push
---@param data table message
function M:NotiChat(data)
    self:notify_event_handler('chat', data)
end

---Team information push
---@param data table message
function M:UpdateTeamInfo(data)
    self:notify_event_handler('update_team_info', data)
end

---Notification push for leaving the team
---@param data table message
function M:LeaveTeam(data)
    self:notify_event_handler('leave_team', data)
end

---Player Information Notification
---@param data table message
function M:NotifyPlayerInfo(data)
    self:notify_event_handler('notify_player_info', data)
end

---Battlefield information notification
function M:NotifyBattleInfo(data)
    self:notify_event_handler("notify_battle_info", data)
end

---Batch information notification
local function notify_chat_messages(self, messages, source)
    if type(messages) ~= 'table' or messages[1] == nil then
        log.warn(source .. " missing chat messages")
        return
    end
    for _, value in ipairs(messages) do
        self:notify_event_handler("chat", { arg1 = value })
    end
end

function M:NotifyWorldChat(data)
    notify_chat_messages(self, data.arg3, "NotifyWorldChat")
end

function M:NotifyMultiChat(data)
    notify_chat_messages(self, data.arg1, "NotifyMultiChat")
end

function M:NotifyPushMultiChat(data)
    notify_chat_messages(self, data.arg2, "NotifyPushMultiChat")
end
------------------- push message -------------------

--rpc network authentication
---@return boolean, string|nil
function M:login_auth()
    log.info("[Client] start login ", self.ip, self.port, self.token and "<redacted>" or "<missing>")
    self:notify_event_handler("connected")
    local data = {
        token = self.token,
        game_play_id = self.game_play_id
    }
    local pb_encoded_data = self.proto_helper:encode('protocol.LoginAuthReq', data)
    return self.message_handler:send_raw_message(const.msgtype.LOGIN_AUTH, pb_encoded_data)
end

---@class client.API
local API = {}

--Create a socket client and connect to the target server
---@param ip string # IP address
---@param port integer # Port number
---@param aid integer # Player id
---@param token string # token
---@param game_play_id integer # Map fixed id
---@return LobbyClient
function API.new_client(ip, port, aid, token, game_play_id)
    local client = New 'LobbyClient' (ip, port, aid, token, game_play_id)
    return client
end

return API
