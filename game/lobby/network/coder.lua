local protocol = require("clicli.game.lobby.network.protocol")

local coder = {}


--Retrives Header Length
---@param data string # network data
---@return integer,integer # protocol type, message length (including header+body)
function coder.unpack_header(data)
    if #data < 8 then
        return 0, 0
    end

    return string.unpack('>I4I4', data)
end

--Retrives Request Header
---@param data string #request protocol data
---@return any ...  #{protocol_id, 0, call_id, method_id, next unread pos in data}
function coder.unpack_request_header(data)
    return string.unpack('>I8I4I4I4', data)
end

--Retrives Response Header
---@param data string # protocol data
---@return any ... #{0, call_id, error_id, next unread pos in data}
function coder.unpack_response_header(data)
    return string.unpack('>I4I4I4', data)
end

--Retrives the request protocol data
---@param data string # network data string
---@return integer,integer,integer, integer # {message_id, call_id, method_id, proto_head_pos}
--@useage:  Unpack request protocol, separate protocol header and protocol body.
function coder.unpack_request(data)
    local message_id, _, call_id, method_id, pos = coder.unpack_request_header(data)
    return message_id, call_id, method_id, pos
end

--Retrives the response protocol data
---@param data string #network data string
---@return integer, integer, integer|nil  {call_id, error_id, proto_head_pos}
--@useage:  Unpack response protocol, separate protocol header and protocol body.
function coder.unpack_response(data)
    local _, call_id, error_id, pos = coder.unpack_response_header(data)
    return call_id, error_id, pos
end

--Retrives Pong Protocol
---@param data string #network data
---@return integer, any ... #{ping_id}
function coder.unpack_pong(data)
    return string.unpack('>I8', data)
end

--Package the request protocol header
---@param message_id integer #service uuid
---@param call_id integer #local auto-increment ID
---@param method_id integer #service method index
---@return string #packed request header bytes
function coder.pack_request_header(message_id, call_id, method_id)
    return string.pack('>I8I4I4I4', message_id, 0, call_id, method_id)
end

--Package the response protocol header
---@param call_id integer #local auto-increment ID
---@param error_id integer #error code
---@return string # packed response header bytes
function coder.pack_response_header(call_id, error_id)
    return string.pack('>I4I4I4', 0, call_id, error_id)
end

--Package the protocol header
---@param proto_type integer #protocol type
---@param length integer #message length (header + body)
---@return string #packed header bytes
function coder.pack_header(proto_type, length)
    return string.pack('>I4I4', length, proto_type)
end

--Package the request protocol
---@param message_id integer  #service uuid
---@param call_id integer #local auto-increment
---@param method_id integer #service method indexes
---@param proto_body string #protocol body
---@return string #packed request protocol bytes
function coder.pack_request(message_id, call_id, method_id, proto_body)
    local proto_len = 0
    if proto_body then
        proto_len = #proto_body
    end

    --Calculate the length of the protocol header = 8 bytes for the fixed message header + 8+4+4+4 bytes for the request class message
    proto_len = proto_len + 28

    local request_header = coder.pack_request_header(message_id, call_id, method_id)
    local common_header = coder.pack_header(protocol.msgtype.RPC_CALL, proto_len)

    return common_header .. request_header .. (proto_body or "")
end

--Package the response protocol
---@param call_id integer #local auto-increment
---@param error_id integer # error code
---@param proto_body string # protocol body
---@return string #packed response protocol bytes
function coder.pack_response(call_id, error_id, proto_body)
    local proto_len = 0
    if proto_body then
        proto_len = #proto_body
    end

    --Calculate the length of the protocol header = 8 bytes for the fixed message header +4+4 +4 bytes for the response type message
    proto_len = proto_len + 20

    local response_header = coder.pack_response_header(call_id, error_id)
    local common_header = coder.pack_header(protocol.msgtype.RPC_RETURN, proto_len)

    return common_header .. response_header .. (proto_body or "")
end

--Package the heartbeat protocol
---@param ping_handle integer #heartbeat handle returned by the server.
---@return string #packed heartbeat protocol bytes
function coder.pack_ping(ping_handle)
    --commonheadr + ping_handle = 16
    local common_header = coder.pack_header(protocol.msgtype.RPC_PING, 16)
    return common_header .. string.pack('>I8', ping_handle)
end

--Package no rpc protocol
---@param custom_data string #cusrom gameplay logic protocol
---@return string
function coder.pack_raw_message(custom_data)
    ---Fixed protocol header + custom message length
    local totle_len = 8 + #custom_data
    local common_header = coder.pack_header(protocol.msgtype.RAW_PROTOCOL, totle_len)
    return common_header .. custom_data
end

--Package the gameplay protocol
---@param proto_type integer #gameplay protocol type
---@param proto_data string # protobuf data
---@return string # package
function coder.pack_gameplay_proto(proto_type, proto_data)
    return string.pack('>I4', proto_type) .. proto_data
end

--Unpackage the gameplay protocol
---@param msg string gameplay protocol data
---@return integer, string|nil #{protocol type, pb data}
function coder.unpack_gameplay_proto(msg)
    local proto_type, pos = string.unpack('>I4', msg)
    return proto_type, pos and msg:sub(pos) or nil
end

return coder
