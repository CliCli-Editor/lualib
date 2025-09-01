--Sync local data to all players
---@class Sync
local M = Class 'Sync'

---@private
M.syncMap = {}

---@package
---@type boolean?
M.singleMode = nil

---@package
---@return boolean
function M.isSingleMode()
    if M.singleMode ~= nil then
        return M.singleMode
    end
    local count = 0
    for player in clicli.player_group.get_all_players():pairs() do
        if player:need_sync() then
            count = count + 1
            if count > 1 then
                clicli.ltimer.wait(60, function ()
                    M.singleMode = nil
                end)
                M.singleMode = false
                return false
            end
        end
    end
    M.singleMode = true
    return true
end

--Send local messages and use 'onSync' to synchronize receiving data
--Use this function in your local environment
---@param id string # Ids beginning with '$' are reserved for internal use
---@param data Serialization.SupportTypes
function M.send(id, data)
    if M.isSingleMode() then
        clicli.ltimer.wait_frame(1, function ()
            local callback = M.syncMap[id]
            if not callback then
                return
            end
            clicli.player.with_local(function (local_player)
                xpcall(callback, log.error, data, local_player)
            end)
        end)
    else
        local bin = clicli.dump.encode(data)
        broadcast_lua_msg(id, bin)
    end
end

--The data is received synchronously, and the callback function is executed after synchronization
--Only one callback function can be registered with the same id, and the later ones will overwrite the earlier ones
---@param id string
---@param callback fun(data: Serialization.SupportTypes, source: Player)
function M.onSync(id, callback)
    M.syncMap[id] = callback
end

clicli.game:event('Games - Receive broadcast information', function (trg, data)
    local id = data.broadcast_lua_msg_id
    local callback = M.syncMap[id]
    if not callback then
        return
    end
    local suc, value = pcall(clicli.dump.decode, data.broadcast_lua_msg_content)
    if not suc then
        return
    end
    xpcall(callback, log.error, value, data.player)
end)

return M
