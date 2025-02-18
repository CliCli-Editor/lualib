--Injury instance
--
--Will be transmitted during injury-related events
---@class DamageInstance
---@overload fun(data: EventParam. Unit - After taking damage, mode: string): self
local M = Class 'DamageInstance'

---@param data EventParam. Unit - After taking damage
---@param mode 'before damage' | 'when damage' | 'after damage'
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

--Get current damage
---@return number
function M:get_damage()
    return self.data.damage
end

--Modify current damage
---@param damage number
function M:set_damage(damage)
    assert(self.mode ~= 'After damage', 'Damage cannot be modified after damage is done')
    if not self.origin_damage then
        self.origin_damage = self.data.damage --Record the original damage
    end
    self.data.damage = damage --Brush away damage, and subsequent events take the same amount of damage
    GameAPI.set_cur_damage(Fix32(damage))
end

--Gets whether the current damage is evaded
---@return boolean
function M:is_missed()
    local damage_state = self.data['_py_params']['__damage_result_state']
    return GameAPI.get_cur_damage_is_miss(damage_state)
end

--Sets whether to dodge the current damage
---@param missed boolean
function M:set_missed(missed)
    assert(self.mode == 'pre-damage', 'Damage dodge can only be modified before damage is done')
    GameAPI.set_cur_damage_is_miss(missed)
end

--Gets whether the current damage is critical
---@return boolean
function M:is_critical()
    local damage_state = self.data['_py_params']['__damage_result_state']
    return GameAPI.get_cur_damage_is_critical(damage_state)
end

--Sets whether the current damage is critical
---@param critical boolean
function M:set_critical(critical)
    assert(self.mode ~= 'After damage', 'Damage Critical can only be changed before (or when) damage is done')
    GameAPI.set_cur_damage_is_critical(critical)
end

function M:get_attack_type()
    return self.data['_py_params']['__attack_type']
end

function M:get_damage_type()
    return self.data["_py_params"]["__damage_type"]
end