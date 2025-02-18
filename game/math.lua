--Use trigonometric functions based on angles
local deg = math.deg(1)
local rad = math.rad(1)

--Mathematical library
--
--All use Angle system
---@class Math
local M = Class 'Math'

---Get random Angle
---@return number
function M.get_random_angle()
    return GameAPI.get_random_angle():float()
end

---Random real numbers in the range
---@param min number The minimum real number in the range
---@param max number Maximum real number in the range
---@return number float A random real number
function M.random_float(min, max)
    return GameAPI.get_random_fixed(Fix32(min), Fix32(max)):float()
end

---sine
---@param value number Real number
---@return number float Real number
function M.sin(value)
    return math.sin(value * rad)
end

---cosine
---@param value number Real number
---@return number float Real number
function M.cos(value)
    return math.cos(value * rad)
end

---tangent
---@param value number Real number
---@return number float Real number
function M.tan(value)
    return math.tan(value * rad)
end

---arcsine
---@param value number Real number
---@return number float Real number
function M.asin(value)
    return math.asin(value) * deg
end

---Inverse cosine
---@param value number Real number
---@return number float Real number
function M.acos(value)
    return math.acos(value) * deg
end

---Inverse tangent
---@param y number
---@param x number
---@return number float Real number
function M.atan(y, x)
    return math.atan(y, x) * deg
end

--Calculate the Angle between 2 angles (Angle system)
---@param r1 number
---@param r2 number
---@return number angle The value range is [0, 180]
---@return number direction Indicates the direction. 1 indicates the clockwise direction and -1 indicates the counterclockwise direction
function M.includedAngle(r1, r2)
    local r = (r1 - r2) % 360
    if r >= 180 then
        return 360 - r, 1
    else
        return r, -1
    end
end

--Check whether the number is in the [min, max] range
---@param number number
---@param min number
---@param max number
---@return boolean
function M.isBetween(number, min, max)
    return number >= min and number <= max
end

---Get random seeds
---@return integer seed Indicates the random seed
function M.get_random_seed()
    return GameAPI.get_random_seed()
end

return M
