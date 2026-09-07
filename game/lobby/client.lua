local state = require 'clicli.game.lobby.state'
local result = require 'clicli.game.lobby.result'

---@class clicli.Lobby.Client
local M = {}

local test_factory

local ENDPOINTS = {
    qa = '42.186.215.253',
    pre = '42.186.213.132',
    prod = '223.252.200.35',
}

local PORT = 8092

local function to_integer(value)
    local ok, integer = pcall(math.tointeger, value)
    if ok then
        return integer
    end
    return nil
end

local function validate_game_play_id(value)
    if type(value) ~= 'number' then
        return nil
    end
    local game_play_id = to_integer(value)
    if not game_play_id or game_play_id <= 0 then
        return nil
    end
    return game_play_id
end

local function remove_resource(resource)
    if resource and resource.remove then
        pcall(resource.remove, resource)
    end
end

local function cleanup_connection()
    for _, cleanup in ipairs(state.runtime.connection_cleanups or {}) do
        pcall(cleanup)
    end
    state.runtime.connection_cleanups = {}
    local old = state.runtime.client
    state.runtime.client = nil
    if old then
        pcall(Delete, old)
    end
end

local function is_valid_client(client)
    if not client then
        return false
    end
    if client.is_valid then
        local ok, valid = pcall(client.is_valid, client)
        return ok and valid == true
    end
    return client.client ~= nil
end

local function validate_endpoint_env(value)
    return value == nil or value == 'qa' or value == 'pre' or value == 'prod'
end

local function current_dungeon_token()
    local dungeon_info = GameAPI.get_dungeon_info()
    local token = dungeon_info and (dungeon_info.space_id or dungeon_info.spaceId) or ''
    token = tostring(token or '')
    if token == '' then
        return '<missing>', 'missing'
    end
    return token, 'ok'
end

local function log_current_dungeon_token(reason)
    local token, status = current_dungeon_token()
    pcall(log.info, string.format(
        '[Lobby][PrivateDungeonDiag] Current level password: reason=%s: status=%s: token=%s',
        tostring(reason),
        status,
        token))
end

local function get_endpoint(endpoint_env)
    local dungeon_info = GameAPI.get_dungeon_info()
    local platform_env = dungeon_info and dungeon_info.env or nil
    local debug_mode = clicli and clicli.game and clicli.game.is_debug_mode and clicli.game.is_debug_mode() or false
    local env
    if platform_env == 'qa' or platform_env == 'debug' or debug_mode then
        env = 'qa'
    elseif endpoint_env ~= nil then
        env = endpoint_env
    elseif platform_env == 'pre' then
        env = 'pre'
    else
        env = 'prod'
    end
    return ENDPOINTS[env], PORT, env
end

local function default_factory(game_play_id, in_game, endpoint_env)
    require 'clicli.game.lobby.bob'
    local created, bob_or_error = pcall(function()
        return New 'LobbyBob' (game_play_id)
    end)
    if not created then
        local reason = tostring(bob_or_error)
        if reason:find('invalid_game_play_id', 1, true) then
            return nil, 'invalid_game_play_id', reason
        end
        return nil, 'connect_failed', reason
    end
    local bob = bob_or_error
    bob.ip, bob.port, bob.env = get_endpoint(endpoint_env)
    state.runtime.endpoint_env = bob.env
    bob:set_in_game(in_game == true)
    return bob
end

local function cleanup_connect_request(request)
    for _, cleanup in ipairs(request.cleanups or {}) do
        pcall(cleanup)
    end
    request.cleanups = {}
    state.runtime.pending[request.id] = nil
    if state.runtime.locks.connect == request.id then
        state.runtime.locks.connect = nil
    end
    if state.runtime.pending_request_id == request.id then
        state.runtime.pending_request_id = nil
    end
end

local function reject_connect_request(request)
    cleanup_connect_request(request)
    state.runtime.eca_request_ids[request.id] = nil
end

local function request_is_current(request)
    return request
        and not request.done
        and not request.cancelled
        and state.runtime.pending[request.id] == request
end

---@param factory fun(game_play_id: integer, in_game: boolean, endpoint_env: string?) : any, string?
function M._set_factory_for_test(factory)
    test_factory = factory
end

function M._resolve_endpoint_for_test(endpoint_env)
    return get_endpoint(endpoint_env)
end

function M._reset_for_test()
    test_factory = nil
    cleanup_connection()
    state.reset_for_test()
end

function M.get()
    return state.runtime.client
end

function M.release_for_terminal()
    cleanup_connection()
end

function M.is_ready()
    return state.runtime.status == 'connected'
        and is_valid_client(state.runtime.client)
end

---@param game_play_id integer? # Missing or invalid gameplay ids will return a rejection result
---@param finish fun(request: table, success: boolean, code: string, reason: string? , data: table?)
---@param in_game boolean?
---@param endpoint_env string?
---@return table
function M.connect(game_play_id, finish, in_game, endpoint_env)
    game_play_id = validate_game_play_id(game_play_id)
    if not game_play_id then
        return result.rejected('Establish a connection', 'invalid_game_play_id', 'Please pass in the valid gameplay ID game_play_id')
    end
    if in_game ~= nil and type(in_game) ~= 'boolean' then
        return result.rejected('Establish a connection', 'invalid_argument', 'Must it be a Boolean value in the game level')
    end
    if not validate_endpoint_env(endpoint_env) then
        return result.rejected('Establish a connection', 'invalid_argument', 'endpoint_env must be qa, pre, or prod')
    end
    in_game = in_game == true
    local status = state.runtime.status
    local action = 'Establish a connection'
    if status == 'closing' or state.runtime.locks.terminal then
        return result.rejected(action, 'connection_closing', 'connection is closing')
    end
    if status == 'connecting' then
        local pending_request_id = state.runtime.pending_request_id
        if state.runtime.current_call_origin == 'eca' and pending_request_id then
            state.runtime.eca_request_ids[pending_request_id] = true
        end
        return result.accepted(action, pending_request_id, {
            reason = 'connection is pending',
            code = 'connecting',
            duplicate = true,
        })
    end
    if status == 'connected' and M.is_ready() then
        return result.accepted(action, nil, {
            reason = 'connection is established',
            code = 'connected',
            sync = true,
            result_data = state.snapshot(),
        })
    end

    cleanup_connection()

    local request = {
        id = state.next_request_id(),
        action = action,
        lock = 'connect',
        done = false,
        cleanups = {},
    }
    state.runtime.pending[request.id] = request
    state.runtime.locks.connect = request.id
    state.runtime.pending_request_id = request.id
    if state.runtime.current_call_origin == 'eca' then
        state.runtime.eca_request_ids[request.id] = true
    end
    state.set_status('connecting')
    local active_client

    local function connection_event_allowed()
        return state.runtime.client == active_client
            and state.runtime.status ~= 'closing'
            and state.runtime.locks.terminal == nil
    end

    local function done(success, code, reason, data)
        if not request_is_current(request) then
            return false
        end
        request.done = true
        cleanup_connect_request(request)
        if success then
            state.set_status('connected')
        else
            cleanup_connection()
            state.set_status('failed', reason or code)
        end
        finish(request, success, code, reason, data or state.snapshot())
        return true
    end

    local function restore_connected(reason)
        if request.cancelled or not connection_event_allowed() then
            return false
        end
        if request.done then
            state.set_status('connected')
            return true
        end
        return done(true, 'ok', reason or 'connection is ready', state.snapshot())
    end

    if clicli.ltimer and clicli.ltimer.wait then
        local ok, timer = pcall(clicli.ltimer.wait, 10, function()
            done(false, 'timeout', 'connection timeout')
        end)
        if ok then
            request.cleanups[#request.cleanups + 1] = function()
                remove_resource(timer)
            end
        end
    end

    local factory = test_factory or default_factory
    local ok, client_or_error, fail_code, fail_reason = pcall(factory, game_play_id, in_game, endpoint_env)
    if not ok then
        local reason = tostring(client_or_error)
        reject_connect_request(request)
        cleanup_connection()
        state.set_status('failed', reason)
        return result.rejected(action, 'connect_failed', reason)
    end
    if not client_or_error then
        local code = fail_code or 'connect_failed'
        local reason = tostring(fail_reason or 'create lobby connection failed')
        reject_connect_request(request)
        cleanup_connection()
        state.set_status('failed', reason)
        return result.rejected(action, code, reason)
    end

    local client = client_or_error
    active_client = client
    state.runtime.client = client

    if client.event_on then
        local ready = client:event_on('Ready', function()
            if in_game then
                log_current_dungeon_token('ready')
            end
            restore_connected('connection is ready')
        end)
        local unavailable = client:event_on('The matching service is unavailable', function(_, error_message)
            done(false, 'connect_failed', tostring(error_message or 'matching service unavailable'))
        end)
        local disconnect = client:event_on('Online status change', function(_, client_status)
            if not connection_event_allowed() then
                return
            end
            if client_status == 'disconnect' then
                if request.done then
                    state.set_status('disconnected')
                else
                    done(false, 'disconnected', 'connection disconnected')
                end
            elseif client_status == 'login' then
                restore_connected('connection is ready')
            end
        end)
        local matching = client:event_on('Change of matching status', function(_, matching_state)
            if not connection_event_allowed() then
                return
            end
            state.emit_event('matching_changed', {
                matching = matching_state == true,
            })
        end)
        local launching = client:event_on('Startup status change', function(_, launching_state)
            if not connection_event_allowed() then
                return
            end
            state.emit_event('launching_changed', {
                launching = launching_state == true,
            })
        end)
        local chat = client:event_on('Received the message', function(_, message)
            if not connection_event_allowed() then
                return
            end
            state.emit_event('message_received', {
                message = state.public_message(message),
            })
        end)
        local team_changed = client:event_on('Team changes', function(_, team_info)
            if not connection_event_allowed() then
                return
            end
            state.emit_event('team_changed', {
                team = state.public_team(team_info or client.team_info),
            })
        end)
        local team_joined = client:event_on('Join the team', function(_, team_info)
            if not connection_event_allowed() then
                return
            end
            state.emit_event('team_joined', {
                team = state.public_team(team_info or client.team_info),
            })
        end)
        local team_left = client:event_on('Leave the team', function(_, leave_reason, last_team_info)
            if not connection_event_allowed() then
                return
            end
            state.emit_event('team_left', {
                reason = tostring(leave_reason or ''),
                team = state.public_team(last_team_info),
            })
        end)
        local member_joined = client:event_on('Someone joined the team.', function(_, member)
            if not connection_event_allowed() then
                return
            end
            state.emit_event('member_joined', {
                member = state.public_player(member),
            })
        end)
        local member_left = client:event_on('Someone left the team.', function(_, member)
            if not connection_event_allowed() then
                return
            end
            state.emit_event('member_left', {
                member = state.public_player(member),
            })
        end)
        local update_required = client:event_on('The client needs to be updated', function()
            if not connection_event_allowed() then
                return
            end
            state.emit_event('client_update_required', {
                required = true,
            })
        end)
        state.runtime.connection_cleanups = {
            function() remove_resource(ready) end,
            function() remove_resource(unavailable) end,
            function() remove_resource(disconnect) end,
            function() remove_resource(matching) end,
            function() remove_resource(launching) end,
            function() remove_resource(chat) end,
            function() remove_resource(team_changed) end,
            function() remove_resource(team_joined) end,
            function() remove_resource(team_left) end,
            function() remove_resource(member_joined) end,
            function() remove_resource(member_left) end,
            function() remove_resource(update_required) end,
        }
    end

    if client.start then
        local started, start_error = pcall(client.start, client)
        if not started then
            local reason = tostring(start_error)
            reject_connect_request(request)
            cleanup_connection()
            state.set_status('failed', reason)
            return result.rejected(action, 'connect_failed', reason)
        end
    end

    if is_valid_client(client) then
        done(true, 'ok', 'connection is ready', state.snapshot())
    end

    if request.done then
        return result.accepted(action, nil, {
            reason = state.runtime.status == 'connected' and 'connection is established' or (state.runtime.last_error or 'connection request finished'),
            code = state.runtime.status == 'connected' and 'connected' or 'failed',
            sync = true,
            result_data = state.snapshot(),
        })
    end

    return result.accepted(action, request.id, {
        reason = 'connection request started',
        code = 'connecting',
        result_data = state.snapshot(),
    })
end

---@return table?
---@return string?
function M.require_ready()
    if state.runtime.status == 'connecting' then
        return nil, 'connection_pending'
    end
    if not M.is_ready() then
        return nil, 'not_connected'
    end
    return state.runtime.client
end

function M.cancel_pending_connect(reason, settle_cancelled)
    local request_id = state.runtime.pending_request_id
    local request = request_id and state.runtime.pending[request_id] or nil
    if not request or state.runtime.locks.connect ~= request.id then
        return {
            cancelled = false,
            code = 'not_pending',
            reason = reason,
        }
    end

    request.cancelled = true
    request.done = true
    cleanup_connect_request(request)
    cleanup_connection()
    if settle_cancelled then
        settle_cancelled(request, false, 'cancelled_by_terminal', reason or 'cancelled by terminal action', state.snapshot())
    end
    return {
        cancelled = true,
        request_id = request.id,
        code = 'cancelled_by_terminal',
        reason = reason,
    }
end

return M
