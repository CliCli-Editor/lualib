---@class clicli.Lobby.State
local M = {}

local runtime = rawget(_G, '__Y3_LOBBY_RUNTIME') or {}
runtime.status = runtime.status or 'idle'
runtime.sequence = runtime.sequence or 0
runtime.pending_request_id = runtime.pending_request_id or nil
runtime.failed_events = runtime.failed_events or {}
runtime.pending = runtime.pending or {}
runtime.locks = runtime.locks or {}
runtime.connection_cleanups = runtime.connection_cleanups or {}
runtime.eca_request_ids = runtime.eca_request_ids or {}
runtime.event_listeners = runtime.event_listeners or {}
runtime.event_sequence = runtime.event_sequence or 0
runtime.current_call_origin = runtime.current_call_origin or nil
runtime.client = runtime.client or nil
runtime.last_error = runtime.last_error or nil
runtime.event_name = runtime.event_name or 'The hall service request has been completed'
runtime.event_param_name = runtime.event_param_name or 'Callback data'
_G.__Y3_LOBBY_RUNTIME = runtime

M.runtime = runtime

---@return string
function M.next_request_id()
    runtime.sequence = runtime.sequence + 1
    local aid = runtime.client and runtime.client.aid or 0
    return string.format('lobby-%s-%d', tostring(aid), runtime.sequence)
end

local function public_scalar(value, fallback)
    local value_type = type(value)
    if value_type == 'string' or value_type == 'number' or value_type == 'boolean' then
        return value
    end
    return fallback
end

---@param player table?
---@return table
function M.public_player(player)
    if type(player) ~= 'table' then
        return {}
    end
    local in_game = player.in_game
    local in_game_known = type(in_game) == 'boolean'
    local public_in_game
    if in_game_known then
        public_in_game = in_game
    end
    return {
        aid = public_scalar(player.aid, 0),
        name = tostring(public_scalar(player.name or player.nickname, '') or ''),
        head_icon = tostring(public_scalar(player.head_icon, '') or ''),
        team_id = public_scalar(player.team_id, 0),
        score = public_scalar(player.score, 0),
        state = tostring(public_scalar(player.state, '') or ''),
        in_game = public_in_game,
        in_game_known = in_game_known,
        map_id = public_scalar(player.map_id, ''),
        game_play_id = public_scalar(player.game_play_id, ''),
    }
end

---@param members table?
---@return table[]
function M.public_members(members)
    local result = {}
    for _, member in ipairs(type(members) == 'table' and members or {}) do
        result[#result + 1] = M.public_player(member)
    end
    return result
end

---@param team table?
---@return table
function M.public_team(team)
    if type(team) ~= 'table' then
        return {}
    end
    return {
        team_id = public_scalar(team.team_id, 0),
        member_limit = public_scalar(team.member_limit, 0),
        team_state = tostring(public_scalar(team.team_state, '') or ''),
        captain = public_scalar(team.captain, 0),
        version = public_scalar(team.version, 0),
        members = M.public_members(team.members),
    }
end

---@param message table?
---@return table
function M.public_message(message)
    if type(message) ~= 'table' then
        return {}
    end
    local chat = type(message.chat) == 'table' and message.chat or nil
    local sender = type(message.sender) == 'table' and message.sender
        or chat and type(chat.sender) == 'table' and chat.sender
        or {}
    local sender_aid = public_scalar(message.aid or sender.aid, 0)
    return {
        sequence = public_scalar(message.sequence, 0),
        channel = tostring(public_scalar(message.channel or message.mode, '') or ''),
        mode = tostring(public_scalar(message.mode, '') or ''),
        time = public_scalar(message.time or message.chat_time or chat and chat.chat_time, 0),
        message = tostring(public_scalar(message.message or message.chat_message or chat and chat.chat_message, '') or ''),
        type = public_scalar(message.type or message.chat_type or chat and chat.chat_type, 0),
        aid = sender_aid,
        sender = {
            aid = sender_aid,
            name = tostring(public_scalar(sender.name or sender.nickname, '') or ''),
            head_icon = tostring(public_scalar(sender.head_icon, '') or ''),
        },
    }
end

---@param status string
---@param reason string?
function M.set_status(status, reason)
    local changed = runtime.status ~= status
    runtime.status = status
    runtime.last_error = reason
    if changed then
        M.emit_event('connection_changed', {
            code = status,
            reason = reason or '',
        })
    end
end

---@param event_name string
---@param data table?
---@return table
function M.emit_event(event_name, data)
    runtime.event_sequence = runtime.event_sequence + 1
    local payload = {
        event = tostring(event_name or ''),
        source = 'lobby',
        status = runtime.status,
        code = data and data.code or 'ok',
        reason = data and data.reason or '',
        data = data or {},
        snapshot = M.snapshot(),
        sequence = runtime.event_sequence,
    }
    for listener, record in pairs(runtime.event_listeners or {}) do
        if not record.event_name or record.event_name == payload.event then
            local ok, err = pcall(record.callback or listener, payload)
            if not ok then
                runtime.failed_events['event-' .. tostring(payload.sequence)] = {
                    payload = payload,
                    error = tostring(err),
                }
            end
        end
    end
    return payload
end

---@param event_name string?
---@param callback fun(payload: table)
---@param persistent boolean?
---@return table
function M.on_event(event_name, callback, persistent)
    runtime.event_listeners[callback] = {
        event_name = event_name,
        callback = callback,
        persistent = persistent == true,
    }
    return {
        remove = function()
            runtime.event_listeners[callback] = nil
        end,
    }
end

---@return table
function M.snapshot()
    local client = runtime.client
    local team_info = client and client.team_info or nil
    local team = M.public_team(team_info)
    local members = team.members or {}
    local dungeon_info = GameAPI.get_dungeon_info()
    local token = dungeon_info and (dungeon_info.space_id or dungeon_info.spaceId) or ''
    return {
        status = runtime.status,
        request_id = '',
        pending_request_id = runtime.pending_request_id or '',
        connected = runtime.status == 'connected',
        failed_events = runtime.failed_events,
        last_error = runtime.last_error or '',
        endpoint_env = runtime.endpoint_env or '',
        pending_count = (function()
            local count = 0
            for _ in pairs(runtime.pending or {}) do
                count = count + 1
            end
            return count
        end)(),
        aid = client and client.aid or nil,
        score = client and client.score or nil,
        has_team = team_info ~= nil,
        team_id = team_info and team.team_id or nil,
        members = members,
        member_count = #members,
        member_limit = team.member_limit or 0,
        is_captain = client and client.is_captain and client:is_captain() or false,
        matching = client and client.is_matching and client:is_matching() or false,
        launching = client and client.is_launching and client:is_launching() or false,
        chat_count = client and client.message_history and #client.message_history or 0,
        token = tostring(token or ''),
        level_id = dungeon_info and dungeon_info.level_id or nil,
        game_mode = dungeon_info and dungeon_info.game_mode or nil,
        game_map_id = dungeon_info and (dungeon_info.game_map_id or dungeon_info.map_id) or nil,
    }
end

function M.reset_for_test()
    runtime.status = 'idle'
    runtime.sequence = 0
    runtime.pending_request_id = nil
    runtime.failed_events = {}
    runtime.pending = {}
    runtime.locks = {}
    runtime.connection_cleanups = {}
    runtime.eca_request_ids = {}
    for callback, record in pairs(runtime.event_listeners or {}) do
        if not record.persistent then
            runtime.event_listeners[callback] = nil
        end
    end
    runtime.event_sequence = 0
    runtime.current_call_origin = nil
    runtime.client = nil
    runtime.last_error = nil
    runtime.endpoint_env = nil
end

return M
