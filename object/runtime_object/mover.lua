---@class Mover
---@field handle py.Mover
---@overload fun(handle: py.Mover): self
local M = Class 'Mover'

---@class Mover: Storage
Extends('Mover', 'Storage')
---@class Mover: GCHost
Extends('Mover', 'GCHost')

---@param handle py.Mover
---@return Mover
function M:__init(handle)
    self.handle = handle
    return self
end

function M:__del()
    GameAPI.remove_mover(self.handle)
end

---@param py_mover py.Mover
---@return Mover
function M.get_by_handle(py_mover)
    return New 'Mover' (py_mover)
end

clicli.py_converter.register_py_to_lua('py.Mover', M.get_by_handle)
clicli.py_converter.register_lua_to_py('py.Mover', function (lua_value)
    return lua_value.handle
end)

---@class Mover.CreateData.Base
---@field on_hit? fun(self: Mover, unit: Unit) # Collision unit callback
---@field on_block? fun(self: Mover) # Collision terrain callback
---@field on_finish? fun(self: Mover) # End of motion callback
---@field on_break? fun(self: Mover) # Motion interrupt callback
---@field on_remove? fun(self: Mover) # Motion remove callback
---@field hit_type? integer # Collision type 0: enemy; 1: Allies; 2: All
---@field hit_radius? number # Collision range
---@field hit_same? boolean # Whether to repeatedly collide with the same unit
---@field hit_interval? number # Collision with the same unit interval
---@field terrain_block? boolean # Whether it will be blocked by terrain
---@field block_interval? number # The interval at which a terrain blocking event is triggered
---@field priority? integer # priority
---@field absolute_height? boolean # Whether absolute height is used
---@field face_angle? boolean # Whether to always face the direction of motion
---@field ability? Ability # Relevance skill
---@field unit? Unit # Associated unit
---@field auto_pitch? boolean # Whether to automatically adjust the pitch Angle. The default value is true

---@class Mover.CreateData.Line: Mover.CreateData.Base
---@field angle number # Direction of motion
---@field distance number # Motion distance
---@field speed number # Initial velocity
---@field acceleration? number # acceleration
---@field max_speed? number # Maximum speed
---@field min_speed? number # Minimum speed
---@field init_height? number # Initial altitude
---@field fin_height? number # Terminal height
---@field parabola_height? number # Height of the vertex of the parabola

---@class Mover.CreateData.Target: Mover.CreateData.Base
---@field target Unit|Destructible|Item # Tracking target
---@field speed number # Initial velocity
---@field target_distance number # The distance to the target
---@field acceleration? number # acceleration
---@field max_speed? number # Maximum speed
---@field min_speed? number # Minimum speed
---@field height? number # Initial altitude
---@field parabola_height? number # Height of the vertex of the parabola
---@field bind_point? string # Binding point
---@field init_angle? number # Initial Angle
---@field rotate_time? number # Transition time
---@field missing_distance? number # Target lost distance
---@field miss_when_target_destroy? boolean # Lost target when target is destroyed
---@field on_miss? fun(self: Mover) # Callback when target is lost
---@field init_max_rotate_angle? number # Initial Angular Velocity

---@class Mover.CreateData.Curve: Mover.CreateData.Base
---@field angle number # Direction of motion
---@field distance number # Motion distance
---@field speed number # Initial velocity
---@field path (Point|py.FixedVec2)[] # waypoint
---@field acceleration? number # acceleration
---@field max_speed? number # Maximum speed
---@field min_speed? number # Minimum speed
---@field init_height? number # Initial altitude
---@field fin_height? number # Terminal height

---@class Mover.CreateData.Round: Mover.CreateData.Base
---@field target Unit|Point # Circling target
---@field radius? number # Circumferential radius
---@field angle_speed? number # Circling velocity
---@field init_angle? number # Initial Angle
---@field clock_wise? boolean # Clockwise or not
---@field round_time? number # Circling time
---@field radius_speed? number # Velocity of radius change
---@field lifting_speed? number # Lifting speed
---@field height? number # Circling height
---@field target_point? Point # Target point

---@private
---@param mover_data Mover.CreateData.Base
---@return fun(mover: Mover) # update mover
---@return fun()? # on_hit
---@return fun()? # on_block
---@return fun()? # on_finish
---@return fun()? # on_break
---@return fun()  # on_remove
---@return fun()? # on_miss
function M.wrap_callbacks(mover_data)
    ---@type Mover
    local mover

    ---@param m Mover
    local function update_mover(m)
        mover = m
    end

    ---@type fun(mover: py.Mover, unit: py.Unit)?
    local on_hit
    if mover_data.on_hit then
        on_hit = function ()
            local py_unit = GameAPI.get_mover_collide_unit()
            local unit = clicli.unit.get_by_handle(py_unit)
            xpcall(mover_data.on_hit, log.error, mover, unit)
        end
    end

    ---@type fun(mover: py.Mover)?
    local on_block
    if mover_data.on_block then
        on_block = function ()
            xpcall(mover_data.on_block, log.error, mover)
        end
    end

    ---@type fun(mover: py.Mover)?
    local on_finish
    if mover_data.on_finish then
        on_finish = function ()
            xpcall(mover_data.on_finish, log.error, mover)
        end
    end

    ---@type fun(mover: py.Mover)?
    local on_break
    if mover_data.on_break then
        on_break = function ()
            xpcall(mover_data.on_break, log.error, mover)
        end
    end

    --TODO currently has no global event for motion removal, so it destructs itself in each motion's removal callback
    ---@type fun(mover: py.Mover)
    local on_remove = function ()
        Delete(mover)
        if mover_data.on_remove then
            xpcall(mover_data.on_remove, log.error, mover)
        end
    end

    ---@cast mover_data Mover.CreateData.Target
    local on_miss
    if mover_data.on_miss then
        ---@type fun(mover: py.Mover)
        local miss_func = mover_data.on_miss
        on_miss = function (_)
            xpcall(miss_func, log.error, mover)
        end
    end

    return update_mover, on_hit, on_block, on_finish, on_break, on_remove, on_miss
end

---@private
---@param mover_data Mover.CreateData.Base
---@return fun(mover: Mover) # update mover
function M.wrap_internal_callbacks(mover_data)
    ---@type Mover
    local mover

    ---@param m Mover
    local function update_mover(m)
        mover = m
    end

    ---@type fun(mover: py.Mover, unit: py.Unit?) ?
    if mover_data.on_hit then
        ---@type fun(mover: py.Mover, unit: py.Unit?)
        local hit_func = mover_data.on_hit
        ---@param unit_id integer
        mover_data.on_hit = function (unit_id)
            --local py_unit = GameAPI.get_mover_collide_unit()
            local unit = clicli.unit.get_by_id(unit_id)
            xpcall(hit_func, log.error, mover, unit)
        end
    end

    if mover_data.on_block then
        ---@type fun(mover: py.Mover)
        local block_func = mover_data.on_block
        mover_data.on_block = function ()
            xpcall(block_func, log.error, mover)
        end
    end

    if mover_data.on_finish then
        ---@type fun(mover: py.Mover)
        local finish_func = mover_data.on_finish
        mover_data.on_finish = function ()
            xpcall(finish_func, log.error, mover)
        end
    end

    if mover_data.on_break then
        ---@type fun(mover: py.Mover)
        local break_func = mover_data.on_break
        mover_data.on_break = function ()
            xpcall(break_func, log.error, mover)
        end
    end

    --TODO currently has no global event for motion removal, so it destructs itself in each motion's removal callback

    ---@type fun(mover: py.Mover)
    local remove_func = mover_data.on_remove
    mover_data.on_remove = function ()
        Delete(mover)
        if remove_func then
            xpcall(remove_func, log.error, mover)
        end
    end

    ---@cast mover_data Mover.CreateData.Target
    if mover_data.on_miss then
        ---@type fun(mover: py.Mover)
        local miss_func = mover_data.on_miss
        mover_data.on_miss = function ()
            --local py_unit = GameAPI.get_mover_collide_unit()
            xpcall(miss_func, log.error, mover)
        end
    end

    return update_mover
end

---@private
---@param builder py.MoverBaseBuilder
---@param args Mover.CreateData.Base
function M.wrap_base_args(builder, args)
    builder.set_collision_type          (args.hit_type or 0)
    builder.set_collision_radius        (Fix32(args.hit_radius or 0.0))
    builder.set_is_face_angle           (args.face_angle or false)
    builder.set_is_multi_collision      (args.hit_same or false)
    builder.set_unit_collide_interval   (Fix32(args.hit_interval or 0.0))
    builder.set_terrain_block           (args.terrain_block or false)
    builder.set_terrain_collide_interval(Fix32(args.block_interval or 0.0))
    builder.set_priority                (args.priority or 1)
    builder.set_is_absolute_height      (args.absolute_height or false)
    builder.dict['is_open_auto_pitch']  = clicli.util.default(args.auto_pitch, true)
    --builder.set_related_unit            (args.unit and args.unit.handle or nil)
    --builder.set_related_ability         (args.ability and args.ability.handle or nil)
end

---@private
---@param args Mover.CreateData.Line
---@return table
function M.wrap_line_args(args)
    local builder = StraightMoverArgs()
    M.wrap_base_args(builder, args)
    builder.set_angle              (Fix32(args.angle))
    builder.set_max_dist           (Fix32(args.distance))
    builder.set_init_velocity      (Fix32(args.speed))
    builder.set_acceleration       (Fix32(args.acceleration or 0.0))
    builder.set_max_velocity       (Fix32(args.max_speed or 99999.0))
    builder.set_min_velocity       (Fix32(args.min_speed or 0.0))
    builder.set_init_height        (Fix32(args.init_height or 0.0))
    builder.set_fin_height         (Fix32(args.fin_height or 0.0))
    builder.set_parabola_height    (Fix32(args.parabola_height or 0.0))
    builder.set_is_parabola_height (args.parabola_height ~= nil)
    builder.set_is_open_init_height(args.init_height ~= nil)
    builder.set_is_open_fin_height (args.fin_height ~= nil)

    return builder
end

---@private
---@param args Mover.CreateData.Target
---@return table
function M.wrap_target_args(args)
    local builder = ChasingMoverArgs()
    M.wrap_base_args(builder, args)
    builder.set_stop_distance_to_target(Fix32(args.target_distance or 0.0))
    builder.set_init_velocity          (Fix32(args.speed))
    builder.set_acceleration           (Fix32(args.acceleration or 0.0))
    builder.set_max_velocity           (Fix32(args.max_speed or 99999.0))
    builder.set_min_velocity           (Fix32(args.min_speed or 0.0))
    builder.set_init_height            (Fix32(args.height or 0.0))
    builder.set_bind_point             (args.bind_point or '')
    builder.set_is_open_init_height    (args.height ~= nil)
    builder.set_is_parabola_height     (args.parabola_height ~= nil)
    builder.set_parabola_height        (Fix32(args.parabola_height or 0.0))
    builder.set_is_open_bind_point     (args.bind_point ~= nil)
    builder.set_target_unit_id         (args.target:get_id())
    builder.dict['init_angle']         = (Fix32(args.init_angle or 0.0))
    builder.dict['rotate_time']        = (Fix32(args.rotate_time or 0.0))
    builder.dict['is_open_init_angle'] = (args.init_angle ~= nil)
    builder.dict["target_miss_distance"] = (Fix32(args.missing_distance or 99999999))
    builder.dict["target_miss_when_target_destroy"] =  clicli.util.default(args.miss_when_target_destroy, false)
    builder.dict["target_miss_event"] = args.on_miss
    builder.dict["init_max_rotate_angle"] = (Fix32(args.init_max_rotate_angle or 180.0))
    return builder
end

---@private
---@param args Mover.CreateData.Curve
---@return table
function M.wrap_curve_args(args)
    ---@param lua_object Point | py.FixedVec2
    ---@return py.FixedVec2
    ---@type py.CurvedPath
    local path = clicli.helper.pack_list(args.path, function (lua_object)
        if type(lua_object) == 'userdata' then
            return lua_object
        end
        ---@cast lua_object Point
        return Fix32Vec2(lua_object:get_x(), lua_object:get_y())
    end)

    local builder = CurvedMoverArgs()
    M.wrap_base_args(builder, args)
    builder.set_angle              (Fix32(args.angle))
    builder.set_max_dist           (Fix32(args.distance))
    builder.set_init_velocity      (Fix32(args.speed))
    builder.set_acceleration       (Fix32(args.acceleration or 0.0))
    builder.set_path               (path)
    builder.set_max_velocity       (Fix32(args.max_speed or 99999.0))
    builder.set_min_velocity       (Fix32(args.min_speed or 0.0))
    builder.set_init_height        (Fix32(args.init_height or 0.0))
    builder.set_fin_height         (Fix32(args.fin_height or 0.0))
    if builder.set_is_open_init_height then
        builder.set_is_open_init_height(args.init_height ~= nil)
    end
    if builder.set_is_open_fin_height then
        builder.set_is_open_fin_height(args.fin_height ~= nil)
    end
    return builder
end

---@private
---@param args Mover.CreateData.Round
---@return table
function M.wrap_round_args(args)
    local target = args.target
    local builder = RoundMoverArgs()
    M.wrap_base_args(builder, args)
    if target.type == 'unit' then
        ---@cast target Unit
        builder.set_is_to_unit(true)
        builder.set_target_unit_id(target:get_id())
    else
        ---@cast target Point
        builder.set_is_to_unit(false)
        --TODO see question 2
        ---@diagnostic disable-next-line: param-type-mismatch
        local x, y = target:get_x(), target:get_y()
        builder.set_target_pos(Fix32Vec2(x / 100.0, y / 100.0))
    end
    builder.set_circle_radius          (Fix32(args.radius or 0.0))
    builder.set_angle_velocity         (Fix32(args.angle_speed or 0.0))
    builder.set_init_angle             (Fix32(args.init_angle or 0.0))
    builder.set_counterclockwise       (args.clock_wise == false and 1 or 0)
    builder.set_round_time             (Fix32(args.round_time or 0))
    builder.set_centrifugal_velocity   (Fix32(args.radius_speed or 0.0))
    builder.set_lifting_velocity       (Fix32(args.lifting_speed or 0.0))
    --hack
    --It's amazing that I could find out 🐮🍺🌶
    builder.dict['init_height']        = (Fix32(args.height or 0.0))
    builder.dict['is_open_bind_point'] = (args.height ~= nil)

    return builder
end

---@private
---@param mover_data Mover.CreateData.Base
function M:init(mover_data)
    if mover_data.ability then
        GameAPI.set_mover_relate_ability(self.handle, mover_data.ability.handle)
    end
end

--interrupter
function M:stop()
    GameAPI.break_mover(self.handle)
end

--Removal motor
function M:remove()
    Delete(self)
end

local DUMMY_FUNCTION = function() end

---@param mover_unit Unit|Projectile
---@param mover_data Mover.CreateData.Line
---@return Mover
function M.mover_line(mover_unit, mover_data)
    assert(mover_data.speed,    'Missing field: speed')
    assert(mover_data.angle,    'Missing field: angle')
    assert(mover_data.distance, 'Missing field: distance')
    if clicli.config.mover.enable_internal_regist then
        --todo complete the meta for CreateMoverComponent and MoverSystem
        local update_mover = M.wrap_internal_callbacks(mover_data)
        local comp = CreateMoverComponent.create_line_mover(mover_data)
        local py_mover = MoverSystem():create_mover(mover_unit.handle, comp)
        local mover = M.get_by_handle(py_mover)
        update_mover(mover)
        return mover
    else
        local update_mover, on_hit, on_block, on_finish, on_break, on_remove = M.wrap_callbacks(mover_data)
        local wrapped_args = M.wrap_line_args(mover_data)
        local py_mover = mover_unit.handle:create_mover_trigger(
            wrapped_args,
            'StraightMover',
            on_hit    or DUMMY_FUNCTION,
            on_finish or DUMMY_FUNCTION,
            on_block  or DUMMY_FUNCTION,
            on_break  or DUMMY_FUNCTION,
            on_remove or DUMMY_FUNCTION
        )
        local mover = M.get_by_handle(py_mover)
        update_mover(mover)
        mover:init(mover_data)
        return mover
    end
end

---@param mover_unit Unit|Projectile
---@param mover_data Mover.CreateData.Target
---@return Mover
function M.mover_target(mover_unit, mover_data)
    assert(mover_data.speed,        'Missing field: speed')
    assert(mover_data.target_distance, 'Missing field: target_distance')
    assert(mover_data.target,       'Missing field: target')
    if clicli.config.mover.enable_internal_regist then
        --todo complete the meta for CreateMoverComponent and MoverSystem
        local update_mover = M.wrap_internal_callbacks(mover_data)
        local comp = CreateMoverComponent.create_chasing_mover(mover_data)
        local py_mover = MoverSystem():create_mover(mover_unit.handle, comp)
        local mover = M.get_by_handle(py_mover)
        update_mover(mover)
        return mover
    else
        local update_mover, on_hit, on_block, on_finish, on_break, on_remove, on_miss = M.wrap_callbacks(mover_data)
        if on_miss then
            mover_data.on_miss = on_miss
        end
        local wrapped_args = M.wrap_target_args(mover_data)
        local py_mover = mover_unit.handle:create_mover_trigger(
            wrapped_args,
            'ChasingMover',
            on_hit    or DUMMY_FUNCTION,
            on_finish or DUMMY_FUNCTION,
            on_block  or DUMMY_FUNCTION,
            on_break  or DUMMY_FUNCTION,
            on_remove or DUMMY_FUNCTION
        )
        local mover = M.get_by_handle(py_mover)
        update_mover(mover)
        mover:init(mover_data)
        return mover
    end
end

---@param mover_unit Unit|Projectile
---@param mover_data Mover.CreateData.Curve
---@return Mover
function M.mover_curve(mover_unit, mover_data)
    assert(mover_data.speed,    'Missing field: speed')
    assert(mover_data.angle,    'Missing field: angle')
    assert(mover_data.distance, 'Missing field: distance')
    if clicli.config.mover.enable_internal_regist then
        --todo complete the meta for CreateMoverComponent and MoverSystem
        local update_mover = M.wrap_internal_callbacks(mover_data)
        local comp = CreateMoverComponent.create_curved_mover(mover_data)
        local py_mover = MoverSystem():create_mover(mover_unit.handle, comp)
        local mover = M.get_by_handle(py_mover)
        update_mover(mover)
        return mover
    else
        local update_mover, on_hit, on_block, on_finish, on_break, on_remove = M.wrap_callbacks(mover_data)
        local wrapped_args = M.wrap_curve_args(mover_data)
        local py_mover = mover_unit.handle:create_mover_trigger(
            wrapped_args,
            'CurvedMover',
            on_hit    or DUMMY_FUNCTION,
            on_finish or DUMMY_FUNCTION,
            on_block  or DUMMY_FUNCTION,
            on_break  or DUMMY_FUNCTION,
            on_remove or DUMMY_FUNCTION
        )
        local mover = M.get_by_handle(py_mover)
        update_mover(mover)
        mover:init(mover_data)
        return mover
    end
end

---@param mover_unit Unit|Projectile
---@param mover_data Mover.CreateData.Round
---@return Mover
function M.mover_round(mover_unit, mover_data)
    assert(mover_data.target, 'Missing field: target')
    if clicli.config.mover.enable_internal_regist then
        --todo complete the meta for CreateMoverComponent and MoverSystem
        local update_mover = M.wrap_internal_callbacks(mover_data)
        local comp = CreateMoverComponent.create_round_mover(mover_data)
        local py_mover = MoverSystem():create_mover(mover_unit.handle, comp)
        local mover = M.get_by_handle(py_mover)
        update_mover(mover)
        return mover
    else
        local update_mover, on_hit, on_block, on_finish, on_break, on_remove = M.wrap_callbacks(mover_data)
        local wrapped_args = M.wrap_round_args(mover_data)
        local py_mover = mover_unit.handle:create_mover_trigger(
            wrapped_args,
            'RoundMover',
            on_hit    or DUMMY_FUNCTION,
            on_finish or DUMMY_FUNCTION,
            on_block  or DUMMY_FUNCTION,
            on_break  or DUMMY_FUNCTION,
            on_remove or DUMMY_FUNCTION
        )
        local mover = M.get_by_handle(py_mover)
        update_mover(mover)
        mover:init(mover_data)
        return mover
    end
end

---@class Unit
local Unit = Class 'Unit'

---@class Projectile
local Projectile = Class 'Projectile'

---Create a linear motion device
---@param mover_data Mover.CreateData.Line
---@return Mover
function Unit:mover_line(mover_data)
    local mover = M.mover_line(self, mover_data)
    return mover
end

---Create a linear motion device
---@param mover_data Mover.CreateData.Line
---@return Mover
function Projectile:mover_line(mover_data)
    local mover = M.mover_line(self, mover_data)
    return mover
end

---Create a tracker
---@param mover_data Mover.CreateData.Target
---@return Mover
function Unit:mover_target(mover_data)
    local mover = M.mover_target(self, mover_data)
    return mover
end

---Create a tracker
---@param mover_data Mover.CreateData.Target
---@return Mover
function Projectile:mover_target(mover_data)
    local mover = M.mover_target(self, mover_data)
    return mover
end

---Create a curve mover
---@param mover_data Mover.CreateData.Curve
---@return Mover
function Unit:mover_curve(mover_data)
    local mover = M.mover_curve(self, mover_data)
    return mover
end

---Create a curve mover
---@param mover_data Mover.CreateData.Curve
---@return Mover
function Projectile:mover_curve(mover_data)
    local mover = M.mover_curve(self, mover_data)
    return mover
end

---Create a surround motion
---@param mover_data Mover.CreateData.Round
---@return Mover
function Unit:mover_round(mover_data)
    local mover = M.mover_round(self, mover_data)
    return mover
end

---Create a surround motion
---@param mover_data Mover.CreateData.Round
---@return Mover
function Projectile:mover_round(mover_data)
    local mover = M.mover_round(self, mover_data)
    return mover
end

---interrupter
function Unit:break_mover()
    GameAPI.break_unit_mover(self.handle)
end

---Removal motor
function Unit:remove_mover()
    GameAPI.remove_unit_mover(self.handle)
end

---interrupter
function Projectile:break_mover()
    --TODO see question 8
    ---@diagnostic disable-next-line: param-type-mismatch
    GameAPI.break_unit_mover(self.handle)
end

---Removal motor
function Projectile:remove_mover()
    --TODO see question 8
    ---@diagnostic disable-next-line: param-type-mismatch
    GameAPI.remove_unit_mover(self.handle)
end

return M
