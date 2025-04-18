local originRequire = require

--Hot heavy duty
--
--For methods related to hot reload, see 'demo/Hot Reload' for details.
---@class Reload
---@overload fun(optional? : Reload.Optional): self
local M = Class 'Reload'

---@private
---@type table<string, boolean>
M.includedNameMap = {}

---@private
---@type string[]
M.includedNames = {}

---@alias Reload.beforeReloadCallback fun(reload: Reload, willReload: boolean)

---@private
---@type {name? : string, callback: Reload.beforeReloadCallback}[]
M.beforeReloadCallbacks = {}

---@alias Reload.afterReloadCallback fun(reload: Reload, hasReloaded: boolean)

---@private
---@type {name? : string, callback: Reload.afterReloadCallback}[]
M.afterReloadCallbacks = {}

---@class Reload.Optional
---@field list? string[] -- List of modules to overload
---@field filter? fun(name: string, reload: Reload): boolean -- filter function

---@private
---@type Reload.Optional?
M.defaultReloadOptional = nil

---@param optional? Reload.Optional
function M:__init(optional)
    self.optional = optional

    ---@private
    ---@type table<string, any>
    self.validMap = optional and optional.list and clicli.util.revertMap(optional.list) --[[@as table<string, any>]]

    ---@private
    self.filter = self.optional and self.optional.filter
end

--Whether the module name will be overloaded
---@param name? string
---@return boolean
function M:isValidName(name)
    if not self.includedNameMap[name] then
        return false
    end
    if not self.validMap and not self.filter then
        return true
    end
    if self.validMap and self.validMap[name] then
        return true
    end
    if not self.filter then
        return false
    end
    local suc, result = xpcall(self.filter, log.error, name, self)
    if not suc then
        return false
    end
    return result
end

function M:fire()
    ---@private
    M._reloading = true
    log.info('=========== reload start ===========')

    local beforeReloadCallbacksNoReload = {}
    local afterReloadCallbacksNoReload  = {}

    for _, data in ipairs(M.beforeReloadCallbacks) do
        local willReload = self:isValidName(data.name)
        if not willReload then
            beforeReloadCallbacksNoReload[#beforeReloadCallbacksNoReload+1] = data
        end
        xpcall(data.callback, log.error, self, willReload)
    end

    for _, data in ipairs(M.afterReloadCallbacks) do
        local willReload = self:isValidName(data.name)
        if not willReload then
            afterReloadCallbacksNoReload[#afterReloadCallbacksNoReload+1] = data
        end
    end

    M.beforeReloadCallbacks = beforeReloadCallbacksNoReload
    M.afterReloadCallbacks  = afterReloadCallbacksNoReload

    local needReload = {}
    for _, name in ipairs(M.includedNames) do
        if self:isValidName(name) then
            needReload[#needReload+1] = name
        end
    end

    for _, name in ipairs(needReload) do
        package.loaded[name] = nil
    end

    for _, name in ipairs(needReload) do
        M.include(name)
    end

    for _, data in ipairs(M.afterReloadCallbacks) do
        xpcall(data.callback, log.error, self, self:isValidName(data.name))
    end
    log.info('=========== reload finish ===========')
    M._reloading = false
end

---@private
M.modNameMap = {}

---@private
M.includeStack = {}

--Similar to 'require', but reloads the file on reload.
--An error while loading a file returns false instead of throwing an exception.
---@param modname string
---@return any
---@return unknown loaderdata
function M.include(modname)
    if not M.includedNameMap[modname] then
        M.includedNameMap[modname] = true
        M.includedNames[#M.includedNames+1] = modname
    end
    M.includeStack[#M.includeStack+1] = modname
    local suc, result, loaderdata = xpcall(originRequire, log.error, modname)
    M.includeStack[#M.includeStack] = nil
    if not suc then
        return false, nil
    end
    if loaderdata ~= nil then
        M.modNameMap[loaderdata] = modname
    end
    return result, loaderdata
end

---@param modname string
---@return unknown
---@return unknown loaderdata
function require(modname)
    if package.loaded[modname] ~= nil then
        return package.loaded[modname], nil
    end
    M.includeStack[#M.includeStack+1] = false
    local _ <close> = clicli.util.defer(function ()
        M.includeStack[#M.includeStack] = nil
    end)
    local result, loaderdata = originRequire(modname)
    if loaderdata ~= nil then
        M.modNameMap[loaderdata] = modname
    end
    return result, loaderdata
end

---@param func function
---@return string?
function M.getIncludeName(func)
    if not debug or not debug.getinfo then
        return nil
    end
    local info = debug.getinfo(func, 'S')
    local source = info.source
    if source:sub(1, 1) ~= '@' then
        return nil
    end
    local path = source:sub(2)
    local modName = M.modNameMap[path]
    if not M.includedNameMap[modName] then
        return nil
    end
    return modName
end

---@return string?
function M.getCurrentIncludeName()
    return M.includeStack[#M.includeStack] or nil
end

--Set default overload options
---@param optional? Reload.Optional
function M.setDefaultOptional(optional)
    M.defaultReloadOptional = optional
end

--overload
---@param optional? Reload.Optional
function M.reload(optional)
    optional = optional or M.defaultReloadOptional
    local reload = New 'Reload' (optional)
    reload:fire()
end

---Is loading
---@return boolean
function M.isReloading()
    return M._reloading == true
end

--Register callbacks before reloading
---@param callback Reload.beforeReloadCallback
function M.onBeforeReload(callback)
    M.beforeReloadCallbacks[#M.beforeReloadCallbacks+1] = {
        name     = M.getCurrentIncludeName(),
        callback = callback,
    }
end

--Register callbacks after reloading
---@param callback Reload.afterReloadCallback
function M.onAfterReload(callback)
    M.afterReloadCallbacks[#M.afterReloadCallbacks+1] = {
        name     = M.getCurrentIncludeName(),
        callback = callback,
    }
end

--Execute the callback function immediately, and then whenever overloading occurs,
--The callback is executed again.
---@generic R1, R2
---@param callback fun(trash: fun(obj: R2): R2): R1?
---@return R1
function M.recycle(callback)
    local trashList = {}
    local function trash(obj)
        trashList[#trashList+1] = obj
        return obj
    end
    M.onBeforeReload(function ()
        for _, obj in ipairs(trashList) do
            Delete(obj)
        end
        trashList = {}
    end)
    M.onAfterReload(function ()
        callback(trash)
    end)
    return callback(trash)
end

return M
