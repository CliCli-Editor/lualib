--On file
---@class SaveData
local M = {}

---@private
M.table_cache = setmetatable({}, { __mode = 'k' })

--Get the player is saved data (Boolean)
---@param player Player
---@param slot integer
---@return boolean
function M.load_boolean(player, slot)
    return player.handle:get_save_data_bool_value(slot) or false
end

--Save the player is saved data (Boolean)
---@param player Player
---@param slot integer
---@param value boolean
function M.save_boolean(player, slot, value)
    player.handle:set_save_data_bool_value(slot, value)
end

--Get the player is saved data (integer)
---@param player Player
---@param slot integer
---@return integer
function M.load_integer(player, slot)
    return player.handle:get_save_data_int_value(slot) or 0
end

--Save the player is saved data (integer)
---@param player Player
---@param slot integer
---@param value integer
function M.save_integer(player, slot, value)
    player.handle:set_save_data_int_value(slot, value)
end

---Add player save data (integer)
---@param player Player
---@param slot integer
---@param value integer
function M.add_integer(player, slot, value)
    player.handle:add_save_data_int_value(slot, value)
end

--Get the player is saved data (real)
---@param player Player
---@param slot integer
---@return number
function M.load_real(player, slot)
    return clicli.helper.tonumber(player.handle:get_save_data_fixed_value(slot)) or 0.0
end

--Save the player is saved data (real)
---@param player Player
---@param slot integer
---@param value number
function M.save_real(player, slot, value)
    player.handle:set_save_data_fixed_value(slot, Fix32(value))
end

---Increased player save data (real)
---@param player Player
---@param slot integer
---@param value number
function M.add_real(player, slot, value)
    player.handle:add_save_data_fixed_value(slot, Fix32(value))
end

--Get the player is archive data (string)
---@param player Player
---@param slot integer
---@return string
function M.load_string(player, slot)
    return player.handle:get_save_data_str_value(slot) or ''
end

--Save the player is saved data (string)
---@param player Player
---@param slot integer
---@param value string
function M.save_string(player, slot, value)
    player.handle:set_save_data_str_value(slot, value)
end

---@type table<Player, table<integer, [table, boolean]>>
M.player_tables = clicli.util.multiTable(2)

---Get the player's saved data (table). Modifying fields in this table is automatically updated to the archive.
---> The editor no longer supports allow override mode.
---@param player Player
---@param slot integer
---@param disable_cover? boolean # Whether to disable overwrite, must be the same as in the archive Settings (default is' true ')
---@return table
function M.load_table(player, slot, disable_cover)
    local last_table = M.player_tables[player][slot]
    if last_table then
        if last_table[2] == disable_cover then
            return last_table[1]
        end
        error('The overlay type setting for the archive is different from last time!')
    end
    last_table = {}
    M.player_tables[player][slot] = last_table
    if disable_cover == true or disable_cover == nil then
        last_table[1] = M.load_table_with_cover_disable(player, slot)
    else
        last_table[1] = M.load_table_with_cover_enable(player, slot)
    end
    last_table[2] = disable_cover
    return last_table[1]
end

---@private
---@type table<Player, table<integer, { timer: LocalTimer, table: table }>>
M.save_table_pool = {}

---Save the player's save data (table), the save Settings must use the allow overwrite mode.
---> The editor no longer supports allowing override mode, so this function is no longer useful.
---@deprecated
---@param player Player
---@param slot integer
---@param t table
function M.save_table(player, slot, t)
    ---@diagnostic disable-next-line: deprecated
    if player ~= clicli.player.get_local() then
        return
    end
    assert(type(t) == 'table', 'The data type must be a table!')
    M.want_to_save = t
    local pools = M.save_table_pool[player]
    if not pools then
        pools = {}
        M.save_table_pool[player] = pools
    end
    local pool = pools[slot]
    if not pool then
        pool = {}
        pools[slot] = pool
        pool.timer = clicli.ltimer.wait(0.1, function ()
            pools[slot] = nil
            local t = pool.table
            t = clicli.proxy.raw(t) or t
            player.handle:set_save_data_table_value(slot, t)
            M.upload_save_data(player)
        end)
    end
    pool.table = t
end

---@private
---@type table<Player, LocalTimer>
M.upload_timer_map = {}

---@private
---@param player Player
function M.upload_save_data(player)
    local timer = M.upload_timer_map[player]
    if timer then
        return
    end
    M.upload_timer_map[player] = clicli.ltimer.wait(0.1, function ()
        M.upload_timer_map[player] = nil
        player.handle:upload_save_data()
        log.info('Auto save archive:', player)
    end)
end

clicli.game:event_on('$CliCli- About to switch levels', function ()
    for _, timer in pairs(M.upload_timer_map) do
        timer:execute()
    end
    for _, pools in pairs(M.save_table_pool) do
        for _, pool in pairs(pools) do
            pool.timer:execute()
        end
    end
end)

---@private
---@param player Player
---@param slot integer
---@return table
function M.load_table_with_cover_enable(player, slot)
    local save_data = player.handle:get_save_data_table_value(slot) or {}
    local create_proxy

    ---@type Proxy.Config
    local proxy_config = {
        anySetter = function (self, raw, key, value, config, custom)
            if custom >= 3 and type(value) == 'table' then
                error('Archive tables only support a maximum of 3 layers of nesting')
            end
            if type(key) ~= 'string'
            and math.type(key) ~= 'integer' then
                error('The key for the archive must be a string or integer')
            end
            value = clicli.helper.as_lua(value)
            local vtype = type(value)
            if  vtype ~= 'nil'
            and vtype ~= 'string'
            and vtype ~= 'boolean'
            and vtype ~= 'number'
            and vtype ~= 'table' then
                error('Archived values can only be base types or tables')
            end
            if vtype == 'table' and clicli.proxy.raw(value) then
                value = clicli.proxy.raw(value)
            end
            raw[key] = value

            ---@diagnostic disable-next-line: deprecated
            M.save_table(player, slot, save_data)
        end,
        anyGetter = function (self, raw, key, config, custom)
            local value = raw[key]
            if type(value) == 'table' then
                return create_proxy(value, custom + 1)
            end
            return clicli.helper.as_lua(value)
        end
    }

    function create_proxy(raw, level)
        if M.table_cache[raw] then
            return M.table_cache[raw]
        end
        local v = clicli.proxy.new(raw, proxy_config, level)
        M.table_cache[raw] = v
        return v
    end

    local proxy_save_data = create_proxy(save_data, 0)

    return proxy_save_data
end

---@private
---@param player Player
---@param slot integer
---@return table
function M.load_table_with_cover_disable(player, slot)
    local save_data = player.handle:get_save_data_table_value(slot) or {}
    local create_proxy

    local function unpack_path(key, path)
        local key1 = path and path[1]
        if not key1 then
            key1 = key
            key = ''
        end
        local key2 = path and path[2]
        if not key2 then
            key2 = key
            key = ''
        end
        local key3 = path and path[3] or key
        return key1, key2, key3
    end

    local function set_value(key, value, path)
        local key1, key2, key3 = unpack_path(key, path)
        if value == nil then
            player.handle:remove_save_table_key_value(slot
                , key1
                , key2
                , key3
            )
        else
            player.handle:set_save_table_key_value(slot
                , key1
                , value
                , key2
                , key3
                , ''
            )
        end
    end

    local function get_value(key, path)
        local key1, key2, key3 = unpack_path(key, path)
        return player.handle:get_save_table_key_value(slot
            , key1
            , key2
            , key3
            ---@diagnostic disable-next-line: param-type-mismatch
            , nil
            , ''
        )
    end

    ---@type Proxy.Config
    local proxy_config = {
        anySetter = function (self, raw, key, value, config, path)
            if type(key) ~= 'string'
            and math.type(key) ~= 'integer' then
                error('The key of the table must be a string or integer')
            end
            value = clicli.helper.as_lua(value)
            local vtype = type(value)
            if vtype == 'table' then
                if next(value) ~= nil then
                    error('A non-empty table cannot be used as an archive value in override mode')
                end
                if path and #path >= 3 then
                    error('Archive tables only support a maximum of 3 layers of nesting')
                end
                if clicli.proxy.raw(value) then
                    value = clicli.proxy.raw(value)
                end
            elseif vtype ~= 'nil'
            and    vtype ~= 'string'
            and    vtype ~= 'boolean'
            and    vtype ~= 'number' then
                error('Archived values can only be base types')
            end
            raw[key] = value

            set_value(key, value, path)
        end,
        anyGetter = function (self, raw, key, config, path)
            local value = get_value(key, path)
            if type(value) == 'table' then
                local new_path = path and { table.unpack(path) } or {}
                new_path[#new_path+1] = key
                return create_proxy(value, new_path)
            end

            return clicli.helper.as_lua(value)
        end
    }

    function create_proxy(raw, path)
        if M.table_cache[raw] then
            return M.table_cache[raw]
        end
        local v = clicli.proxy.new(raw, proxy_config, path)
        M.table_cache[raw] = v
        return v
    end

    local proxy_save_data = create_proxy(save_data)

    return proxy_save_data
end

return M
