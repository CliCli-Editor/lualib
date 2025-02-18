--ground
--
--Ground collision correlation method
---@class Ground
local M = Class 'Ground'

---Set collision
---@param point Point Collision point
---@param is_collision_effect boolean Specifies whether the collision takes effect
---@param is_land_effect boolean Ground collision switch
---@param is_air_effect boolean Indicates the air collision switch
function M.set_collision(point, is_collision_effect, is_land_effect, is_air_effect)
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    GameAPI.set_point_collision(point.handle, is_collision_effect, is_land_effect, is_air_effect)
end

---Gets the collision type of the map at that point
---@param point Point Collision point
---@return integer
function M.get_collision(point)
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    return GameAPI.get_point_ground_collision(point.handle)
end

---Gets the view type of the map at that point
---@param point Point
---@return integer
function M.get_view_block_type(point)
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    return GameAPI.get_point_view_block_type(point.handle)
end

---Gets the hierarchy of the map's position at that point
---@param point Point
---@return integer level Indicates the level
function M.get_height_level(point)
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    return GameAPI.get_point_ground_height(point.handle):float() --[[@as integer]]
end

return M
