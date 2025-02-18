---@class ECAHelper
local M = Class 'ECAHelper'

---Register ECA functions
---
---You can use this feature to have lua functions called in ECA.
---@param name string
---@return ECAFunction
function M.def(name)
    return New 'ECAFunction' (name)
end

---@private
M._call_impls = {}

M._resolves = {}

---Invoke custom events defined in the ECA
function M.call(...)
    local impl = M._call_impls[...]
    if not impl then
        error('This custom event does not exist:' .. tostring(...))
    end
    impl(...)
end

---@param data EventParam. Games - Messages
---@return table
function M.resolve(data)
    ---@diagnostic disable-next-line: undefined-field
    local name = data._extra_args and data._extra_args[1]
    local resolve = M._resolves[name]
    if not resolve then
        ---@diagnostic disable-next-line: inject-field
        data.name = tostring(name)
        ---@diagnostic disable-next-line: inject-field
        data.data = data.c_param_dict
        return data
    end
    return resolve(data)
end

---@private
---@param name string
---@param impl function
function M.register_custom_event_impl(name, impl)
    M._call_impls[name] = impl
end

---@private
function M.register_custom_event_resolve(name, resolve)
    M._resolves[name] = resolve
end

return M
