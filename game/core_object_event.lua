local event_configs = require 'clicli.meta.eventconfig'
local get_master    = require 'clicli.util.get_master'

---@class CoreObjectEvent
---@field private object_event_manager? EventManager
---@overload fun(): self
local M = Class 'CoreObjectEvent'

--Engine events for registered objects
---@param event_name string
---@param ... any
---@return Trigger
function M:event(event_name, ...)
    local config = event_configs.config[event_name]
    if config and config.from_global then
        return self:core_subscribe_from_global(event_name, ...)
    end
    if not rawget(self, 'object_event_manager') then
        self.object_event_manager = New 'EventManager' (self)
    end
    return self:core_subscribe(event_name, ...)
end

---@param self_type string
---@param config table
---@return boolean
local function is_valid_object(self_type, config)
    if config.object == self_type then
        return true
    end
    local extra_objs = config.extraObjs
    if not extra_objs then
        return false
    end
    for _, data in ipairs(extra_objs) do
        if data.luaType == self_type then
            return true
        end
    end
    return false
end

---@private
function M:core_subscribe(event_name, ...)
    local config = event_configs.config[event_name]
    local self_type = clicli.class.type(self)
    ---@diagnostic disable-next-line: undefined-field
    if not self.handle then
        error("Registered object event missing handle:" .. tostring(event_name))
    end
    if not config or not self_type then
        error('This event cannot be treated as an object event:' .. tostring(event_name))
    end
    if not config or not is_valid_object(self_type, config) then
        error('This event cannot be treated as an object event:' .. tostring(event_name))
    end

    local nargs = select('#', ...)
    local extra_args
    ---@type Trigger.CallBack
    local callback
    if nargs == 1 then
        callback = ...
    elseif nargs > 1 then
        extra_args = {...}
        callback = extra_args[nargs]
        extra_args[nargs] = nil
    else
        error('Missing callback function!')
    end

    if self_type == config.object then
        --Check to restore the object to the event parameters
        for i, param in ipairs(config.params) do
            if param.type == config.object then
                if not extra_args then
                    extra_args = {}
                end
                table.insert(extra_args, i, self)
                break
            end
        end
    end

    local args = {}
    for i, param in ipairs(config.params) do
        if not param.call then
            local val = extra_args[i]
            if param.resolve then
                val = param.resolve(extra_args[i])
            end
            table.insert(args, val)
        end
    end

    local trigger = self.object_event_manager:event(event_name, extra_args, callback)
    ---@diagnostic disable-next-line: undefined-field
    local seq = regist_object_event(self.handle, config.key, function (data)
        ---@diagnostic disable-next-line: invisible
        local lua_params = clicli.py_event_sub.convert_py_params(config.key, data, extra_args)
        trigger:execute(lua_params)
    end, table.unpack(args))

    local unsubscribe = function ()
        unregist_object_event(seq)
    end
    ---@diagnostic disable-next-line: invisible
    trigger:on_remove(unsubscribe)

    local gcHost = self --[[@as GCHost]]
    if gcHost.bindGC then
        gcHost:bindGC(trigger)
    end
    return trigger
end

---@private
function M:core_subscribe_from_global(event_name, ...)
    local params = { ... }
    local callback = table.remove(params)
    params[#params+1] = function (trigger, lua_params)
        local master = get_master(event_name, lua_params)
        if master == self then
            callback(trigger, lua_params)
        end
    end
    return clicli.game:event(event_name, table.unpack(params))
end
