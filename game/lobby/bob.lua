local work = require 'clicli.game.lobby.service.client'

---@diagnostic disable-next-line: deprecated
local local_player = clicli.player.get_local()
---@enum(key) Bob.PlayerState
local player_state = {
    ['Free'] = 1,
    ['Matching'] = 2,
    ['InTheGame'] = 3,
}

---@enum(key) Bob.TeamState
local team_state = {
    ['Free'] = 1,
    ['Matching'] = 2,
}

---@enum(key) Bob.LeaveReason
local leave_reason = {
    "leave" = 1,
    "kickOut" = 2,
    "disband" = 3,
}

---@alias Bob.State
---| 'none'
---| 'connecting'
---| 'connected'
---| 'disconnect'
---| 'login'

---@class LobbyBob: CustomEvent, GCHost
---@field event_on fun(self: Bob, event: 'ready ', callback: fun(trg: Trigger)): Trigger
---@field event_on fun(self: Bob, event: 'online state change ', callback: fun(trg: Trigger, State: bob.state)): Trigger
---@field event_on fun(self: Bob, event: 'Match state change ', callback: fun(trg: Trigger, state: boolean)): Trigger
---@field event_on fun(self: Bob, event:  istartup state change ', callback: fun(trg: Trigger, state: boolean)): Trigger
---@field event_on fun(self: Bob, event: 'Received message ', callback: fun(trg: Trigger, data: bob.chatinfo)): Trigger
---@field event_on fun(self: Bob, event: 'team change ', callback: fun(trg: Trigger, data: bob.teaminfo)): Trigger
---@field event_on fun(self: Bob, event: 'Join the team ', callback: fun(trg: Trigger)): Trigger
---@field event_on fun(self: Bob, event: 'Leave the team ', callback: fun(trg: Trigger, reason: bob.leavereason, last_team_info: Bob.TeamInfo)): Trigger
---@field event_on fun(self: Bob, event: 'Someone joins the team ', callback: fun(trg: Trigger, data: bob.playerinfo)): Trigger
---@field event_on fun(self: Bob, event: 'Someone left the team ', callback: fun(trg: Trigger, data: bob.playerinfo)): Trigger
---@field event_on fun(self: Bob, event: 'The client needs to update ', callback: fun(trg: Trigger)): Trigger
---@overload fun(game_play_id: integer):Bob
local M = Class 'LobbyBob'

local CHANNEL_OP_JOIN = 2
local WORLD_CHANNEL_TYPE = 5
local WORLD_CHANNEL_ID = 10000
local EXIT_CLEANUP_STEP_TIMEOUT = 2

Extends('LobbyBob', 'CustomEvent')
Extends('LobbyBob', 'GCHost')

---@type Bob.State
M.state = 'none'

---@type string
M.ip = ''
---@type integer
M.port = 0
---@type string
M.token = nil

--My score
M.score = 0

---@alias Bob.ChatType 'chat'/' system '

---@class LobbyBob.ChatInfo
---@field mode Bob.ChatType
---@field time integer
---@field message string
---@field chat? Bob.ChatData

local function to_positive_integer(value)
    if type(value) ~= 'number' then
        return nil
    end
    local ok, integer = pcall(math.tointeger, value)
    if ok and integer and integer > 0 then
        return integer
    end
    return nil
end

function M:__init(game_play_id)
    log.debug('【BOB】 is initializing bob')
    local valid_game_play_id = to_positive_integer(game_play_id)
    if not valid_game_play_id then
        error('invalid_game_play_id')
    end
    --My unique platform id
    self.aid = local_player:get_platform_id()
    log.debug('【BOB】aid:', self.aid)
    --My nickname
    self.name = local_player:get_platform_name()
    log.debug('【BOB】name:', self.name)
    --My profile picture
    self.icon = local_player:get_platform_icon_url()
    log.debug('【BOB】icon:', self.icon)
    --My mall token
    pcall(function()
        local store_params = local_player.handle:api_get_role_store_params()
        if store_params ~= '' then
            self.token = clicli.json.decode(store_params).sign
        end
        log.debug('【BOB】token:', self.token and '<redacted>' or '<missing>')
    end)
    local dungeon_info = GameAPI.get_dungeon_info and GameAPI.get_dungeon_info() or nil
    self.map_id = dungeon_info and tostring(dungeon_info.map_id) or ''
    log.debug('【BOB】map_id:', self.map_id)
    self.game_play_id = tostring(valid_game_play_id)
    self.game_play_id_num = valid_game_play_id
    log.debug('【BOB】game_play_id:', self.game_play_id)
    self.level_id = dungeon_info and dungeon_info.level_id or ''
    log.debug('【BOB】level_id:', self.level_id)
    --Cache request return packet processing
    ---@private
    self.request_handlers = {}
    --Received chat
    ---@type Bob.ChatInfo[]
    self.message_history = {}
    --Known player information
    ---@private
    ---@type table<integer, Bob.PlayerInfo>
    self.player_infos = {}

    --The official library is not bound to the project UI. The chat display is handled by subscribing to the "Received Message" event by the project itself.
end

function M:__del()
    if self.client then
        Delete(self.client)
    end
    if self.chat_event then
        self.chat_event:remove()
    end
end

---@private
M._in_game = false

---@param in_game boolean
function M:set_in_game(in_game)
    log.debug('【BOB】 Set the game status', in_game)
    self._in_game = in_game
end

function M:start()
    if not IsValid(self) then
        return
    end
    log.debug('[BOB] Start the matching system')
    self:check_update(function(need_update)
        if need_update then
            log.debug('【BOB】 Failed startup: The client needs to be updated')
            self:event_notify('The client needs to be updated')
        else
            if not IsValid(self) then
                return
            end
            --The true client object
            ---@private
            local ok, client = pcall(work.new_client, self.ip, self.port, self.aid, self.token, self.game_play_id_num)
            if not ok then
                log.warn('【BOB】 Startup failed: The custom protocol is unavailable, and the matching and RPC functions have been disabled', client)
                self:event_notify('The matching service is unavailable', client)
                return
            end
            self.client = client
            self:register_methods()
            self.client:start()
        end
    end)
end

---@private
function M:login()
    log.debug('[BOB] Log in')
    self:request_login(function(result, err)
        if err then
            log.debug('【BOB】 Login error:', clicli.inspect(err))
            return
        end
        self:get_team_info(self.aid, function(result, team_err)
            if team_err then
                log.warn('[BOB] Failed to obtain team information after logging in:', team_err)
                return
            end
            self.team_info = result
            self:refresh_player_info(function(_, refresh_err)
                if refresh_err then
                    log.warn('[BOB] Failed to update player information after logging in:', refresh_err)
                    return
                end
                log.debug('【BOB】 Initiate an event: Ready')
                self:event_notify('Ready')
            end)
        end)
    end)
end

---@return boolean
function M:is_valid()
    return self.state == 'login'
end

---@private
---@type fun(msg: string)?
M.error_handler = nil

---@param handler fun(msg: string, errid: integer)
function M:set_error_handler(handler)
    self.error_handler = handler
end

---@alias Bob.Receiver fun(result: any, err: any): boolean?

---@private
function M:get_request_handler(id)
    if not self.request_handlers[id] then
        local handler = {
            id = id,
            map = {},
        }
        self.request_handlers[id] = handler
        handler.callback = function(errid, data, arg)
            local receiver = handler.last_receiver
            handler.last_receiver = nil
            if not receiver then
                if handler.token_getter then
                    local token = handler.token_getter(arg.arg1)
                    receiver = handler.map[token]
                    handler.map[token] = nil
                end
            end
            if not receiver then
                log.warn('【BOB】 Received a reply packet without a recipient, ignore:', id)
                return
            end
            if errid ~= 1 then
                local suc, ignore = xpcall(receiver, log.error, nil, errid)
                if suc and ignore then
                else
                    local msg = String.format('[bob]Request[%s]Failed,Error_id = %s', id, errid)
                    log.warn(msg)
                    if self.error_handler then
                        xpcall(self.error_handler, log.error, msg, errid)
                    end
                end
            elseif type(data.ret1) == 'table'
                and ((data.ret1.errnu and data.ret1.errnu ~= 0) or (data.ret1.error_code and data.ret1.error_code ~= 0)) then
                local err = data.ret1.errnu or data.ret1.error_code
                local suc, ignore = xpcall(receiver, log.error, nil, err)
                if suc and ignore then
                else
                    local msg = String.format('【bob】Request[%s]Failed,Err = %s, data = %s', id, err, tostring(data.ret1.data))
                    log.warn(msg)
                    if self.error_handler then
                        xpcall(self.error_handler, log.error, msg, err)
                    end
                end
            else
                log.debug('【BOB】 Request successful:', id, 'Return value:', clicli.inspect(data))
                xpcall(receiver, log.error, data.ret1, nil)
            end
        end
    end
    return self.request_handlers[id]
end

---@private
---@param id string
---@return boolean
function M:can_request(id)
    local handler = self:get_request_handler(id)
    if handler.last_receiver then
        return false
    end
    return true
end

---@private
---@param id string
---@param sender fun()
---@param receiver Bob.Receiver
---@return boolean
function M:request(id, sender, receiver)
    log.debug('【BOB】 Initiate a request', id)
    if not self:can_request(id) then
        log.debug('【BOB】 Request failed:', 'Cannot re-enter')
        receiver(nil, 'The request cannot be re-entered')
        return false
    end
    local handler = self:get_request_handler(id)
    handler.last_receiver = receiver
    sender()
    return true
end

---@private
---@generic T
---@param id string
---@param sender fun()
---@param receiver Bob.Receiver
---@param token T
---@param token_getter fun(request_data: any):T
function M:request_with_token(id, sender, receiver, token, token_getter)
    log.debug('【BOB】 Initiate a request (with token)', id, token and '<redacted>' or '<missing>')
    local handler = self:get_request_handler(id)
    handler.map[token] = receiver
    handler.token_getter = token_getter
    sender()
end

_G['_SVN_VERSION_INJECTION_STATUS'] = 'pending'
log.info('[LobbyVersionDiag] lua injection submitted',
    'lua_globals=', tostring(_G),
    'local=', tostring(_G['_SVN_VERSION']),
    'injection=', tostring(_G['_SVN_VERSION_INJECTION_STATUS']))
---@diagnostic disable-next-line: redundant-parameter, undefined-field
GameAPI.visual_pyexec([[
import clients.G as G

lua_globals = G.black_box.lua_rt.globals()
local_version = None
try:
    import shipping
    local_version = shipping.CUR_SVN_VERSION
    lua_globals['_SVN_VERSION'] = local_version
    lua_globals['_SVN_VERSION_INJECTION_STATUS'] = 'ok' if local_version is not None else 'empty'
except Exception as error:
    lua_globals['_SVN_VERSION_INJECTION_STATUS'] = 'failed: ' + str(error)
python_runtime_id = hex(id(lua_globals))
lua_globals['_SVN_VERSION_INJECTION_RUNTIME_ID'] = python_runtime_id
print(
    '[LobbyVersionDiag] python injection executed'
    f' | lua_globals_id={python_runtime_id}'
    f' | local={local_version!r}'
    f' | local_type={type(local_version).__name__}'
    f" | injection={lua_globals['_SVN_VERSION_INJECTION_STATUS']}"
)
]])

local function log_version_observation(stage, bob, local_version, injection_status)
    log.info('[LobbyVersionDiag] lua version observed',
        'stage=', stage,
        'lua_globals=', tostring(_G),
        'python_lua_globals_id=', tostring(_G['_SVN_VERSION_INJECTION_RUNTIME_ID']),
        'player=', tostring(local_player),
        'player_id=', tostring(local_player:get_id()),
        'aid=', tostring(bob and bob.aid),
        'level_id=', tostring(bob and bob.level_id),
        'local=', tostring(local_version),
        'local_type=', type(local_version),
        'injection=', tostring(injection_status))
end

---Check whether the client needs to be updated
---@param callback fun(need_update: boolean)
function M:check_update(callback)
    local completed = false
    local function finish(need_update)
        if completed then
            return false
        end
        completed = true
        callback(need_update)
        return true
    end

    local local_version = _G['_SVN_VERSION']
    local injection_status = _G['_SVN_VERSION_INJECTION_STATUS'] or 'unknown'
    log_version_observation('check-start', self, local_version, injection_status)
    if clicli.game.is_debug_mode(true) then
        Log.info('【bob】【VersionCheck】result=skip-debug',
            'local=', tostring(local_version),
            'local_type=', type(local_version),
            'injection=', tostring(injection_status))
        finish(false)
        return
    end
    local dungeon_info = GameAPI.get_dungeon_info()
    local env = dungeon_info and dungeon_info.env or nil
    if env ~= 'prod' then
        Log.info('【bob】【VersionCheck】result=skip-non-prod',
            'env=', tostring(env),
            'local=', tostring(local_version),
            'local_type=', type(local_version),
            'injection=', tostring(injection_status))
        finish(false)
        return
    end

    Log.info('【bob】【VersionCheck】result=requesting-remote',
        'env=', tostring(env),
        'local=', tostring(local_version),
        'local_type=', type(local_version),
        'injection=', tostring(injection_status))
    clicli.game:request_url('https://up5.update.netease.com/pl/patchmd5_windows64_produp5_release.txt', nil, function(body)
        if completed then
            return
        end
        local_version = _G['_SVN_VERSION']
        injection_status = _G['_SVN_VERSION_INJECTION_STATUS'] or 'unknown'
        log_version_observation('remote-response', self, local_version, injection_status)
        if not body then
            Log.warn('【bob】【VersionCheck】result=remote-request-empty',
                'policy=allow',
                'local=', tostring(local_version),
                'local_type=', type(local_version),
                'injection=', tostring(injection_status))
            finish(false)
            return
        end
        local decode_ok, data = pcall(clicli.json.decode, body)
        if not decode_ok then
            Log.error('【bob】【VersionCheck】result=remote-parse-failed',
                'error=', tostring(data),
                'local=', tostring(local_version),
                'injection=', tostring(injection_status))
            finish(false)
            return
        end
        local read_ok, remote_version = pcall(function()
            return data['2.0']['@metadata@']['@displayversion@']
        end)
        if not read_ok then
            Log.error('【bob】【VersionCheck】result=remote-version-read-failed',
                'error=', tostring(remote_version),
                'local=', tostring(local_version),
                'injection=', tostring(injection_status))
            finish(false)
            return
        end

        local need_update = local_version ~= remote_version
        local result
        if local_version == nil or tostring(local_version) == '' then
            result = 'local-version-missing'
        elseif remote_version == nil or tostring(remote_version) == '' then
            result = 'remote-version-missing'
        elseif need_update and tostring(local_version) == tostring(remote_version) then
            result = 'version-type-mismatch'
        elseif need_update then
            result = 'client-version-mismatch'
        else
            result = 'version-match'
        end

        local version_log = need_update and log.warn or log.info
        Version_log('【bob】【VersionCheck】result=' .. result,
            'need_update=', tostring(need_update),
            'local=', tostring(local_version),
            'local_type=', type(local_version),
            'remote=', tostring(remote_version),
            'remote_type=', type(remote_version),
            'injection=', tostring(injection_status))
        if result == 'local-version-missing' and clicli.ltimer and clicli.ltimer.wait then
            clicli.ltimer.wait(1, function()
                log_version_observation(
                    'post-missing-1s',
                    self,
                    _G['_SVN_VERSION'],
                    _G['_SVN_VERSION_INJECTION_STATUS'] or 'unknown'
                )
            end)
        end
        finish(need_update)
    end, { timeout = 5 })
end

---@private
---@param done Bob.Receiver
function M:request_login(done)
    log.debug('[BOB] Request to log in')
    self:request('Team_Login', function()
        ---@type PlayerInfo
        local data = {
            aid = self.aid,
            head_icon = self.icon,
            name = self.name,
            state = 0,
            score = self.score,
            map_id = self.map_id,
            in_game = self._in_game,
            game_play_id = self.game_play_id_num,
        }
        log.debug('【BOB】Team_Login', clicli.inspect(data))
        self.client:Team_Login(data)
    end, function(result, err)
        if err then
            done(nil, err)
            return
        end
        self:subscribe_world_chat(function(_, subscribe_err)
            if subscribe_err then
                done(nil, subscribe_err)
                return
            end
            done(result, nil)
        end)
    end)
end

---@private
---@param done Bob.Receiver
function M:subscribe_world_chat(done)
    self:request('Chat_UpdateChannel', function()
        self.client:ApiRouter_UpdateChannel(
            CHANNEL_OP_JOIN,
            WORLD_CHANNEL_TYPE,
            WORLD_CHANNEL_ID,
            { self.aid },
            self.game_play_id_num
        )
    end, function(result, err)
        if err then
            done(nil, err)
            return
        end
        if result ~= nil and result ~= 0 and result ~= 'default_ErrCode' then
            done(nil, result)
            return
        end
        done(result, nil)
    end)
end

---@private
---@param done? fun(result: any? , err: any?)
function M:refresh_player_info(done)
    log.debug('[BOB] Request to update player information')
    if self._refreshing_player_info then
        log.debug('[BOB] The update of player information is in the process of being requested. We are waiting for a reply package')
        if done then
            self._refresh_player_info_callbacks = self._refresh_player_info_callbacks or {}
            self._refresh_player_info_callbacks[#self._refresh_player_info_callbacks + 1] = done
        end
        return true
    end
    ---@type PlayerInfo
    local data = {
        aid = self.aid,
        head_icon = self.icon,
        name = self.name,
        state = 0,
        score = self.score,
        map_id = self.map_id,
        in_game = self._in_game,
        game_play_id = self.game_play_id_num,
    }
    self._refreshing_player_info = true
    self._refresh_player_info_callbacks = done and { done } or {}
    local finished = false
    local timeout
    local finish = function(result, err)
        if finished then
            return
        end
        finished = true
        if timeout then
            timeout:remove()
        end
        self._refreshing_player_info = false
        log.debug('【BOB】 Update the player information return package', clicli.inspect({ result = result, err = err }))
        local callbacks = self._refresh_player_info_callbacks or {}
        self._refresh_player_info_callbacks = {}
        for _, callback in ipairs(callbacks) do
            xpcall(callback, log.error, result, err)
        end
    end
    timeout = clicli.ltimer.wait(3, function()
        --Keep the placeholder receiver to prevent late return packets from being mistakenly consumed by the next refresh request.
        finish(nil, 'timeout')
        if self.client and not self._exiting then
            self.client:reconnect('Player information refresh timeout')
        end
    end)
    self:request('Team_UpdatePlayerInfo', function()
        log.debug('【BOB】Team_UpdatePlayerInfo', clicli.inspect(data))
        self.client:Team_UpdatePlayerInfo(data)
    end, finish)
    return true
end

---Delete the server player information.
---@param done? fun(result: any? , err: any?)
---@return boolean, string?
function M:delete_player_info(done)
    if not self.client then
        local reason = 'The client is not connected'
        if done then done(nil, reason) end
        return false, reason
    end
    return self:request('Team_DelPlayerInfo', function()
        log.debug('【BOB】Team_DelPlayerInfo', self.aid)
        self.client:Team_DelPlayerInfo(self.aid)
    end, function(result, err)
        log.debug('【BOB】 Delete the player information reply package', clicli.inspect({ result = result, err = err }))
        if done then done(result, err) end
    end)
end

---Before actually exiting the game, serially cancel the match, leave the team and delete the player is information.
---@param done? fun(ok: boolean, reason: string?)
---@param step_timeout? number
---@return boolean started
function M:cleanup_before_exit(done, step_timeout)
    self._exit_cleanup_callbacks = self._exit_cleanup_callbacks or {}
    if done then
        self._exit_cleanup_callbacks[#self._exit_cleanup_callbacks + 1] = done
    end
    if self._exit_cleanup_active then
        return false
    end

    self._exiting = true
    self._exit_cleanup_active = true
    local cleanup = {
        finished = false,
        errors = {},
        timer = nil,
        matching_trigger = nil,
        leave_trigger = nil,
    }
    self._exit_cleanup = cleanup
    step_timeout = step_timeout or EXIT_CLEANUP_STEP_TIMEOUT

    local function record_error(reason)
        if reason then
            cleanup.errors[#cleanup.errors + 1] = tostring(reason)
        end
    end

    local function cancel_timer()
        if cleanup.timer then
            cleanup.timer:remove()
            cleanup.timer = nil
        end
    end

    local function remove_trigger(name)
        local trigger = cleanup[name]
        if trigger then
            trigger:remove()
            cleanup[name] = nil
        end
    end

    local function arm_timeout(stage, callback)
        cancel_timer()
        cleanup.timer = clicli.ltimer.wait(step_timeout, function()
            cleanup.timer = nil
            record_error(stage .. '-timeout')
            callback()
        end)
    end

    local function finish()
        if cleanup.finished then
            return
        end
        cleanup.finished = true
        cancel_timer()
        remove_trigger('matching_trigger')
        remove_trigger('leave_trigger')

        self.team_info = nil
        if self.player_infos then
            self.player_infos[self.aid] = nil
        end
        self._matching_state = false
        self._is_launching = false
        self._exit_cleanup_active = false
        self._exit_cleanup = nil

        if self.client and self.client.close then
            self.client:close('exit cleanup')
        end

        local callbacks = self._exit_cleanup_callbacks
        self._exit_cleanup_callbacks = {}
        local reason = #cleanup.errors > 0 and table.concat(cleanup.errors, ',') or nil
        for _, callback in ipairs(callbacks) do
            xpcall(callback, log.error, reason == nil, reason)
        end
    end

    local delete_player_info
    local leave_team
    local cancel_match

    delete_player_info = function()
        if cleanup.finished then return end
        local completed = false
        local function complete(err)
            if completed or cleanup.finished then return end
            completed = true
            cancel_timer()
            if err then record_error('delete-player:' .. tostring(err)) end
            finish()
        end
        arm_timeout('delete-player', function()
            complete()
        end)
        local sent, err = self:delete_player_info(function(_, request_err)
            complete(request_err)
        end)
        if sent == false then
            complete(err or 'request-failed')
        end
    end

    leave_team = function()
        if cleanup.finished then return end
        remove_trigger('matching_trigger')
        if not self:is_in_team() then
            delete_player_info()
            return
        end

        local completed = false
        local function complete(err)
            if completed or cleanup.finished then return end
            completed = true
            cancel_timer()
            remove_trigger('leave_trigger')
            if err then record_error('leave-team:' .. tostring(err)) end
            delete_player_info()
        end

        cleanup.leave_trigger = self:event_on('Leave the team', function()
            complete()
        end)
        arm_timeout('leave-team', function()
            complete()
        end)
        local sent, err = self:leave_team(function(_, request_err)
            if request_err then complete(request_err) end
        end, true)
        if sent == false then
            complete(err or 'request-failed')
        end
    end

    cancel_match = function()
        if cleanup.finished then return end
        if not self:is_matching() then
            leave_team()
            return
        end

        local completed = false
        local function complete(err)
            if completed or cleanup.finished then return end
            completed = true
            cancel_timer()
            remove_trigger('matching_trigger')
            if err then record_error('cancel-match:' .. tostring(err)) end
            leave_team()
        end

        cleanup.matching_trigger = self:event_on('Change of matching status', function(_, matching)
            if not matching then complete() end
        end)
        arm_timeout('cancel-match', function()
            complete()
        end)
        local sent, err = self:cancel_match(function(_, request_err)
            if request_err then complete(request_err) end
        end)
        if sent == false then
            complete(err or 'request-failed')
        end
    end

    cancel_match()
    return true
end

--Create a team
---@param done? fun(result: any?, err: any?) # It is called after creation is completed
---@param member_limit integer # Team size limit
function M:create_team(done, member_limit)
    log.debug('[BOB] Try to create a team')
    member_limit = member_limit or 8
    self:check_update(function(need_update)
        if need_update then
            log.debug('【BOB】 Team creation failed: The client needs to be updated')
            if done then done(nil, 'The client needs to be updated') end
        else
            self:request('Team_CreateTeam', function()
                log.debug('【BOB】Team_CreateTeam', self.aid)
                self.client:Team_CreateTeam(self.aid, member_limit)
            end, function(result, err)
                log.debug('【BOB】 Create a team return package', clicli.inspect({ result = result, err = err }))
                if done then done(result, err) end
            end)
        end
    end)
end

--Leave the team
---@param done? fun(result: any?, err: any?) # It is called after leaving is completed
---@param force? boolean # Only exit the cleaning usage. Requests for leaving the team are allowed in the matching or startup state
---@return boolean, string?
function M:leave_team(done, force)
    log.debug('BOB tried to leave the team')
    if not force and (self:is_matching() or self:is_launching()) then
        local reason = 'Matching or starting'
        log.debug('【BOB】 Failed to leave the team:' .. reason)
        if done then done(nil, reason) end
        return false, reason
    end
    return self:request('Team_LeaveTeam', function()
        log.debug('【BOB】Team_LeaveTeam', self.aid)
        self.client:Team_LeaveTeam(self.aid)
    end, function(result, err)
        log.debug('BOB left the team and returned the package', clicli.inspect({ result = result, err = err }))
        if done then
            done(result, err)
        end
    end)
end

--Join the team
---@param team_id integer
---@param done? fun(result: any?, err: any?) # It is called after the addition is completed
function M:join_team(team_id, done)
    log.debug('[BOB] Try to join the team', team_id)
    if self:is_matching() or self:is_launching() then
        local reason = 'Matching or starting'
        log.debug('【BOB】 Failed to join the team:' .. reason)
        if done then done(nil, reason) end
        return false, reason
    end
    self:check_update(function(need_update)
        if need_update then
            log.debug('【BOB】 Failed to join the team: The client needs to be updated')
            if done then done(nil, 'The client needs to be updated') end
        else
            self:request('Team_JoinTeam', function()
                log.debug('【BOB】Team_JoinTeam', self.aid, team_id)
                self.client:Team_JoinTeam(self.aid, team_id)
            end, function(result, err)
                log.debug('【BOB】 Join the team and return the package', clicli.inspect({ result = result, err = err }))
                if done then done(result, err) end
            end)
        end
    end)
end

--Disband the team
---@param done? fun(ok?: boolean, err?: string) # It will be invoked after the dissolution is completed
function M:dismiss_team(done)
    log.debug('BOB attempts to disband the team')
    if not self:is_in_team() then
        log.debug('【BOB】 Failed to disband the team: Currently not in the team')
        if done then done(false, 'Not in the team at the moment') end
        return false, 'Not in the team at the moment'
    end
    if not self:is_captain() then
        log.debug('【BOB】 Failed to disband the team: The current player is not the team leader')
        if done then done(false, 'Only the team leader can disband the team') end
        return false, 'Only the team leader can disband the team'
    end
    if self:is_matching() or self:is_launching() then
        log.debug('【BOB】 Failed to disband the team: In the process of matching or starting')
        if done then done(false, 'Teams cannot be disbanded during matching or startup') end
        return false, 'Teams cannot be disbanded during matching or startup'
    end
    self:request('Team_DismissTeam', function()
        log.debug('【BOB】Team_DismissTeam', self.aid)
        self.client:Team_DismissTeam(self.aid)
    end, function(result, err)
        log.debug('【BOB】 Disband the team and return the package', clicli.inspect({ result = result, err = err }))
        if done then
            done(true)
        end
    end)
    return true
end

--Kick out of the team
---@param lick_aid integer
---@param done? fun(result: any? , err: any?)
function M:team_kick(lick_aid, done)
    log.debug('BOB tried to kick out of the team', lick_aid)
    local target_aid = math.tointeger(lick_aid)
    if not self:is_in_team() or not self:is_captain() then
        local reason = 'Only the team leader can remove members'
        log.debug('【BOB】 Failed to kick out of the team:', reason)
        if done then done(nil, reason) end
        return false, reason
    end
    if self:is_matching() or self:is_launching() then
        local reason = 'Members cannot be removed during matching or startup'
        log.debug('【BOB】 Failed to kick out of the team:', reason)
        if done then done(nil, reason) end
        return false, reason
    end
    if not target_aid or target_aid == math.tointeger(self.aid) then
        local reason = 'The removal of the target is invalid.'
        log.debug('【BOB】 Failed to kick out of the team:', reason)
        if done then done(nil, reason) end
        return false, reason
    end
    local found = false
    for _, member in ipairs(self.team_info.members or {}) do
        if math.tointeger(member.aid) == target_aid then
            found = true
            break
        end
    end
    if not found then
        local reason = 'The target player is not in the current team'
        log.debug('【BOB】 Failed to kick out of the team:', reason)
        if done then done(nil, reason) end
        return false, reason
    end
    self:request('Team_TeamKick', function()
        log.debug('【BOB】Team_TeamKick', self.aid, target_aid)
        self.client:Team_TeamKick(self.aid, target_aid)
    end, function(result, err)
        log.debug('【BOB】 Kick out of the team and return the package', clicli.inspect({ result = result, err = err }))
        if done then done(result, err) end
    end)
    return true
end

--Transfer Captain
---@param new_leader_aid integer
---@param done? fun(result: any?, err: any?) # It is called after the transfer is completed
function M:change_captain(new_leader_aid, done)
    log.debug('[BOB] Try to transfer the captain', new_leader_aid)
    local target_aid = math.tointeger(new_leader_aid)
    if not self:is_in_team() or not self:is_captain() then
        local reason = 'Only the captain can transfer the captain'
        log.debug('【BOB】 Failed to transfer the captain:', reason)
        if done then done(nil, reason) end
        return false, reason
    end
    if self:is_matching() or self:is_launching() then
        local reason = 'The captain cannot be transferred during matching or startup'
        log.debug('【BOB】 Failed to transfer the captain:', reason)
        if done then done(nil, reason) end
        return false, reason
    end
    if not target_aid or target_aid == math.tointeger(self.aid) then
        local reason = 'Transferring the target is invalid.'
        log.debug('【BOB】 Failed to transfer the captain:', reason)
        if done then done(nil, reason) end
        return false, reason
    end
    local found = false
    for _, member in ipairs(self.team_info.members or {}) do
        if math.tointeger(member.aid) == target_aid then
            found = true
            break
        end
    end
    if not found then
        local reason = 'The target player is not in the current team'
        log.debug('【BOB】 Failed to transfer the captain:', reason)
        if done then done(nil, reason) end
        return false, reason
    end
    self:request('Team_ChangeTeamLeader', function()
        log.debug('【BOB】Team_ChangeTeamLeader', self.aid, target_aid)
        self.client:Team_ChangeTeamLeader(self.aid, target_aid)
    end, function(result, err)
        log.debug('【BOB】 Transfer the captain back to the package', clicli.inspect({ result = result, err = err }))
        if done then
            done(result, err)
        end
    end)
    return true
end

--Open more battlefields
function M:create_multi_battle_space(battle_info)
    log.debug('【BOB】 Try to open up more battlefields', clicli.inspect(battle_info))
    self.client:BattleCreate_CreateMultiBattleSpace(battle_info)
end

---@class LobbyBob.PlayerInfo
---@field aid integer
---@field head_icon string
---@field name string
---@field team_id integer
---@field score integer
---@field state Bob.PlayerState

---@class LobbyBob.TeamInfo
---@field member_limit integer
---@field team_id integer
---@field team_state Bob.TeamState
---@field captain integer
---@field members Bob.PlayerInfo[]
---@field version integer

function M:convert_player_info(player_info)
    if player_info.in_game then
        player_info.state = 'In a match'
    else
        for key, state in pairs(player_state) do
            if state == player_info.state then
                player_info.state = key
                break
            end
        end
    end
    self.player_infos[player_info.aid] = player_info
end

---@private
---@param team_info table
---@return Bob.TeamInfo
function M:convert_team_info(team_info)
    for key, state in pairs(team_state) do
        if state == team_info.state then
            team_info.team_state = key
            break
        end
    end
    for _, player_info in ipairs(team_info.members) do
        self:convert_player_info(player_info)
    end
    return team_info
end

--Obtain team information
---@param aid integer
---@param response fun(result: Bob.TeamInfo? , err: any?)
function M:get_team_info(aid, response)
    log.debug('[BOB] Request team information', aid)
    self:request_with_token('Team_GetTeamInfoByAid', function()
        log.debug('【BOB】Team_GetTeamInfoByAid', aid)
        self.client:Team_GetTeamInfoByAid(aid)
    end, function(result, err)
        if not result then
            --PLAYER_HAS_NO_TEAM
            if err == 1402 then
                log.debug('The player has no team')
                response(nil, nil)
                return true
            end
            log.debug('【BOB】 Failed to obtain team information:', clicli.inspect(err))
            response(nil, err)
            return
        end
        local team_info = self:convert_team_info(result.team_info)
        log.debug('【BOB】 Team information obtained successfully:', clicli.inspect(team_info))
        response(team_info)
    end, aid, function(arg)
        return arg
    end)
end

--Obtain player information
---@param aid integer
---@param done fun(result: Bob.PlayerInfo? , err: any?)
function M:get_player_info(aid, done)
    log.debug('[BOB] Request player information', aid)
    if self.player_infos[aid] then
        log.debug('BOB pulls out the player information from the cache', clicli.inspect(self.player_infos[aid]))
        done(self.player_infos[aid], nil)
        return
    end
    log.debug('BOB will obtain player information through team information', aid)
    self:get_team_info(aid, function(_, err)
        if err then
            done(nil, err)
            return
        end
        log.debug('【BOB】 Successfully obtained player information:', clicli.inspect(self.player_infos[aid]))
        done(self.player_infos[aid], nil)
    end)
end

--Can they match?
---@return boolean
---@ the return (' not captain '|' are matching '|' lose connection '|' someone in the game '|' someone on match '|' starting)?
function M:can_match()
    if self.team_info and not self:is_captain() then
        return false, 'Not the captain'
    end
    if self:is_matching() then
        return false, 'Matching in progress'
    end
    if self:is_launching() then
        return false, '"Starting up"'
    end
    if not self:is_valid() then
        return false, 'Lost connection'
    end
    if self.team_info then
        for _, member in ipairs(self.team_info.members) do
            if member.state == 'In a match' then
                return false, 'Someone is in the game'
            end
            if member.state == 'Matchmaking...' then
                return false, 'Someone is matching.'
            end
        end
    end
    return true
end

---@param players DungeonPlayerField[]?
---@return boolean
---@ the return (' not captain '|' are matching '|' lose connection '|' someone on match '|' starting '|' no qualified players')?
function M:can_start_private_dungeon_filtered(players)
    if not self:is_in_team() then
        return false, 'Not in the team at the moment'
    end
    if not self:is_captain() then
        return false, 'Not the captain'
    end
    if self:is_matching() then
        return false, 'Matching in progress'
    end
    if self:is_launching() then
        return false, '"Starting up"'
    end
    if not self:is_valid() then
        return false, 'Lost connection'
    end
    if type(players) ~= 'table' or #players == 0 then
        return false, 'There are no qualified players.'
    end
    local selected = {}
    for _, player in ipairs(players) do
        selected[tostring(player.aid)] = true
    end
    for _, member in ipairs(self.team_info and self.team_info.members or {}) do
        if selected[tostring(member.aid)] and member.state == 'Matchmaking...' then
            return false, 'Someone is matching.'
        end
    end
    return true
end

---@private
M._matching_state = false

---@private
function M:update_matching_state()
    local matching_state = self:is_matching()
    if matching_state == self._matching_state then
        return false
    end
    self._matching_state = matching_state
    log.debug('【BOB】 Matching status change:', local_player, matching_state)
    self:event_notify('Change of matching status', matching_state)
    return true
end

--Is it matching?
function M:is_matching()
    if self.team_info then
        if self.team_info.team_state == 'Matchmaking...' then
            return true
        else
            return false
        end
    else
        local self_info = self.player_infos[self.aid]
        if self_info and self_info.state == 'Matchmaking...' then
            return true
        end
    end
    return false
end

---@private
M._is_launching = false

---Is the game starting
function M:is_launching()
    return self._is_launching
end

---@private
---@param game_mode integer # The game mode entered after a successful match
---@param score integer? # The matching score uses the average score by default
---@param done? fun(result: any? , err: any?)
function M:_start_match(game_mode, score, done)
    ---@private
    self:update_matching_state()
    log.debug('[BOB] Start requesting a match')
    self:request('Match_startMatch', function()
        ---@type MatchInfo
        local match_info = {
            map_id = self.map_id,
            level_id = self.level_id,
            game_mode = game_mode,
            game_play_id = self.game_play_id,
        }
        if self.team_info then
            log.debug('BOB is in the team')
            if not score then
                score = 0
                for _, player_info in ipairs(self.team_info.members) do
                    score = score + player_info.score
                end
                score = score // #self.team_info.members
                log.debug('[BOB] No score was set; the average score of the team was used', score)
            end
            log.debug('【BOB】Match_startMatch', self.team_info.team_id, score, true, clicli.inspect(match_info))
            self.client:Match_startMatch(self.team_info.team_id, score, true, match_info)
        else
            log.debug('BOB is not in the team')
            log.debug('【BOB】Match_startMatch', self.aid, score or self.score, false, clicli.inspect(match_info))
            self.client:Match_startMatch(self.aid, score or self.score, false, match_info)
        end
    end, function(result, err)
        log.debug('[BOB] Start matching the return packets', clicli.inspect({ result = result, err = err }))
        if done then done(result, err) end
    end)
end

--Start matching
---@param game_mode integer # The game mode entered after a successful match
---@param score integer? # The matching score uses the average score by default
---@param done? fun(result: any? , err: any?)
---@return boolean, string?
function M:start_match(game_mode, score, done)
    log.debug('[BOB] Try to start matching', game_mode, score)
    local can_match, reason = self:can_match()
    if not can_match then
        log.debug('【BOB】 Start matching failed:', reason)
        if done then done(nil, reason) end
        return false, reason
    end
    self:check_update(function(need_update)
        if need_update then
            log.debug('【BOB】 Failed to start matching: The client needs to update')
            if done then done(nil, 'The client needs to be updated') end
        else
            self:_start_match(game_mode, score, done)
        end
    end)
    return true
end

--unmatch
---@param done? fun(result: any?, err: any?) # Call after cancellation is completed
---@return boolean
function M:cancel_match(done)
    log.debug('[BOB] Try to cancel the match')
    return self:request('Match_cancelMatch', function()
        log.debug('【BOB】Match_cancelMatch', self.team_info and self.team_info.team_id or self.aid)
        self.client:Match_cancelMatch(self.team_info and self.team_info.team_id or self.aid)
    end, function(result, err)
        log.debug('【BOB】 Unmatch the return packet', clicli.inspect({ result = result, err = err }))
        if done then
            done(result, err)
        end
    end)
end

---@private
---@param message string
---@param chat_type integer
---@param channel_id integer
---@param done? fun(result: any? , err: any?)
---@return boolean, string?
function M:send_chat_to_channel(message, chat_type, channel_id, done)
    local send_ok, send_err
    local accepted = self:request('Chat_SendChatMsg', function()
        send_ok, send_err = self.client:ApiRouter_SendChatMsg(
            self.aid,
            message,
            chat_type,
            channel_id,
            0)
    end, done or function()
    end)
    if not accepted then
        return false, 'The request cannot be re-entered'
    end
    if send_ok == false then
        self:get_request_handler('Chat_SendChatMsg').last_receiver = nil
        if done then done(nil, send_err) end
        return false, send_err
    end
    return true
end

--Send chat messages
---@param message string
---@param done? fun(result: any? , err: any?)
---@return boolean, string?
function M:send_chat(message, done)
    log.debug('[BOB] Send chat messages', message)
    if not self.team_info or not self.team_info.team_id or self.team_info.team_id == 0 then
        return false, 'Not in the team at the moment'
    end
    return self:send_chat_to_channel(message, 4, self.team_info.team_id, done)
end

--Send world chat messages
---@param message string
---@param done? fun(result: any? , err: any?)
---@return boolean, string?
function M:send_world_chat(message, done)
    log.debug('[BOB] Send world chat messages', message)
    return self:send_chat_to_channel(message, WORLD_CHANNEL_TYPE, WORLD_CHANNEL_ID, done)
end

--Multiplayer private dungeon: players are fully built by the business layer according to team_info.members.
---@param dungeon_info DungeonSpaceField
---@param players DungeonPlayerField[] Each item contains only the string aid and a fixed version '2.0'
---@param done? fun(result: any? , err: any?)
function M:start_private_dungeon_game_filtered(dungeon_info, players, done)
    local can_start, reason = self:can_start_private_dungeon_filtered(players)
    if not can_start then
        return false, reason
    end
    log.debug('【BOB】 Send a private copy message within the bureau', string.format(
        'game_play_id=%s game_map_id=%s level_id=%s game_mode=%s player_count=%d',
        tostring(self.game_play_id or ''),
        tostring(dungeon_info and dungeon_info.game_map_id or ''),
        tostring(dungeon_info and dungeon_info.level_id or ''),
        tostring(dungeon_info and dungeon_info.game_mode or ''),
        #players))
    local send_ok, send_err
    local accepted = self:request('DungeonManager_StartMatchPrivateDungeonGame', function()
        send_ok, send_err = self.client:DungeonManager_StartMatchPrivateDungeonGame(dungeon_info, players)
    end, done or function()
    end)
    if not accepted then
        return false, 'The request cannot be re-entered'
    end
    if send_ok == false then
        self:get_request_handler('DungeonManager_StartMatchPrivateDungeonGame').last_receiver = nil
        if done then done(nil, send_err) end
        return false, send_err
    end
    return true
end

--Format chat messages
---@param chat_data Bob.ChatInfo
---@return string
function M:format_message(chat_data)
    if chat_data.mode == 'System' then
        return string.format('[%s]< System >: %s'
        , os.date('%H:%M:%S', chat_data.time)
        , chat_data.message)
    else
        local chat_type = {
            [4] = 'room',
            [5] = 'the',
        }
        return string.format('[%s][%s]<#fafe06%s#E>: %s'
        , os.date('%H:%M:%S', chat_data.time)
        , chat_type[chat_data.chat.chat_type]
        , chat_data.chat.sender.nickname
        , chat_data.message)
    end
end

--Send system messages
---@param message string
function M:display_message(message)
    local message_info = {
        mode    = 'System',
        message = message,
        time    = os.time(),
    }
    self.message_history[#self.message_history + 1] = message_info
    log.debug('【BOB】 Received the < System > message', clicli.inspect(message_info))
    self:event_notify('Received the message', message_info)
end

--Am I in the team
function M:is_in_team()
    return self.team_info ~= nil
end

--Am I the captain?
function M:is_captain()
    if not self.team_info then
        return false
    end
    return self.team_info.captain == self.aid
end

--Modify your own score
---@param score integer
function M:set_score(score, done)
    log.debug('[BOB] set score', score)
    self.score = score
    if self.state == 'login' then
        self:refresh_player_info(done)
        return true
    else
        self:event_on('Ready', function(trg)
            trg:remove()
            self:refresh_player_info(done)
        end)
        return true
    end
end

---@class LobbyBob.ChatData
---@field sender ChatSender # Sender information
---@field chat_message string # Chat message
---@field chat_time integer # timestamp
---@field chat_type integer # Information type

---@private
---@param chat_data Bob.ChatData
---@return Bob.ChatInfo
function M:record_chat(chat_data)
    local message_info = {
        mode    = 'chat',
        message = chat_data.chat_message,
        time    = chat_data.chat_time,
        type    = chat_data.chat_type,
        chat    = chat_data,
    }
    self.message_history[#self.message_history + 1] = message_info
    log.debug('【BOB】 Record the < Chat > message', clicli.inspect(message_info))
    self:event_notify('Received the message', message_info)
    return message_info
end

---@private
---@param message string
---@param chat_type integer
function M:display_local_chat(message, chat_type)
    self:record_chat({
        sender = {
            aid = self.aid,
            nickname = self.name,
            head_icon = self.icon,
        },
        chat_message = message,
        chat_time = os.time(),
        chat_type = chat_type,
    })
end

---@private
function M:notify_chat(data)
    ---@type Bob.ChatData
    local chat_data = data.arg1
    if chat_data.sender and chat_data.sender.aid == self.aid then
        log.debug('[BOB] Ignore your own chat messages that have been displayed by the successful reply package', clicli.inspect(chat_data))
        return
    end
    self:record_chat(chat_data)
end

---@private
function M:notify_update_team_info(data)
    local old_team_info = self.team_info
    log.debug('[BOB] Received new team information', clicli.inspect(data.arg1.team_info))
    log.debug('【BOB】 Current team information', clicli.inspect(old_team_info))

    if old_team_info and old_team_info.version > data.arg1.team_info.version then
        log.debug('[BOB] The new team information version is too low. Ignore it')
        return
    end

    --The information of the current team
    local new_team_info = self:convert_team_info(data.arg1.team_info)
    self.team_info = new_team_info
    log.debug('【BOB】 Trigger team changes', clicli.inspect(new_team_info))
    self:event_notify('Team changes', new_team_info)

    if not old_team_info or old_team_info.team_id ~= new_team_info.team_id then
        log.debug('【BOB】 Trigger to join the team')
        self:event_notify('Join the team')
        return
    end

    local old_members = {}
    local new_members = {}
    if old_team_info then
        for _, member in ipairs(old_team_info.members) do
            old_members[member.aid] = true
        end
    end
    for _, member in ipairs(new_team_info.members) do
        new_members[member.aid] = true
    end

    if old_team_info then
        for _, member in ipairs(old_team_info.members) do
            if not new_members[member.aid] and member.aid ~= self.aid then
                log.debug('【BOB】 Trigger someone to leave the team', clicli.inspect(member))
                self:event_notify('Someone left the team.', member)
            end
        end
    end

    for _, member in ipairs(new_team_info.members) do
        if not old_members[member.aid] and member.aid ~= self.aid then
            log.debug('【BOB】 Trigger someone to join the team', clicli.inspect(member))
            self:event_notify('Someone joined the team.', member)
        end
    end
end

---@private
function M:notify_leave_team(data)
    log.debug('BOB received the notice to leave the team', clicli.inspect(data))
    local last_team_info = self.team_info
    self.team_info = nil
    local reason = 'unknown'
    if data.arg1 == 1 then
        reason = 'Leave'
    elseif data.arg1 == 2 then
        reason = 'Kick out'
    elseif data.arg1 == 3 then
        reason = 'Disband'
    end
    log.debug('【BOB】 Trigger departure from the team', reason, clicli.inspect(last_team_info))
    self:event_notify('Leave the team', reason, last_team_info)
    self:update_matching_state()
end

---@private
function M:notify_player_info(data)
    ---@type PlayerInfo
    local player_info = data.arg1
    self:convert_player_info(player_info)
    log.debug('[BOB] Received the player`s information', clicli.inspect(player_info))
    self:update_matching_state()

    if player_info.state_change_reason == 1 then
        log.debug('BOB is starting the game')
        self._is_launching = true
        self:event_notify('Startup status change', self._is_launching)
        clicli.ltimer.wait(10, function()
            log.warn('【BOB】 Failed to start the game within 10 seconds!')
            self._is_launching = false
            self:event_notify('Startup status change', self._is_launching)
        end)
    end
end

---@private
function M:notify_battle_info(data)
    local battle_info = data.arg1
    log.debug('[BOB] Received battlefield information', clicli.inspect(battle_info))
end

---@private
function M:notify_state_change(state)
    if state == 'disconnect' then
        --The connection has been closed and no old connection callback packets will be received. After all pending requests are completed, reconnection and re-initiation are allowed.
        local receivers = {}
        for _, handler in pairs(self.request_handlers) do
            local receiver = handler.last_receiver
            local token_receivers = handler.map
            handler.last_receiver = nil
            handler.map = {}
            if receiver then
                receivers[#receivers + 1] = receiver
            end
            for _, token_receiver in pairs(token_receivers) do
                receivers[#receivers + 1] = token_receiver
            end
        end
        for _, receiver in ipairs(receivers) do
            xpcall(receiver, log.error, nil, 'Connection disconnected')
        end
    end
    self.state = state
    if state == 'login' then
        self:login()
    end
    log.debug('[BOB] Online status change', state)
    self:event_notify('Online status change', state)
end

---@private
function M:notify_ret(method_name, errid, arg, ret)
    if method_name == 'Chat_SendChatMsg' then
        local ret1 = ret and ret.ret1
        local business_error = type(ret1) == 'table'
            and ((ret1.errnu and ret1.errnu ~= 0) or (ret1.error_code and ret1.error_code ~= 0))
        if errid == 1 and not business_error then
            self:display_local_chat(arg.arg2, arg.arg3)
        end
    end
    local handler = self.request_handlers[method_name]
    if handler then
        handler.callback(errid, ret, arg)
    end
end

---@private
function M:register_methods()
    self.client:on_event(function(event, ...)
        if event == 'connecting'
            or event == 'connected'
            or event == 'login'
            or event == 'disconnect' then
            self:notify_state_change(event)
            return
        end
        if event == 'chat' then
            self:notify_chat(...)
            return
        end
        if event == 'update_team_info' then
            self:notify_update_team_info(...)
            return
        end
        if event == 'leave_team' then
            self:notify_leave_team(...)
            return
        end
        if event == 'notify_player_info' then
            self:notify_player_info(...)
            return
        end
        if event == 'notify_battle_info' then
            self:notify_battle_info(...)
            return
        end
        if event == 'ret' then
            self:notify_ret(...)
            return
        end
    end)
end

---comment
---@return integer,integer
function M:get_player_count()
    local max_count = self.team_info and self.team_info.member_limit or 0
    local team_count = 0
    for i = 1, max_count do
        local member = self.team_info and self.team_info.members[i]
        if member then
            team_count = team_count + 1
        end
    end
    return team_count, max_count
end
