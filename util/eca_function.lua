---@class ECABind
Bind = {}

--Register ECA functions
--
--You can use this feature to have lua functions called in ECA.
---@class ECAFunction
---@field call_name string
---@field params {key: string, type: string, optional? : boolean}[]
---@field returns {key: string, type: string}[]
---@field func function
---@overload fun(name: string): self
local M = Class 'ECAFunction'

function M:__tostring()
    return string.format('{ECAFunction|%s}'
        , self.call_name
    )
end

---@private
---@param error_handler fun(...)
---@param ... any
---@return ...
function M:_unpack_params(error_handler, ...)
    local param_list = {...}
    for i, param in ipairs(self.params) do
        local py_value = param_list[i]
        if py_value == nil and not param.optional then
            error(('The %d parameter %s is null!'):format(i, param.key))
        end
        local ok, lua_value = xpcall(clicli.py_converter.py_to_lua, function (...)
            error_handler('# [' .. i .. '【 parameter 】' .. param.key .. '【 Conversion failure: \n', ...)
        end, param.type, py_value)
        if not ok then
            return
        end
        param_list[i] = lua_value
    end
    return table.unpack(param_list, 1, #self.params)
end

---@private
---@param error_handler fun(...)
---@param ok boolean
---@param ... any
---@return ...
function M:_pack_returns(error_handler, ok, ...)
    if not ok then
        return nil
    end
    if #self.returns == 0 then
        return nil
    end
    local ok2, ret_value = xpcall(clicli.py_converter.lua_to_py, error_handler, self.returns[1].type, ...)
    if not ok2 then
        return nil
    end
    return ret_value
end

---@param name string
---@return self
function M:__init(name)
    self.call_name  = name
    self.params     = {}
    self.returns    = {}
    return self
end

--Add parameter
---@param key string
---@param type_name string
---@return self
function M:with_param(key, type_name)
    local optional
    if type_name:sub(-1) == '?' then
        optional = true
        type_name = type_name:sub(1, -2)
    end
    table.insert(self.params, {
        key  = key,
        type = clicli.py_converter.get_py_type(type_name),
        optional = optional,
    })
    return self
end

--Add return value
---@param key string
---@param type_name string
---@return self
function M:with_return(key, type_name)
    table.insert(self.returns, {
        key  = key,
        type = clicli.py_converter.get_py_type(type_name),
    })
    return self
end

--Executed function
---@param func function
function M:call(func)
    if Bind[self.call_name] and not clicli.reload.isReloading() then
        error(('Binding functions cannot be defined repeatedly: %s'):format(self.call_name))
    end
    self.func = func
    local function error_handler(...)
        log.error('At [' .. self.call_name .. 'An error occurred in: \n', ...)
    end
    Bind[self.call_name] = function (...)
        return self:_pack_returns(error_handler, xpcall(self.func, error_handler, self:_unpack_params(error_handler, ...)))
    end
end

return M
