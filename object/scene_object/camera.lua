--Lens
---@class Camera
---@field handle py.Camera
---@overload fun(py_camera: py.Camera): self
local M = Class 'Camera'

M.type = 'camera'

---@param py_camera py.Camera
---@return self
function M:__init(py_camera)
    self.handle = py_camera
    return self
end

---@param py_camera integer
---@return Camera camera
function M.get_by_handle(py_camera)
    local camera = New 'Camera' (py_camera)
    return camera
end

--Get the lens placed on the scene
---@param res_id integer
---@return Camera
function M.get_by_res_id(res_id)
    return M.get_by_handle(res_id)
end

clicli.py_converter.register_py_to_lua('py.Camera', M.get_by_handle)
clicli.py_converter.register_lua_to_py('py.Camera', function (lua_value)
    return lua_value.handle
end)

--Reference shot
---@param player_or_group? Player | PlayerGroup # Players or groups of players, all players by default
---@param duration? number # Transition time. The default value is 0
---@param slope_mode? clicli.Const.CameraMoveMode # Transition mode, the default is constant speed
function M:apply(player_or_group, duration, slope_mode)
    GameAPI.apply_camera_conf(
        ---@diagnostic disable-next-line: param-type-mismatch
        (player_or_group or clicli.player_group.get_all_players()).handle,
        self.handle,
        duration or 0,
        clicli.const.CameraMoveMode[slope_mode] or 0
    )
end

---Whether the player camera is playing an animation
---@param player Player
---@return boolean Specifies whether an animation is being played
function M.is_camera_playing_timeline(player)
    return GameAPI.is_cameraIS_playing_timeline(player.handle)
end

---Create shot
---@param point Point Point where the camera is
---@param focal_length number Focal length
---@param focal_height number Focal height
---@param yaw number Lens yaw
---@param pitch number pitch of the shot
---@param range_of_visibility number Visibility range
---@return Camera
function M.create_camera(point, focal_length, focal_height, yaw, pitch, range_of_visibility)
    local id = GameAPI.add_camera_conf(
        point.handle,
        focal_length,
        focal_height,
        yaw,
        pitch,
        range_of_visibility
    )
    return M.get_by_handle(id)
end

---Allows the player to move the camera
---@param player Player
function M.enable_camera_move(player)
    GameAPI.camera_set_move_enable(player.handle)
end

---Disable player camera movement
---@param player Player
function M.disable_camera_move(player)
    GameAPI.camera_set_move_not_enable(player.handle)
end

---Play shot animation
---@param player Player
---@param camera_timeline_id py.CamlineID ID of the shot animation
function M.play_camera_timeline(player, camera_timeline_id)
    GameAPI.play_camera_timeline(player.handle, camera_timeline_id)
end

---Stop shot animation
---@param player Player
function M.stop_camera_timeline(player)
    GameAPI.stop_camera_timeline(player.handle)
end

---The lens tape attenuates vibration
---@param player Player
---@param shake number Number of vibrations
---@param attenuation number Attenuation
---@param frequency number Frequency
---@param time number Duration
---@param shake_type integer Shake mode
function M.camera_shake_with_decay(player, shake, attenuation, frequency, time, shake_type)
    GameAPI.camera_shake_with_decay(player.handle, Fix32(shake), Fix32(attenuation), Fix32(frequency), Fix32(time), shake_type)
end

---Camera wobble
---@param player Player
---@param strength number Shaking amplitude
---@param speed number Indicates the speed
---@param time number Duration
---@param shake_type integer Shake mode
function M.camera_shake(player, strength, speed, time, shake_type)
    GameAPI.camera_shake(player.handle, Fix32(strength), Fix32(speed), Fix32(time), shake_type)
end

---Set TPS Angle mouse display
---@param player Player
---@param switch boolean Specifies whether to display the mouse
function M.show_tps_mode_mouse(player,switch)
    GameAPI.set_tps_mode_ctrl(player.handle, switch)
end

---Linear movement (time)
---@param player Player
---@param point Point Target point
---@param time number Transition time
---@param move_type integer Indicates the movement mode
function M.linear_move_by_time(player, point, time, move_type)
    GameAPI.camera_linear_move_duration(player.handle, point.handle, Fix32(time), move_type)
end

---Set the lens following unit
---@param player Player
---@param unit Unit Target unit
---@param x? number Transition time
---@param y? number mobile mode
---@param height? number height
---@param socket? string socket
function M.set_camera_follow_unit(player, unit, x, y, height, socket)
    ---@diagnostic disable-next-line: missing-parameter
    GameAPI.camera_set_follow_unit(player.handle, unit.handle, x or 0, y or 0, height or 0)
end

---Set the lens to unfollow
---@param player Player
function M.cancel_camera_follow_unit(player)
    GameAPI.camera_cancel_follow_unit(player.handle)
end

---Set the lens third person following unit
---@param player Player
---@param unit Unit Target unit
---@param sensitivity? number sensitivity
---@param yaw? number yaw
---@param pitch? number pitch
---@param x_offset? number Offset X
---@param y_offset? number Indicates the offset Y
---@param z_offset? number offset height
---@param camera_distance? number Distance from focus
function M.set_tps_follow_unit(player, unit, sensitivity, yaw, pitch, x_offset, y_offset, z_offset, camera_distance)
    GameAPI.camera_set_tps_follow_unit(player.handle, unit.handle, sensitivity, yaw, pitch, x_offset, y_offset, z_offset, camera_distance)
end

---Cancel the lens third person following unit
---@param player Player
function M.cancel_tps_follow_unit(player)
    GameAPI.camera_cancel_tps_follow_unit(player.handle)
end

---Set the lens to face the point
---@param player Player
---@param point Point Target point
---@param time number Transition time
function M.look_at_point(player, point, time)
    GameAPI.camera_look_at(player.handle, point.handle, Fix32(time))
end

---Set the maximum lens height
---@param player Player
---@param value number Upper limit of height
function M.set_max_distance(player, value)
    GameAPI.set_camera_distance_max(player.handle, value)
end

---Set the lens Angle
---@param player Player
---@param angle_type py.CameraRotate Indicates the Angle type
---@param value number Specifies the value
---@param time number Transition time
function M.set_rotate(player, angle_type, value, time)
    GameAPI.camera_set_param_rotate(player.handle, angle_type, Fix32(value), Fix32(time))
end


---Set focus distance
---@param player Player
---@param value number Specifies the value
---@param time number Transition time
function M.set_distance(player, value, time)
    GameAPI.camera_set_param_distance(player.handle, Fix32(value), Fix32(time))
end


---Set the lens focus height
---@param player Player
---@param value number Specifies the value
---@param time number Transition time
function M.set_focus_height(player, value, time)
    GameAPI.camera_set_focus_y(player.handle, Fix32(value), Fix32(time))
end


---Limit lens movement
---@param player Player
---@param area Area Mobile area
function M.limit_in_rectangle_area(player, area)
    GameAPI.camera_limit_area(player.handle, area.handle)
end


---Turn off the lens to restrict movement
---@param player Player
function M.cancel_area_limit(player)
    GameAPI.camera_limit_area_close(player.handle)
end


---Set whether the mouse can move the lens
---@param player Player
---@param state boolean Switch
function M.set_moving_with_mouse(player, state)
    GameAPI.set_mouse_move_camera_mode(player.handle, state)
end


---Set lens speed (mouse)
---@param player Player
---@param speed number Moving speed
function M.set_mouse_move_camera_speed(player, speed)
    GameAPI.set_mouse_move_camera_speed(player.handle, speed)
end


---Set the camera speed (keyboard)
---@param player Player
---@param speed number Moving speed
function M.set_keyboard_move_camera_speed(player, speed)
    GameAPI.set_key_move_camera_speed(player.handle, speed)
end


--Get the player camera orientation.
--Must first set ` clicli. Config. Sync. Camera = true `
---@param player Player
---@return Point Camera orientation
function M.get_player_camera_direction(player)
    if not clicli.config.sync.camera then
        error('Must first set ` clicli. Config. Sync. Camera = true `')
    end
    local py_point = GameAPI.get_player_camera_direction(player.handle)
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    return clicli.point.get_by_handle(py_point)
end


--Gets the collision point of the center ray of the player is camera.
--Must first set ` clicli. Config. Sync. Camera = true `
---@param player Player
---@return Point Collision point of the camera center ray
function M.get_camera_center_raycast(player)
    if not clicli.config.sync.camera then
        error('Must first set ` clicli. Config. Sync. Camera = true `')
    end
    local py_point = GameAPI.get_camera_center_raycast(player.handle)
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    return clicli.point.get_by_handle(py_point)
end

return M
