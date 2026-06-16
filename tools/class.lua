---@diagnostic disable: deprecated

local rawset = rawset
local rawget = rawget

local tablecreatef = setmetatable({}, { __index = function (t, k)
    local buf = {}
    buf[#buf+1] = 'return function () return {'
    for i = 1, k do
        buf[#buf+1] = 'x' .. i .. ' = nil,'
    end
    buf[#buf+1] = '} end'
    local content = table.concat(buf, '')
    local f = assert(load(content, content))()
    t[k] = f
    return f
end })

local tablecreate = table.create or function (_, nrec)
    return tablecreatef[nrec]()
end

---@class Class
local M = {}

---@private
---@type table<string, Class.Base>
M._classes = {}

---@private
---@type table<string, function>
M._alias = {}

---@private
---@type table<string, Class.Config>
M._classConfig = {}

---@private
M._errorHandler = error

---@class Class.Base
---@field public  __init?  fun(self: any, ...)
---@field public  __del?   fun(self: any)
---@field public  __alloc? fun(self: any)
---@field package __call   fun(self: any, ...)
---@field package __name string
---@field public  __getter table
---@field public  __setter table
---@field public  __super  Class.Base
---@field package __config Class.Config

---@class Class.Config
---@field package name         string
---@field package extendsMap   table<string, boolean>
---@field package extendsList  Class.ExtendsInfo[]
---@field package extendsRev   table<string, boolean>
---@field private superCache   table<string, fun(...) >
---@field package superClass?  Class.Base
---@field package inited?      boolean
---@field package extendsKeys? table<string, boolean>
---@field package initCalls?   fun(obj: Class.Base, ...) []
---@field package compress     string[]
---@field package presize?     integer
---@field package resetTrap    fun()
---@field private initOrder?  Class.Config[]
---@field private mergedCompress? string[]
local Config = {}

---@param name string | table
---@return Class.Config
function M.getConfig(name)
    if type(name) == 'table' then
        name = name.__name
    end
    if not M._classConfig[name] then
        M._classConfig[name] = setmetatable({
            name         = name,
            extendsMap   = {},
            extendsList  = {},
            extendsRev   = {},
            superCache   = {},
            compress     = {},
        }, { __index = Config })
    end
    return M._classConfig[name]
end

--Define a class
---@generic T: string
---@generic Super: string
---@param name  `T`
---@param super? `Super`
---@param superInit? fun(self: Class, super: Super, ...)
---@return T
---@return Class.Config
function M.declare(name, super, superInit)
    local config = M.getConfig(name)
    if M._classes[name] then
        config:reset()
        return M._classes[name], config
    end
    local class  = {}
    local getter = {}
    local setter = {}
    local keyMap
    local keyMapRev --integer slot -> Original key, used only for __pairs
    class.__name   = name
    class.__getter = getter
    class.__setter = setter
    class.__config = config

    local function buildKeyMap()
        if keyMap then
            return
        end
        keyMap = {}
        keyMapRev = {}
        for i, k in ipairs(config:getCompress()) do
            keyMap[k] = i
            keyMapRev[i] = k
        end
        setmetatable(keyMap, { __index = function (t, k)
            t[k] = false
            return false
        end })
    end

    ---@param self any
    ---@param k any
    ---@return any
    local function getterFuncWithCompress(self, k)
        local ik = keyMap[k]
        if ik then
            local v = rawget(self, ik)
            if v ~= nil then
                return v
            end
        end
        local r = class[k]
        if r == nil then
            local f = getter[k]
            if f then
                local res, needCache = f(self)
                if needCache then
                    rawset(self, ik or k, res)
                end
                return res
            else
                return nil
            end
        else
            return r
        end
    end

    ---@param self any
    ---@param k any
    ---@return any
    local function getterFunc(self, k)
        local r = class[k]
        if r == nil then
            local f = getter[k]
            if f then
                local res, needCache = f(self)
                if needCache then
                    rawset(self, k, res)
                end
                return res
            else
                return nil
            end
        else
            return r
        end
    end

    ---@param self any
    ---@param k any
    ---@param v any
    ---@return any
    local function setterFuncWithCompress(self, k, v)
        local ik = keyMap[k]
        if ik then
            if rawget(self, ik) ~= nil then
                rawset(self, ik, v)
                return
            end
        end
        local f = setter[k]
        if f then
            local res = f(self, v)
            if res ~= nil then
                rawset(self, ik or k, res)
            end
        else
            rawset(self, ik or k, v)
        end
    end

    ---@param self any
    ---@param k any
    ---@param v any
    ---@return any
    local function setterFunc(self, k, v)
        local f = setter[k]
        if f then
            local res = f(self, v)
            if res ~= nil then
                rawset(self, k, res)
            end
        else
            rawset(self, k, v)
        end
    end

    local mt = {
        __call = function (self, ...)
            if not self.__alloc then
                error(('class %q can not be instantiated'):format(name))
                return self
            end
            return self:__alloc(...)
        end,
    }

    config.resetTrap = function ()
        keyMap = nil
        keyMapRev = nil

        function mt:__index(k)
            config:init()
            mt.__index = nil
            return rawget(self, k)
        end

        function class:__index(k)
            config:init()
            local compress = config:getCompress()
            if next(class.__getter) or #compress > 0 then
                if #compress > 0 then
                    buildKeyMap()
                    class.__index = getterFuncWithCompress
                    return getterFuncWithCompress(self, k)
                else
                    class.__index = getterFunc
                    return getterFunc(self, k)
                end
            else
                class.__index = class
                return class[k]
            end
        end

        function class:__newindex(k, v)
            local compress = config:getCompress()
            if next(class.__setter) or #compress > 0 then
                if #compress > 0 then
                    buildKeyMap()
                    class.__newindex = setterFuncWithCompress
                    return setterFuncWithCompress(self, k, v)
                else
                    class.__newindex = setterFunc
                    setterFunc(self, k, v)
                end
            else
                class.__newindex = nil
                rawset(self, k, v)
            end
        end

        function class:__pairs()
            if #config:getCompress() == 0 then
                class.__pairs = nil
                return next, self, nil
            end
            buildKeyMap()
            ---@cast keyMap -?
            ---@cast keyMapRev -?
            return function (_, k)
                local ik
                if k == nil then
                    ik = nil
                elseif type(k) == 'string' and keyMap[k] then
                    --The last time the original compressed key was returned, and it needs to be switched back to integer slot
                    ik = keyMap[k]
                else
                    ik = k
                end
                local nk, nv = next(self, ik)
                if type(nk) == 'number' and keyMapRev[nk] then
                    return keyMapRev[nk], nv
                end
                return nk, nv
            end, self, nil
        end
    end
    config.resetTrap()

    function class:__encode()
        return self
    end

    function class:__decode(value)
        return M.new(name, value)
    end

    function class:__call(...)
        config:runInit(self, ...)
        return self
    end

    M._classes[name] = class

    setmetatable(class, mt)

    local superClass = M._classes[super]
    if superClass then
        if class == superClass then
            M._errorHandler(('class %q can not inherit itself'):format(name))
        else
            class.__super = superClass
            config.superClass = superClass
            config:extends(super, superInit)
        end

    end

    return class, config
end

--Get a class
---@generic T: string
---@param name `T`
---@return T
function M.get(name)
    return M._classes[name]
end

---Create a type alias for an existing constructor
---@param name string
---@param creator function
function M.alias(name, creator)
    M._alias[name] = creator
end

--Instantiate a class
---@generic T: string
---@param name `T`
---@param tbl? table
---@return T | fun(...) :T
function M.new(name, tbl)
    local class = M._classes[name]
    if not class then
        local aliasCreator = M._alias[name]
        if aliasCreator then
            return function (...)
                local instance = aliasCreator(...)
                instance.__class__ = name
                return instance
            end
        elseif type(name) == 'table' then
            class = name
            name = class.__name
        else
            M._errorHandler(('class %q not found'):format(tostring(name)))
            return nil
        end
    end

    local config = class.__config
    if not config.inited then
        config:init()
    end

    if not tbl then
        local presize = config.presize
        if presize then
            tbl = tablecreate(0, presize + 2)
        else
            tbl = tablecreate(0, 2)
        end
    end
    tbl.__class__ = class.__name

    local instance = setmetatable(tbl, class)

    return instance
end

--Construct an example
---@param obj table
function M.delete(obj)
    if obj.__deleted__ then
        return
    end
    obj.__deleted__ = true
    local name = obj.__class__
    if not name then
        M._errorHandler('can not delete undeclared class : ' .. tostring(obj))
        return
    end

    local config = M.getConfig(name)
    config:runDel(obj)
end

--Gets the name of the class
---@param obj any
---@return string?
function M.type(obj)
    if type(obj) ~= 'table' then
        return nil
    end
    return obj.__class__
end

--Determine whether an instance is valid
---@param obj table
---@return boolean
function M.isValid(obj)
    return obj.__class__ ~= nil
       and not obj.__deleted__
end

--It is recommended to use "extended semantics" rather than "inherited" semantics.
--So  isuper' is no longer suitable.
---@deprecated
---@param name string
---@return fun(...)
function M.super(name)
    local config = M.getConfig(name)
    return config:super(name)
end

---@class Class.ExtendsInfo
---@field name string
---@field init? fun(self: any, super: (fun(...) : Class.Base), ...)

---@generic Class: string
---@generic Extends: string
---@param name `Class` | table
---@param extendsName `Extends`
---@param init? fun(self: Class, super: Extends, ...)
function M.extends(name, extendsName, init)
    local config = M.getConfig(name)
    config:extends(extendsName, init)
end

---@param errorHandler fun(msg: string)
function M.setErrorHandler(errorHandler)
    M._errorHandler = errorHandler
end

---@param name string
---@return fun(...)
function Config:super(name)
    if not self.superCache[name] then
        local class = M._classes[name]
        if not class then
            M._errorHandler(('class %q not found'):format(name))
            return function () end
        end
        local super = self.superClass
        if not super then
            M._errorHandler(('class %q not inherit from any class'):format(name))
            return function () end
        end
        self.superCache[name] = function (...)
            local k, obj = debug.getlocal(2, 1)
            if k ~= 'self' then
                M._errorHandler(('`%s()` must be called by the class'):format(name))
                return
            end
            super.__call(obj,...)
        end
    end
    return self.superCache[name]
end

---@generic Extends: string
---@param extendsName `Extends`
---@param init? fun(self: self, super: Extends, ...)
function Config:extends(extendsName, init)
    if type(init) ~= 'nil' and type(init) ~= 'function' then
        M._errorHandler('init must be nil or function')
        return
    end
    if self.extendsMap[extendsName] then
        return
    end
    self.extendsMap[extendsName] = true
    M.getConfig(extendsName).extendsRev[self.name] = true

    self.extendsList[#self.extendsList+1] = {
        name = extendsName,
        init = init,
    }

    self:reset()
end

---Return the merged list of compress containing all parent classes (in init order)
---@package
---@return string[]
function Config:getCompress()
    local merged = self.mergedCompress
    if merged then
        return merged
    end
    merged = {}
    self.mergedCompress = merged
    for _, cfg in ipairs(self:getInitOrder()) do
        for _, k in ipairs(cfg.compress) do
            merged[#merged+1] = k
        end
    end
    return merged
end

---Build the init call plan. One DFS completion
---* initCalls: Flattened callable list (each element = function(obj,...)) (end), arranged in the order of invocation
---* initOrder: The order of Class.Config after removing duplications from the rhombus, for use in reverse order by runDel
---Diamond inheritance is de-duplicated during the build phase. The super of the explicit init hook is also pre-packaged with the corresponding sub-steps
---@private
function Config:buildInitPlan()
    if self.initCalls then
        return
    end

    local initCalls = {}
    local initOrder = {}
    self.initCalls = initCalls
    self.initOrder = initOrder

    local visited = {}      --name -> true, diamond-shaped deduplication
    local inProgress = {}   --name -> true, loop inheritance detection
    local selfName = self.name

    local function pushSelfCall(cfg)
        initOrder[#initOrder+1] = cfg
        local cfgName = cfg.name
        initCalls[#initCalls+1] = function (obj, ...)
            local class = M._classes[cfgName]
            if class and class.__init then
                class.__init(obj, ...)
            end
        end
    end

    local expand

    --Handle the extendsList[i] of cfg: If the init hook is included, fold the corresponding parent class chain into a super() closure
    local function handleExtends(info)
        local pcfg = M.getConfig(info.name)
        if not pcfg then
            M._errorHandler(('class %q not found'):format(info.name))
            return
        end
        if not info.init then
            expand(pcfg)
            return
        end

        --Explicit init hook: First, attempt to expand the parent class chain to the end of initCalls
        local userInit = info.init
        local parentName = info.name
        local subStart = #initCalls + 1
        expand(pcfg)
        local subEnd = #initCalls

        if subStart > subEnd then
            --The entire parent chain has been de-duplicated (diamond-shaped) → super() will definitely report an error
            initCalls[#initCalls+1] = function (obj, ...)
                local superCount = 0
                local function super(...)
                    superCount = superCount + 1
                    if superCount > 1 then
                        M._errorHandler(('super can only be called once in extends of class %q'):format(selfName))
                        return
                    end
                    M._errorHandler(('diamond inheritance: class %q already initialized, cannot call super explicitly in %q'):format(parentName, selfName))
                end
                userInit(obj, super, ...)
                if superCount == 0 then
                    M._errorHandler(('super must be called in extends of class %q'):format(selfName))
                end
            end
            return
        end

        --Put subStart.." The subEnd is extracted and triggered by super()
        local subCalls = {}
        for i = subStart, subEnd do
            subCalls[#subCalls+1] = initCalls[i]
        end
        for i = subEnd, subStart, -1 do
            initCalls[i] = nil
        end
        local subN = #subCalls
        initCalls[#initCalls+1] = function (obj, ...)
            local superCount = 0
            local function super(...)
                superCount = superCount + 1
                if superCount > 1 then
                    M._errorHandler(('super can only be called once in extends of class %q'):format(selfName))
                    return
                end
                for i = 1, subN do
                    subCalls[i](obj, ...)
                end
            end
            userInit(obj, super, ...)
            if superCount == 0 then
                M._errorHandler(('super must be called in extends of class %q'):format(selfName))
            end
        end
    end

    expand = function (cfg)
        local cfgName = cfg.name
        if visited[cfgName] then
            return
        end
        if inProgress[cfgName] then
            M._errorHandler(('class %q has circular inheritance'):format(selfName))
            return
        end
        inProgress[cfgName] = true

        for _, info in ipairs(cfg.extendsList) do
            handleExtends(info)
        end

        inProgress[cfgName] = nil
        visited[cfgName] = true
        pushSelfCall(cfg)
    end

    expand(self)
end

---Return a flat list of init calls
---@private
---@return (fun(obj: any, ...) ) []
function Config:getInitCalls()
    self:buildInitPlan()
    return self.initCalls
end

---Return the execution order of __init (the diamonds have been de-duplicated) for use in reverse order by runDel
---@private
---@return Class.Config[]
function Config:getInitOrder()
    self:buildInitPlan()
    return self.initOrder
end

---@package
function Config:init()
    if self.inited then
        return
    end
    self.inited = true
    self:getInitOrder() --Trigger the loop inheritance check and build the initOrder cache
    self.extendsKeys = {}

    local class = M._classes[self.name]
    for _, info in ipairs(self.extendsList) do
        local extendsName = info.name
        local extends = M._classes[extendsName]
        if not extends then
            M._errorHandler(('class %q not found'):format(extendsName))
            goto continue
        end
        local extendsConfig = extends.__config
        extendsConfig:init()

        --Copy the fields of the parent class with the getter and setter
        for k, v in pairs(extends) do
            if not class[k] and not k:match '^__' then
                self.extendsKeys[k] = true
                class[k] = v
            end
        end
        for k, v in pairs(extends.__getter) do
            if not class.__getter[k] then
                self.extendsKeys[k] = true
                class.__getter[k] = v
            end
        end
        for k, v in pairs(extends.__setter) do
            if not class.__setter[k] then
                self.extendsKeys[k] = true
                class.__setter[k] = v
            end
        end
        ::continue::
    end
end

---@package
---@param obj table
---@param ... any
function Config:runInit(obj, ...)
    local initCalls = self:getInitCalls()
    for i = 1, #initCalls do
        initCalls[i](obj, ...)
    end
end

---@package
---@param obj table
function Config:runDel(obj)
    --Destruction order: Executed in reverse order of the init order
    local order = self:getInitOrder()
    for i = #order, 1, -1 do
        local extClass = M._classes[order[i].name]
        if extClass and extClass.__del then
            extClass.__del(obj)
        end
    end
end

---Reset the cache to support overloading
---@package
---@param visited? table
function Config:reset(visited)
    self.initOrder = nil
    self.initCalls = nil
    self.mergedCompress = nil

    if self.inited then
        self.inited = nil
        self:resetTrap()

        --Clear the fields copied from the parent class, and the subclass may redefine its own fields
        local class = M._classes[self.name]
        if class and self.extendsKeys then
            for k in pairs(self.extendsKeys) do
                class[k] = nil
                class.__getter[k] = nil
                class.__setter[k] = nil
            end
            self.extendsKeys = nil
        end
    end

    --Regardless of whether this class has been init or not, cache invalidation should be propagated to the subclasses that have been init
    visited = visited or {}
    visited[self.name] = true
    for child in pairs(self.extendsRev) do
        if not visited[child] then
            M.getConfig(child):reset(visited)
        end
    end
end

local isInstanceMap = setmetatable({}, { __index = function (isInstanceMap, myName)
    local map = {
        [myName] = true,
    }
    isInstanceMap[myName] = map

    local config = M.getConfig(myName)
    setmetatable(map, { __index = function (_, targetName)
        local superName = config.superClass and config.superClass.__name
        if superName then
            if isInstanceMap[superName][targetName] then
                map[targetName] = true
                return true
            end
        end
        for parentName in pairs(config.extendsMap) do
            if isInstanceMap[parentName][targetName] then
                map[targetName] = true
                return true
            end
        end
        map[targetName] = false
        return false
    end })
    return map
end })

---Checks whether an object is an instance of a class
---@param obj any
---@param targetName string
---@return boolean
function M.isInstanceOf(obj, targetName)
    local myName = M.type(obj)
    if not myName then
        return false
    end

    return isInstanceMap[myName][targetName]
end

---Clear the cache data of an object (corresponding to the field of the '__getter')
---@param obj Class.Base
function M.flush(obj)
    local getter = obj.__getter
    for k in pairs(getter) do
        obj[k] = nil
    end
end

---Enable field compression for the class: Map the specified string key to the integer slot
---Reduce the overhead of the instance hash part.
---
---** Note ** : After enabling compression, instances of this class can no longer be written with positive integers as keys
---It may conflict with the compression slot, overwrite or read incorrect data.
---@param name string | table
---@param keys string[]
function M.compressKeys(name, keys)
    local config = M.getConfig(name)
    config.compress = keys
    config:reset()
end

function M.presize(name, nreq)
    local config = M.getConfig(name)
    config.presize = nreq
end

return M
