--Sync local data to all players
---@class Sync
local M = Class 'Sync'

---@package
M.speedLimit = 4096 --A maximum of 4096 bytes of data can be synchronized per frame
---@package
M.syncLimit = 1024 * 1024 --Data exceeding 1M is not allowed to be synchronized
---@package
M.queue = {} --The current data queue waiting for synchronization, [id, bin]

---@package
---@type thread
M.syncWorker = nil --A worker (coroutine) used for segmented data transmission

---@private
M.syncMap = {}

---@package
M.syncLocalCount = 0
---@package
M.syncLocalCallbackMap = {}

---@package
M.syncPartsLocalCount = 0
---@package
M.syncPartsMap = clicli.util.multiTable(2)

---@package
---@type boolean?
M.singleMode = nil

local totoal_broadcast_count = 0
local function broadcast_with_log(tag, data)
    broadcast_lua_msg(tag, data)
    totoal_broadcast_count = totoal_broadcast_count + #data
    log.debug('Total amount of data sent', totoal_broadcast_count)
end

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

local function startWorker(dispose)
    ---@async
    return clicli.await.call(function ()
        local limit = M.speedLimit
        local idleCount = 0

        ---@async
        local function waitNextFrame()
            clicli.await.yield(function (resume)
                clicli.ltimer.wait_frame(1, resume)
            end)
            limit = M.speedLimit
        end

        while true do
            local current = table.remove(M.queue, 1)
            if not current then
                idleCount = idleCount + 1
                if idleCount > 10 then
                    break
                end
                waitNextFrame()
                goto continue
            end
            local id, bin = current[1], current[2]
            if limit >= #bin then
                limit = limit - #bin
                broadcast_with_log(id, bin)
                goto continue
            elseif #bin > M.syncLimit then
                log.error('sync.lua', 'The synchronized data is too large. id: {%s}, length: {%s}' % { id, #bin })
            else
                local index = M.syncPartsLocalCount + 1
                M.syncPartsLocalCount = index
                broadcast_with_log('$sync_part', clicli.dump.encode {
                    index = index,
                    part  = 1,
                    data  = bin:sub(1, limit)
                })
                local nextStart = limit + 1
                waitNextFrame()
                for i = 2, 10000 do
                    local currentEnd = nextStart + limit - 1
                    if currentEnd >= #bin then
                        broadcast_with_log('$sync_part', clicli.dump.encode {
                            id    = id, --Mark transmission completed
                            index = index,
                            part  = i,
                            data  = bin:sub(nextStart),
                            --hash  = clicli.hash(bin),
                        })
                        limit = limit - (#bin - nextStart + 1)
                        break
                    else
                        broadcast_with_log('$sync_part', clicli.dump.encode {
                            index = index,
                            part  = i,
                            data  = bin:sub(nextStart, currentEnd)
                        })
                        nextStart = currentEnd + 1
                        waitNextFrame()
                    end
                end
            end
            ::continue::
        end
        dispose()
    end)
end

---@param id string
---@param bin string
local function broadcast_with_limit(id, bin)
    M.queue[#M.queue+1] = { id, bin }
    if M.syncWorker then
        return
    end
    ---@async
    M.syncWorker = startWorker(function ()
        M.syncWorker = nil
    end)
end

--Send local messages and use 'onSync' to synchronize receiving data
--Use this function in your local environment
---@generic T: Serialization.SupportTypes
---@param id string # Ids beginning with '$' are reserved for internal use
---@param data? T # If an object is included, the '__encode' and '__decode' methods need to be implemented on the class
---@param done? async fun(data: T)
function M.send(id, data, done)
    if not clicli.config.sync.send_in_single_mode and M.isSingleMode() then
        ---@async
        clicli.await.call(function ()
            clicli.await.sleep(0.01)
            ---@async
            clicli.player.with_local(function (local_player)
                local callback = M.syncMap[id]
                if callback then
                    xpcall(callback, log.error, data, local_player)
                end
                if done then
                    done(data)
                end
            end)
        end)
        return
    end
    if done then
        M.syncLocalCount = M.syncLocalCount + 1
        M.syncLocalCallbackMap[M.syncLocalCount] = done
        local bin = clicli.dump.encode {
            id    = id,
            count = M.syncLocalCount,
            value = data,
        }
        broadcast_with_limit('$sync_proxy', bin)
    else
        local bin = clicli.dump.encode(data)
        broadcast_with_limit(id, bin)
    end
end

--The data is received synchronously, and the callback function is executed after synchronization
--Only one callback function can be registered with the same id, and the later ones will overwrite the earlier ones
---@param id string
---@param callback async fun(data: Serialization.SupportTypes, source: Player)
function M.onSync(id, callback)
    M.syncMap[id] = callback
end

local function resolveBroadCast(id, content, player)
    local callback = M.syncMap[id]
    if not callback then
        return
    end
    local suc, value = pcall(clicli.dump.decode, content)
    if not suc then
        return
    end
    clicli.await.call(function ()
        xpcall(callback, log.error, value, player)
    end)
end

clicli.game:event('Games - Receive broadcast information', function (trg, data)
    resolveBroadCast(data.broadcast_lua_msg_id, data.broadcast_lua_msg_content, data.player)
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

---@param data table
---@param source Player
M.onSync('$sync_part', function (data, source)
    local index = data.index
    local part  = data.part
    local pid   = source:get_id()
    local cache = M.syncPartsMap[pid][index]
    if not cache then
        cache = {
            id    = nil,
            len   = nil,
            parts = {},
        }
        M.syncPartsMap[pid][index] = cache
    end
    cache.parts[part] = data.data
    if data.id then
        cache.id  = data.id
        cache.len = data.part
        --cache.hash = data.hash
    end
    if not cache.id then
        return
    end
    --Has it been filled completely?
    for i = 1, cache.len do
        if cache.parts[i] == nil then
            return
        end
    end

    M.syncPartsMap[pid][index] = nil

    local bin = table.concat(cache.parts)
    --assert(cache.hash == clicli.hash(bin), 'hash does not match ')
    resolveBroadCast(cache.id, bin, source)
end)

return M
