---@class clicli.Lobby.Result
local M = {}

local function normalize_string(value)
    if value == nil then
        return ''
    end
    return tostring(value)
end

---@param action string
---@param request_id string?
---@param extra table?
---@return table
function M.accepted(action, request_id, extra)
    local result = {
        accepted = true,
        action = normalize_string(action),
        request_id = normalize_string(request_id),
        reason = normalize_string(extra and extra.reason or 'The request has been accepted.'),
        code = normalize_string(extra and extra.code or 'ok'),
        sync = extra and extra.sync == true or false,
        result_data = extra and extra.result_data or {},
    }
    if extra then
        for key, value in pairs(extra) do
            if result[key] == nil then
                result[key] = value
            end
        end
    end
    return result
end

---@param action string
---@param code string
---@param reason string?
---@param result_data table?
---@return table
function M.rejected(action, code, reason, result_data)
    return {
        accepted = false,
        action = normalize_string(action),
        request_id = '',
        reason = normalize_string(reason or code),
        code = normalize_string(code),
        sync = true,
        result_data = result_data or {},
    }
end

---@param request_id string
---@param action string
---@param success boolean
---@param code string?
---@param reason string?
---@param result_data table?
---@return table
function M.completed(request_id, action, success, code, reason, result_data)
    return {
        request_id = normalize_string(request_id),
        action = normalize_string(action),
        success = success == true,
        reason = normalize_string(reason or code),
        code = normalize_string(code or (success and 'ok' or 'failed')),
        result_data = result_data or {},
    }
end

return M
