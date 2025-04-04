local type           = type
local next           = next
local pairs          = pairs
local ipairs         = ipairs
local rawget         = rawget
local rawset         = rawset
local pcall          = pcall
local tostring       = tostring
local select         = select
local sformat        = string.format
local getregistry    = debug.getregistry
local getmetatable   = debug.getmetatable
local getupvalue     = debug.getupvalue
---@diagnostic disable-next-line: deprecated
local getuservalue   = debug.getuservalue or debug.getfenv
local getlocal       = debug.getlocal
local getinfo        = debug.getinfo
local maxinterger    = 10000
local mathType       = math.type
local _G             = _G
local registry       = getregistry()
local ccreate        = coroutine.create
local setmetatable   = setmetatable
local error          = error
local multiUserValue = _VERSION == 'Lua 5.4'
local hasPoint       = pcall(sformat, '%p', _G)

local _private = {}

---@generic T
---@param o T
---@return T
local function private(o)
    if not o then
        return nil
    end
    _private[o] = true
    return o
end

---@class Doctor
local m = private {}

---@private
m._ignoreMainThread = true

---@alias Doctor.ToStringLevel 'all' | 'onlylua' | 'none'

---@private
---@type Doctor.ToStringLevel
m._toStringTable = 'all'

---@private
---@type Doctor.ToStringLevel
m._toStringUserdata = 'all'

---@private
m._cache = false

---@private
m._exclude = nil

---@private
m._lastCache = nil

local function getPoint(obj)
    if hasPoint then
        return ('%p'):format(obj)
    else
        local mt = getmetatable(obj)
        local ts
        if mt then
            ts = rawget(mt, '__tostring')
            if ts then
                rawset(mt, '__tostring', nil)
            end
        end
        local name = tostring(obj)
        if ts then
            rawset(mt, '__tostring', ts)
        end
        return name:match(': (.+)')
    end
end

local function formatObject(obj, tp, ext)
    local text = ('%s:%s'):format(tp, getPoint(obj))
    if ext then
        text = ('%s(%s)'):format(text, ext)
    end
    return text
end

local function isInteger(obj)
    if mathType then
        return mathType(obj) == 'integer'
    else
        return obj % 1 == 0
    end
end

---@param obj table | userdata
---@param level Doctor.ToStringLevel
---@return string?
local function getTostring(obj, level)
    local mt = getmetatable(obj)
    if not mt then
        return nil
    end
    local name = rawget(mt, '__name')
    if type(name) ~= 'string' then
        name = nil
    end
    if level == 'none' then
        return name
    end
    local toString = rawget(mt, '__tostring')
    if not toString then
        return nil
    end
    if level == 'onlylua' then
        if getinfo(toString, 'S').what == 'C' then
            return name
        end
    end
    local suc, str = pcall(toString, obj)
    if not suc then
        return nil
    end
    if type(str) ~= 'string' then
        return nil
    end
    if #str > 100 then
        str = str:sub(1, 100) .. '...(len=' .. #str .. ')'
    end
    return str
end

local function formatName(obj)
    local tp = type(obj)
    if tp == 'nil' then
        return 'nil:nil'
    elseif tp == 'boolean' then
        if obj == true then
            return 'boolean:true'
        else
            return 'boolean:false'
        end
    elseif tp == 'number' then
        if isInteger(obj) then
            return ('number:%d'):format(obj)
        else
            --If a floating point number can be fully represented as an integer, then it is converted to an integer
            local str = ('%.10f'):format(obj):gsub('%.?[0]+$', '')
            if str:find('.', 1, true) then
                --If a floating point number cannot be represented as an integer, then its exact representation is added
                str = ('%s(%q)'):format(str, obj)
            end
            return 'number:' .. str
        end
    elseif tp == 'string' then
        local str = ('%q'):format(obj)
        if #str > 100 then
            local new = ('%s...(len=%d)'):format(str:sub(1, 100), #str)
            if #new < #str then
                str = new
            end
        end
        return 'string:' .. str
    elseif tp == 'function' then
        local info = getinfo(obj, 'S')
        if info.what == 'C' then
            return formatObject(obj, 'function', '=[C]')
        elseif info.what == 'main' then
            return formatObject(obj, 'function', 'main')
        else
            return formatObject(obj, 'function', ('%s:%d-%d'):format(info.source, info.linedefined, info.lastlinedefined))
        end
    elseif tp == 'table' then
        local id = getTostring(obj, m._toStringTable)
                or rawget(obj, '__class__')
        if not id then
            if obj == _G then
                id = '_G'
            elseif obj == registry then
                id = 'registry'
            end
        end
        if id then
            return formatObject(obj, 'table', id)
        else
            return formatObject(obj, 'table')
        end
    elseif tp == 'userdata' then
        local id = getTostring(obj, m._toStringUserdata)
        if id then
            return formatObject(obj, 'userdata', id)
        else
            return formatObject(obj, 'userdata')
        end
    else
        return formatObject(obj, tp)
    end
end

---Take a memory snapshot to generate an internal data structure.
---Instead of using this API, use report or catch instead.
---@return table
m.snapshot = private(function ()
    if m._lastCache then
        return m._lastCache
    end

    local exclude = {}
    if m._exclude then
        for _, o in ipairs(m._exclude) do
            exclude[o] = true
        end
    end
    ---@generic T
    ---@param o T
    ---@return T
    local function private(o)
        if not o then
            return nil
        end
        exclude[o] = true
        return o
    end

    private(exclude)

    local find
    local mark = private {}

    local originFormatName = formatName
    local formatCache = private {}

    local function formatName(obj)
        if obj == nil then
            return originFormatName(obj)
        end
        if not formatCache[obj] then
            formatCache[obj] = originFormatName(obj)
        end
        return formatCache[obj]
    end

    local function isGCObject(v)
        local tp = type(v)
        return tp == 'table'
            or tp == 'userdata'
            or tp == 'function'
            or tp == 'thread'
    end

    local function findTable(t, result)
        result = result or {}
        local mt = getmetatable(t)
        local wk, wv
        if mt then
            local mode = rawget(mt, '__mode')
            if type(mode) == 'string' then
                if mode:find('k', 1, true) then
                    wk = true
                end
                if mode:find('v', 1, true) then
                    wv = true
                end
            end
        end
        for k, v in next, t do
            if not wk then
                local keyInfo = find(k)
                if keyInfo then
                    if wv and isGCObject(v) then
                        find(v)
                        local valueResults = mark[v]
                        if valueResults then
                            valueResults[#valueResults+1] = private {
                                type = 'weakvalue-key',
                                name = formatName(t) .. '|' .. formatName(v),
                                info = keyInfo,
                            }
                        end
                    else
                        result[#result+1] = private {
                            type = 'key',
                            name = formatName(k),
                            info = keyInfo,
                        }
                    end
                end
            end
            if not wv then
                local valueInfo = find(v)
                if valueInfo then
                    if wk and isGCObject(k) then
                        find(k)
                        local keyResults = mark[k]
                        if keyResults then
                            keyResults[#keyResults+1] = private {
                                type = 'weakkey-field',
                                name = formatName(t) .. '|' .. formatName(k),
                                info = valueInfo,
                            }
                        end
                    else
                        result[#result+1] = private {
                            type = 'field',
                            name = formatName(k) .. '|' .. formatName(v),
                            info = valueInfo,
                        }
                    end
                end
            end
        end
        local MTInfo = find(getmetatable(t))
        if MTInfo then
            result[#result+1] = private {
                type = 'metatable',
                name = formatName(getmetatable(t)),
                info = MTInfo,
            }
        end
        return result
    end

    local function findFunction(f, result)
        result = result or {}
        for i = 1, maxinterger do
            local n, v = getupvalue(f, i)
            if not n then
                break
            end
            local valueInfo = find(v)
            if valueInfo then
                result[#result+1] = private {
                    type = 'upvalue',
                    name = n,
                    info = valueInfo,
                }
            end
        end
        return result
    end

    local function findUserData(u, result)
        result = result or {}
        local maxUserValue = multiUserValue and maxinterger or 1
        for i = 1, maxUserValue do
            local v, b = getuservalue(u, i)
            if not b then
                break
            end
            local valueInfo = find(v)
            if valueInfo then
                result[#result+1] = private {
                    type = 'uservalue',
                    name = formatName(i),
                    info = valueInfo,
                }
            end
        end
        local MTInfo = find(getmetatable(u))
        if MTInfo then
            result[#result+1] = private {
                type = 'metatable',
                name = formatName(getmetatable(u)),
                info = MTInfo,
            }
        end
        if #result == 0 then
            return nil
        end
        return result
    end

    local function findThread(trd, result)
        --Do not look for the main thread, the main thread must be temporary (considered a weak reference)
        if m._ignoreMainThread and trd == registry[1] then
            return nil
        end
        result = result or private {}

        for i = 1, maxinterger do
            local info = getinfo(trd, i, 'Sf')
            if not info then
                break
            end
            local funcInfo = find(info.func)
            if funcInfo then
                for ln = 1, maxinterger do
                    local n, l = getlocal(trd, i, ln)
                    if not n then
                        break
                    end
                    local valueInfo = find(l)
                    if valueInfo then
                        funcInfo[#funcInfo+1] = private {
                            type = 'local',
                            name = n,
                            info = valueInfo,
                        }
                    end
                end
                result[#result+1] = private {
                    type = 'stack',
                    name = i .. '@' .. formatName(info.func),
                    info = funcInfo,
                }
            end
        end

        if #result == 0 then
            return nil
        end
        return result
    end

    local function findMainThread()
        --Do not look for the main thread, the main thread must be temporary (considered a weak reference)
        if m._ignoreMainThread then
            return nil
        end
        local result = private {}

        for i = 1, maxinterger do
            local info = getinfo(i, 'Sf')
            if not info then
                break
            end
            local funcInfo = find(info.func)
            if funcInfo then
                for ln = 1, maxinterger do
                    local n, l = getlocal(i, ln)
                    if not n then
                        break
                    end
                    local valueInfo = find(l)
                    if valueInfo then
                        funcInfo[#funcInfo+1] = private {
                            type = 'local',
                            name = n,
                            info = valueInfo,
                        }
                    end
                end
                result[#result+1] = private {
                    type = 'stack',
                    name = i .. '@' .. formatName(info.func),
                    info = funcInfo,
                }
            end
        end

        if #result == 0 then
            return nil
        end
        return result
    end

    local stringInfo = private {
        count = 0,
        totalSize = 0,
        largeStrings = private {},
    }

    function find(obj)
        if obj == nil then
            return nil
        end
        if mark[obj] then
            return mark[obj]
        end
        if exclude[obj] or _private[obj] then
            return nil
        end
        local tp = type(obj)
        if tp == 'table' then
            mark[obj] = private {}
            mark[obj] = findTable(obj, mark[obj])
        elseif tp == 'function' then
            mark[obj] = private {}
            mark[obj] = findFunction(obj, mark[obj])
        elseif tp == 'userdata' then
            mark[obj] = private {}
            mark[obj] = findUserData(obj, mark[obj])
        elseif tp == 'thread' then
            mark[obj] = private {}
            mark[obj] = findThread(obj, mark[obj])
        elseif tp == 'string' then
            stringInfo.count = stringInfo.count + 1
            stringInfo.totalSize = stringInfo.totalSize + #obj
            if #obj >= 10000 then
                stringInfo.largeStrings[#stringInfo.largeStrings+1] = obj
            end
        else
            return nil
        end
        if mark[obj] then
            mark[obj].object = obj
        end
        return mark[obj]
    end

    --TODO: In Lua 5.1, neither the main thread nor _G are in the registry
    local root = private {
        name = formatName(registry),
        type = 'root',
        info = find(registry),
    }
    if not registry[1] then
        root.info[#root.info+1] = private {
            type = 'thread',
            name = 'main',
            info = findMainThread(),
        }
    end
    if not registry[2] then
        root.info[#root.info+1] = private {
            type = '_G',
            name = '_G',
            info = find(_G),
        }
    end
    for name, mt in next, private {
        ['nil']       = getmetatable(nil),
        ['boolean']   = getmetatable(true),
        ['number']    = getmetatable(0),
        ['string']    = getmetatable(''),
        ['function']  = getmetatable(function () end),
        ['thread']    = getmetatable(ccreate(function () end)),
    } do
        root.info[#root.info+1] = private {
            type = 'metatable',
            name = name,
            info = find(mt),
        }
    end
    local result = {
        root = root,
        stringInfo = stringInfo,
    }
    if m._cache then
        m._lastCache = result
    end
    return result
end)

---Traverse the virtual machine, looking for references to objects.
---The input can be either an object entity or a description of the object (copied from the return value of another interface).
---Returns an array of arrays of strings, each describing how to refer from the root node to the specified object.
---Multiple objects can be found at the same time.
---@param ... any
---@return string[][]
m.catch = private(function (...)
    local targets = {}
    if not ... then
        error('No target specified')
    end
    if ... == '*' then
        setmetatable(targets, {
            __index = function (t, k)
                return type(k) == 'string'
            end,
            __newindex = function (t, k, v)
                if v == nil then
                    t[k] = false
                end
            end
        })
    else
        for i = 1, select('#', ...) do
            local target = select(i, ...)
            if target ~= nil then
                targets[target] = true
            end
        end
    end
    local report = m.snapshot()
    local path =   {}
    local result = {}
    local mark =   {}

    local function push()
        local resultPath = {}
        for i = 1, #path do
            resultPath[i] = path[i]
        end
        result[#result+1] = resultPath
    end

    local function search(t)
        path[#path+1] = ('(%s)%s'):format(t.type, t.name)
        local addTarget
        local point = getPoint(t.info.object)
        if targets[t.info.object] then
            targets[t.info.object] = nil
            addTarget = t.info.object
            push()
        end
        if targets[point] then
            targets[point] = nil
            addTarget = point
            push()
        end
        if not mark[t.info] then
            mark[t.info] = true
            for _, obj in ipairs(t.info) do
                search(obj)
            end
        end
        path[#path] = nil
        if addTarget then
            targets[addTarget] = true
        end
    end

    search(report.root)

    return result
end)

---@alias Doctor.Report { point: string, count: integer, name: string, childs: integer }
---@alias Doctor.StringInfo { count: integer, totalSize: integer, largeStrings: string[] }
---@alias Doctor.WeakTableInfo { totalSize: integer, tables: { name: string, point: string, size: integer }[]}
---@alias Doctor.GCTableInfo { tables: { name: string, point: string, gc: string }[] }

local function countTable(t)
    local n = 0
    for _ in next, t do
        n = n + 1
    end
    return n
end

---Generates a memory snapshot report.
---You should output it to a file and look at it again.
---@return {
---report: Doctor.Report[],
---stringInfo: Doctor.StringInfo,
---weakTableInfo: Doctor.WeakTableInfo,
---gcTableInfo: Doctor.GCTableInfo,
---}
m.report = private(function ()
    local snapshot = m.snapshot()
    local cache = {}
    local mark = {}
    local weakTableInfo = {
        totalSize = 0,
        tables = {},
    }
    local gcTableInfo = {
        tables = {},
    }

    local function scanRoot(t)
        local obj = t.info.object
        local tp = type(obj)
        if tp == 'table'
        or tp == 'userdata'
        or tp == 'function'
        or tp == 'string'
        or tp == 'thread' then
            local point = getPoint(obj)
            if not cache[point] then
                cache[point] = {
                    point  = point,
                    count  = 0,
                    name   = formatName(obj),
                    childs = #t.info,
                }
            end
            cache[point].count = cache[point].count + 1
        end
        if tp == 'table' then
            local mt = getmetatable(obj)
            if mt then
                if rawget(mt, '__mode') then
                    local n = countTable(obj)
                    weakTableInfo.totalSize = weakTableInfo.totalSize + n
                    weakTableInfo.tables[#weakTableInfo.tables+1] = {
                        name  = formatName(obj),
                        point = getPoint(obj),
                        size  = n,
                    }
                end
            end
        end
        if tp == 'table' or tp == 'userdata' then
            local mt = getmetatable(obj)
            if mt then
                local gc = rawget(mt, '__gc')
                if gc then
                    gcTableInfo.tables[#gcTableInfo.tables+1] = {
                        name  = formatName(obj),
                        point = getPoint(obj),
                        gc    = formatName(gc),
                    }
                end
            end
        end
        if not mark[t.info] then
            mark[t.info] = true
            for _, child in ipairs(t.info) do
                scanRoot(child)
            end
        end
    end

    scanRoot(snapshot.root)
    local list = {}
    for _, info in pairs(cache) do
        list[#list+1] = info
    end
    return {
        report = list,
        stringInfo = snapshot.stringInfo,
        weakTableInfo = weakTableInfo,
        gcTableInfo = gcTableInfo,
    }
end)

---Objects excluded during snapshot-related operations.
---You can use this feature to exclude some data tables.
m.exclude = private(function (...)
    m._exclude = {...}
end)

---Compare the two reports
---@param old table
---@param new table
---@return table
m.compare = private(function (old, new)
    local newHash = {}
    local ret = {}
    for _, info in ipairs(new.root) do
        newHash[info.point] = info
    end
    for _, info in ipairs(old.root) do
        if newHash[info.point] then
            ret[#ret + 1] = {
                old = info,
                new = newHash[info.point]
            }
        end
    end
    return ret
end)

---Whether to ignore the stack of the main thread
---@param flag boolean
m.ignoreMainThread = private(function (flag)
    m._ignoreMainThread = flag
end)

---Whether to tostring tables or userdata (call their __tostring metamethods)
---@param toStringTable Doctor.ToStringLevel
---@param toStringUserdata Doctor.ToStringLevel
m.toString = private(function (toStringTable, toStringUserdata)
    m._toStringTable = toStringTable
    m._toStringUserdata = toStringUserdata
end)

---If caching is enabled, the results of the first lookup will always be used.
---Suitable for continuous lookup references. If you want to find new references, you need to turn off the cache first.
---@param flag boolean
m.enableCache = private(function (flag)
    if flag then
        m._cache = true
    else
        m._cache = false
        m._lastCache = nil
    end
end)

---Clear cache now
m.flushCache = private(function ()
    m._lastCache = nil
end)

private(getinfo(1, 'f').func)

return m
