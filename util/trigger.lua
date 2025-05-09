local counter = clicli.util.counter()

--flip-flop
---@class Trigger
---@field private _event Event
---@field private _callback Trigger.CallBack
---@field private _event_args? any[]
---@field private _include_name? string | false
---@field private _on_remove? function
---@field private _disable_once? boolean
---@field event_manager EventManager?
---@overload fun(event: Event, event_args: any[], callback: Trigger.CallBack): self
local M = Class 'Trigger'

---@alias Trigger.CallBack fun(trg: Trigger, ...) : any, any, any, any


M.all_triggers = setmetatable({}, clicli.util.MODE_V)
M.uniques = setmetatable({}, clicli.util.MODE_V)

---@param event Event
---@param event_args? any[]
---@param callback Trigger.CallBack
---@return self
function M:__init(event, event_args, callback)
    self._event = event
    self._callback = callback
    self._id = counter()
    self._event_args = event_args
    self.event_arg_mode, self.event_arg_target = M.compute_event_args(event_args)
    event:add_trigger(self)
    M.all_triggers[self._id] = self
    return self
end

function M:__del()
    self._event:remove_trigger(self)
    if self._on_remove then
        self._on_remove()
    end
end

M.type = 'trigger'
---@private
M._enable = true
---@private
M._id = 0

function M:__tostring()
    return ('{trigger|%d}'):format(self._id)
end

function M:get_id()
    return self._id
end

--Disable trigger
function M:disable()
    self._enable = false
end

function M:enable()
    self._enable = true
end

---@return boolean
function M:is_enable()
    return self._enable
end

--Disable this trigger in this event
function M:disable_once()
    self._disable_once = true
    if self.event_manager then
        self.event_manager:disable_trigger_once(self)
    end
end

function M:recover_disable_once()
    self._disable_once = nil
end

---@type 'none' | 'custom' | 'array'
M.event_arg_mode = 'none'

---@type any
M.event_arg_target = nil

---@param event_args? any[]
---@return 'custom' | 'array' | 'none'
---@return any
function M.compute_event_args(event_args)
    if event_args == nil then
        return 'none', nil
    end
    if Type(event_args) then
        return 'custom', event_args
    end
    if type(event_args) == 'table' then
        if #event_args > 0 then
            return 'array', event_args[1]
        else
            return 'none', nil
        end
    else
        return 'custom', event_args
    end
end

--Check that the parameters of the event match the parameters of the trigger,
--The number of allowed event parameters exceeds the number of trigger parameters.
---@param fire_args any[]?
---@param fire_mode 'custom' | 'array' | 'none'
---@param fire_target any
---@return boolean
function M:is_match_args(fire_args, fire_mode, fire_target)
    local event_args   = self._event_args
    local event_mode   = self.event_arg_mode
    local event_target = self.event_arg_target

    if not fire_mode then
        fire_mode, fire_target = M.compute_event_args(fire_args)
    end

    if fire_mode ~= event_mode then
        return false
    end

    if fire_target ~= event_target then
        return false
    end

    --Finally, make a judgment on the assumption of an array
    local fire_args_n = fire_args and #fire_args or 0
    local event_args_n = event_args and #event_args or 0
    --The number of event parameters exceeds the number of trigger parameters. If the event parameter does not match, false is returned
    if fire_args_n < event_args_n then
        return false
    end
    --If any parameter matches, return true directly
    if event_args_n <= 0 then
        return true
    end
    --Since the trigger parameter is greater than 0 and the event parameter is greater than or equal to the trigger parameter,
    --Then none of them will be nil
    ---@cast event_args -nil
    ---@cast fire_args -nil
    for i = 2, event_args_n do
        local event_arg = event_args[i]
        local fire_arg = fire_args[i]
        if fire_arg ~= event_arg then
            return false
        end
    end
    return true
end

--Run the trigger to return up to 4 return values
---@param ... any
---@return any, any, any, any
function M:execute(...)
    if not IsValid(self) then
        return
    end
    if not self._enable
    or self._disable_once then
        return
    end
    local suc, a, b, c, d = xpcall(self._callback, log.error, self, ...)
    if suc then
        return a, b, c, d
    end
end

function M:remove()
    Delete(self)
end

---@return string?
function M:get_include_name()
    if not self._include_name then
        self._include_name = clicli.reload.getIncludeName(self._callback) or false
    end
    return self._include_name or nil
end

---@private
function M:on_remove(callback)
    self._on_remove = callback
end

--Add tag
---@param tag any
function M:add_tag(tag)
    if not self._tags then
        ---@private
        self._tags = {}
    end
    self._tags[tag] = true
end

--Label or not
---@param tag any
---@return boolean
function M:has_tag(tag)
    if not self._tags then
        return false
    end
    return self._tags[tag] ~= nil
end

--Remove tag
---@param tag any
function M:remove_tag(tag)
    if not self._tags then
        return
    end
    self._tags[tag] = nil
end

---@param name string
---@return Trigger
function M:unique(name)
    if M.uniques[name] then
        M.uniques[name]:remove()
    end
    M.uniques[name] = self
    return self
end

return M
