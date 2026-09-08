package.path = './?.lua;./?/init.lua;' .. package.path

package.preload['clicli.game.lobby.result'] = function()
    return dofile('game/lobby/result.lua')
end
package.preload['clicli.game.lobby.state'] = function()
    return dofile('game/lobby/state.lua')
end
package.preload['clicli.game.lobby.client'] = function()
    return dofile('game/lobby/client.lua')
end
package.preload['clicli.game.lobby'] = function()
    return dofile('game/lobby/init.lua')
end
package.preload['clicli.game.lobby.eca'] = function()
    return dofile('game/lobby/eca.lua')
end
package.preload['clicli.game.lobby.bob'] = function()
    return dofile('game/lobby/bob.lua')
end
package.preload['clicli.game.lobby.service.client'] = function()
    return dofile('game/lobby/service/client.lua')
end
package.preload['clicli.game.lobby.service.define'] = function()
    return {}
end
package.preload['clicli.game.lobby.network.protocol'] = function()
    return {
        msgtype = {
            RPC_RETURN = 1,
            RPC_CALL = 2,
            RPC_EVENT = 3,
            RAW_PROTOCOL = 4,
            LOGIN_AUTH = 5,
        },
        event_subtype = {
            ON_RUNNING = 1,
            LOSE_CONNECTION = 2,
        },
    }
end
package.preload['clicli.game.lobby.network.fsm'] = function()
    return {
        new = function()
            return {
                init = function()
                end,
                add_state = function()
                end,
                add_transition = function()
                end,
                change_state = function()
                    return true
                end,
            }
        end,
    }
end
package.preload['clicli.game.lobby.proto.proto_helper'] = function()
    return {
        load_all = function()
            return true
        end,
        init_pb = function()
            return {
                is_service_method = function()
                    return false
                end,
                encode = function(_, _, data)
                    return data
                end,
                get_pb_desc = function()
                    return {
                        service_uuid = 1,
                        method_index = 1,
                    }
                end,
                get_pb_ret_type = function()
                    return 'protocol.Team_Login_ret'
                end,
                decode = function(_, _, data)
                    return data
                end,
                get_method_info = function()
                    return nil
                end,
            }
        end,
    }
end
package.preload['clicli.game.lobby.network.message_handler'] = function()
    return {
        new = function()
            return {
                set_network_event_handle = function()
                end,
                start = function()
                end,
                shutdown = function()
                end,
                send_request = function()
                    return true
                end,
                send_raw_message = function()
                    return true
                end,
            }
        end,
    }
end

local function assert_equal(actual, expected, message)
    if actual ~= expected then
        error((message or 'assert_equal failed') .. ': expected ' .. tostring(expected) .. ', got ' .. tostring(actual), 2)
    end
end

local function assert_not_contains(haystack, needle, message)
    if tostring(haystack):find(tostring(needle), 1, true) then
        error((message or 'assert_not_contains failed') .. ': leaked ' .. tostring(needle), 2)
    end
end

local function assert_contains(haystack, needle, message)
    if not tostring(haystack):find(tostring(needle), 1, true) then
        error((message or 'assert_contains failed') .. ': missing ' .. tostring(needle), 2)
    end
end

local TEST_GAME_PLAY_ID = 10190356
local eca_names = {}
local eca_definitions = {}
local bind = {}
local factory_calls = 0
local factory_game_play_ids = {}
local factory_in_games = {}
local factory_endpoint_envs = {}
local private_dungeon_requests = {}
local exit_game_calls = 0
local frame_callbacks = {}
local timeout_callbacks = {}
local timeout_timers = {}
local captured_logs = {}
local eca_call_impls = {
    "hallServiceRequestCompleted" = function()
    end,
}
local completion_payloads = {}
local latest_client
local next_client_options = {}
---@type false|string
local platform_return_error = false
local expected_eca = {
    { name = 'Hall Service - Establishing connections', params = { { 'Gameplay ID', 'integer' }, { 'Is it in a game level', 'boolean?' } } },
    { name = 'Hall Service - Get connection status', params = {} },
    { name = 'Hall Service - Set matching scores', params = { { 'Score', 'integer' } } },
    { name = 'Hall Service - Creating a queue', params = { { 'Headcount ceiling', 'integer' } } },
    { name = 'Hall Service - Join the queue', params = { { 'Team number', 'integer' } } },
    { name = 'Hall service - Leave the queue', params = {} },
    { name = 'Hall Service - Disband the team', params = {} },
    { name = 'Hall Service - Transfer Team Leader', params = { { 'Target: AID', 'integer' } } },
    { name = 'Hall service - Remove team members', params = { { 'Target: AID', 'integer' } } },
    { name = 'Hall Service - Get team members', params = {} },
    { name = 'Hall Service - Start matching', params = { { 'Matching parameters', 'table' } } },
    { name = 'Hall Service - Cancel Match', params = {} },
    { name = 'Hall Service - Send team chat', params = { { 'message', 'string' } } },
    { name = 'Hall Service - Send World Chat', params = { { 'message', 'string' } } },
    { name = 'Hall Service - Get chat records', params = { { 'channel', 'string?' } } },
    { name = 'Hall Service - Private Copy within the bureau', params = { { 'Copy parameter', 'table' } } },
    { name = 'Hall Service - Add password', params = { { 'Password', 'string' } } },
    { name = 'Hall Service - Get password', params = {} },
    { name = 'Hall Service - Return to the hall', params = { { 'Hall parameters', 'table' } } },
    { name = 'Hall Service - Exit the game', params = {} },
    { name = 'Hall Service - Get status snapshots', params = {} },
    { name = 'Hall Service - Get chat messages', params = { { 'Serial number', 'integer' }, { 'channel', 'string?' } } },
    { name = 'Hall Service - Get team member items', params = { { 'Serial number', 'integer' } } },
    { name = 'Hall Service - Get team information', params = { { 'Target: AID', 'integer?' } } },
    { name = 'Hall Service - Obtain player information', params = { { 'Target: AID', 'integer?' } } },
    { name = 'Hall Service - Refresh player information', params = {} },
}

---@class LobbyContract.GameAPI
---@field get_dungeon_info fun(): table
_G.GameAPI = {
    lua_get_start_args = function()
        return {}
    end,
    get_dungeon_info = function()
        return {
            map_id = 9001,
            game_play_id = '1001',
            level_id = 'lobby-contract',
            env = 'debug',
        }
    end,
    api_is_client = function()
        return false
    end,
    api_stop_luagc_control = function()
    end,
    visual_pyexec = function()
    end,
}

local function capture_log(level, ...)
    local values = { level }
    for i = 1, select('#', ...) do
        values[#values + 1] = tostring(select(i, ...))
    end
    captured_logs[#captured_logs + 1] = table.concat(values, ' ')
end

---@class LobbyContract.Log
_G.log = {
    info = function(...)
        capture_log('info', ...)
    end,
    debug = function(...)
        capture_log('debug', ...)
    end,
    warn = function(...)
        capture_log('warn', ...)
    end,
    error = function(...)
        capture_log('error', ...)
        error(table.concat({ ... }, ' '))
    end,
}

_G.Class = function(name)
    local cls = {}
    cls.__name = name
    _G[name] = cls
    setmetatable(cls, {
        __call = function(class_table, ...)
            local obj = setmetatable({}, { __index = class_table })
            if obj.__init then
                obj:__init(...)
            end
            return obj
        end,
    })
    return cls
end

_G.New = function(name)
    local cls = _G[name]
    return function(...)
        return cls(...)
    end
end

_G.Delete = function(obj)
    if obj and obj.__del then
        obj:__del()
    end
end

_G.IsValid = function(obj)
    return obj ~= nil
end

_G.Extends = function(_class_name, _parent_name, _init)
end

_G.clicli = {
    json = {
        decode = function(_text)
            return {
                sign = 'bob-runtime-sign-secret',
            }
        end,
    },
    inspect = function(value)
        if type(value) ~= 'table' then
            return tostring(value)
        end
        local parts = {}
        for key, item in pairs(value) do
            parts[#parts + 1] = tostring(key) .. '=' .. tostring(item)
        end
        return '{' .. table.concat(parts, ',') .. '}'
    end,
    eca = {
        has_custom_event = function(name)
            return not not eca_call_impls[name]
        end,
        def = function(name)
            eca_names[#eca_names + 1] = name
            local definition = {
                name = name,
                params = {},
                returns = {},
            }
            eca_definitions[name] = definition
            local builder = definition
            function builder:with_param(param_name, param_type)
                self.params[#self.params + 1] = { param_name, param_type }
                return self
            end
            function builder:with_return(return_name, return_type)
                self.returns[#self.returns + 1] = { return_name, return_type }
                return self
            end
            function builder:call(fn)
                bind[name] = fn
                return self
            end
            return builder
        end,
        call = function(name)
            local fn = eca_call_impls[name]
            if not fn then
                error('missing event')
            end
            fn()
        end,
    },
    const = {
        CustomEventName = {},
    },
    ltimer = {
        wait = function(delay, callback)
            timeout_callbacks[#timeout_callbacks + 1] = callback
            local timer = {
                delay = delay,
                removed = false,
                remove = function(self)
                    self.removed = true
                end,
            }
            timeout_timers[#timeout_timers + 1] = timer
            return timer
        end,
        wait_frame = function(_, callback)
            frame_callbacks[#frame_callbacks + 1] = callback
            return { remove = function() end }
        end,
    },
    ctimer = {
        wait_frame = function(_, callback)
            local timer = {
                removed = false,
                remove = function(self)
                    self.removed = true
                end,
            }
            frame_callbacks[#frame_callbacks + 1] = function()
                if not timer.removed then
                    callback(timer, 1)
                end
            end
            return timer
        end,
    },
    player = {
        get_local = function()
            return {
                get_id = function()
                    return 1
                end,
                get_platform_id = function()
                    return 10086
                end,
                get_platform_name = function()
                    return 'lobby-contract-player'
                end,
                get_platform_icon_url = function()
                    return 'lobby-contract-icon'
                end,
                handle = {
                    api_get_role_store_params = function(_self)
                        return '{"sign":"bob-runtime-sign-secret"}'
                    end,
                },
            }
        end,
        with_local = function(callback)
            callback({
                handle = {
                    request_create_private_dungeon = function(_, ...)
                        local args = table.pack(...)
                        if platform_return_error then
                            error(platform_return_error)
                        end
                        private_dungeon_requests[#private_dungeon_requests + 1] = {
                            level_id = args[1],
                            game_mode = args[2],
                            max_player = args[3],
                            custom_param = args[4],
                            argc = args.n,
                        }
                    end,
                    request_join_private_dungeon = function()
                    end,
                },
                exit_game = function()
                    exit_game_calls = exit_game_calls + 1
                end,
            })
        end,
    },
}

local lobby = require 'clicli.game.lobby'
local completion_listener = lobby.on_complete(function(payload)
    completion_payloads[#completion_payloads + 1] = payload
end)
local client = require 'clicli.game.lobby.client'
local state_api = require 'clicli.game.lobby.state'
local original_get_dungeon_info = GameAPI.get_dungeon_info
local original_game = clicli.game
local endpoint_platform_env = 'prod'
local endpoint_debug_mode = false
local function get_endpoint_dungeon_info()
    return { env = endpoint_platform_env }
end
GameAPI.get_dungeon_info = get_endpoint_dungeon_info
--Streamline the test stub to only implement the Game interface used in this scenario.
---@diagnostic disable-next-line: missing-fields
clicli.game = {
    is_debug_mode = function(_ignore_config)
        return endpoint_debug_mode
    end,
}
local explicit_pre_ip, _, explicit_pre_env = client._resolve_endpoint_for_test('pre')
assert_equal(explicit_pre_ip, '42.186.213.132', 'explicit pre endpoint uses the pre server address')
assert_equal(explicit_pre_env, 'pre', 'explicit endpoint_env selects pre outside debug mode')
local _, _, default_prod_env = client._resolve_endpoint_for_test()
assert_equal(default_prod_env, 'prod', 'missing endpoint_env follows platform environment')
endpoint_platform_env = 'pre'
local _, _, default_pre_env = client._resolve_endpoint_for_test()
assert_equal(default_pre_env, 'pre', 'platform pre environment remains pre by default')
endpoint_debug_mode = true
local debug_pre_ip, _, debug_pre_env = client._resolve_endpoint_for_test('pre')
assert_equal(debug_pre_ip, '42.186.215.253', 'debug mode always uses the qa server address')
assert_equal(debug_pre_env, 'qa', 'debug mode overrides explicit endpoint_env with qa')
local debug_default_ip, _, debug_default_env = client._resolve_endpoint_for_test()
assert_equal(debug_default_ip, '42.186.215.253', 'debug mode defaults to the qa server address')
assert_equal(debug_default_env, 'qa', 'missing endpoint_env still defaults to qa in debug mode')
GameAPI.get_dungeon_info = original_get_dungeon_info
clicli.game = original_game
local function install_fake_factory()
client._set_factory_for_test(function(game_play_id, in_game, endpoint_env)
    factory_calls = factory_calls + 1
    factory_game_play_ids[#factory_game_play_ids + 1] = game_play_id
    factory_in_games[#factory_in_games + 1] = in_game
    factory_endpoint_envs[#factory_endpoint_envs + 1] = endpoint_env or false
    local options = next_client_options
    next_client_options = {}
    latest_client = {
        aid = 10086,
        client = {},
        event_callbacks = {},
        event_handles = {},
        cleanup_before_exit_calls = 0,
        start_calls = 0,
        set_score_callbacks = {},
        is_valid = function()
            return options.valid ~= false
        end,
        event_on = function(self, event_name, callback)
            self.event_callbacks[#self.event_callbacks + 1] = {
                name = event_name,
                callback = callback,
            }
            local handle = {
                removed = false,
                remove = function(this)
                    this.removed = true
                end,
            }
            self.event_handles[#self.event_handles + 1] = handle
            return handle
        end,
        start = function(self)
            self.start_calls = self.start_calls + 1
            return true
        end,
        cleanup_before_exit = function(self, callback)
            self.cleanup_before_exit_calls = self.cleanup_before_exit_calls + 1
            self.cleanup_before_exit_callback = callback
            if self.cleanup_before_exit_returns_false then
                return false
            end
            if options.cleanup_before_exit_immediate ~= nil then
                callback(options.cleanup_before_exit_immediate, options.cleanup_before_exit_reason)
            end
            return true
        end,
        set_score = function(self, score, callback)
            self.set_score_callbacks[#self.set_score_callbacks + 1] = {
                score = score,
                callback = callback,
            }
            return true
        end,
        is_in_team = function(self)
            return self.team_info ~= nil
        end,
        is_captain = function(self)
            return self.team_info ~= nil and self.team_info.captain == self.aid
        end,
        is_matching = function(self)
            return self.matching == true
        end,
        is_launching = function(self)
            return self.launching == true
        end,
        can_match = function(self)
            if self.can_match_result == false then
                return false, self.can_match_reason
            end
            return true
        end,
        create_team = function(self, callback, member_limit)
            self.create_team_callback = callback
            self.last_member_limit = member_limit
            return true
        end,
        join_team = function(self, team_id, callback)
            self.last_team_id = team_id
            self.join_team_callback = callback
            return true
        end,
        leave_team = function(self, callback)
            self.leave_team_callback = callback
            return true
        end,
        dismiss_team = function(self, callback)
            self.dismiss_team_callback = callback
            return true
        end,
        change_captain = function(self, target_aid, callback)
            self.last_target_aid = target_aid
            self.change_captain_callback = callback
            return true
        end,
        team_kick = function(self, target_aid, callback)
            self.last_target_aid = target_aid
            self.team_kick_callback = callback
            return true
        end,
        cancel_match = function(self, callback)
            self.cancel_match_callback = callback
            return true
        end,
        send_chat = function(self, message, callback)
            self.last_team_message = message
            self.send_chat_callback = callback
            return true
        end,
        start_match = function(self, game_mode, score, callback)
            self.last_match = { game_mode = game_mode, score = score }
            self.start_match_callback = callback
            return true
        end,
        get_team_info = function(self, aid, callback)
            self.last_get_team_info_aid = aid
            self.get_team_info_callback = callback
            return true
        end,
        get_player_info = function(self, aid, callback)
            self.last_get_player_info_aid = aid
            self.get_player_info_callback = callback
            return true
        end,
        refresh_player_info = function(self, callback)
            self.refresh_player_info_callback = callback
            return true
        end,
    }
    return latest_client
end)
end

local function emit_client_event(fake, event_name, ...)
    for _, record in ipairs(fake.event_callbacks or {}) do
        if record.name == event_name then
            record.callback(nil, ...)
            return
        end
    end
    error('missing fake client event: ' .. tostring(event_name))
end

install_fake_factory()

require 'clicli.game.lobby.eca'

assert_equal(#eca_names, #expected_eca, 'The number of ECA interfaces')
for index, expected in ipairs(expected_eca) do
    assert_equal(eca_names[index], expected.name, 'ECA interface name #' .. index)
    local definition = eca_definitions[expected.name]
    assert_equal(type(definition), 'table', 'The ECA definition exists in #' .. index)
    assert_equal(#definition.params, #expected.params, expected.name .. 'Number of parameters')
    for param_index, param in ipairs(expected.params) do
        assert_equal(definition.params[param_index][1], param[1], expected.name .. 'Parameter Name #' .. param_index)
        assert_equal(definition.params[param_index][2], param[2], expected.name .. 'Parameter type #' .. param_index)
    end
    assert_equal(#definition.returns, 1, expected.name .. 'Return quantity')
    assert_equal(definition.returns[1][2], 'table', expected.name .. 'Return type')
end
assert_equal(eca_definitions['Hall service - Separate rooms for the same room'], nil, 'The ECA interface for the old shared room diversion must not exist')
assert_equal(eca_definitions['Hall Service - Cross-room convergence'], nil, 'The old cross-house combined ECA interface must not exist')
for _, function_name in ipairs({ 'same_room_split', 'cross_room_merge', 'start_private_dungeon' }) do
    assert_equal(lobby[function_name], nil, 'The old' .. function_name .. 'The Lua interface must not exist')
end
assert_equal(lobby._get_player_version_for_test(), '2.0', 'Player Agreement Version')
for _, function_name in ipairs({
    'on_event',
    'get_member',
    'get_chat_message',
    'get_team_info',
    'get_player_info',
    'refresh_player_info',
}) do
    assert_equal(type(lobby[function_name]), 'function', 'Expose the Lua interface' .. function_name)
end

local before = lobby.get_state()
assert_equal(before.result_data.status, 'idle', '"Initialization state"')
assert_equal(factory_calls, 0, 'Initialization does not create a client')

--Intentionally violating the public signature, the verification of missing parameters still returns a rejection result.
---@diagnostic disable-next-line: missing-parameter
local invalid_connect_missing = lobby.connect()
assert_equal(invalid_connect_missing.accepted, false, 'connect was rejected because it lacked a gameplay ID')
assert_equal(invalid_connect_missing.code, 'invalid_game_play_id', 'connect is missing the gameplay ID code')
--Intentionally pass in a string to verify the runtime parameter validation.
---@diagnostic disable-next-line: param-type-mismatch
local invalid_connect_string = lobby.connect(tostring(TEST_GAME_PLAY_ID))
assert_equal(invalid_connect_string.accepted, false, 'The connect string gameplay ID was rejected')
assert_equal(invalid_connect_string.code, 'invalid_game_play_id', 'connect string gameplay ID code')
local invalid_connect_zero = lobby.connect(0)
assert_equal(invalid_connect_zero.accepted, false, 'The non-official play ID of connect was rejected')
assert_equal(invalid_connect_zero.code, 'invalid_game_play_id', 'connect non-positive play ID code')
local invalid_connect_negative = lobby.connect(-1)
assert_equal(invalid_connect_negative.accepted, false, 'The connect negative play ID was rejected')
assert_equal(invalid_connect_negative.code, 'invalid_game_play_id', 'connect negative number play ID code')
--Intentionally passing in a decimal to verify the integer constraint.
---@diagnostic disable-next-line: param-type-mismatch
local invalid_connect_fraction = lobby.connect(10190356.5)
assert_equal(invalid_connect_fraction.accepted, false, 'The connect decimal play ID was rejected')
assert_equal(invalid_connect_fraction.code, 'invalid_game_play_id', 'connect Decimal Play ID code')
assert_equal(factory_calls, 0, 'invalid connect does not create a client')

local return_without_connection = lobby.return_lobby({
    level_id = 'official-lobby',
    game_mode = 1201,
    max_player = 8,
    custom_param = 'official-param',
})
assert_equal(return_without_connection.accepted, true, 'return_lobby is not connected and executable')
assert_equal(factory_calls, 0, 'return_lobby does not create a client if it is not connected')
assert_equal(#private_dungeon_requests, 1, 'The return_lobby is not connected to the calling platform request')
assert_equal(private_dungeon_requests[1].level_id, 'official-lobby', 'return_lobby is not connected to level_id')
assert_equal(private_dungeon_requests[1].custom_param, 'official-param', 'The return_lobby is not connected to custom_param')
if #frame_callbacks > 0 then
    frame_callbacks[#frame_callbacks]()
end

local frames_before_exit_without_connection = #frame_callbacks
local completions_before_exit_without_connection = #completion_payloads
local exit_without_connection = lobby.exit_game()
assert_equal(exit_without_connection.accepted, true, 'exit_game is not connected and executable')
assert_equal(factory_calls, 0, 'exit_game does not create a client when not connected')
assert_equal(exit_game_calls, 0, 'exit_game returns first and then exits when not connected')
assert_equal(#frame_callbacks >= frames_before_exit_without_connection + 1, true, 'exit_game without connection schedules completion frame')
frame_callbacks[frames_before_exit_without_connection + 1]()
assert_equal(#completion_payloads, completions_before_exit_without_connection + 1, 'exit_game without connection publishes completion first')
assert_equal(completion_payloads[#completion_payloads].request_id, exit_without_connection.request_id, 'exit_game without connection completion request_id')
assert_equal(exit_game_calls, 0, 'exit_game without connection does not exit in completion frame')
assert_equal(#frame_callbacks >= frames_before_exit_without_connection + 2, true, 'exit_game without connection schedules exit frame')
frame_callbacks[frames_before_exit_without_connection + 2]()
assert_equal(exit_game_calls, 1, 'exit_game exits the engine once when not connected')

local connect_result = lobby.connect(TEST_GAME_PLAY_ID)
assert_equal(connect_result.accepted, true, 'connect accepted')
assert_equal(factory_calls, 1, 'connect creates the client')
assert_equal(factory_game_play_ids[#factory_game_play_ids], TEST_GAME_PLAY_ID, 'connect forwards game_play_id to factory')
assert_equal(factory_endpoint_envs[#factory_endpoint_envs], false, 'connect defaults to the platform endpoint environment')
assert_equal(factory_in_games[#factory_in_games], false, 'By default, connect does not connect by game level')

local duplicate = lobby.connect(TEST_GAME_PLAY_ID)
assert_equal(factory_calls, 1, '"connected" does not repeatedly create clients')
assert_equal(duplicate.result_data.connected, true, 'connected snapshot')

assert_equal(type(lobby.on_event), 'function', 'Expose the on_event event interface')
local event_payloads = {}
local all_event_payloads = {}
local connection_event_listener = lobby.on_event('connection_changed', function(payload)
    event_payloads[#event_payloads + 1] = payload
end)
local all_event_listener = lobby.on_event(function(payload)
    all_event_payloads[#all_event_payloads + 1] = payload
end)
latest_client.event_callbacks[3].callback(nil, 'disconnect')
local disconnected_payload = event_payloads[#event_payloads]
assert_equal(type(disconnected_payload), 'table', 'connection_changed stable load')
assert_equal(disconnected_payload.event, 'connection_changed', 'The name of the connection_changed event')
assert_equal(disconnected_payload.source, 'lobby', 'Source of connection_changed')
assert_equal(disconnected_payload.status, 'disconnected', '"connection_changed status.')
assert_equal(type(disconnected_payload.sequence), 'number', 'connection_changed serial number')
assert_equal(type(disconnected_payload.snapshot), 'table', 'connection_changed snapshot')
local disconnected_event_count = #event_payloads
state_api.set_status('disconnected', 'updated diagnostic only')
assert_equal(#event_payloads, disconnected_event_count, 'The same connection status will not be notified repeatedly due to changes in reason')
assert_equal(lobby.get_state().result_data.last_error, 'updated diagnostic only', 'same connection status reason updates snapshot last_error')

local failed_event_count_before_listener_error = 0
for _ in pairs(lobby.get_state().result_data.failed_events) do
    failed_event_count_before_listener_error = failed_event_count_before_listener_error + 1
end
local failing_event_listener = lobby.on_event('connection_changed', function()
    error('ordinary listener failed')
end)
state_api.set_status('failed', 'listener failure probe')
local failed_events_after_listener_error = lobby.get_state().result_data.failed_events
local failed_event_count_after_listener_error = 0
for _, failed_event in pairs(failed_events_after_listener_error) do
    failed_event_count_after_listener_error = failed_event_count_after_listener_error + 1
    if failed_event.payload and failed_event.payload.event == 'connection_changed' then
        assert_equal(tostring(failed_event.error):find('ordinary listener failed', 1, true) ~= nil, true, 'ordinary on_event listener error is recorded')
    end
end
assert_equal(failed_event_count_after_listener_error, failed_event_count_before_listener_error + 1, 'ordinary on_event listener failure writes failed_events')
failing_event_listener.remove()
state_api.set_status('disconnected', 'listener removed probe')
local failed_event_count_after_remove = 0
for _ in pairs(lobby.get_state().result_data.failed_events) do
    failed_event_count_after_remove = failed_event_count_after_remove + 1
end
assert_equal(failed_event_count_after_remove, failed_event_count_after_listener_error, 'removed failing on_event listener no longer affects events')

local team_event_payload
local team_event_listener = lobby.on_event('team_changed', function(payload)
    team_event_payload = payload
end)
local raw_team = {
    team_id = 77001,
    member_limit = 4,
    captain = 10086,
    team_state = 'leisure',
    version = 3,
    internal_token = 'must-not-leak',
    members = {
        { aid = 10086, name = 'captain', score = 10, internal_token = 'member-secret' },
    },
}
emit_client_event(latest_client, 'Team changes', raw_team)
assert_equal(team_event_payload.data.team == raw_team, false, 'team_changed does not disclose BOB`s original team table')
assert_equal(team_event_payload.data.team.internal_token, nil, 'team_changed removes the internal team field')
assert_equal(team_event_payload.data.team.members[1].internal_token, nil, 'team_changed removes the internal member field')
team_event_listener.remove()

local message_event_payload
local message_event_listener = lobby.on_event('message_received', function(payload)
    message_event_payload = payload
end)
local raw_message = {
    mode = 'chat',
    time = 123,
    message = 'hello',
    type = 4,
    chat = {
        sender = { aid = 10086, nickname = 'captain', head_icon = 'icon' },
        internal_token = 'chat-secret',
    },
}
emit_client_event(latest_client, 'Received the message', raw_message)
assert_equal(message_event_payload.data.message == raw_message, false, 'message_received does not disclose the original message table of BOB')
assert_equal(message_event_payload.data.message.chat, nil, 'message_received removes the internal chat field')
assert_equal(message_event_payload.data.message.sender.aid, 10086, 'The message_received retains the public sender field')
message_event_listener.remove()

local removed_event_count = #event_payloads
connection_event_listener.remove()
latest_client.event_callbacks[3].callback(nil, 'login')
assert_equal(#event_payloads, removed_event_count, 'No callback after on_event remove')
assert_equal(all_event_payloads[#all_event_payloads].event, 'connection_changed', 'The on_event full listener can receive events')
all_event_listener.remove()

client._reset_for_test()
install_fake_factory()
local raw_game_api = rawget(_G, 'GameAPI')
local global_metatable = getmetatable(_G)
local injected_game_api = {
    get_dungeon_info = function()
        return {
            env = 'debug',
            level_id = 'metatable-level',
            space_id = 'current-dungeon-token',
        }
    end,
}
rawset(_G, 'GameAPI', nil)
setmetatable(_G, {
    __index = function(_, key)
        if key == 'GameAPI' then
            return injected_game_api
        end
        local inherited_index = global_metatable and global_metatable.__index
        if type(inherited_index) == 'function' then
            return inherited_index(_G, key)
        end
        if type(inherited_index) == 'table' then
            return inherited_index[key]
        end
        return nil
    end,
})
local in_game_connect = lobby.connect(TEST_GAME_PLAY_ID, true, 'pre')
assert_equal(factory_endpoint_envs[#factory_endpoint_envs], 'pre', 'connect forwards endpoint_env to client factory')
assert_equal(in_game_connect.accepted, true, 'connect supports the Boolean parameter in_game')
assert_equal(factory_in_games[#factory_in_games], true, 'connect forwards in_game to the client factory')
latest_client.event_callbacks[1].callback()
local metatable_token = lobby.get_token()
assert_equal(metatable_token.result_data.token, 'current-dungeon-token', 'The get_token supports the GameAPI for meta-table injection')
local metatable_snapshot = lobby.get_state().result_data
assert_equal(metatable_snapshot.token, 'current-dungeon-token', 'The state snapshot supports the GameAPI for meta table injection')
assert_equal(metatable_snapshot.level_id, 'metatable-level', 'The status snapshot reads the level information of the metatartable GameAPI')
local _, _, metatable_endpoint_env = client._resolve_endpoint_for_test()
assert_equal(metatable_endpoint_env, 'qa', 'Connect the environment to parse the GameAPI that supports meta-table injection')
local join_log_token = 'join-dungeon-token'
local join_log_result = lobby.join_by_token(' ' .. join_log_token .. ' ')
assert_equal(join_log_result.accepted, true, 'The join_by_token diagnostic log test request has been submitted')
local private_dungeon_log_output = table.concat(captured_logs, '\n')
assert_contains(private_dungeon_log_output, 'Current level password', 'Record the password of the current level after the game level is ready')
assert_contains(private_dungeon_log_output, 'token=current-dungeon-token', 'The current level password log retains the complete password')
assert_contains(private_dungeon_log_output, 'Add password request', 'Record the diagnostic log when submitting the join password')
assert_contains(private_dungeon_log_output, 'token=<redacted>', 'Add the password log to desensitize and enter the password')
setmetatable(_G, global_metatable)
rawset(_G, 'GameAPI', raw_game_api)
client._reset_for_test()
install_fake_factory()
--Intentionally using an unsupported options table, the verification of the old calling method was rejected.
---@diagnostic disable-next-line: param-type-mismatch
local table_options_connect = lobby.connect(TEST_GAME_PLAY_ID, { in_game = true })
assert_equal(table_options_connect.accepted, false, 'connect does not disclose the options table')
assert_equal(table_options_connect.code, 'invalid_argument', 'connect options table code')
local factory_calls_before_invalid_endpoint = factory_calls
local invalid_endpoint_connect = lobby.connect(TEST_GAME_PLAY_ID, false, 'staging')
assert_equal(invalid_endpoint_connect.accepted, false, 'connect rejects unsupported endpoint_env')
assert_equal(invalid_endpoint_connect.code, 'invalid_argument', 'connect endpoint_env code')
assert_equal(factory_calls, factory_calls_before_invalid_endpoint, 'invalid endpoint_env does not create client')

local eca_connect_invalid = bind['Hall Service - Establishing connections']()
assert_equal(eca_connect_invalid.accepted, false, 'ECA connect was rejected due to the lack of gameplay ID')
assert_equal(eca_connect_invalid.code, 'invalid_game_play_id', 'ECA connect lacks the gameplay ID code')

Eca_call_impls['HallServiceRequestCompleted'] = nil
local not_connected_result = bind['Hall Service - Send World Chat']('hello')
assert_equal(not_connected_result.code, 'event_missing', 'The pre-examination for ECA events is missing')

local disconnect_setup = lobby.connect(TEST_GAME_PLAY_ID)
assert_equal(disconnect_setup.accepted, true, 'disconnect setup connect accepted')
latest_client.event_callbacks[3].callback(nil, 'disconnect')
assert_equal(lobby.get_state().result_data.status, 'disconnected', 'connected client disconnect updates status')
local disconnected_client = latest_client
local disconnected_requests = #private_dungeon_requests
local disconnected_return = lobby.return_lobby({
    level_id = 'official-disconnected-return',
    game_mode = 1201,
    max_player = 8,
})
assert_equal(disconnected_return.accepted, true, 'return_lobby accepts from disconnected status')
assert_equal(#private_dungeon_requests, disconnected_requests + 1, 'return_lobby submits platform request while disconnected')
assert_equal(client.get(), disconnected_client, 'return_lobby preserves disconnected client')
assert_equal(lobby.get_state().result_data.status, 'disconnected', 'return_lobby restores disconnected status')
local reconnect_after_disconnect = lobby.connect(TEST_GAME_PLAY_ID)
assert_equal(reconnect_after_disconnect.accepted, true, 'reconnect after disconnect accepted')
latest_client.event_callbacks[1].callback()
assert_equal(lobby.get_state().result_data.status, 'connected', 'reconnect after disconnect restores connected status')

local return_connected_before_requests = #private_dungeon_requests
local return_connected_before_completions = #completion_payloads
local return_connected_client = latest_client
local return_connected_cleanup_calls = latest_client.cleanup_before_exit_calls
latest_client.team_info = {
    team_id = 77221,
    captain = latest_client.aid,
    members = { { aid = latest_client.aid } },
}
local return_connected = lobby.return_lobby({
    level_id = 'official-connected-return',
    game_mode = 1202,
    max_player = 8,
})
assert_equal(return_connected.accepted, true, 'return_lobby connected accepted')
assert_equal(return_connected.result_data.platform_requested, true, 'return_lobby connected reports platform request')
assert_equal(return_connected.result_data.cross_map_tracking, 'degraded', 'return_lobby connected reports degraded tracking')
assert_equal(#private_dungeon_requests, return_connected_before_requests + 1, 'return_lobby connected requests platform immediately')
assert_equal(#completion_payloads, return_connected_before_completions, 'return_lobby connected does not publish completion')
assert_equal(return_connected.request_id, '', 'return_lobby does not expose awaitable request id')
assert_equal(latest_client.cleanup_before_exit_calls, return_connected_cleanup_calls, 'return_lobby does not run exit cleanup')
assert_equal(client.get(), return_connected_client, 'return_lobby preserves lobby client')
assert_equal(latest_client.team_info.team_id, 77221, 'return_lobby preserves cached team state')
assert_equal(lobby.get_state().result_data.status, 'connected', 'return_lobby preserves connected status')

local function reset_contract_runtime()
    client._reset_for_test()
    install_fake_factory()
    private_dungeon_requests = {}
    exit_game_calls = 0
    frame_callbacks = {}
    timeout_callbacks = {}
    timeout_timers = {}
    completion_payloads = {}
    latest_client = nil
    next_client_options = {}
    platform_return_error = false
end

local function drain_frames()
    while #frame_callbacks > 0 do
        local callbacks = frame_callbacks
        frame_callbacks = {}
        for _, callback in ipairs(callbacks) do
            callback()
        end
    end
end

local function count_completion(request_id, code)
    local count = 0
    local last
    for _, payload in ipairs(completion_payloads) do
        if payload.request_id == request_id and (not code or payload.code == code) then
            count = count + 1
            last = payload
        end
    end
    return count, last
end

local function assert_no_late_change(request_id, status_before, completion_count_before, message)
    local status = lobby.get_state().result_data.status
    assert_equal(status, status_before, message .. ' status')
    assert_equal(#completion_payloads, completion_count_before, message .. ' completion count')
    assert_equal(count_completion(request_id), 1, message .. ' original completion remains once')
end

local function trigger_saved_connect_callbacks(saved_client, saved_timeout_callback, request_id, stable_status, stable_completion_count)
    assert_equal(#saved_client.event_callbacks >= 3, true, 'pending connect captured ready/unavailable/status callbacks')
    saved_client.event_callbacks[1].callback()
    assert_no_late_change(request_id, stable_status, stable_completion_count, 'late ready no-op')
    saved_client.event_callbacks[2].callback(nil, 'late unavailable')
    assert_no_late_change(request_id, stable_status, stable_completion_count, 'late unavailable no-op')
    saved_client.event_callbacks[3].callback(nil, 'login')
    assert_no_late_change(request_id, stable_status, stable_completion_count, 'late login no-op')
    saved_client.event_callbacks[3].callback(nil, 'disconnect')
    assert_no_late_change(request_id, stable_status, stable_completion_count, 'late disconnect no-op')
    saved_timeout_callback()
    assert_no_late_change(request_id, stable_status, stable_completion_count, 'late timeout no-op')
end

local terminal_lock_params = {
    level_id = 'official-terminal-locked-return',
    game_mode = 1307,
    max_player = 8,
}

local function assert_terminal_locked(result, message)
    assert_equal(type(result), 'table', message .. ' result')
    assert_equal(result.accepted, false, message .. ' accepted')
    assert_equal(result.code, 'terminal_locked', message .. ' code')
end

local function assert_sync_invalid_without_platform(call, message)
    local requests_before = #private_dungeon_requests
    local status_before = lobby.get_state().result_data.status
    local result_value = call()
    assert_equal(type(result_value), 'table', message .. ' result')
    assert_equal(result_value.accepted, false, message .. ' accepted')
    assert_equal(result_value.code, 'invalid_argument', message .. ' code')
    assert_equal(result_value.sync, true, message .. ' sync')
    assert_equal(#private_dungeon_requests, requests_before, message .. ' no platform request')
    local snapshot = lobby.get_state().result_data
    assert_equal(snapshot.pending_count, 0, message .. ' no pending request')
    assert_equal(snapshot.status, status_before, message .. ' status unchanged')
end

local function assert_exit_terminal_settled(exit_result, completion_count_before, exit_calls_before, message)
    assert_equal(count_completion(exit_result.request_id, 'ok'), 1, message .. ' completion once')
    assert_equal(#completion_payloads, completion_count_before + 1, message .. ' no extra completions')
    assert_equal(exit_game_calls, exit_calls_before, message .. ' actual exit not in completion frame')
    assert_equal(#frame_callbacks, 1, message .. ' actual exit scheduled for next frame')
    frame_callbacks[1]()
    assert_equal(exit_game_calls, exit_calls_before + 1, message .. ' actual exit once')
    for index = 2, #frame_callbacks do
        frame_callbacks[index]()
    end
    assert_equal(exit_game_calls, exit_calls_before + 1, message .. ' no duplicate exit')
    assert_equal(lobby.get_state().result_data.status, 'idle', message .. ' final idle')
end

reset_contract_runtime()
local connected_for_error_contracts = lobby.connect(TEST_GAME_PLAY_ID)
assert_equal(connected_for_error_contracts.accepted, true, 'connect for stable error contracts accepted')
assert_equal(lobby.get_state().result_data.has_team, false, 'snapshot has_team false without cached team')
assert_equal(lobby.leave_team().code, 'not_in_team', 'leave_team local error code')
assert_equal(lobby.dismiss_team().code, 'not_in_team', 'dismiss_team local error code')
assert_equal(lobby.cancel_match().code, 'not_matching', 'cancel_match local error code')
assert_equal(lobby.send_team_chat('hello').code, 'not_in_team', 'send_team_chat local error code')

latest_client.team_info = {
    team_id = 88001,
    captain = 99001,
    members = {
        { aid = latest_client.aid },
        { aid = 99001 },
    },
}
assert_equal(lobby.get_state().result_data.has_team, true, 'snapshot has_team true with cached team')
assert_equal(lobby.dismiss_team().code, 'not_captain', 'dismiss_team captain error code')
assert_equal(lobby.change_captain(99002).code, 'not_captain', 'change_captain captain error code')

latest_client.team_info.captain = latest_client.aid
assert_equal(lobby.change_captain(99002).code, 'member_not_found', 'change_captain member error code')
assert_equal(lobby.kick_member(99002).code, 'member_not_found', 'kick_member member error code')

latest_client.matching = true
assert_equal(lobby.join_team(88002).code, 'state_conflict', 'join_team state error code')
assert_equal(lobby.leave_team().code, 'state_conflict', 'leave_team state error code')
latest_client.matching = false
latest_client.can_match_result = false
latest_client.can_match_reason = 'Someone is in the game'
assert_equal(lobby.start_match({ level_id = 'error-contract', game_mode = 1401 }).code, 'state_conflict', 'start_match state error code')
latest_client.can_match_result = nil

local team_query = lobby.get_team_info(99003)
assert_equal(team_query.accepted, true, 'get_team_info no-team query accepted')
latest_client.get_team_info_callback(nil, nil)
local _, team_query_payload = count_completion(team_query.request_id)
assert_equal(team_query_payload.success, true, 'get_team_info no-team query succeeds')
assert_equal(team_query_payload.result_data.has_team, false, 'get_team_info no-team result flag')

latest_client.team_info = nil
local missing_player_query = lobby.get_player_info(99004)
assert_equal(missing_player_query.accepted, true, 'get_player_info missing query accepted')
latest_client.get_player_info_callback(nil, nil)
local _, missing_player_payload = count_completion(missing_player_query.request_id)
assert_equal(missing_player_payload.success, false, 'get_player_info missing query fails')
assert_equal(missing_player_payload.code, 'player_not_found', 'get_player_info missing code')

local remote_player_query = lobby.get_player_info(99005)
assert_equal(remote_player_query.accepted, true, 'get_player_info remote error query accepted')
latest_client.get_player_info_callback(nil, 'remote-string-error')
local _, remote_player_payload = count_completion(remote_player_query.request_id)
assert_equal(remote_player_payload.code, 'rpc_failed', 'get_player_info remote error code')
assert_equal(remote_player_payload.result_data.remote_error_code, 'remote-string-error', 'get_player_info preserves original remote error')

latest_client.chat_history = {
    alpha = {
        { sequence = 1, channel = 'alpha', message = 'one' },
        { sequence = 3, channel = 'alpha', message = 'three' },
        { time = 10, channel = 'alpha', message = 'time-ten-alpha' },
        { time = 20, channel = 'alpha', message = 'time-twenty-alpha' },
    },
    beta = {
        { sequence = 2, channel = 'beta', message = 'two' },
        { sequence = 4, channel = 'beta', message = 'four' },
        { time = 10, channel = 'beta', message = 'time-ten-beta' },
        { time = 10, channel = 'beta', message = 'time-ten-beta-stable' },
    },
}
latest_client.message_history = {}
local merged_history = lobby.get_chat_history().result_data.messages
assert_equal(merged_history[1].message, 'one', 'chat history order #1')
assert_equal(merged_history[2].message, 'two', 'chat history order #2')
assert_equal(merged_history[3].message, 'three', 'chat history order #3')
assert_equal(merged_history[4].message, 'four', 'chat history order #4')
assert_equal(merged_history[5].message, 'time-ten-alpha', 'chat history missing sequence time order #1')
assert_equal(merged_history[6].message, 'time-ten-beta', 'chat history missing sequence time order #2')
assert_equal(merged_history[7].message, 'time-ten-beta-stable', 'chat history missing sequence stable order')
assert_equal(merged_history[8].message, 'time-twenty-alpha', 'chat history missing sequence time order #4')

local saved_with_local = clicli.player.with_local
reset_contract_runtime()
clicli.player.with_local = function()
end
local split_without_player = lobby.private_dungeon({
    level_id = 'missing-player',
    game_mode = 1403,
    max_player = 2,
})
assert_equal(split_without_player.code, 'local_player_missing', 'private_dungeon missing local player code')
clicli.player.with_local = saved_with_local

reset_contract_runtime()
local connected_for_argument_boundaries = lobby.connect(TEST_GAME_PLAY_ID)
assert_equal(connected_for_argument_boundaries.accepted, true, 'connect for argument boundary checks accepted')
assert_sync_invalid_without_platform(function()
    return lobby.return_lobby(nil)
end, 'return_lobby nil params')
assert_sync_invalid_without_platform(function()
    return lobby.return_lobby('bad')
end, 'return_lobby non-table params')
assert_sync_invalid_without_platform(function()
    return lobby.return_lobby({ level_id = '  ', game_mode = 1404, max_player = 2 })
end, 'return_lobby empty level_id')
assert_sync_invalid_without_platform(function()
    return lobby.return_lobby({ level_id = 'invalid-mode', game_mode = 1404.5, max_player = 2 })
end, 'return_lobby non-integer game_mode')
assert_sync_invalid_without_platform(function()
    return lobby.return_lobby({ level_id = 'invalid-max-player', game_mode = 1404, max_player = 0 })
end, 'return_lobby non-positive max_player')
assert_sync_invalid_without_platform(function()
    return lobby.private_dungeon({ level_id = 'explicit-players', game_mode = 1405, max_player = 2, players = {} })
end, 'private_dungeon rejects externally supplied players')
local solo_before_requests = #private_dungeon_requests
local solo_private = lobby.private_dungeon({
    level_id = 'solo-private',
    game_mode = 1405,
    max_player = 2,
})
assert_equal(solo_private.accepted, true, 'private_dungeon solo accepts without team')
assert_equal(#private_dungeon_requests, solo_before_requests + 1, 'private_dungeon solo calls platform')
assert_equal(private_dungeon_requests[#private_dungeon_requests].level_id, 'solo-private', 'private_dungeon solo forwards level_id')
assert_equal(private_dungeon_requests[#private_dungeon_requests].argc, 3, 'private_dungeon without custom_param uses three arguments')
assert_equal(solo_private.result_data.route, 'solo_engine', 'private_dungeon solo route')
assert_equal(solo_private.result_data.completion_mode, 'request_only', 'private_dungeon solo completion mode')
assert_equal(solo_private.request_id, '', 'private_dungeon solo has no awaitable request id')
assert_equal(lobby.get_state().result_data.pending_count, 0, 'private_dungeon solo leaves no pending request')
local solo_retry = lobby.private_dungeon({ level_id = 'solo-retry', game_mode = 1405, max_player = 2 })
assert_equal(solo_retry.accepted, true, 'private_dungeon solo remains retryable when platform does not switch map')
assert_equal(#private_dungeon_requests, solo_before_requests + 2, 'private_dungeon solo retry calls platform again')

latest_client.team_info = {
    team_id = 456,
    captain = latest_client.aid,
    members = {
        { aid = latest_client.aid, in_game = false },
    },
}
local one_member_before_requests = #private_dungeon_requests
assert_equal(lobby._private_dungeon_completion_mode_for_eca({}), 'request_only', 'one-member team uses request-only ECA route')
local one_member_private = lobby.private_dungeon({
    level_id = 'platform-one-member',
    engine_level_id = 'engine-one-member',
    game_mode = 1405,
    max_player = 2,
})
assert_equal(one_member_private.accepted, true, 'private_dungeon one-member team accepts through engine route')
assert_equal(#private_dungeon_requests, one_member_before_requests + 1, 'private_dungeon one-member team calls engine request')
assert_equal(private_dungeon_requests[#private_dungeon_requests].level_id, 'engine-one-member', 'private_dungeon one-member team forwards engine level id')
assert_equal(one_member_private.result_data.route, 'solo_engine', 'private_dungeon one-member team route')
assert_equal(one_member_private.result_data.completion_mode, 'request_only', 'private_dungeon one-member team completion mode')

reset_contract_runtime()
next_client_options = { valid = false }
local pending_return_connect = lobby.connect(TEST_GAME_PLAY_ID)
local pending_return_client = latest_client
local pending_return_timeout_callback = timeout_callbacks[#timeout_callbacks]
assert_equal(pending_return_connect.accepted, true, 'pending connect before return_lobby accepted')
assert_equal(lobby.get_state().result_data.status, 'connecting', 'pending connect status before return_lobby')
local pending_return = lobby.return_lobby({
    level_id = 'official-pending-return',
    game_mode = 1301,
    max_player = 8,
})
assert_equal(pending_return.accepted, true, 'return_lobby accepts while connect pending')
assert_equal(pending_return_client.cleanup_before_exit_calls, 0, 'return_lobby must not cleanup half-initialized pending client')
assert_equal(count_completion(pending_return_connect.request_id, 'cancelled_by_terminal'), 1, 'pending connect cancelled exactly once by return_lobby')
drain_frames()
assert_equal(count_completion(pending_return.request_id, 'ok'), 0, 'return_lobby does not publish completion after cancelling connect')
assert_equal(#private_dungeon_requests, 1, 'return_lobby terminal still requests platform once')
assert_equal(lobby.get_state().result_data.status, 'idle', 'return_lobby after pending connect ends idle')
assert_equal(client.get(), nil, 'return_lobby clears pending client')
for index, handle in ipairs(pending_return_client.event_handles) do
    assert_equal(handle.removed, true, 'return_lobby removes pending connect listener #' .. index)
end
trigger_saved_connect_callbacks(
    pending_return_client,
    pending_return_timeout_callback,
    pending_return_connect.request_id,
    lobby.get_state().result_data.status,
    #completion_payloads)

reset_contract_runtime()
next_client_options = { valid = false }
local pending_exit_connect = lobby.connect(TEST_GAME_PLAY_ID)
local pending_exit_client = latest_client
local pending_exit_timeout_callback = timeout_callbacks[#timeout_callbacks]
local pending_exit = lobby.exit_game()
assert_equal(pending_exit.accepted, true, 'exit_game accepts while connect pending')
assert_equal(pending_exit_client.cleanup_before_exit_calls, 0, 'exit_game must not cleanup half-initialized pending client')
assert_equal(count_completion(pending_exit_connect.request_id, 'cancelled_by_terminal'), 1, 'pending connect cancelled exactly once by exit_game')
drain_frames()
assert_equal(count_completion(pending_exit.request_id, 'ok'), 1, 'exit_game terminal completes after cancelling connect')
assert_equal(exit_game_calls, 1, 'exit_game after pending connect exits once on next frame')
assert_equal(lobby.get_state().result_data.status, 'idle', 'exit_game after pending connect ends idle')
assert_equal(client.get(), nil, 'exit_game clears pending client')
for index, handle in ipairs(pending_exit_client.event_handles) do
    assert_equal(handle.removed, true, 'exit_game removes pending connect listener #' .. index)
end
trigger_saved_connect_callbacks(
    pending_exit_client,
    pending_exit_timeout_callback,
    pending_exit_connect.request_id,
    lobby.get_state().result_data.status,
    #completion_payloads)

reset_contract_runtime()
local connected_for_operation = lobby.connect(TEST_GAME_PLAY_ID)
assert_equal(connected_for_operation.accepted, true, 'connect for pending operation accepted')
assert_equal(lobby.get_state().result_data.status, 'connected', 'connected before pending operation')
local pending_operation = lobby.set_score(123)
assert_equal(pending_operation.accepted, true, 'operation pending before terminal accepted')
local pending_operation_client = latest_client
local terminal_during_operation = lobby.return_lobby({
    level_id = 'official-operation-return',
    game_mode = 1302,
    max_player = 8,
})
assert_equal(terminal_during_operation.accepted, true, 'terminal bypasses ordinary operation lock')
assert_equal(count_completion(pending_operation.request_id, 'cancelled_by_terminal'), 1, 'ordinary operation cancelled exactly once by terminal')
assert_equal(pending_operation_client.cleanup_before_exit_calls, 0, 'return_lobby does not cleanup client during pending operation')
assert_equal(client.get(), pending_operation_client, 'return_lobby preserves client during pending operation')
assert_equal(lobby.get_state().result_data.status, 'connected', 'return_lobby restores connected status after cancelling operation')
assert_equal(count_completion(terminal_during_operation.request_id, 'ok'), 0, 'return_lobby does not complete after cancelling ordinary operation')
local after_operation_terminal_count = #completion_payloads
pending_operation_client.set_score_callbacks[1].callback(nil, nil)
assert_equal(#completion_payloads, after_operation_terminal_count, 'late ordinary operation callback is no-op after terminal cancellation')

reset_contract_runtime()
next_client_options = { valid = false }
local reentrant_connect = lobby.connect(TEST_GAME_PLAY_ID)
local reentrant_factory_before_terminal = factory_calls
local reentrant_result
local reentrant_listener = lobby.on_complete(function(payload)
    if payload.request_id == reentrant_connect.request_id and payload.code == 'cancelled_by_terminal' then
        reentrant_result = lobby.connect(TEST_GAME_PLAY_ID)
    end
end)
local reentrant_terminal = lobby.return_lobby({
    level_id = 'official-reentrant-return',
    game_mode = 1303,
    max_player = 8,
})
assert_equal(reentrant_terminal.accepted, true, 'terminal for reentrant listener accepted')
assert_equal(type(reentrant_result), 'table', 'cancel completion listener reentered connect')
assert_equal(reentrant_result.accepted, false, 'reentrant connect rejected while terminal closing')
assert_equal(reentrant_result.code, 'connection_closing', 'reentrant connect returns connection_closing')
assert_equal(factory_calls, reentrant_factory_before_terminal, 'reentrant connect does not create new client')
reentrant_listener.remove()
drain_frames()

reset_contract_runtime()
local connected_for_terminal_lock = lobby.connect(TEST_GAME_PLAY_ID)
assert_equal(connected_for_terminal_lock.accepted, true, 'connect for terminal lock accepted')
local retry_client = latest_client
local retry_cleanup_calls = latest_client.cleanup_before_exit_calls
local retry_requests_before = #private_dungeon_requests
local first_return = lobby.return_lobby({
    level_id = 'official-active-terminal',
    game_mode = 1304,
    max_player = 8,
})
local second_return = lobby.return_lobby({
    level_id = 'official-active-terminal',
    game_mode = 1304,
    max_player = 8,
})
assert_equal(first_return.accepted, true, 'first return_lobby request accepted')
assert_equal(second_return.accepted, true, 'return_lobby remains retryable')
assert_equal(#private_dungeon_requests, retry_requests_before + 2, 'return_lobby retry submits platform request again')
assert_equal(latest_client.cleanup_before_exit_calls, retry_cleanup_calls, 'return_lobby retry does not run exit cleanup')
assert_equal(client.get(), retry_client, 'return_lobby retry preserves client')
assert_equal(lobby.get_state().result_data.status, 'connected', 'return_lobby retry preserves connected status')

reset_contract_runtime()
local connected_for_completion_listener_lock = lobby.connect(TEST_GAME_PLAY_ID)
assert_equal(connected_for_completion_listener_lock.accepted, true, 'connect for completion listener terminal lock accepted')
local listener_lock_client = latest_client
local listener_lock_results
local listener_lock_exit = lobby.exit_game()
local listener_lock_completion_count_before = #completion_payloads
local listener_lock_exit_calls_before = exit_game_calls
local listener_lock = lobby.on_complete(function(payload)
    if payload.request_id == listener_lock_exit.request_id then
        listener_lock_results = {
            return_lobby = lobby.return_lobby(terminal_lock_params),
            return_lobby_nil = lobby.return_lobby(nil),
            exit_game = lobby.exit_game(),
        }
    end
end)
assert_equal(listener_lock_exit.accepted, true, 'exit_game before completion listener reentry accepted')
listener_lock_client.cleanup_before_exit_callback(true, nil)
assert_equal(type(listener_lock_results), 'table', 'completion listener reentered terminal requests')
assert_terminal_locked(listener_lock_results.return_lobby, 'return_lobby reentered in completion listener')
assert_terminal_locked(listener_lock_results.return_lobby_nil, 'return_lobby nil reentered in completion listener')
assert_terminal_locked(listener_lock_results.exit_game, 'exit_game reentered in completion listener')
assert_equal(#private_dungeon_requests, 0, 'completion listener reentry must not call platform return')
listener_lock.remove()
assert_exit_terminal_settled(listener_lock_exit, listener_lock_completion_count_before, listener_lock_exit_calls_before, 'completion listener terminal lock')

reset_contract_runtime()
local connected_for_same_frame_lock = lobby.connect(TEST_GAME_PLAY_ID)
assert_equal(connected_for_same_frame_lock.accepted, true, 'connect for same-frame terminal lock accepted')
local same_frame_client = latest_client
local same_frame_exit = lobby.exit_game()
local same_frame_completion_count_before = #completion_payloads
local same_frame_exit_calls_before = exit_game_calls
assert_equal(same_frame_exit.accepted, true, 'exit_game before same-frame reentry accepted')
same_frame_client.cleanup_before_exit_callback(true, nil)
assert_equal(count_completion(same_frame_exit.request_id, 'ok'), 1, 'same-frame setup completion published')
assert_terminal_locked(lobby.return_lobby(terminal_lock_params), 'return_lobby after completion before exit frame')
assert_terminal_locked(lobby.return_lobby(nil), 'return_lobby nil after completion before exit frame')
assert_terminal_locked(lobby.exit_game(), 'exit_game after completion before exit frame')
assert_equal(#private_dungeon_requests, 0, 'same-frame terminal reentry must not call platform return')
assert_exit_terminal_settled(same_frame_exit, same_frame_completion_count_before, same_frame_exit_calls_before, 'same-frame terminal lock')

reset_contract_runtime()
local connected_for_platform_failure = lobby.connect(TEST_GAME_PLAY_ID)
assert_equal(connected_for_platform_failure.accepted, true, 'connect for platform failure accepted')
platform_return_error = 'platform return failed'
local platform_failure = lobby.return_lobby({
    level_id = 'official-platform-failure',
    game_mode = 1306,
    max_player = 8,
})
assert_equal(platform_failure.accepted, false, 'return_lobby platform failure rejected synchronously')
assert_equal(platform_failure.code, 'request_error', 'return_lobby platform failure code')
local platform_failure_completion_count = count_completion(platform_failure.request_id)
assert_equal(platform_failure_completion_count, 0, 'platform failure does not fabricate return_lobby completion')
assert_equal(latest_client.cleanup_before_exit_calls, 0, 'platform failure does not run exit cleanup')
assert_equal(lobby.get_state().result_data.status, 'connected', 'platform failure preserves connected status')
assert_equal(client.get(), latest_client, 'platform failure preserves runtime client')

captured_logs = {}
require 'clicli.game.lobby.bob'
local bob = New 'LobbyBob' (TEST_GAME_PLAY_ID)
assert_equal(bob.game_play_id, tostring(TEST_GAME_PLAY_ID), 'LobbyBob uses the passed-in gameplay ID')
assert_equal(bob.game_play_id_num, TEST_GAME_PLAY_ID, 'LobbyBob Digital Play ID')
bob._refreshing_player_info = true
bob._refresh_player_info_callbacks = {}
--White-box testing: Verify the merging behavior of internal refresh requests.
---@diagnostic disable-next-line: invisible
local merged_refresh = bob:refresh_player_info(function()
end)
assert_equal(merged_refresh, true, 'When a player has already made a refresh request, the merge and wait will still be considered accepted')
assert_equal(#bob._refresh_player_info_callbacks, 1, 'When an existing player refreshes the request, keep the new callback')
bob._refreshing_player_info = false

local propagated_player_error
--White-box testing: Clear the internal cache to cover the remote error pass-through path.
---@diagnostic disable-next-line: invisible
bob.player_infos = {}
bob.get_team_info = function(_, _, callback)
    callback(nil, 300123)
end
bob:get_player_info(99009, function(_, err)
    propagated_player_error = err
end)
assert_equal(propagated_player_error, 300123, 'get_player_info passes the get_team_info remote error')

do
    local original_is_valid = IsValid
    local bob_valid = true
    ---@param value any
    ---@return boolean
    IsValid = function(value)
        if value == bob then
            return bob_valid
        end
        return original_is_valid(value)
    end
    local function get_version_check_dungeon_info()
        return { env = 'prod' }
    end
    GameAPI.get_dungeon_info = get_version_check_dungeon_info
    clicli.json.decode = function(_text)
        return {
            ['2.0'] = {
                ['@metadata@'] = {
                    ['@displayversion@'] = '2.5.24.762647',
                },
            },
        }
    end

    local function begin_version_check(local_version, injection_status)
        local scenario = {
            completion_count = 0,
            need_update = nil,
            first_frame_index = #frame_callbacks + 1,
        }
        local remote_callback
        --Streamline the test stub to only implement the interfaces required for version checking.
        ---@diagnostic disable-next-line: missing-fields
        clicli.game = {
            is_debug_mode = function(_ignore_config)
                return false
            end,
            request_url = function(_, _, _, callback, _options)
                remote_callback = callback
            end,
        }
        _G['_SVN_VERSION'] = local_version
        _G['_SVN_VERSION_INJECTION_STATUS'] = injection_status
        bob_valid = true
        bob:check_update(function(need_update)
            scenario.completion_count = scenario.completion_count + 1
            scenario.need_update = need_update
        end)
        assert_equal(type(remote_callback), 'function', 'Version checking initiates remote requests')
        remote_callback('{}')
        return scenario
    end

    local pending = begin_version_check(nil, 'pending')
    assert_equal(pending.completion_count, 0, 'Version checks should not be completed when injecting a local version pending')
    assert_equal(type(frame_callbacks[pending.first_frame_index]), 'function', 'When injecting the local version in the pending state, wait for the next client frame')
    _G['_SVN_VERSION'] = '2.5.24.762647'
    _G['_SVN_VERSION_INJECTION_STATUS'] = 'ok'
    frame_callbacks[pending.first_frame_index]()
    assert_equal(pending.completion_count, 1, 'Only one version check is completed after the local version injection is finished')
    assert_equal(pending.need_update, false, 'No update is required when the local and remote versions are consistent')
    frame_callbacks[pending.first_frame_index]()
    assert_equal(pending.completion_count, 1, 'Repeated client frame callbacks cannot repeatedly complete version checks')

    local stale = begin_version_check('stale-version', 'pending')
    assert_equal(stale.completion_count, 0, 'When injecting pending, the remaining old version cannot be used')
    _G['_SVN_VERSION'] = '2.5.24.762647'
    _G['_SVN_VERSION_INJECTION_STATUS'] = 'ok'
    frame_callbacks[stale.first_frame_index]()
    assert_equal(stale.completion_count, 1, 'The inspection is completed after the residual version is overwritten by a new injection')
    assert_equal(stale.need_update, false, 'No update is required when the newly injected version is consistent')

    local destroyed = begin_version_check(nil, 'pending')
    local callbacks_before_destroy = #frame_callbacks
    bob_valid = false
    frame_callbacks[destroyed.first_frame_index]()
    assert_equal(destroyed.completion_count, 0, 'BOB will no longer complete the version check after destruction')
    assert_equal(#frame_callbacks, callbacks_before_destroy, 'BOB will no longer wait for version injection after destruction')

    local exhausted = begin_version_check(nil, 'pending')
    for index = exhausted.first_frame_index, exhausted.first_frame_index + 149 do
        frame_callbacks[index]()
    end
    assert_equal(exhausted.completion_count, 1, 'Version injection waits until it is exhausted to complete the check')
    assert_equal(exhausted.need_update, false, 'After the version injection is exhausted, press "fail-open" to continue')

    local failed = begin_version_check(nil, 'failed: test')
    assert_equal(failed.completion_count, 1, 'Complete the check immediately when version injection fails')
    assert_equal(failed.need_update, false, 'When version injection fails, press "fail-open" to continue')
    IsValid = original_is_valid
end

local client_api = require 'clicli.game.lobby.service.client'
local raw_client = client_api.new_client('127.0.0.1', 8092, 10086, 'client-runtime-token-secret', TEST_GAME_PLAY_ID)
raw_client:login_auth()
local log_output = table.concat(captured_logs, '\n')
assert_not_contains(log_output, 'bob-runtime-sign-secret', 'The BOB initialization log cannot contain the original sign')
assert_not_contains(log_output, 'client-runtime-token-secret', 'The client log cannot contain the original token')

completion_listener.remove()
do
    ---@type ECAHelper
    local eca_helper = dofile('util/eca_helper.lua')
    local calls = 0
    local event_name = 'lobby-contract-query'
    assert_equal(eca_helper.has_custom_event(event_name), false, 'ECA query rejects unregistered events')
    --Simulate the engine registration event to verify that public queries do not trigger callbacks.
    ---@diagnostic disable-next-line: invisible
    eca_helper.register_custom_event_impl(event_name, function()
        calls = calls + 1
    end)
    assert_equal(eca_helper.has_custom_event(event_name), true, 'ECA query finds registered events')
    assert_equal(eca_helper.has_custom_event('missing-event'), false, 'ECA query checks the requested name')
    assert_equal(calls, 0, 'ECA query does not invoke the event')
    eca_helper.call(event_name)
    assert_equal(calls, 1, 'ECA query preserves event invocation')
end

print('lobby_contract ok')
