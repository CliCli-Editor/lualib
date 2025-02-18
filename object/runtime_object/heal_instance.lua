--Treatment instance
--
--Transmission during treatment-related events
---@class HealInstance
---@overload fun(data: EventParam. Unit - After being healed, mode: string): self
local M = Class 'HealInstance'

---@param data EventParam. Unit - After receiving treatment
---@param mode 'before treatment' | 'during treatment' | 'after treatment'
function M:__init(data, mode)
    ---@private
    self.data = data
    ---@private
    self.mode = mode
end

--Acquire relevant skills
---@return Ability?
function M:get_ability()
    return self.data.ability
end

--Access to current treatment
---@return number
function M:get_heal()
    return self.data.cured_value
end

--Modify current treatment
---@param value number
function M:set_heal(value)
    assert(self.mode ~= 'post-treatment', 'Damage cannot be modified after healing')
    GameAPI.set_cur_cure_value(Fix32(value))
end
