--Particle effect
---@class Particle
---@field handle py.Sfx
---@overload fun(sfx:py.Sfx): self
local M = Class 'Particle'

M.type = 'particle'

function M:__tostring()
    return string.format('{Particle|%s}'
        , self.handle
    )
end

---@param sfx py.Sfx
---@return self
function M:__init(sfx)
    self.handle = sfx
    return self
end

function M:__del()
    GameAPI.delete_sfx(self.handle, nil, true)
end

---@param py_sfx py.Sfx
---@return Particle
function M.get_by_handle(py_sfx)
    local particle = New 'Particle' (py_sfx)
    return particle
end

clicli.py_converter.register_py_to_lua('py.Sfx', M.get_by_handle)
clicli.py_converter.register_lua_to_py('py.Sfx', function (lua_value)
    return lua_value.handle
end)

---@class Particle.Param.Screen
---@field type py.SfxKey Special effect id
---@field time number Duration
---@field target Player
---@field is_on_fog boolean Specifies whether it is above the fog

---Create screen effects
---@param data Particle.Param.Screen
---@return Particle
function M.create_screen(data)
    local py_player = data.target and data.target.handle
    local py_sfx = GameAPI.add_sfx_to_camera_with_return(data.type, data.time, py_player, data.is_on_fog)
    local ptc = New 'Particle' (py_sfx)
    return ptc
end

---@class Particle.Param.Create
---@field type py.SfxKey id of the special effect type
---@field target Point|Unit
---@field angle? number direction
---@field scale? number scaling
---@field time? number duration
---@field height? number height, valid only if 'target' is of type a point
---@field socket? string special effect hanging node, only valid if the type of 'target' is a unit
---@field follow_rotation? Integer | clicli. Const. SfxRotateType following unit rotating mode, only when ` target ` type of units available at the time
---@field follow_scale? boolean Whether to scale with units, valid only if the type of 'target' is units
---@field immediate? boolean Whether to remove the display effect immediately upon destruction
---@field detach? boolean Specifies whether to detach from units. Valid only if the type of 'target' is units

--Create effects to units or points
---@param data Particle.Param.Create
---@return Particle
function M.create(data)
    local target    = data.target
    local angle     = data.angle or 0.0
    local scale     = data.scale or 1.0
    local time      = data.time  or -1.0
    local immediate = data.immediate
    if target.type == 'unit' then
        ---@cast target Unit
        local socket          = data.socket or 'origin'
        local follow_rotation = data.follow_rotation
        local follow_scale    = data.follow_scale    and true or false
        local py_sfx = GameAPI.create_sfx_on_unit_new(
            data.type,
            target.handle,
            socket,
            clicli.const.SfxRotateType[follow_rotation] or follow_rotation or 0,
            follow_scale,
            scale,
            time,
            angle,
            immediate,
            immediate == nil,
            data.detach
        )
        local ptc = New 'Particle' (py_sfx)
        return ptc
    else
        ---@cast target Point
        local height = data.height or 0.0
        local py_sfx = GameAPI.create_sfx_on_point(
            data.type,
            --TODO see question 2
            ---@diagnostic disable-next-line: param-type-mismatch
            target.handle,
            angle,
            scale,
            height,
            time,
            immediate,
            immediate == nil
        )
        local ptc = New 'Particle' (py_sfx)
        return ptc
    end
end

---@return py.Sfx
function M:get_handle()
    return self.handle
end

--Deletion particle
function M:remove()
    Delete(self)
end

--Set rotation Angle
---@param x number X axis Angle
---@param y number Y-axis Angle
---@param z number Z-axis Angle
function M:set_rotate(x, y, z)
    GameAPI.set_sfx_rotate(self.handle, x, y, z)
end

--orientation
---@param direction number Indicates the direction
function M:set_facing(direction)
    GameAPI.set_sfx_angle(self.handle, direction)
end


--Set scale
---@param x number X axis scaling
---@param y number Scaling the Y-axis
---@param z number Z-axis scaling
function M:set_scale(x, y, z)
    GameAPI.set_sfx_scale(self.handle, x, y, z)
end

--Set height
---@param height number Height
function M:set_height(height)
    GameAPI.set_sfx_height(self.handle, height)
end

--Set coordinates
---@param point Point
function M:set_point(point)
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    GameAPI.set_sfx_position(self.handle, point.handle)
end

--Set animation speed
---@param speed number Speed
function M:set_animation_speed(speed)
    GameAPI.set_sfx_animation_speed(self.handle, speed)
end

--Set duration
---@param duration number Indicates the duration
function M:set_time(duration)
    GameAPI.set_sfx_duration(self.handle, duration)
end

--Set effects color
---@param x number # x
---@param y number # y
---@param z number # z
---@param w number # w
function M:set_color(x, y, z, w)
    GameAPI.set_sfx_color(self.handle, x, y, z, w)
end

--Set effects display
---@param visible boolean # Switch
function M:set_visible(visible)
    local role = GameAPI.get_client_role()
    GameAPI.enable_sfx_visible(self.handle, role, visible)
end

function M:get_type()
    return 16
end

return M
