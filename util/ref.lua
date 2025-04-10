--[[
Maintains the life state of engine objects
The current strategy is as follows：

1. The first time an engine object enters Lua, it generates the corresponding Lua object and adds a reinforced reference
2. After the engine object is reclaimed by the engine, the Lua object is changed from a strong reference to a weak reference
--]]

---@class Ref
---@overload fun(className: string, new: (fun(key: Ref.ValidKeyType, ...) : any)): self
local M = Class 'Ref'

---@alias Ref.ValidKeyType any

---@type table<string, Ref>
M.all_managers = {}

---@generic T: string
---@param className `T`
---@param new fun(key: Ref.ValidKeyType, ...) : T
function M:__init(className, new)
    --The name of the object class used for management
    ---@private
    self.className = className
    --A method to create a new object
    ---@private
    self.newMethod = new
    --Strong reference
    ---@private
    self.strongRefMap = {}
    --Weak reference
    ---@private
    self.weakRefMap = setmetatable({}, clicli.util.MODE_K)

    M.all_managers[className] = self
end

---Gets the object for which the key is specified, if it does not exist, created with all the parameters and returned
---@param key Ref.ValidKeyType
---@param ... any
---@return any
function M:get(key, ...)
    if not key then
        return nil
    end
    local obj = self:fetch(key)
    if obj then
        return obj
    end
    obj = self.newMethod(key, ...)
    if not obj then
        return nil
    end
    self.strongRefMap[key] = obj
    self.weakRefMap[obj] = nil
    return obj
end

---Get specified key
---@param key Ref.ValidKeyType
---@return any
function M:fetch(key)
    local strongRefMap = self.strongRefMap
    if strongRefMap[key] then
        return strongRefMap[key]
    end
    return nil
end

local doNothing = function () end
local dummyHandle = setmetatable({}, {
    __index = function (t, k)
        return doNothing
    end,
    __tostring = function (t)
        return '<DUMMY_HANDLE>'
    end
})

---Remove the specified key immediately
function M:removeNow(key)
    local obj = self.strongRefMap[key]
    if not obj then
        return
    end
    obj._removed_by_py = true
    obj.handle = dummyHandle
    Delete(obj)
    self.strongRefMap[key] = nil
    self.weakRefMap[obj] = true
end

local logicEntityModuleMap = {
    [2] = 'Unit',
    [3] = 'Projectile',
    [4] = 'Item',
    [5] = 'Destructible',
    [7] = 'Ability',
    [8] = 'Buff',
    [9] = 'Area',
}

---This method is used to notify the Lua layer synchronously when the black box destroys a logical entity
---@param entity_module integer
---@param entity_uid integer
---@param is_return_to_pool boolean
_G['notify_entity_destroyed'] = function (entity_module, entity_uid, is_return_to_pool)
    local manager = M.all_managers[logicEntityModuleMap[entity_module]]
    if not manager then
        return
    end
    if entity_module == 2 and clicli.config.ref.clear_ref_when_unit_return_to_pool and is_return_to_pool then
        local unit = manager:fetch(entity_uid)
        if unit then
            local modifier_manager = M.all_managers["Buff"]
            if modifier_manager then
                for _, uid in pairs(unit.handle:api_get_all_modifier_ids()) do
                    modifier_manager:removeNow(uid);
                end
            end
            
            local ability_manager = M.all_managers["Ability"]
            if ability_manager then
                for _, uid in pairs(unit.handle:api_get_all_ability_id()) do
                    ability_manager:removeNow(uid);
                end
            end
        end
    end
    manager:removeNow(entity_uid)
end

return M
