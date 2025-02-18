local pairs = pairs
local tableInsert = table.insert
local tableSort = table.sort

---@class NPBehave.Tool.MethodDecorator
---@overload fun(): self
local MethodDecorator = Class 'NPBehave.Tool.MethodDecorator'

---@class NPBehave.Tool.BindCallback
---@overload fun(...) :any

---Functions are bound to objects
---@param func fun(...)
---@return NPBehave.Tool.BindCallback
function MethodDecorator:bind(func)
    if not self.funcBindCache then
        self.funcBindCache = {}
    end
    if not self.funcBindCache[func] then
        self.funcBindCache[func] = function(...) return func(self, ...) end
    end
    return self.funcBindCache[func]
end

---@class SortedDictionary - Sort dictionary. You can set key-value pairs by index, but you cannot get key-value pairs by index.
---@field dictionary table<any, any>
---@overload fun():SortedDictionary
SortedDictionary = Class("SortedDictionary")

--constructor
function SortedDictionary:__init()
    self.dictionary = {}
    return self
end

--Add or update key-value pairs
---@param key any
---@param value any
function SortedDictionary:add(key, value)
    self.dictionary[key] = value
end

--Remove a key-value pair
---@param key any
function SortedDictionary:remove(key)
    self.dictionary[key] = nil
end

--Fetch value
---@param key any
---@return any
function SortedDictionary:get(key)
    return self.dictionary[key]
end

--Check whether keys are included
---@param key any
---@return boolean
function SortedDictionary:containsKey(key)
    return self.dictionary[key] ~= nil
end

--Gets the sorted list of keys
function SortedDictionary:getSortedKeys()
    local keys = {}
    for key in pairs(self.dictionary) do
        tableInsert(keys, key)
    end
    tableSort(keys)
    return keys
end

--Gets ordered iterators
---@return fun():any, any
function SortedDictionary:SortedPairs()
    local sortedKeys = self:getSortedKeys()
    local i = 0
    local n = #sortedKeys
    return function()
        i = i + 1
        if i <= n then
            local key = sortedKeys[i]
            return key, self.dictionary[key]
        end
    end
end

function SortedDictionary:__newindex(key, value)
    --@ Stores key-value pairs in a dictionary
    if rawget(self, "dictionary") then
        rawset(self.dictionary, key, value)
    elseif key == "dictionary" then
        rawset(self, key, value)
    end
end
