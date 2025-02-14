---@class Force
---@field handle integer
local M = Class 'Force'

M.type = 'force'

function M:__tostring()
    return string.format('{Force|%s}'
        , self.handle
    )
end

---@param handle integer
---@return self
function M:__init(handle)
    self.handle = handle
    return self
end

function M:__del()
    GameAPI.api_destroy_force(self.handle)
end

function M:remove()
    Delete(self)
end

---@class Force.Options
---@field target Unit | Point | number # The target of traction can be another unit, point, or Angle
---@field speed number # Traction speed
---@field max_speed? number # Maximum traction speed
---@field min_speed? number # Minimum traction speed
---@field accel? number # Traction acceleration

---@param unit Unit # The unit being pulled
---@param options Force.Options # Traction option
---@return Force
function M.create(unit, options)
    ---@diagnostic disable: param-type-mismatch
    local target = options.target
    if type(target) == 'number' then
        local handle = GameAPI.create_force_direction(unit.handle
            , Fix32(target)
            , Fix32(options.speed)
            , Fix32(options.max_speed or 10000)
            , Fix32(options.min_speed or 0)
            , Fix32(options.accel or 0)
        )
        return New 'Force' (handle)
    elseif Type(target) == 'Point' then
        ---@cast target Point
        local handle = GameAPI.create_force_point(unit.handle
            , target.handle
            , Fix32(options.speed)
            , Fix32(options.max_speed or 10000)
            , Fix32(options.min_speed or 0)
            , Fix32(options.accel or 0)
        )
        return New 'Force' (handle)
    elseif Type(target) == 'Unit' then
        ---@cast target Unit
        local handle = GameAPI.create_force_target(unit.handle
            , target.handle
            , Fix32(options.speed)
            , Fix32(options.max_speed or 10000)
            , Fix32(options.min_speed or 0)
            , Fix32(options.accel or 0)
        )
        return New 'Force' (handle)
    else
        error('牵引目标不正确：' .. tostring(target))
    end
    ---@diagnostic enable: param-type-mismatch
end

---@class Unit
local Unit = Class 'Unit'

---@param options Force.Options
---@return Force
function Unit:create_force(options)
    return M.create(self, options)
end
