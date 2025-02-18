# Game

Game interface

## clear_table

```lua
function Game.clear_table(table: any)
```

Clear list
## close_role_micro_unit

```lua
function Game.close_role_micro_unit(player: Player)
```

Turn off player's nearby voice chat

@*param* `player` — Player
## create_day_night_human_time

```lua
function Game.create_day_night_human_time(time: number, dur: number)
```

Create artificial time

@*param* `time` — time

@*param* `dur` — duration
## current_game_run_time

```lua
function Game.current_game_run_time()
  -> time: number
```

The time the game has been running

@*return* `time` — time
## custom_event_manager

```lua
EventManager?
```

## download_platform_icon

```lua
function Game.download_platform_icon(url: string, icon: string, callback: fun(real_path: string))
```

Download the player platform avatar, call the callback function after downloading

@*param* `url` — Avatar download address

@*param* `icon` — Avatar path, if the local avatar is not downloaded, but immediately call the callback function

@*param* `callback` — After downloading the callback function
## enable_grass_by_pos

```lua
function Game.enable_grass_by_pos(is_on: boolean, point: Point)
```

Switch the grass at the target point

@*param* `is_on` — Switch

@*param* `point` — 点
## enable_soft_pause

```lua
function Game.enable_soft_pause()
```

Enable soft pause
## encrypt_table

```lua
function Game.encrypt_table(tab: table)
```

Encrypted list

@*param* `tab` — 表
## end_player_game

```lua
function Game.end_player_game(player: Player, result: string, is_show: boolean)
```

End player game

@*param* `player` — Player

@*param* `result` — result

@*param* `is_show` — Display interface or not
## event

```lua
fun(self: Game, event: "Game - initialization, callback: fun(trg: Trigger, data: EventParam). Game - initialization)):Trigger
```

## event_dispatch

```lua
(method) CustomEvent:event_dispatch(event_name: string, ...any)
  -> any
  2. any
  3. any
  4. any
```

Initiate custom events (receipt mode), which, unlike notification mode, allows for insert billing。
The return value of the event can be accepted, and the event is called in the order of registration when there are multiple registrations，
When any event callback returns a non-nil value, subsequent triggers are not called。

```lua
Obj:event_on('Acquire', function (trigger,...)
    print('Acquire1')
    return 1
end)
Obj:event_on('Acquire', function (trigger,...)
    print('Acquire2')
    return 2
end)

local result = Obj:event_dispatch('Acquire')

print('Turn out：', result)
```

The above code will print：

```
Acquire1
Turn out：    1
```

## event_dispatch_with_args

```lua
(method) CustomEvent:event_dispatch_with_args(event_name: string, args: any, ...any)
  -> any
  2. any
  3. any
  4. any
```

 Initiates custom events with event parameters (receipt mode）
## event_manager

```lua
unknown
```

## event_notify

```lua
(method) CustomEvent:event_notify(event_name: string, ...any)
```

When a custom event is initiated (notification mode), only one event is executed on the same object，
When an insert settlement occurs, subsequent events are queued

```lua
Obj:event_on('obtained', function ()
    print('Trigger acquisition')
    print('Before removal')
    Obj:event_notify('Remove ') - In real business, maybe the buff you get kills yourself and the death clearsbuff
    print('After removal')
end)

Obj:event_on('Remove', function ()
    print('Trigger removal')
end)

Obj:event_notify('obtained')
```

This code will print：

```
Trigger acquisition
Before removal
After removal
Trigger removal
```

## event_notify_with_args

```lua
(method) CustomEvent:event_notify_with_args(event_name: string, args: any[], ...any)
```

 Initiates custom events with event parameters (notification mode）
## event_on

```lua
(method) CustomEvent:event_on(...any)
  -> Trigger
```

Register a custom event and, when triggered, execute a callback function。

```lua
Obj:event_on('input', function (trigger, ...)
    print('The input event was triggered', ...)
end)

Obj:event_notify('input', '123', '456')
```

The above will print：

```
The input event was triggered 123 456
```

---

You can specify parameters for the event during registration：

```lua
Obj:event_on('input', {'123'}, function (trigger, ...)
    print('The input event was triggered', ...)
end)

Obj:event_notify('Enter ', 1) -- the event cannot be triggered
Obj:event_notify_with_args('Enter ', {'123'}, 2) -- to trigger the event
Obj:event_notify_with_args('Enter ', {'456'}, 3) -- cannot fire an event
Obj:event_notify_with_args('Enter ', {'123', '666'}, 4) -- to trigger the event
```

## get_archive_rank_player_archive_value

```lua
function Game.get_archive_rank_player_archive_value(file: integer, index: integer)
  -> value: integer
```

Gets the integer save leaderboard player save value

@*param* `file` — On file

@*param* `index` — Serial number

@*return* `value` — Archive value
## get_camp_by_id

```lua
function Game.get_camp_by_id(id: py.CampID)
  -> py.Camp
```

Acquisition camp

@*param* `id` — Factionsid
## get_compound_attributes

```lua
function Game.get_compound_attributes(primary_attribute: string, secondary_attr: string)
  -> coefficient: number
```

Get the influence coefficient of the three-dimensional attribute

@*param* `primary_attribute` — First-level attribute

@*param* `secondary_attr` — Secondary attribute

@*return* `coefficient` — coefficient
## get_current_game_mode

```lua
function Game.get_current_game_mode()
  -> game_mode: py.GameMode
```

Gets the current game mode

@*return* `game_mode` — Game mode
## get_current_server_time

```lua
function Game.get_current_server_time(time_zone?: integer)
  -> ServerTime
```

Gets the current server time. In order to ensure the consistency of the results you need to specify your own time zone。

@*param* `time_zone` — Time zone. The default value is 0. Get China time please pass in8。
## get_custom_event_manager

```lua
(method) CustomEvent:get_custom_event_manager()
  -> EventManager?
```

## get_damage_ratio

```lua
function Game.get_damage_ratio(attack_type: integer, area_type: integer)
  -> factor: number
```

Gain damage coefficient

@*param* `attack_type` — Attack type

@*param* `area_type` — Type of armor

@*return* `factor` — Damage coefficient
## get_day_night_time

```lua
function Game.get_day_night_time()
  -> time: number
```

Gets the game's current day and night time

@*return* `time` — time
## get_event_manager

```lua
(method) Game:get_event_manager()
  -> EventManager
```

## get_game_init_time_stamp

```lua
function Game.get_game_init_time_stamp()
  -> time_stamp: integer
```

Get the game start time stamp

@*return* `time_stamp` — timestamp
## get_game_x_resolution

```lua
function Game.get_game_x_resolution()
  -> x_resolution: integer
```

Gets the initial horizontal resolution

@*return* `x_resolution` — Lateral resolution
## get_game_y_resolution

```lua
function Game.get_game_y_resolution()
  -> y_resolution: integer
```

Gets the initial vertical resolution

@*return* `y_resolution` — Longitudinal resolution
## get_global_archive

```lua
function Game.get_global_archive(name: string)
  -> archive: integer
```

Get global archive

@*param* `name` — Archive name

@*return* `archive` — On file
## get_global_weather

```lua
function Game.get_global_weather()
  -> weather: integer
```

Get global weather

@*return* `weather` — weather
## get_graphics_quality

```lua
function Game.get_graphics_quality()
  -> quality: 'high'|'low'|'medium'
```

Get the initial game quality

@*return* `quality` — Picture quality

```lua
quality:
    | 'low'
    | 'medium'
    | 'high'
```
## get_icon_id

```lua
function Game.get_icon_id(id: integer)
  -> texture: py.Texture
```

Get the picture based on the picture ID
## get_level

```lua
function Game.get_level()
  -> py.Map
```

Get current level

@*return* — Current level
## get_obj_icon

```lua
function Game.get_obj_icon(obj?: Ability|Buff|Item|Unit)
  -> texture: py.Texture
```

Get any object picture

@*param* `obj` — Units | items | skills | magic effects
## get_point_texture

```lua
function Game.get_point_texture(point: Point)
  -> integer
```

Get terrain texture

@*param* `point` — 点
## get_start_mode

```lua
function Game.get_start_mode()
  -> game_mode: integer
```

Get the local game environment

@*return* `game_mode` — Game environment, 1 is the editor, 2 is the platform
## get_table

```lua
function Game.get_table(name: string, as_lua?: boolean)
  -> tb: table
```

Acquisition list

@*param* `name` — Table name

@*param* `as_lua` — Whether to convert the data in the table to a Lua data type, such as Fix32number

@*return* `tb` — 表
## get_tech_description

```lua
function Game.get_tech_description(tech_id: py.TechKey)
  -> description: string
```

Get a description of the technology type

@*param* `tech_id` — Science and technology type

@*return* `description` — Description
## get_tech_icon

```lua
function Game.get_tech_icon(tech_id: py.TechKey, index: integer)
  -> texture: py.Texture
```

Get Technology ICONS

@*param* `tech_id` — Science and technology

@*param* `index` — Lv.

@*return* `texture` — iconid
## get_tech_max_level

```lua
function Game.get_tech_max_level(tech_id: py.TechKey)
  -> level: integer
```

Get the maximum level of technology

@*param* `tech_id` — Science and technologyid

@*return* `level` — Maximum grade
## get_tech_name

```lua
function Game.get_tech_name(tech_id: py.TechKey)
  -> name: string
```

Get the name of the technology type

@*param* `tech_id` — Science and technology type

@*return* `name` — name
## get_window_mode

```lua
function Game.get_window_mode()
  -> mode: Game.WindowMode
```

Gets the windowed category

@*return* `mode` — Windowing class

```lua
mode:
    | "full_screen" -- Full screen
    | "window_mode" -- Windowed
    | "window_mode_full_screen" -- Windowing full screen
```
## is_compound_attributes_enabled

```lua
function Game.is_compound_attributes_enabled()
  -> is_open: boolean
```

Whether to enable 3D properties

@*return* `is_open` — Enable or not
## is_debug_mode

```lua
function Game.is_debug_mode(ignore_config?: boolean)
  -> boolean
```

 Debug mode or not

@*param* `ignore_config` — Whether to ignore user Settings
## locale

```lua
function Game.locale(key: string|integer)
  -> Multilingual content: string
```

Get multilingual content

@*param* `key` — multilingualkey
## modify_point_texture

```lua
function Game.modify_point_texture(point: Point, terrain_type: integer, range: integer, area_type: integer)
```

Set the terrain texture for a point

@*param* `point` — 点

@*param* `terrain_type` — Texture type

@*param* `range` — Radius

@*param* `area_type` — shape
## on_client_tick

```lua
function Game.on_client_tick(callback: fun(local_player: Player))
```

The local client calls back this function every frame  
Only one callback can be registered. The one registered later overwrites the one registered earlier，
Distribute it in the callback if necessary

>Warning: The callback function is executed on the local player's client, take care to avoid the problem of asynchronization。
## pause_game

```lua
function Game.pause_game()
```

Pause the game
## reg_sound_area

```lua
function Game.reg_sound_area(area: Area)
```

Sign up area for nearby voice channels

@*param* `area` — region
## remove_ability_kv

```lua
function Game.remove_ability_kv(ability_key: py.AbilityKey, key: string)
```

Clear skill type key value

@*param* `ability_key` — skillid

@*param* `key` — 键
## remove_item_kv

```lua
function Game.remove_item_kv(item_key: py.ItemKey, key: string)
```

Clear item type key value

@*param* `item_key` — itemid

@*param* `key` — 键
## remove_unit_kv

```lua
function Game.remove_unit_kv(unit_key: py.UnitKey, key: string)
```

Clear the unit type key value

@*param* `unit_key` — unitid

@*param* `key` — 键
## replace_area_texture

```lua
function Game.replace_area_texture(area: Area, old_texture: integer, new_texture: integer)
```

Alternate terrain texture

@*param* `area` — region

@*param* `old_texture` — Texture type

@*param* `new_texture` — Texture type
## request_url

```lua
(method) Game:request_url(url: string, body?: string, callback?: fun(body?: string), options?: HttpRequestOptions)
```

Sending an http request triggers a callback on success or failure，
The parameter of the callback is the body returned by http on success, and the parameter of the callback on failure is `nil`
## restart_game

```lua
function Game.restart_game(fast_restart: boolean)
```

Start a new game

@*param* `fast_restart` — Quick reset
## resume_soft_pause

```lua
function Game.resume_soft_pause()
```

Resume soft pause
## send_custom_event

```lua
function Game.send_custom_event(id: integer, table: table)
```

 Send custom events toECA

@*param* `id` — incidentid

@*param* `table` — Event data
## send_signal

```lua
function Game.send_signal(player: Player, signal_enum: y3.Const.SignalType, point: Point, visible_enum: y3.Const.VisibleType)
```

Send signal

@*param* `player` — Player

@*param* `signal_enum` — Signal enumeration value

@*param* `point` — 点

@*param* `visible_enum` — Visibility enumeration value
## set_area_weather

```lua
function Game.set_area_weather(area: Area, weather: integer)
```

Set area weather

@*param* `area` — region

@*param* `weather` — weather
## set_cascaded_shadow_distanc

```lua
function Game.set_cascaded_shadow_distanc(distance: number)
```

Set shadow distance

@*param* `distance` — distance
## set_cascaded_shadow_distance

```lua
function Game.set_cascaded_shadow_distance(dis: number)
```

Set shadow distance

@*param* `dis` — distance
## set_cascaded_shadow_enable

```lua
function Game.set_cascaded_shadow_enable(is_enable: boolean)
```

Switch cascade shadow

@*param* `is_enable` — Switch
## set_compound_attributes

```lua
function Game.set_compound_attributes(primary_attribute: string, secondary_attr: string, value: number)
```

Set compound properties

@*param* `primary_attribute` — First-level attribute

@*param* `secondary_attr` — Secondary attribute

@*param* `value` — Attribute value
## set_damage_factor

```lua
function Game.set_damage_factor(attack_type: integer, armor_type: integer, ratio: number)
```

Set damage coefficient

@*param* `attack_type` — Attack type

@*param* `armor_type` — Type of armor

@*param* `ratio` — coefficient
## set_day_night_speed

```lua
function Game.set_day_night_speed(speed: number)
```

Set the speed at which the game time passes

@*param* `speed` — speed
## set_day_night_time

```lua
function Game.set_day_night_time(time: number)
```

Set play time

@*param* `time` — time
## set_fog_attr

```lua
function Game.set_fog_attr(fog: table, attr: string, value: number)
```

Set fog effect properties (new)

@*param* `fog` — Local fog

@*param* `attr` — orientation

@*param* `value` — positionx
## set_fog_attribute

```lua
function Game.set_fog_attribute(fog: table, direction: number, pos_x: number, pos_y: number, pos_z: number, scale_x: number, scale_y: number, scale_z: number, red: number, green: number, blue: number, concentration: number, speed: number)
```

Set the fog effect property

@*param* `fog` — Local fog

@*param* `direction` — orientation

@*param* `pos_x` — positionx

@*param* `pos_y` — positiony

@*param* `pos_z` — positionz

@*param* `scale_x` — Zoomx

@*param* `scale_y` — Zoomy

@*param* `scale_z` — Zoomz

@*param* `red` — colourr

@*param* `green` — colourg

@*param* `blue` — colourb

@*param* `concentration` — concentration

@*param* `speed` — Velocity of flow
## set_game_speed

```lua
function Game.set_game_speed(speed: number)
```

Set the game speed

@*param* `speed` — speed
## set_global_weather

```lua
function Game.set_global_weather(weather: integer)
```

Set global weather

@*param* `weather` — weather
## set_globale_view

```lua
function Game.set_globale_view(enable: boolean)
```

 Enable Full view (always visible）
## set_jump_word

```lua
function Game.set_jump_word(enable: boolean)
```

Turn off localplayer's presentation layer hops

@*param* `enable` — Close or not
## set_logic_fps

```lua
function Game.set_logic_fps(fps: integer)
```

Set the logical frame rate

@*param* `fps` — Frame rate
## set_material_param

```lua
function Game.set_material_param(obj: Unit, mat: integer, r: number, g: number, b: number, intensity: number, alpha: number)
```

Sets the material of the object

@*param* `mat` — material

@*param* `r` — 红

@*param* `g` — 绿

@*param* `b` — 蓝

@*param* `intensity` — intensity

@*param* `alpha` — transparency
## set_nearby_micro_switch

```lua
function Game.set_nearby_micro_switch(player: Player, switch: boolean)
```

Set the player's nearby voice chat speech switch

@*param* `player` — Player

@*param* `switch` — Close or not
## set_nearby_sound_switch

```lua
function Game.set_nearby_sound_switch(player: Player, switch: boolean)
```

Set the player's nearby voice chat listening switch

@*param* `player` — Player

@*param* `switch` — Close or not
## set_nearby_voice_mode

```lua
function Game.set_nearby_voice_mode(switch: boolean)
```

Set the area mode switch for nearby voices

@*param* `switch` — Close or not
## set_object_color

```lua
function Game.set_object_color(obj: Destructible|Item|Unit, r: integer, g: integer, b: integer, a?: integer, o?: number)
```

Sets the object base material color

@*param* `r` — red（0~255）

@*param* `g` — green（0~255）

@*param* `b` — blue（0~255）

@*param* `a` — intensity（0~100）

@*param* `o` — opacity（0~1）
## set_object_fresnel

```lua
function Game.set_object_fresnel(obj: Destructible|Item|Unit, r?: integer, g?: integer, b?: integer, alpha?: number, exp?: number, strength?: number)
```

Sets the Fresnel effect of an object

@*param* `r` — R

@*param* `g` — G

@*param* `b` — B

@*param* `alpha` — alpha

@*param* `exp` — exp

@*param* `strength` — strength
## set_object_fresnel_visible

```lua
function Game.set_object_fresnel_visible(obj: Destructible|Item|Unit, b: boolean)
```

Sets the Fresnel effect of an object
## set_post_effect

```lua
function Game.set_post_effect(player: Player, processing: py.PostEffect)
```

Switch styles for the player

@*param* `player` — Player

@*param* `processing` — Painting style
## set_random_seed

```lua
function Game.set_random_seed(seed: integer)
```

Set the random number seed

@*param* `seed` — Random seed
## set_role_all_micro_switch

```lua
function Game.set_role_all_micro_switch(player: Player, switch: boolean)
```

Set the player's all voice chat speech switch

@*param* `player` — Player

@*param* `switch` — Close or not
## set_role_all_sound_switch

```lua
function Game.set_role_all_sound_switch(player: Player, switch: boolean)
```

Set the player's everyone voice chat listening switch

@*param* `player` — Player

@*param* `switch` — Close or not
## set_role_camp_micro_switch

```lua
function Game.set_role_camp_micro_switch(player: Player, switch: boolean)
```

Set the player's peer group voice chat speech switch

@*param* `player` — Player

@*param* `switch` — Close or not
## set_role_camp_sound_switch

```lua
function Game.set_role_camp_sound_switch(player: Player, switch: boolean)
```

Set the player's peer voice chat listening switch

@*param* `player` — Player

@*param* `switch` — Close or not
## set_role_micro_unit

```lua
function Game.set_role_micro_unit(player: Player, unit: Unit)
```

Set up the player's sound master unit

@*param* `player` — Player

@*param* `unit` — Close or not
## sfx_switch

```lua
function Game.sfx_switch(player: Player, switch: boolean)
```

Special effect switch

@*param* `player` — Player

@*param* `switch` — Close or not
## str_to_ability_cast_type

```lua
function Game.str_to_ability_cast_type(str: string)
  -> py.AbilityCastType
```

String to skill release type

@*param* `str` — Character string

@*return* — Skill release type
## str_to_ability_key

```lua
function Game.str_to_ability_key(str: string)
  -> py.AbilityKey
```

The string is converted to the skill type

@*param* `str` — Character string

@*return* — Skill type
## str_to_ability_type

```lua
function Game.str_to_ability_type(str: string)
  -> py.AbilityType
```

The character string is converted to the slot type

@*param* `str` — Character string

@*return* — Skill Slot type
## str_to_audio_key

```lua
function Game.str_to_audio_key(str: string)
  -> py.AudioKey
```

String to sound type

@*param* `str` — Character string

@*return* — Sound type
## str_to_camp

```lua
function Game.str_to_camp(str: string)
  -> py.Camp
```

String to camp

@*param* `str` — Character string

@*return* — Factions
## str_to_damage_type

```lua
function Game.str_to_damage_type(str: string)
  -> integer
```

Character string transfer damage type

@*param* `str` — Character string

@*return* — Injury type
## str_to_dest_key

```lua
function Game.str_to_dest_key(str: string)
  -> py.DestructibleKey
```

String to destructible type

@*param* `str` — Character string

@*return* — Destructible type
## str_to_item_key

```lua
function Game.str_to_item_key(str: string)
  -> py.ItemKey
```

String to item type

@*param* `str` — Character string

@*return* — Item type
## str_to_keyboard_key

```lua
function Game.str_to_keyboard_key(str: string)
  -> py.KeyboardKey
```

String to keyboard key

@*param* `str` — Character string

@*return* — Keyboard key
## str_to_link_sfx_key

```lua
function Game.str_to_link_sfx_key(str: string)
  -> py.SfxKey
```

String to link effect

@*param* `str` — Character string

@*return* — Link effect
## str_to_model_key

```lua
function Game.str_to_model_key(str: string)
  -> py.ModelKey
```

String to model type

@*param* `str` — Character string

@*return* — Model type
## str_to_modifier_effect_type

```lua
function Game.str_to_modifier_effect_type(str: string)
  -> py.ModifierEffectType
```

String to magic effect effect type

@*param* `str` — Character string

@*return* — Magic effects affect type
## str_to_modifier_key

```lua
function Game.str_to_modifier_key(str: string)
  -> py.ModifierKey
```

String to magic effect type

@*param* `str` — Character string

@*return* — Magic effect type
## str_to_modifier_type

```lua
function Game.str_to_modifier_type(str: string)
  -> py.ModifierType
```

String to magic effect category

@*param* `str` — Character string

@*return* — Magic effect categories
## str_to_mouse_key

```lua
function Game.str_to_mouse_key(str: string)
  -> py.MouseKey
```

String turn mouse button

@*param* `str` — Character string

@*return* — Mouse button
## str_to_mouse_wheel

```lua
function Game.str_to_mouse_wheel(str: string)
  -> py.MouseWheel
```

String turn mouse wheel

@*param* `str` — Character string

@*return* — Mouse wheel
## str_to_particle_sfx_key

```lua
function Game.str_to_particle_sfx_key(str: string)
  -> py.SfxKey
```

String conversion effect

@*param* `str` — Character string

@*return* — VFX
## str_to_project_key

```lua
function Game.str_to_project_key(str: string)
  -> py.ProjectileKey
```

String transprojectile type

@*param* `str` — Character string

@*return* — Projectile type
## str_to_role_relation

```lua
function Game.str_to_role_relation(str: string)
  -> py.RoleRelation
```

String to player relationship

@*param* `str` — Character string

@*return* — Player relationship
## str_to_role_res

```lua
function Game.str_to_role_res(str: string)
  -> py.RoleResKey
```

String to player properties

@*param* `str` — Character string

@*return* — 3 Player attributes
## str_to_role_status

```lua
function Game.str_to_role_status(status: py.RoleStatus)
  -> string
```

Word player status to string
## str_to_role_type

```lua
function Game.str_to_role_type(str: string)
  -> py.RoleType
```

String to player control state

@*param* `str` — Character string

@*return* — Player control state
## str_to_store_key

```lua
function Game.str_to_store_key(str: string)
  -> store_key: py.StoreKey
```

String to platform item type

@*param* `str` — Character string

@*return* `store_key` — Platform item types
## str_to_tech_key

```lua
function Game.str_to_tech_key(str: string)
  -> py.TechKey
```

String to technology type

@*param* `str` — Character string

@*return* — Science and technology type
## str_to_ui_event

```lua
function Game.str_to_ui_event(str: string)
  -> string
```

The string to interface event

@*param* `str` — Character string
## str_to_unit_attr_type

```lua
function Game.str_to_unit_attr_type(str: string)
  -> string
```

String to unit attribute type

@*param* `str` — Character string

@*return* — Unit attribute type
## str_to_unit_command_type

```lua
function Game.str_to_unit_command_type(str: string)
  -> py.UnitCommandType
```

Character string to unit command type

@*param* `str` — Character string

@*return* — Unit command type
## str_to_unit_key

```lua
function Game.str_to_unit_key(str: string)
  -> py.UnitKey
```

It is a string to a unit type

@*param* `str` — Character string

@*return* — Unit type
## str_to_unit_name

```lua
function Game.str_to_unit_name(str: string)
  -> string
```

String to unit property

@*param* `str` — Character string

@*return* — Unit attribute
## str_to_unit_type

```lua
function Game.str_to_unit_type(str: string)
  -> py.UnitType
```

String to unit classification

@*param* `str` — Character string

@*return* — Unit classification
## subscribe_event

```lua
(method) Game:subscribe_event(event_type: y3.Const.EventType, ...any)
  -> any[]?
  2. Trigger.CallBack
  3. Unsubscribe: function
```

## switch_level

```lua
function Game.switch_level(level_id_str: py.Map)
```

Switch to level

@*param* `level_id_str` — checkpointID
## table_has_key

```lua
function Game.table_has_key(table: table, key: string)
  -> boolean
```

Whether the table has fields
## toggle_day_night_time

```lua
function Game.toggle_day_night_time(is_on: boolean)
```

Switch time lapse

@*param* `is_on` — Switch
## unreg_sound_area

```lua
function Game.unreg_sound_area(area: Area)
```

The nearby voice channel of the unregistered area

@*param* `area` — region
## world_pos_to_camera_pos

```lua
function Game.world_pos_to_camera_pos(world_pos: Point)
  -> x: number
  2. y: number
```

World coordinates Convert screen coordinates

@*param* `world_pos` — World coordinates

@*return* `x,y` — Screen coordinate
## world_pos_to_screen_edge_pos

```lua
function Game.world_pos_to_screen_edge_pos(world_pos: Point, delta_dis: number)
  -> x: number
  2. y: number
```

World coordinates convert screen edge coordinates

# Game.WindowMode

```lua
Game.WindowMode:
    | "full_screen" -- Full screen
    | "window_mode" -- Windowed
    | "window_mode_full_screen" -- Windowing full screen
```


```lua
"full_screen"|"window_mode"|"window_mode_full_screen"
```


