# Camera

Lens

## apply

```lua
(method) Camera:apply(player_or_group?: Player|PlayerGroup, duration?: number, slope_mode?: y3.Const.CameraMoveMode)
```

 Reference shot

@*param* `player_or_group` — Players or groups of players, all players by default

@*param* `duration` — Transition time, the default is0

@*param* `slope_mode` — Transition mode, the default is constant speed
## camera_shake

```lua
function Camera.camera_shake(player: Player, strength: number, speed: number, time: number, shake_type: integer)
```

Camera wobble

@*param* `player` — Player

@*param* `strength` — Swing amplitude

@*param* `speed` — speed

@*param* `time` — duration

@*param* `shake_type` — Vibration mode
## camera_shake_with_decay

```lua
function Camera.camera_shake_with_decay(player: Player, shake: number, attenuation: number, frequency: number, time: number, shake_type: integer)
```

The lens tape attenuates vibration

@*param* `player` — Player

@*param* `shake` — Amplitude of vibration

@*param* `attenuation` — attenuation

@*param* `frequency` — frequency

@*param* `time` — duration

@*param* `shake_type` — Vibration mode
## cancel_area_limit

```lua
function Camera.cancel_area_limit(player: Player)
```

Turn off the lens to restrict movement

@*param* `player` — Player
## cancel_camera_follow_unit

```lua
function Camera.cancel_camera_follow_unit(player: Player)
```

Set the lens to unfollow

@*param* `player` — Player
## cancel_tps_follow_unit

```lua
function Camera.cancel_tps_follow_unit(player: Player)
```

Cancel the lens third person following unit

@*param* `player` — Player
## create_camera

```lua
function Camera.create_camera(point: Point, focal_length: number, focal_height: number, yaw: number, pitch: number, range_of_visibility: number)
  -> Camera
```

Create shot

@*param* `point` — Shot point

@*param* `focal_length` — Focus Distance

@*param* `focal_height` — Focal height

@*param* `yaw` — Lens'yaw

@*param* `pitch` — Lens'pitch

@*param* `range_of_visibility` — Vision cut scope
## disable_camera_move

```lua
function Camera.disable_camera_move(player: Player)
```

Disable player camera movement

@*param* `player` — Player
## enable_camera_move

```lua
function Camera.enable_camera_move(player: Player)
```

Allows the player to move the camera

@*param* `player` — Player
## get_by_handle

```lua
function Camera.get_by_handle(py_camera: integer)
  -> camera: Camera
```

## get_by_res_id

```lua
function Camera.get_by_res_id(res_id: integer)
  -> Camera
```

 Get the lens placed on the scene
## get_camera_center_raycast

```lua
function Camera.get_camera_center_raycast(player: Player)
  -> The collision point of the central ray of the camera: Point
```

 Gets the collision point of the center ray of the player's camera。
 Must be set `y3.config.sync.camera = true`

@*param* `player` — Player
## get_player_camera_direction

```lua
function Camera.get_player_camera_direction(player: Player)
  -> Camera orientation: Point
```

 Get the player camera orientation。
 Must be set `y3.config.sync.camera = true`

@*param* `player` — Player
## handle

```lua
py.Camera
```

Lens configuration
## is_camera_playing_timeline

```lua
function Camera.is_camera_playing_timeline(player: Player)
  -> Whether an animation is playing: boolean
```

Whether the player camera is playing an animation

@*param* `player` — Player
## limit_in_rectangle_area

```lua
function Camera.limit_in_rectangle_area(player: Player, area: Area)
```

Limit lens movement

@*param* `player` — Player

@*param* `area` — Moving range area
## linear_move_by_time

```lua
function Camera.linear_move_by_time(player: Player, point: Point, time: number, move_type: integer)
```

Linear movement (time）

@*param* `player` — Player

@*param* `point` — Target point

@*param* `time` — Transition time

@*param* `move_type` — Mobile mode
## look_at_point

```lua
function Camera.look_at_point(player: Player, point: Point, time: number)
```

Set the lens to face the point

@*param* `player` — Player

@*param* `point` — Target point

@*param* `time` — Transition time
## play_camera_timeline

```lua
function Camera.play_camera_timeline(player: Player, camera_timeline_id: py.CamlineID)
```

Play shot animation

@*param* `player` — Player

@*param* `camera_timeline_id` — Shot animationID
## set_camera_follow_unit

```lua
function Camera.set_camera_follow_unit(player: Player, unit: Unit, x: number, y: number, height: number)
```

Set the lens following unit

@*param* `player` — Player

@*param* `unit` — Target unit

@*param* `x` — Transition time

@*param* `y` — Mobile mode

@*param* `height` — Altitude
## set_distance

```lua
function Camera.set_distance(player: Player, value: number, time: number)
```

Set focus distance

@*param* `player` — Player

@*param* `value` — 值

@*param* `time` — Transition time
## set_focus_height

```lua
function Camera.set_focus_height(player: Player, value: number, time: number)
```

Set the lens focus height

@*param* `player` — Player

@*param* `value` — 值

@*param* `time` — Transition time
## set_keyboard_move_camera_speed

```lua
function Camera.set_keyboard_move_camera_speed(player: Player, speed: number)
```

Set the camera movement speed (keyboard）

@*param* `player` — Player

@*param* `speed` — Moving speed
## set_max_distance

```lua
function Camera.set_max_distance(player: Player, value: number)
```

Set the maximum lens height

@*param* `player` — Player

@*param* `value` — Upper limit of height
## set_mouse_move_camera_speed

```lua
function Camera.set_mouse_move_camera_speed(player: Player, speed: number)
```

Set the lens movement speed (mouse）

@*param* `player` — Player

@*param* `speed` — Moving speed
## set_moving_with_mouse

```lua
function Camera.set_moving_with_mouse(player: Player, state: boolean)
```

Set whether the mouse can move the lens

@*param* `player` — Player

@*param* `state` — Switch
## set_rotate

```lua
function Camera.set_rotate(player: Player, angle_type: py.CameraRotate, value: number, time: number)
```

Set the lens Angle

@*param* `player` — Player

@*param* `angle_type` — Angle type

@*param* `value` — 值

@*param* `time` — Transition time
## set_tps_follow_unit

```lua
function Camera.set_tps_follow_unit(player: Player, unit: Unit, sensitivity?: number, yaw?: number, pitch?: number, x_offset?: number, y_offset?: number, z_offset?: number, camera_distance?: number)
```

Set the lens third person following unit

@*param* `player` — Player

@*param* `unit` — Target unit

@*param* `sensitivity` — sensitivity

@*param* `yaw` — yaw

@*param* `pitch` — pitch

@*param* `x_offset` — offsetX

@*param* `y_offset` — offsetY

@*param* `z_offset` — Offset height

@*param* `camera_distance` — Distance from focus
## show_tps_mode_mouse

```lua
function Camera.show_tps_mode_mouse(player: Player, switch: boolean)
```

Set TPS Angle mouse display

@*param* `player` — Player

@*param* `switch` — Show mouse or not
## stop_camera_timeline

```lua
function Camera.stop_camera_timeline(player: Player)
```

Stop shot animation

@*param* `player` — Player
## type

```lua
string
```


