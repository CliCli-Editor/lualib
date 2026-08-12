local lobby = require 'clicli.game.lobby'
local state = require 'clicli.game.lobby.state'
local result = require 'clicli.game.lobby.result'

local M = {}
local completion_listener
local status_listener

M.EVENT_NAME = 'The hall service request has been completed'
M.EVENT_PARAM_NAME = 'Callback data'
M.STATUS_EVENT_NAME = 'The service status of the hall has changed'
M.STATUS_EVENT_PARAM_NAME = 'Event data'

local function has_completion_event()
    if clicli.eca and clicli.eca._call_impls and clicli.eca._call_impls[M.EVENT_NAME] then
        return true
    end
    local names = clicli.const and clicli.const.CustomEventName
    return names and names[M.EVENT_NAME] ~= nil and names[M.EVENT_NAME] ~= 0
end

local function emit(payload)
    if clicli.eca and clicli.eca.call then
        local ok = pcall(clicli.eca.call, M.EVENT_NAME, payload)
        if ok then
            return true
        end
    end
    local event_id = clicli.const and clicli.const.CustomEventName and clicli.const.CustomEventName[M.EVENT_NAME]
    if event_id and event_id ~= 0 and clicli.game and clicli.game.send_custom_event then
        local ok, err = pcall(clicli.game.send_custom_event, event_id, {
            [M.EVENT_PARAM_NAME] = payload,
        })
        if ok then
            return true
        end
        return false, tostring(err)
    end
    return false, 'The completion event does not exist'
end

local function has_status_event()
    if clicli.eca and clicli.eca._call_impls and clicli.eca._call_impls[M.STATUS_EVENT_NAME] then
        return true
    end
    local names = clicli.const and clicli.const.CustomEventName
    return names and names[M.STATUS_EVENT_NAME] ~= nil and names[M.STATUS_EVENT_NAME] ~= 0
end

local function emit_status(payload)
    if not has_status_event() then
        return true
    end
    if clicli.eca and clicli.eca.call then
        local ok = pcall(clicli.eca.call, M.STATUS_EVENT_NAME, payload)
        if ok then
            return true
        end
    end
    local event_id = clicli.const and clicli.const.CustomEventName and clicli.const.CustomEventName[M.STATUS_EVENT_NAME]
    if event_id and event_id ~= 0 and clicli.game and clicli.game.send_custom_event then
        local ok, err = pcall(clicli.game.send_custom_event, event_id, {
            [M.STATUS_EVENT_PARAM_NAME] = payload,
        })
        if ok then
            return true
        end
        return false, tostring(err)
    end
    return false, 'The status event does not exist'
end

local SYNC_ACTIONS = {
    "getConnectionStatus" = true,
    "getTeamMembers" = true,
    ['GetTeamMemberItems'] = true,
    "getChatRecords" = true,
    "getChatMessages" = true,
    ['GetPassword'] = true,
    "getStatusSnapshot" = true,
}

local REQUEST_ONLY_ACTIONS = {
    ['JoinPassword'] = true,
    "returnToTheHall" = true,
}

local ROUTE_AWARE_ACTIONS = {
    "privateCopyWithinTheGame" = lobby._private_dungeon_completion_mode_for_eca,
}

local function is_valid_game_play_id(value)
    if type(value) ~= 'number' then
        return false
    end
    local ok, integer = pcall(math.tointeger, value)
    return ok and integer ~= nil and integer > 0
end

local function call_for_eca(action, fn, ...)
    local args = table.pack(...)
    local invalid_connect = action == 'Establish a connection' and not is_valid_game_play_id(args[1])
    local completion_mode = nil
    if ROUTE_AWARE_ACTIONS[action] then
        completion_mode = ROUTE_AWARE_ACTIONS[action](table.unpack(args, 1, args.n))
    end
    local request_only = REQUEST_ONLY_ACTIONS[action] or completion_mode == 'request_only'
    if not invalid_connect and not SYNC_ACTIONS[action] and not request_only and not has_completion_event() then
        return result.rejected(action, 'event_missing', 'Please first create a custom event in the main level: Hall Service Request completed, parameter: callback data')
    end
    local previous_origin = state.runtime.current_call_origin
    state.runtime.current_call_origin = 'eca'
    local ok, call_result = xpcall(function()
        return fn(table.unpack(args, 1, args.n))
    end, function(err)
        return tostring(err)
    end)
    state.runtime.current_call_origin = previous_origin
    if not ok then
        return result.rejected(action, 'request_error', call_result)
    end
    return call_result
end

local DEFINITIONS = {
    { 'Hall Service - Establishing connections', 'Establish a connection', lobby.connect, { { 'Gameplay ID', 'integer' }, { 'Is it in a game level', 'boolean?' } } },
    { 'Hall Service - Get connection status', 'Obtain the connection status', lobby.get_connection_status },
    { 'Hall Service - Set matching scores', 'Set the matching score', lobby.set_score, { { 'Score', 'integer' } } },
    { 'Hall Service - Creating a queue', 'Create a team', lobby.create_team, { { 'Headcount ceiling', 'integer' } } },
    { 'Hall Service - Join the queue', 'Join the team', lobby.join_team, { { 'Team number', 'integer' } } },
    { 'Hall service - Leave the queue', 'Leave the team', lobby.leave_team },
    { 'Hall Service - Disband the team', 'Disband the team', lobby.dismiss_team },
    { 'Hall Service - Transfer Team Leader', 'Transfer Captain', lobby.change_captain, { { 'Target: AID', 'integer' } } },
    { 'Hall service - Remove team members', 'Remove the team members', lobby.kick_member, { { 'Target: AID', 'integer' } } },
    { 'Hall Service - Get team members', 'Get team members', lobby.get_members },
    { 'Hall Service - Start matching', 'Start matching', lobby.start_match, { { 'Matching parameters', 'table' } } },
    { 'Hall Service - Cancel Match', 'unmatch', lobby.cancel_match },
    { 'Hall Service - Send team chat', 'Send team chat', lobby.send_team_chat, { { 'message', 'string' } } },
    { 'Hall Service - Send World Chat', 'Send World chat', lobby.send_world_chat, { { 'message', 'string' } } },
    { 'Hall Service - Get chat records', 'Obtain chat records', lobby.get_chat_history, { { 'channel', 'string?' } } },
    { 'Hall Service - Private Copy within the bureau', 'Private copy within the bureau', lobby.private_dungeon, { { 'Copy parameter', 'table' } } },
    { 'Hall Service - Add password', '"Add password', lobby.join_by_token, { { 'Password', 'string' } } },
    { 'Hall Service - Get password', 'Get the password', lobby.get_token },
    { 'Hall Service - Return to the hall', 'Return to the hall', lobby.return_lobby, { { 'Hall parameters', 'table' } } },
    { 'Hall Service - Exit the game', 'Quit the game', lobby.exit_game },
    { 'Hall Service - Get status snapshots', 'Obtain the status snapshot', lobby.get_state },
    { 'Hall Service - Get chat messages', 'Get chat messages', lobby.get_chat_message, { { 'Serial number', 'integer' }, { 'channel', 'string?' } } },
    { 'Hall Service - Get team member items', 'Get the team member items', lobby.get_member, { { 'Serial number', 'integer' } } },
    { 'Hall Service - Get team information', 'Obtain team information', lobby.get_team_info, { { 'Target: AID', 'integer?' } } },
    { 'Hall Service - Obtain player information', 'Obtain player information', lobby.get_player_info, { { 'Target: AID', 'integer?' } } },
    { 'Hall Service - Refresh player information', 'Refresh the player information', lobby.refresh_player_info },
}

function M.get_definitions()
    return DEFINITIONS
end

function M.register()
    if not clicli.eca or not clicli.eca.def then
        return false
    end
    for _, definition in ipairs(DEFINITIONS) do
        local builder = clicli.eca.def(definition[1])
        for _, param in ipairs(definition[4] or {}) do
            builder:with_param(param[1], param[2])
        end
        builder:with_return('result', 'table')
        builder:call(function(...)
            return call_for_eca(definition[2], definition[3], ...)
        end)
    end
    return true
end

M.register()

if not completion_listener then
    local listen = lobby._on_complete_internal or lobby.on_complete
    completion_listener = listen(function(payload)
        if not state.runtime.eca_request_ids[payload.request_id] then
            return
        end
        state.runtime.eca_request_ids[payload.request_id] = nil
        local ok, err = emit(payload)
        if not ok then
            state.runtime.failed_events[payload.request_id] = {
                payload = payload,
                error = err,
            }
        end
    end)
end

if not status_listener then
    local listen = lobby._on_event_internal or lobby.on_event
    status_listener = listen(function(payload)
        local ok, err = emit_status(payload)
        if not ok then
            state.runtime.failed_events['status-event-' .. tostring(payload.sequence or '')] = {
                payload = payload,
                error = err,
            }
        end
    end)
end

return M
