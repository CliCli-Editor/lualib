---@class Proxy
local M = {}

local CONFIG    = {'<CONFIG>'}
local CUSTOM    = {'<CUSTOM>'}
local RECUSIVE  = {'<RECUSIVE>'}
local PATH      = {'<PARENT>'}

local rawMap = setmetatable({}, { __mode = 'k' })

---@alias Proxy.Setter fun(self: table, raw: any, key: any, value: any, config: Proxy.Config, custom: any): any
---@alias Proxy.Getter fun(self: table, raw: any, key: any, config: Proxy.Config, custom: any): any

---@class Proxy.Config
---@field cache? boolean # The result of the read/write is cached, and the next read/write will not trigger the setter, getter (unless the last result was nil)
---@field updateRaw? boolean # Whether to write the assignment to 'raw'
---@field recursive? boolean # Recursive proxy or not
---@field setter? { [any]: Proxy.Setter }
---@field getter? { [any]: Proxy.Getter }
---@field anySetter? Proxy.Setter # anySetter is triggered only if there is no corresponding setter
---@field anyGetter? Proxy.Getter # 'anyGetter' is triggered only if there is no corresponding 'getter'
local defaultConfig = {
    cache     = true,
}

local metatable

local function getRecusiveProxy(parent, key, value, config, custom, recursive)
    value = rawMap[value] or value
    local proxy = recursive[value]
    if proxy then
        return proxy
    end
    if type(value) ~= 'table' and type(value) ~= 'userdata' then
        return value
    end
    proxy = setmetatable({
        [CONFIG]   = config,
        [CUSTOM]   = custom,
        [RECUSIVE] = recursive,
        [PATH]     = { parent, key },
    }, metatable)
    recursive[value] = proxy
    rawMap[proxy] = value
    return proxy
end

metatable = {
    __newindex = function (self, key, value)
        local raw    = rawMap[self]
        ---@type Proxy.Config
        local config = rawget(self, CONFIG)
        local custom = rawget(self, CUSTOM)
        local setter = config.setter and config.setter[key]
        local nvalue
        if setter then
            nvalue = setter(self, raw, key, value, config, custom)
        elseif config.anySetter then
            nvalue = config.anySetter(self, raw, key, value, config, custom)
        else
            nvalue = value
        end
        if config.cache then
            rawset(self, key, nvalue)
        end
        if config.updateRaw then
            raw[key] = nvalue
        end
    end,
    __index = function (self, key)
        local raw    = rawMap[self]
        ---@type Proxy.Config
        local config = rawget(self, CONFIG)
        local custom = rawget(self, CUSTOM)
        local recursive = rawget(self, RECUSIVE)
        local getter = config.getter and config.getter[key]
        local value
        if getter then
            value = getter(self, raw, key, config, custom)
        elseif config.anyGetter then
            value = config.anyGetter(self, raw, key, config, custom)
        else
            value = raw[key]
        end

        if config.cache then
            rawset(self, key, value)
        end

        if recursive then
            value = getRecusiveProxy(self, key, value, config, custom, recursive)
        end

        return value
    end,
    __pairs = function (self)
        local raw = rawMap[self]
        local t = {}
        for k in pairs(raw) do
            t[k] = self[k]
        end
        for k in next, self do
            if k ~= CONFIG and k ~= CUSTOM and k ~= RECUSIVE then
                t[k] = self[k]
            end
        end
        return next, t, nil
    end,
    __len = function (self)
        local raw = rawMap[self]
        return #raw
    end
}

local metaKV = { __mode = 'kv' }

---@generic T
---@param obj T # The object to proxy
---@param config? Proxy.Config # disposition
---@param custom? any # Custom data
---@return T
function M.new(obj, config, custom)
    local tp = type(obj)
    if tp ~= 'table' and tp ~= 'userdata' then
        error('Only table and userdata can be brokered')
    end
    config = config or defaultConfig

    local proxy = {
        [CONFIG] = config,
        [CUSTOM] = custom,
    }

    if config.recursive then
        local recursive = setmetatable({}, metaKV)
        proxy[RECUSIVE] = recursive
        recursive[obj] = proxy
    end

    setmetatable(proxy, metatable)
    rawMap[proxy] = obj

    return proxy
end

---@param proxyObj table
---@return any
function M.raw(proxyObj)
    return rawMap[proxyObj] or proxyObj
end

---@param proxyObj table
---@return any
function M.rawRecusive(proxyObj)
    local obj = rawMap[proxyObj] or proxyObj
    for k, v in pairs(obj) do
        if type(v) == 'table' then
            obj[k] = M.rawRecusive(v)
        end
    end
    return obj
end

---@param proxyObj table
---@return table
function M.config(proxyObj)
    return proxyObj[CONFIG]
end

--Invert the order of the elements in an array
---@param arr any[]
---@return any[]
local function revertArray(arr)
    local len = #arr
    if len <= 1 then
        return arr
    end
    for x = 1, len // 2 do
        local y = len - x + 1
        arr[x], arr[y] = arr[y], arr[x]
    end
    return arr
end

function M.getPath(proxyObj)
    local result = {}
    while proxyObj do
        local path = rawget(proxyObj, PATH)
        if not path then
            break
        end
        local parent, key = path[1], path[2]
        result[#result+1] = key
        proxyObj = parent
    end
    revertArray(result)
    return result
end

return M
