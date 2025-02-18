# Player

Player

## add

```lua
(method) Player:add(key: string|y3.Const.PlayerAttr, value: number)
```

Increment attribute value

@*param* `key` — Attribute name

@*param* `value` — 值
## add_global_save_data

```lua
(method) Player:add_global_save_data(key: string, value: integer)
```

Add global archive

@*param* `key` — 键

@*param* `value` — 值
## add_tech_level

```lua
(method) Player:add_tech_level(tech_type: py.TechKey, level: integer)
```

Upgrade technology

@*param* `tech_type` — Technological grade

@*param* `level` — Lv.
## create_unit

```lua
(method) Player:create_unit(unit_id: py.UnitKey, point?: Point, facing?: number)
  -> Unit
```

Create unit

@*param* `unit_id` — Unit type

@*param* `point` — unit

@*param* `facing` — orientation
## custom_event_manager

```lua
EventManager?
```

## display_info

```lua
(method) Player:display_info(msg: string, localize?: boolean)
```

Send hints to the player

@*param* `msg` — message

@*param* `localize` — Whether locale is supported
## display_message

```lua
(method) Player:display_message(message: string, localize?: boolean)
```

 Displays a text message to the player

@*param* `message` — message

@*param* `localize` — Whether locale is supported
## enable_vignetting

```lua
function Player.enable_vignetting(player: Player, is_enable: boolean)
```

@*param* `player` — Player

@*param* `is_enable` — Switch

Set the dark corner switch
## event

```lua
fun(self: Player, event: "Player - Join the game ", callback: fun(trg: Trigger, data: EventParam). Player - Join the game)):Trigger
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

## exit_game

```lua
(method) Player:exit_game()
```

 Quit the game
## get_achieve_point

```lua
(method) Player:get_achieve_point()
  -> integer|true
```

Get achievement points for the player's current map
## get_all_units

```lua
(method) Player:get_all_units()
  -> unit_group: UnitGroup
```

All units belonging to a player

@*return* `unit_group` — Unit group
## get_attr

```lua
(method) Player:get_attr(key: string|y3.Const.PlayerAttr)
  -> role_res: number
```

Get player attributes

@*param* `key` — Attribute name

@*return* `role_res` — Player attributes
## get_by_handle

```lua
function Player.get_by_handle(py_player: py.Role)
  -> Player
```

## get_by_id

```lua
function Player.get_by_id(id: integer)
  -> player: Player
```

Convert player ID to player

@*param* `id` — PlayerID

@*return* `player` — Player
## get_by_string

```lua
function Player.get_by_string(str: string)
  -> Player?
```

Get the player according to the string, the string is passed `tostring(Player)`
Or using the "Convert any variable to string" in ECA。
## get_camp

```lua
(method) Player:get_camp()
  -> py.Camp
```

## get_color

```lua
(method) Player:get_color()
  -> HEXcolour: string
```

Get player colors
## get_controller

```lua
(method) Player:get_controller()
  -> role_type: y3.Const.RoleType
```

Gets the player controller type

@*return* `role_type` — Type of player controller
## get_custom_event_manager

```lua
(method) CustomEvent:get_custom_event_manager()
  -> EventManager?
```

## get_exp_rate

```lua
(method) Player:get_exp_rate()
  -> exp_rate: number
```

Gain experience gain rate

@*return* `exp_rate` — Experience gain rate
## get_id

```lua
(method) Player:get_id()
  -> role_id_num: integer
```

Acquire playersID

@*return* `role_id_num` — PlayerID
## get_local

```lua
function Player.get_local()
  -> Player
```

 Get local players, be aware that this may cause out-of-sync！  
> Warning: Do not use this function if you are not sure what it is doing！

> Obsolete: Please use instead `y3.player.with_local`
## get_map_level

```lua
(method) Player:get_map_level()
  -> integer
```

Get the player's platform level for this map
## get_map_level_rank

```lua
(method) Player:get_map_level_rank()
  -> integer
```

Get the player's platform rank in the local chart
## get_mouse_pos

```lua
(method) Player:get_mouse_pos()
  -> point: Point
```

 Gets the point of the mouse in the game。
 Must be set `y3.config.sync.mouse = true`。

@*return* `point` — 点
## get_mouse_pos_x

```lua
(method) Player:get_mouse_pos_x()
  -> pos_x: number
```

Gets the X-coordinate of the mouse on the screen

@*return* `pos_x` — Xcoordinate
## get_mouse_pos_y

```lua
(method) Player:get_mouse_pos_y()
  -> pos_y: number
```

Gets the y coordinate of the mouse on the screen

@*return* `pos_y` — Ycoordinate
## get_mouse_ui_x_percent

```lua
(method) Player:get_mouse_ui_x_percent()
  -> x_per: number
```

Gets the percentage of the player's mouse screen coordinate X。
 Must be set `y3.config.sync.mouse = true`。

@*return* `x_per` — X% of
## get_mouse_ui_y_percent

```lua
(method) Player:get_mouse_ui_y_percent()
  -> y_per: number
```

Gets the percentage of the player's mouse screen coordinate y。
 Must be set `y3.config.sync.mouse = true`。

@*return* `y_per` — Y% of
## get_name

```lua
(method) Player:get_name()
  -> role_name: string
```

Get player name

@*return* `role_name` — Player name
## get_operation_key

```lua
(method) Player:get_operation_key(key: py.NormalKey, assist_key: py.RecordKey)
  -> shortcut: py.EditableGameFunc
```

Get the basic actions of the player in response to keyboard keystrokes (filter out the forbidden Settings)）

@*param* `key` — Key name

@*param* `assist_key` — Keyboard key

@*return* `shortcut` — Basic operation
## get_platform_icon

```lua
(method) Player:get_platform_icon()
  -> icon: string
```

Get the player platform avatar

@*return* `icon` — Platform avatar
## get_platform_icon_url

```lua
(method) Player:get_platform_icon_url()
  -> icon_url: string
```

Get the player platform avatar download address

@*return* `icon_url` — Platform avatar download address
## get_platform_id

```lua
(method) Player:get_platform_id()
  -> plat_aid: integer
```

Get player platform uniqueID

@*return* `plat_aid` — Platform uniqueID
## get_platform_level

```lua
(method) Player:get_platform_level()
  -> map_level: integer
```

Gain the player platform level

@*return* `map_level` — Level of platform
## get_platform_model

```lua
(method) Player:get_platform_model()
  -> model: py.ModelKey
```

Get the player platform appearance model

@*return* `model` — modelid
## get_platform_name

```lua
(method) Player:get_platform_name()
  -> name: string
```

Get the player's unique name

@*return* `name` — Attribute name
## get_platform_uuid

```lua
(method) Player:get_platform_uuid()
  -> string
```

Get player encryptionUUID
## get_played_times

```lua
(method) Player:get_played_times()
  -> integer
```

Gets the player's accumulated game count on the local graph
## get_rank_num

```lua
(method) Player:get_rank_num(key: integer)
  -> rank_num: integer
```

Get integer save player rank

@*param* `key` — On filekey

@*return* `rank_num` — Integer save player rank
## get_res_icon

```lua
function Player.get_res_icon(key: py.RoleResKey)
  -> icon: integer
```

Gets currency ICONS for player attributes

@*param* `key` — Attribute name

@*return* `icon` — iconid
## get_res_keys

```lua
function Player.get_res_keys(only_coin: boolean)
  -> py.RoleResKey[]
```

 Gets attribute names for all player attributes

@*param* `only_coin` — Only gets player attributes for currency types
## get_res_name

```lua
function Player.get_res_name(key: py.RoleResKey)
  -> name: string
```

Gets the player attribute name

@*param* `key` — Attribute name

@*return* `name` — Attribute name
## get_save_data_bool_value

```lua
(method) Player:get_save_data_bool_value(index: integer)
  -> bool_value: boolean
```

Boolean player save data

@*param* `index` — On filekey

@*return* `bool_value` — Boolean player save data
## get_save_data_float

```lua
(method) Player:get_save_data_float(key: integer)
  -> int_value: number
```

Real type archive data

@*param* `key` — On filekey

@*return* `int_value` — Real type archive data
## get_save_data_int

```lua
(method) Player:get_save_data_int(key: integer)
  -> int_value: integer
```

Gets integer archive data

@*param* `key` — On filekey

@*return* `int_value` — Integer archive data
## get_save_data_string

```lua
(method) Player:get_save_data_string(key: integer)
  -> str_value: string
```

String type player save data

@*param* `key` — On filekey

@*return* `str_value` — String player save data
## get_save_data_table

```lua
(method) Player:get_save_data_table(key: integer)
  -> table_value: table?
```

Tabular player save data

@*param* `key` — On filekey

@*return* `table_value` — Tabular player save data
## get_selecting_unit

```lua
(method) Player:get_selecting_unit()
  -> Unit?
```

## get_selecting_unit_group

```lua
(method) Player:get_selecting_unit_group()
  -> UnitGroup?
```

## get_state

```lua
(method) Player:get_state()
  -> role_status: y3.Const.RoleStatus
```

Get the player's game status

@*return* `role_status` — Player game state
See: [y3.Const.RoleStatus](file:///d%3A/y3-2/games/2.0/game/LocalData/Y3%E5%BA%93%E5%BC%80%E5%8F%913/maps/EntryMap/script/y3/game/const.lua#250#9)
## get_store_item_end_time

```lua
(method) Player:get_store_item_end_time(id: py.StoreKey)
  -> store_item_end_time: integer
```

Player platform item expiration time stamp

@*param* `id` — Platform itemid

@*return* `store_item_end_time` — Platform item expiration time stamp
## get_store_item_number

```lua
(method) Player:get_store_item_number(id: py.StoreKey)
  -> store_item_cnt: integer
```

The number of items on the player's platform

@*param* `id` — Platform itemid

@*return* `store_item_cnt` — Number of platform items
## get_team_id

```lua
(method) Player:get_team_id()
  -> camp_id: integer
```

Acquire teamID

@*return* `camp_id` — teamID
## get_tech_level

```lua
(method) Player:get_tech_level(tech_id: py.TechKey)
  -> tech_level: integer
```

Obtain technology grade

@*param* `tech_id` — Science and technologyid

@*return* `tech_level` — Technological grade
## handle

```lua
py.Role
```

Player
## id

```lua
integer
```

## is_achieve_unlock

```lua
(method) Player:is_achieve_unlock(id: string)
  -> boolean
```

Determines whether the specified achievement is unlocked
## is_enemy

```lua
(method) Player:is_enemy(player: Player)
  -> is_enemy: boolean
```

Whether the relationship between players is hostile

@*param* `player` — Player

@*return* `is_enemy` — Hostile relationship or not
## is_in_fog

```lua
(method) Player:is_in_fog(point: Point)
  -> is_point_in_fog: boolean
```

Whether a location is in the player's fog

@*param* `point` — 点

@*return* `is_point_in_fog` — Point in the fog
## is_in_group

```lua
(method) Player:is_in_group(player_group: PlayerGroup)
  -> is_in_group: boolean
```

The player is in the player group

@*param* `player_group` — Player group

@*return* `is_in_group` — The player is in the player group
## is_in_shadow

```lua
(method) Player:is_in_shadow(point: Point)
  -> is_point_in_shadow: boolean
```

Whether a location is in the player's black shadow

@*param* `point` — 点

@*return* `is_point_in_shadow` — Point in black shadow
## is_key_pressed

```lua
(method) Player:is_key_pressed(key: y3.Const.KeyboardKey|y3.Const.MouseKey)
  -> Whether it is pressed: boolean
```

Whether the player's button is pressed

@*param* `key` — key
## is_middle_join

```lua
(method) Player:is_middle_join()
  -> is_middle_join: boolean
```

Whether the player joins halfway

@*return* `is_middle_join` — Whether to join halfway
## is_operation_key_occupied

```lua
(method) Player:is_operation_key_occupied(key: py.NormalKey, assist_key: py.RecordKey)
  -> is_conf: boolean
```

Whether the player base action shortcuts are occupied
TODO:Function key lua layer indicates need to be processed

@*param* `key` — Key name

@*param* `assist_key` — Secondary key name

@*return* `is_conf` — Whether it is occupied
## is_visible

```lua
(method) Player:is_visible(point: Point)
  -> visible: boolean
```

Whether the player can see a location

@*param* `point` — 点

@*return* `visible` — Points are visible to the player
## key

```lua
integer?
```

## kick

```lua
(method) Player:kick(reason: string)
```

Forced kick

@*param* `reason` — Kick out cause
## kv_has

```lua
(method) KV:kv_has(key: string)
  -> boolean
```

 Whether the specified key - value pair is owned. Interwork with ECA。
## kv_key

```lua
string?
```

## kv_load

```lua
(method) KV:kv_load(key: string, lua_type: 'boolean'|'integer'|'number'|'string'|'table'...(+1))
  -> any
```

```lua
lua_type:
    | 'boolean'
    | 'number'
    | 'integer'
    | 'string'
    | 'table'
```
## kv_remove

```lua
(method) KV:kv_remove(key: any)
```

## kv_save

```lua
(method) KV:kv_save(key: string, value: KV.SupportType)
```

 Save custom key-value pairs. Interwork with ECA。
## object_event_manager

```lua
EventManager?
```

## open_platform_shop

```lua
(method) Player:open_platform_shop(id: py.StoreKey)
```

Request to purchase platform items

@*param* `id` — Platform itemid
## phandle

```lua
py.Role
```

Player
## ref_manager

```lua
unknown
```

## request_random_pool

```lua
(method) Player:request_random_pool(id: integer, callback: fun(code: 0|1|2|999, result: { [integer]: integer }))
```

Request execution of random pool drop
After the execution is complete, the callback function is called with the following parameters：
* `code`: Result code
  + `0`: Successful
  + `1`: The trigger interval is not met
  + `2`: The daily limit is not met
  + `999`: The server cannot connect and must be on the platform to test
* `result`: In the result table, 'key' represents the affected archive number and 'value' represents the changed value

@*param* `id` — Number of the random pool

@*param* `callback` — Callback function after execution
## select_unit

```lua
(method) Player:select_unit(unit_or_group: Unit|UnitGroup)
```

Select the unit/unit group

@*param* `unit_or_group` — Unit/unit group
## set

```lua
(method) Player:set(key: string|y3.Const.PlayerAttr, value: number)
```

Set attribute value

@*param* `key` — Attribute name

@*param* `value` — 值
## set_all_operation_key

```lua
(method) Player:set_all_operation_key(operation: py.AllGameFunc, is_enable: boolean)
```

Set the player's base action switch (contains all base actions)）
TODO:operationDescription on the lua layer to be sorted Method Name English to be confirmed

@*param* `operation` — Editable operation

@*param* `is_enable` — On or not
## set_color_grading

```lua
(method) Player:set_color_grading(value: integer)
```

 Set filter

@*param* `value` — filter
## set_exp_rate

```lua
(method) Player:set_exp_rate(rate: number)
```

Set the experience gain rate

@*param* `rate` — Experience gain rate
## set_follow_distance

```lua
(method) Player:set_follow_distance(distance: number)
```

Set following distance

@*param* `distance` — distance
## set_hostility

```lua
(method) Player:set_hostility(player: Player, is_hostile: boolean)
```

antagonize

@*param* `player` — Player

@*param* `is_hostile` — Whether hostile or not
## set_local_terrain_visible

```lua
(method) Player:set_local_terrain_visible(is_visible: boolean)
```

Show/hide the player's surface texture

@*param* `is_visible` — Show/hide
## set_mouse_click_selection

```lua
(method) Player:set_mouse_click_selection(is_enable: boolean)
```

Click on/off for the player

@*param* `is_enable` — Whether to open the mouse click
## set_mouse_drag_selection

```lua
(method) Player:set_mouse_drag_selection(is_enable: boolean)
```

Open/close the mouse box for the player

@*param* `is_enable` — Select whether to open the mouse box
## set_mouse_wheel

```lua
(method) Player:set_mouse_wheel(is_enable: boolean)
```

Turn the mouse wheel on/off for the player

@*param* `is_enable` — Whether to turn on the mouse wheel
## set_name

```lua
(method) Player:set_name(name: string)
```

Set name

@*param* `name` — Name
## set_operation_key

```lua
(method) Player:set_operation_key(operation: py.EditableGameFunc, key: py.NormalKey, assist_key: py.RecordKey)
```

Set the player's basic action shortcuts (filter out the forbidden Settings)） 
TODO:operationDescription on the lua layer to be sorted Method Name English to be confirmed

@*param* `operation` — Editable operation

@*param* `key` — Function key

@*param* `assist_key` — Auxiliary key
## set_role_vignetting_breath_rate

```lua
(method) Player:set_role_vignetting_breath_rate(circle_time: number)
```

Set the dark Angle breathing cycle

@*param* `circle_time` — Respiratory cycle
## set_strict_group_navigation

```lua
(method) Player:set_strict_group_navigation(is_strict: boolean)
```

Set group pathfinding strict mode

@*param* `is_strict` — Whether it is strict
## set_team

```lua
(method) Player:set_team(id: py.Camp)
```

Set up teamID
## set_tech_level

```lua
(method) Player:set_tech_level(tech_type: py.TechKey, level: integer)
```

Set technology level

@*param* `tech_type` — Technological grade

@*param* `level` — Lv.
## set_vignetting_change_range

```lua
(method) Player:set_vignetting_change_range(range: number)
```

Set the amplitude of the dark Angle change

@*param* `range` — range
## set_vignetting_color

```lua
(method) Player:set_vignetting_color(red: number, green: number, blue: number, time: number)
```

Set the dark corner color

@*param* `red` — colourr

@*param* `green` — colourg

@*param* `blue` — colourb

@*param* `time` — Transition time
## set_vignetting_size

```lua
(method) Player:set_vignetting_size(size: number)
```

Set the dark Angle size

@*param* `size` — size
## share_vision_of_unit

```lua
(method) Player:share_vision_of_unit(unit: Unit, share: boolean)
```

Get the unit's view

@*param* `unit` — unit
## share_vision_with_player

```lua
(method) Player:share_vision_with_player(target_player: Player, share: boolean)
```

Open your eyes to the player

@*param* `target_player` — Player
## storage_all

```lua
(method) Storage:storage_all()
  -> table
```

 Gets the container for storing data
## storage_get

```lua
(method) Storage:storage_get(key: any)
  -> any
```

 Gets the stored value
## storage_set

```lua
(method) Storage:storage_set(key: any, value: any)
```

 Store arbitrary values
## storage_table

```lua
table
```

## subscribe_event

```lua
(method) ObjectEvent:subscribe_event(event_name: string, ...any)
  -> any[]?
  2. Trigger.CallBack
  3. Unsubscribe: function
```

## type

```lua
string
```

## upload_save_data

```lua
(method) Player:upload_save_data()
```

Upload archive
## upload_tracking_data

```lua
(method) Player:upload_tracking_data(key: string, cnt: integer)
```

 Upload the buried data
## use_store_item

```lua
(method) Player:use_store_item(count: integer, item_id: py.StoreKey)
```

Cost the player platform items

@*param* `count` — number

@*param* `item_id` — Platform itemid
## with_local

```lua
function Player.with_local(callback: fun(local_player: Player))
```

Execute code in the local player environment。  
In development mode, this code is prevented from modifying upper values, modifying global variables, and calling synchronization functions, thus incurring additional overhead. Temporary failure）  
There is no detection on the platform and no additional overhead。

---


```lua
y3.player.with_local(function (local_player)
    -- Modifying the upper value in this callback function, modifying global variables, and calling the synchronization function will give warnings
    print(local_player)
end)
```

