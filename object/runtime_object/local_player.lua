local must_sync = require 'clicli.meta.must_sync'

---@class LocalPlayer
local M = Class 'LocalPlayer'

local getupvalue  = debug and debug.getupvalue
local setupvalue  = debug and debug.setupvalue
local upvaluejoin = debug and debug.upvaluejoin
local getinfo     = debug and debug.getinfo

local can_use_debug = getupvalue ~= nil
                and   setupvalue ~= nil
                and   upvaluejoin ~= nil
                and   getinfo ~= nil
                and   true
                or    false

---@param func function
function M:__init(func)
    self.func = func
    self.uv_values = {}

    for i = 1, 255 do
        local name, value = getupvalue(func, i)
        if not name then
            break
        end
        if value == _ENV then
            value = self:wrap_env_in_upvalue(func, i, value)
        elseif type(value) == 'function' then
            value = self:wrap_function_in_upvalue(func, i, value)
        elseif type(value) == 'table' then
            value = self:wrap_table_in_upvalue(func, i, name, value)
        end
        self.uv_values[i] = value
    end
end

---@param name string
---@return boolean
function M.is_name_must_sync(name)
    if not M.must_sync_name_map then
        M.must_sync_name_map = clicli.util.revertMap(must_sync)
    end
    return M.must_sync_name_map[name] ~= nil
end

---@param func function
---@param name string
---@param old_value any
---@param new_value any
local function build_upvalue_error_message(func, name, old_value, new_value)
    local info = getinfo(func, 'Sl')
    log.warn(string.format('You change the value of the upper value [%s] from [%s] to [%s] in the local player environment. Values have been restored to ensure synchronization. \n Environment location :% s:%d'
        , name
        , old_value
        , new_value
        , info.short_src
        , info.linedefined
    ))
end

---@param t table
---@param k any
---@param old_value any
---@param new_value any
local function build_variable_error_message(t, k, old_value, new_value)
    local info = getinfo(3, 'Sl')
    log.warn(string.format('You change the value of the variable [%s] from [%s] to [%s] in the local environment. \n Modified position :% s:%d'
        , k
        , old_value
        , new_value
        , info.short_src
        , info.linedefined
    ))
end

---@param name string
local function build_call_error_message(name)
    log.warn(string.format('API [%s] \n%s cannot be invoked in a local environment'
        , name
        , debug.traceback()
    ))
end

function M:__close()
    --TODO
    --It is currently impossible to determine the local variable quilt function modification in the local environment,
    --Temporarily block this feature
    do return end
    for i, old_value in ipairs(self.uv_values) do
        local name, value = getupvalue(self.func, i)
        --If it is the upper value that has not been represented, restore the original value.
        --If it is a brokered value, its reference is already
        --It's not the same reference as the real upvalue, so
        --You can also modify it directly
        if old_value ~= value then
            setupvalue(self.func, i, old_value)
            build_upvalue_error_message(self.func, name, old_value, value)
        end
    end
end

---@param func function
---@param i integer
---@param value function
---@return function
function M:wrap_function_in_upvalue(func, i, value)
    local wrapped_func = M.wrap_function(value)
    local dummy = function () return wrapped_func end
    upvaluejoin(func, i, dummy, 1)
    return wrapped_func
end

---@param func function
---@param i integer
---@param value table
---@return table
function M:wrap_env_in_upvalue(func, i, value)
    local wrapped_env = M.wrap_env(value)
    local dummy = function () return wrapped_env end
    upvaluejoin(func, i, dummy, 1)
    return wrapped_env
end

---@param func function
---@param i integer
---@param name string
---@param value table
---@return table
function M:wrap_table_in_upvalue(func, i, name, value)
    local wrapped_table = M.wrap_table(name, value)
    local dummy = function () return wrapped_table end
    upvaluejoin(func, i, dummy, 1)
    return wrapped_table
end

M.LOCAL_PLAYER = clicli.player.get_by_handle(GameAPI.get_client_role())

M.dont_wrap_this = setmetatable({}, { __mode = 'k' })

---@private
---@param func function
---@return function
function M.wrap_function(func)
    if M.dont_wrap_this[func] then
        return func
    end
    local f = function (...)
        local _ <close> = New 'LocalPlayer' (func)
        return func(...)
    end
    M.dont_wrap_this[f] = true
    return f
end

---@private
---@param name string
---@param tbl table
---@return table
function M.wrap_table(name, tbl)
    if M.dont_wrap_this[tbl] then
        return tbl
    end
    local wrapped_table = clicli.proxy.new(tbl, M.proxy_config, name)
    M.dont_wrap_this[wrapped_table] = true
    return wrapped_table
end

---@type Proxy.Config
M.proxy_config = {
    cache = true,
    anyGetter = function (self, raw, key, config, parent_path)
        local value = raw[key]
        if type(value) == 'table' then
            local new_path
            if parent_path == '' then
                new_path = tostring(key)
            else
                new_path = parent_path .. '.' .. tostring(key)
            end
            return clicli.proxy.new(value, M.proxy_config, new_path)
        elseif type(value) == 'function' then
            value = M.check_function_in_sandbox(parent_path, value)
            return value
        else
            return value
        end
    end,
    anySetter = function (self, raw, key, value, config, parent_path)
        build_variable_error_message(self, parent_path .. '.' .. tostring(key), self[key], value)
        return value
    end
}

---@param name string
---@param func function
---@return function
function M.check_function_in_sandbox(name, func)
    --Checks whether it is a "harmful" function, and rejects execution if it is
    if M.is_name_must_sync(name) then
        build_call_error_message(name)
        return function () end
    end
    --Wrap the callback function
    local info = getinfo(func, 'u')
    if info.nparams == 0 then
        return func
    end
    local wrapped_func = function (...)
        local params = table.pack(...)
        for i, p in ipairs(params) do
            if type(p) == 'function' then
                params[i] = M.wrap_function(p)
            end
        end
        return func(table.unpack(params, 1, params.n))
    end
    return wrapped_func
end

M.sandbox = clicli.proxy.new(_G, M.proxy_config, '')

clicli.reload.onAfterReload(function ()
    M.sandbox = clicli.proxy.new(_G, M.proxy_config, '')
end)

---@param env table
---@return table
function M.wrap_env(env)
    return M.sandbox
end

---@class Player
local Player = Class 'Player'

--Execute code in the local player environment.
--In development mode, this code is prevented from modifying upper values, modifying global variables, and calling synchronization functions, thus incurring additional overhead. (temporarily disabled)
--There is no detection on the platform and no additional overhead.
--
------
--
--```lua
--clicli.player.with_local(function (local_player)
--Modifying the upper value in this callback function, modifying global variables, and calling synchronous functions will give warnings
--print(local_player)
--end)
--```
---@param callback fun(local_player: Player)
function Player.with_local(callback)
    do
        callback(M.LOCAL_PLAYER)
        return
    end
    if not can_use_debug
    or not clicli.game.is_debug_mode() then
        callback(M.LOCAL_PLAYER)
        return
    end
    local func = M.wrap_function(callback)
    func(M.LOCAL_PLAYER)
end

return M
