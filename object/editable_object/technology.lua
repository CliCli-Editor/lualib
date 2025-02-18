--Science and technology
---@class Technology
local M = Class 'Technology'

---Check the technology type preconditions
---@param player Player
---@param tech_key py.TechKey Skill type id (Object id)
---@return boolean is_meet Whether the preconditions for the skill type are met
function M.check_precondition_by_key(player, tech_key)
    return GameAPI.check_tech_key_precondition(player.handle, tech_key)
end

return M
