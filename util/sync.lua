--Sync local data to all players
---@class Sync
local M = Class 'Sync'

---@private
M.syncMap = {}

M.syncLocalCount = 0
M.syncLocalCallbackMap = {}

--Send local messages and use 'onSync' to synchronize receiving data
--Use this function in your local environment
---@generic T: Serialization.SupportTypes
---@param id string # Ids beginning with '$' are reserved for internal use
---@param data T # If an object is included, the '__encode' and '__decode' methods need to be implemented on the class
---@param done? async fun(data: T)
function M.send(id, data, done)
    if done then
        M.syncLocalCount = M.syncLocalCount + 1
        M.syncLocalCallbackMap[M.syncLocalCount] = done
        local bin = clicli.dump.encode({
            id    = id,
            count = M.syncLocalCount,
            value = data,
        })
        broadcast_lua_msg('$sync_proxy', bin)
    else
        local bin = clicli.dump.encode(data)
        broadcast_lua_msg(id, bin)
    end
end

--The data is received synchronously, and the callback function is executed after synchronization
--Only one callback function can be registered with the same id, and the later ones will overwrite the earlier ones
---@param id string
---@param callback async fun(data: Serialization.SupportTypes, source: Player)
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
    clicli.await.call(function ()
        xpcall(callback, log.error, value, data.player)
    end)
end)

---@param data table
---@param source Player
M.onSync('$sync_proxy', function (data, source)
    clicli.await.call(function ()
        local id    = data.id
        local count = data.count
        local value = data.value
        local callback = M.syncMap[id]
        if callback then
            xpcall(callback, log.error, value, source)
        end
        clicli.player.with_local(function (local_player)
            if source ~= local_player then
                return
            end
            local done = M.syncLocalCallbackMap[count]
            M.syncLocalCallbackMap[count] = nil
            if done then
                xpcall(done, log.error, value)
            end
        end)
    end)
end)

return M
