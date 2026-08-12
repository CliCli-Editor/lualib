local const = {}

local function protect(tbl)
    return setmetatable({}, {
        __index = tbl,
        __newindex = function(t, key, value)
            error("attempting to change constant " ..
                tostring(key) .. " to " .. tostring(value), 2)
        end
    })
end

--RPC message ID
const.msgtype = {
    ["RPC_CALL"] = 1,
    ["RPC_RETURN"] = 2,
    ["RAW_PROTOCOL"] = 5,
    ["RPC_PING"] = 10,
    ["RPC_PONG"] = 11,
    ["RPC_EVENT"] = 15,
    ["LOGIN_AUTH"] = 1001,
    ["LOGIN_AUTH_RESP"] = 1002,
}

const.event_subtype = {
    ["ON_RUNNING"] = 1,
    ["LOSE_CONNECTION"] = 2,
}

--RPC error ID
const.rpcerror = { ["OK"] = 1, ["NOT_FOUND"] = 2, ["EXCEPTION"] = 3, ["TIMEOUT"] = 4, ["LIMIT"] = 5, ["LOSE_CONNECTION"] = 6 }

--Coroutine state
const.costate = { ["NEED_CALL_STUB"] = 1, ["NEED_SEND_CALL"] = 2, ["RECVED_PROXY_CALL_RETURN"] = 3 }

return protect(const)
