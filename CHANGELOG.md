`2025-8-4`
+ Fixed the issue where some data might be lost when the data synchronized by 'y3.sync.send' contains sparse arrays

`2025-5-19`
+ `y3.save_data.save_integer` 'y3.save_data.add_integer' will verify whether the value is an integer

`2025-4-5`
+ Add interface：
  * `Player:is_alive` Determine if a player is alive (a real player who is playing the game)）
  * `y3.await.waitAll` The coroutine waits for multiple asynchronous functions to finish executing

`2025-3-26`
+ Add interface：
  * `Unit:create_force` Add traction
  * `(Unit|Item|Buff...):kv_serialize` Serialize custom key values
  * `(Unit|Item|Buff...):kv_deserialize` Deserialize custom key values
  * `y3.game.request_map_rank` Request the latest archived leaderboard data
  * `Player:update_save_rank` Update archive leaderboard
  * `y3.game.md5` Computed stringmd5
  * `y3.rsa` RSACorrelation interface
+ Track movement Add the following parameters：
  * `missing_distance` Target loss distance
  * `miss_when_target_destroy` Lost target when target destroyed
  * `on_miss` Call back when the target is lost

`2025-3-24`
+ Add interface：
  * `y3.camera.get_attr_real` Gets (local player) shot attributes (real number）
  * `y3.camera.get_attr_integer` Gets (local player) shot properties (integer）

`2025-3-4`
+ Add interface：
  * `y3.game.get_booked_number` Get the current number of map reservations

`2024-2-19`
+ append `y3.object.destructible`

`2024-2-18`
+ Add interface：
  * `Unit:set_name_show_type` Set how names are displayed (display unit name or player name）
  * `Item:set_name_show_type` Set how names are displayed (display unit name or player name）
  * `Unit:transformation` shapeshift

`2024-2-7`
+ Add interface：
  * `ItemGroup:pairs` Save the money and use 'pick' first
  * `ProjectileGroup:pairs` Save the money and use 'pick' first

`2025-1-20`
+ The engine provides an interface for registering the builder, which provides better performance and can be opened without modifying the builder.dict itself
+ Timer registration interface optimization to solve the leakage of old interface timers

`2025-1-15`
+ Add interface：
  * `y3.save_data.add_integer` Increase the player's save data (integer）
  * `y3.save_data.add_real` Increase the player's save data (real number）

`2025-1-13`
+ Remove event：
  * `Unit - general attack hit 'The event has long since been deprecated
  * `Unit - General attack causes damage 'This event has long since been abandoned and inactivated
+ `Unit:damage` You can use font parameters (same as floating text fonts)）
+ Added a new reader editor interface：
  * `y3.object.unit[12345].lua_data` It is used in a similar way to 'data', except that the type is automatically converted when a field is read or written. For example, a tuple whose original data type is python is automatically converted to a Lua array。

`2024-1-9`
+ Add interface：
  * `Player:get_sign_in_days` Get player sign-in days

`2024-1-2`
+ `y3.projectile.create` Added 'show_in_fog' option to display in fog

`2024-12-16`
+ Add interface：
  * `UnitGroup:pairs` Save the money and use 'pick' first
  * `PlayerGroup:pairs` Save the money and use 'pick' first

`2024-12-24`
+ Fixed an error reported for `clicli.road.get_path_areas_by_tag`

`2024-12-12`
+ Fixed an issue where 'Player:is_key_pressed' was invalid

`2024-12-9`
+ Add interface：
  * `Pool:merge` Consolidation pool

`2024-12-5`
+ When creating a new unit or skill set, you can pass in a table field specifying the new set
+ Add interface：
  * `Unit:get_casting_ability` Gets the ability that the unit is releasing

`2024-12-2`
+ Add interface：
  * `Ability:stop_cast` Stop casting
+ You can now immediately remove an ongoing spell

`2024-11-29`
+ Add event：
  * `Unit - About to pick up items`

`2024-11-26`
+ Keyboard events and mouse events can be directly passed strings

`2024-11-21`
+ Fixed an issue where 'clicli.area.get_polygon_areas_point_list' returned incorrect results

`2024-11-18`
+ Tracking motion added "initial Angle" and "transition time" parameters

`2024-11-14`
+ Fixed an issue where object events did not check for trigger validity

`2024-11-11`
+ `LocalUI:bind_unit_attr` Added 'accuracy' decimal precision parameter
+ Add interface：
  * `UI:set_text_format` Format text

`2024-11-8`
+ Optimized the overall performance of Lua

`2024-11-4`
+ Remove setting `y3.config.ui.get_removed_child`
+ Add interface：
  * `y3.game.request_time` To request the real time, you need to receive the result through the callback function

`2024-10-28`
+ Fixed an issue where events registered by catalog ID might not trigger
+ Add interface：
  * `Item:get_stack_type` Get stack type

`2024-10-25`
+ Fixed an issue where projectiles could not be used properly after object pooling was enabled
+ Fixed an issue where events registered through an object were not triggered strictly by object ID

`2024-10-24`
+ Fixed an issue where 'LinkedTable' could not be created in 'New' mode
+ Fixed an issue where objects were not removed when the GC container was removed and then added

`2024-10-23`
+ Support for performance analysis using 'Tracy' (a link to the documentation will follow)）
+ Add interface：
  * `enable_lua_profile` Enable 'Tracy' for performance analysis

`2024-10-12`
+ Add interface：
  * `Destructible:has_tag` Determine if the destructible has a label

`2024-10-11`
+ `y3.particle.create` Add field `detach`
+ Add interface：
  * `LocalTimer:set_remaining_count` Set remaining times
  * `LocalTimer:set_remaining_time` Set remaining time
  * `LocalTimer:set_time_out_time` Set timer period

`2024-10-10`
+ Add interface：
  * `Player:request_random_pool` Request execution of random pool drop
  * `Player:request_use_item` Request to use the mall item, after use through the callback function to notify whether successful
  * `Unit:change_model_texture` Modify model map

`2024-10-8`
+ A function 'set_exp' is added to the argument of the event 'Unit - before experience', which can be called to modify the experience value to be gained
+ `Unit:damage` New 'attack_type' and 'pos_socket' fields

`2024-9-27`
+ Add interface：
  * `Ability:prevent_cast` Stop a spell that is about to begin

`2024-9-26`
+ Add event：
  * `Unit - Approaching enemy`
  * `Unit - Spotted target`

`2024-9-25`
+ Saving 'nil' to an archived form field that disables overwriting will delete the field correctly。

`2024-9-23`
+ Add event：
  * `Screen - Video playback is complete`
+ Add Settings：
  * `y3.config.ui.get_removed_child = false` Whether the child control that has been removed can be obtained when the child control is obtained. The ECA behaves as if it can get it, but later operations on it will report an error）

`2024-9-20`
+ Fixed 'Fix32' returning 0 when passed to a large integerbug

`2024-9-14`
+ Add interface：
  * `Player:get_community_value` Get data on how players interact with the community

`2024-9-12`
+ `LocalUI:refresh_prefab` Add the 'on_refresh' callback to refresh the data when the child element is refreshed
+ Add event：
  * `Command - Attack move`
  * `Command - Sell items`
  * `Command - Cast abilities`
  * `command-patrol`
  * `command-move`

`2024-9-11`
+ Surround motion supports end height
+ Add interface：
  * `y3.game.load_sub_scene` Create terrain presets
+ Add event：
  * `Game - Terrain presets loaded complete`

`2024-9-10`
+ `UI:get_child` Deleted controls will not be retrieved
+ Add interface
  * `UI:set_input_field_not_focus` Make the input field lose focus

`2024-9-3`
+ Add event
  * `Player - Reconnect`

`2024-9-2`
+ 《Y3"Development Assistant" dashboard under 'time' added to modify the game speed, pause the game

`2024-8-30`
+ Add event
  * `Interface - Equipment drag and drop`

`2024-8-28`
+ Add interface
  * `UI:set_scrollview_scroll` Set the list to allow/disable scrolling
  * `Player:get_platform_icon_url` Get the player platform avatar download address
  * `UI:set_image_url` Setup picture (from the web）

`2024-8-23`
+ Surround motion supports height

`2024-8-15`
+ Points support the z-axis

`2024-8-5`
+ Fixed 'Local-Select-Unit' event unable to get selected unitsBUG

`2024-8-2`
+ Add option：
  * `y3.config.cache.ui = true`，When enabled, the UI's child control relationships are cached. This option can be enabled only if the map does not operate the UI in the ECA。

`2024-7-25`
+ Provides enumerations for arguments to 'clicli.ui.play_timeline_animation'

`2024-7-24`
+ Add event：
  * `Selected - Lost unit`
  * `Local - Selected - Lost unit`
  * `Local-interface-input box gets focus`
  * `Local-interface-input box out of focus`
  * `Local - Interface - Input box content changed`

`2024-7-22`
+ Fixed 'Interface - Slider Change' event not firingbug
+ Change the log folder from 'log' to `.log`
+ Add event：
  * `Game - Logic is out of sync`
+ Add interface：
  * `y3.fs.load` Read files in the 'script' directory
  * `y3.fs.save` Save the file to the 'script' or 'custom' directory

`2024-7-17`
+ Add interface：
  * `y3.reload.isReloading` Determines whether you are currently in the process of reloading Lua

`2024-7-15`
+ Fixed an error in eca calling the lua chronograph

`2024-7-12`
+ Add interface：
  * `y3.helper.py_dict` Convert a Lua table into a python dictionary

`2024-7-5`
+ Add interface：
  * `y3.helper.number_type` Determine number type

`2024-7-1`
+ Table archives that disable overwriting can save empty tables in fields
+ `Unit:add_buff` Add a 'data' field to save custom data
+ Add interface：
  * `Player:upload_tracking_data` Upload the buried data
  * `Player:get_map_level` Get map rank
  * `Player:get_map_level_rank` Get rank
  * `Player:get_played_times` Obtain the cumulative number of innings
  * `Player:get_achieve_point` Earn achievement points
  * `Player:is_achieve_unlock` Judge achievement unlock
  * `Projectile:set_visible` Sets whether projectiles are visible
  * `y3.camera.get_by_res_id` Get the lens placed on the scene
  * `Camera:apply` Application lens
  * `UIPrefab:kv_save`
  * `UIPrefab:kv_load`
  * `UIPrefab:kv_has`
  * `UIPrefab:kv_remove`
+ Add event：
  * `Interface - Slider changes`
  * `Interface - Chat box visibility changes`
  * `Screen - Check box changes`

`2024-6-27`
+ `y3.sync.onSync` The callback function passes in the player who initiated the synchronization
+ Add interface：
  * `UI:insert_ui_gridview_comp` Add the UI to the grid list
  * `UI:set_ui_gridview_type` Set the grid list layout
  * `UI:set_ui_gridview_count` Set the number of rows in the grid list
  * `UI:set_ui_gridview_size` Sets the width and height of the grid list cells
  * `UI:set_ui_gridview_margin` Set the grid list margin
  * `UI:set_ui_gridview_space` Set the grid list cell spacing
  * `UI:set_ui_gridview_align` Set the grid list alignment
  * `UI:set_ui_gridview_scroll` Set the grid list to enable/disable scrolling
  * `UI:set_ui_gridview_size_adaptive` Set mesh list Enable/Disable size change with content
  * `UI:set_ui_gridview_bar_percent` Set the percentage of horizontal/vertical jumps in the grid list
  * `UI:set_ui_comp_parent` Sets the parent control of an interface control
  * `UI:clear_ui_comp_image` Clear the UI control picture
+ Add event：
  * `Local - Keyboard - Press`
  * `Local - Keyboard - Lift`
  * `Local - Mouse - Press down`
  * `Local - Mouse - Lift`
  * `Local - Mouse - Double click`
  * `Local - Mouse - Press the unit`
  * `Local - mouse - lift unit`
  * `Local - Mouse - Double click the unit`
  * `Local - Mouse - Move`
  * `Local - Mouse - Wheel`
  * `Local - Mouse - Hover`
  * `Local - Select - Unit`
  * `Local - Select - Cancel`
  * `Local - Select - Destructible`
  * `Local - Select - Items`
  * `Local - Select - Unit Group`

`2024-6-24`
+ `Unit:follow` Add more parameters
+ Add interface：
  * `y3.ui.create_floating_text2` Create floating text (jump word）

`2024-6-24`
+ Add interface：
  * `y3.item.get_tags_by_key` Get all labels for the item

`2024-6-19`
+ Add interface：
  * `Trigger:add_tag`
  * `Trigger:has_tag`
  * `Trigger:remove_tag`

`2024-6-12`
+ Calling methods after the object has been deleted will no longer result in an error
+ Add Settings：
  * `y3.config.logic_frame = 30 --The default is', if your map has changed the logical frame rate, you need to change this setting

`2024-6-11`
+ `y3.game.get_table` Add optional parameters to convert the Fix32 type in the table tonumber
+ `y3.beam.ceate` Adds the 'follow_scale' parameter, only if the starting point is a unit
+ Add event：
  * `Player - platform item changes`
  * `Player - Platform mall window changes`
+ Add interface：
  * `UI:set_ui_model_unit` Sets the unit of the model control
  * `Point:get_random_point` Gets random points in the range
  * `Selector:in_range` Round range selection, easier to write
  * `Selector:pick` Let's choose an array of units, so it's easier to write
  * `Selector:ipairs` Pick and iterate, make it easier to write
  * `Selector:sort_type` Set the selection order, the options are "from near to far", "from far to near", "random""`

`2024-6-7`
+ Added instruction '.rr 'to restart the game
+ Add interface：
  + `y3.reload.recycle` You can easily specify the code that needs to be repeated and the garbage to be collected when hot overloading
  + `y3.develop.helper.createTreeView` You can create your own view in the "Custom view" of CliCli-Helper, see the demonstration for specific usage: 'clicli\demo\CliCli-Helper\Custom view.lua`

`2024-6-5`
+ `y3.object` The library added support for projectiles
+ Add interface：
  * `Projectile:bindGC`

`2024-6-4`
+ Add interface：
  * `Player:get_store_item_end_time` Get the platform item expiration timestamp
  * `Player:open_platform_shop` Request to purchase platform items
+ Fixed an error that might be reported when saving the archivebug
+ Fix 'Object:kv_remove' errorbug

`2024-6-3`
+ Add interface：
  * `UI:set_anim_rotate` Set animation rotation
  * `Player:get_platform_uuid` Get player uniqueID

`2024-5-30`
+ Add interface：
  * `Buff:add_cycle_time` Add cycle
  * `Buff:set_cycle_time` Set cycle

`2024-5-29`
+ Add interface：
  * `Ability:get_item` Get the skill on which item
  * `Ability:get_max_cd` Gain skills MaxCD

`2024-5-28`
+ A new event registration method has been added to the object registry, consistent with other event registration methods
  ```lua
  y3.object.unit[134274912]:event('Unit-AfterTakingDamage', function (trg, data)
      print('When such units take damage', data.damage)
  end)
  ```

`2024-5-17`
+ Add interface：
  * `y3.base64.encode` Encodes the string asbase64
  * `y3.base64.decode` Decode base64 as a string
  * `y3.aes.encrypt` The aes algorithm is used to encrypt the string
  * `y3.aes.decrypt` The aes algorithm is used to decrypt the string

`2024-5-16`
+ `LocalUILogic` Add the 'on_init' method to subscribe to control initialization

`2024-5-15`
+ Fixed box item selection errorbug
+ Add interface：
  * `Trigger:disable_once` Disable this trigger for this event (generally to avoid accidental reentrant of the current trigger)）

`2024-5-10`
+ Add interface：
  * `Ability:add_tag` Label skills
  * `Ability:remove_tag` Untag skills
  * `Ability:has_tag` Determine if a skill has a label

`2024-5-9`
+ The built-in debugger for CliCli-Helper is supported, and the Lua debugger in the plugin market is no longer loaded
+ `Unit:add_item` You can specify the slot type
+ Fixed 'Unit - dying event' being an object event when the object was not correctBUG

`2024-5-6`
+ Added the 'Client timer' module (`clicli.ctimer`), which is a purely asynchronous timer driven by the local CPU, even when the game is paused。
  * `y3.ctimer.wait`
  * `y3.ctimer.loop`
  * `y3.ctimer.loop_count`
  * `y3.ctimer.wait_frame`
  * `y3.ctimer.loop_frame`
  * `y3.ctimer.loop_count_frame`

`2024-4-29`
+ `y3.item.get_item_buy_price` And 'clicli.item.get_item_sell_price_by_key' support directly using the player attribute display name as a parameter
+ `print` In development mode it will always print to the screen and is no longer affected by 'clicli.config.log.toGame'
+ Fixing some items related to the method reported errorbug
+ Added an ECA-related interface：
  * `y3.eca.def` Define a function for ECA to call (before 'ECAFunction' wrapper）
  * `y3.eca.call` Invoke custom events in the ECA ("CliCli-Helper" version required >= 1.1.0）

`2024-4-28`
+ `kv_save` Series functions support the 'UnitGroup' type

`2024-4-24`
+ Added 'clicli.network' library, can be used as a client socket connection, specific usage refer to [demo](./demo/network.lua)
+ `Unit:add_buff` The default duration is' -1 '(unlimited), the same as in ECA
+ After the repair object is actively deleted by the engine, it will not trigger 'bindGC'bug

`2024-4-22`
+ Fixed an issue where 'Player:get_exp_rate' would report errors
+ Add event：
  * `Check - cancel`

`2024-4-19`
+ The person being treated and the source of treatment are added to the callback parameters for treatment-related events

`2024-4-16`
+ Unit properties support directly filling in the name of a custom property (requires CliCli-Helper >= 0.7.0）

`2024-4-15`
+ Fixed bugs where 'Player - holding platform item' and 'player - using platform item' could not trigger. These two events now do not require incoming itemsID

`2024-4-12`
+ Add interface：
  * `UIPrefab:get_child` Gets the UI object of the component
  * `Unit:get_ability_by_seq` Gets the skill object according to the sequence
+ Fixed 'clicli.scene_ui.create_scene_ui_at_player_unit_socket' invalidbug
+ Fixed 'Skill - Open indicator' and 'skill - Close Indicator' events not registering on skill objectsbug

`2024-4-8`
+ Add interface：
  * `Unit:get_camp_id` Get units for the teamid
  * `Player:get_selecting_unit` Get the player's selected unit
  * `Player:get_selecting_group` Gets the player's selected unit group
  * `Ability:get_description` Get skill description
  * `Ability:get_icon` Get skill icon
  * `UI:set_absolute_pos` Sets the absolute coordinates of the control
+ Add a tool class 'LocalUILogic' to bind logic to * local controls *, please refer to 'clicli\demo\demo\interface`

`2024-4-7`
+ The interface related to unit attributes can use Chinese attribute names and Chinese attribute types
  * `Unit:set_attr`
  * `Unit:add_attr`
  * `Unit:add_attr_gc`
  * `Unit:get_final_attr`
  * `Unit:get_attr_other`
  * `Unit:get_attr_base`
  * `Unit:get_attr_base_ratio`
  * `Unit:get_attr_bonus`
  * `Unit:get_attr_all_ratio`
  * `Unit:get_attr_bonus_ratio`
+ Add interface：
  * `Unit:get_attr` Uniform interface for obtaining unit properties
  * `UI:bind_unit_attr` Replace the previously named interface with a problem `UI:bind_player_attribute`

`2024-4-3`
+ `y3.player.with_local` Disable behavior detection temporarily and change the implementation mode later
+ Add interface
  * `Unit:get_icon` Get the unit's avatar

`2024-3-19`
+ Fixed an object where casting class events could not be triggeredbug

`2024-3-18`
+ Add interface
  * `y3.unit_group.create` Create an empty unit group (available after update on March 28)）
  * `y3.player_group.create` Create an empty player group (available after update on March 28)）
  * `PlayerGroup:count()` Gets the number of players in the player group

`2024-3-15`
+ Add interface:
  * `y3.game:request_url` Send an http request
+ Add event:
  * `Game -http return`

`2024-3-14`
+ Fixed object removal class event could not be triggeredbug

`2024-3-13`
+ Fixed accidentally overloading global triggers and timers in B after using 'require 'B' in' include 'A'bug

`2024-3-6`
+ Add interface:
  * `y3.unit.get_by_string` Restores' tostring(Unit) 'to a unit object
  * `y3.player.get_by_string` Restores' tostring(Player) 'to a unit object

`2024-3-4`
+ `Object:kv_save` With 'Object:kv_load' supported values for tables
+ UIThe event enumeration item is modified：
  * `Left - hold ': Discard
  * `Right click - hold ': Discard
  * `Left - click ': Add
  * `Right - click ': Add

`2024-2-28`
+ Add interface:
  * `Unit:set_move_channel_land` Set the movement type of the unit to ground
  * `Unit:set_move_channel_air` Set the movement type of the unit to air
  * `Unit:set_move_collision` Sets whether the unit counts a collision type
  * `Particle:set_color` Set effects color
  * `Particle:set_visible` Set effects display

`2024-2-26`
+ Add Settings：
  * `y3.config.log.toFile` Whether to print logs to log files. The default value is `true`
  * `y3.config.log.toConsole` Whether to print logs to the console. The default value is `true`

`2024-2-22`
+ Add interface：
  * `y3.game.on_client_tick(callback)` The client calls back events per frame

`2024-2-19`
+ Added interfaces related to data synchronization：
  * `y3.sync.send` Synchronize data to all players
  * `y3.sync.onSync` Register the callback after data synchronization

`2024-2-6`
+ Mouse events on the interface support right-clicking events

`2024-1-25`
+ Add interface：
  * `PlayerGroup:clear()` Clear player group
  * `UnitGroup:clear()` Empty unit group

`2024-1-24`
+ Fixed particle may not be visible when creating effects without passing timebug

`2024-1-22`
+ Add interface：
  * `Player:get_color` Gets the player color string

`2024-1-19`
+ Add interface：
  * `y3.game.get_obj_icon` Get ICONS for units, items, skills, and magic effects

`2024-1-15`
+ Sports add field：
  * `hit_interval` Collision with the same unit interval
  * `block_interval` The interval of the collision terrain
+ Fixed a bug where 'Buff:get_owner' would report an error if the buff had been removed. This method may now return `nil` 。
+ Fixed hot reload not maintaining file load orderbug

`2024-1-12`
+ Fix 'clicli.game.send_custom_event' is invalidbug

`2023-12-25`
+ Add interface：
  * `y3.game.get_current_server_time()` Returns the current server time

`2023-12-21`
+ Fix allows overwriting of archive forms that are not automatically saved after modificationbug

`2023-12-15`
+ Fixed an issue where 'ProjectileGroup:pick' reported errors

`2023-12-14`
+ The following interfaces can now use names in the editor as arguments：
  * `y3.scene_ui.create_scene_ui_at_point`
  * `y3.scene_ui.create_scene_ui_at_player_unit_socket`

`2023-12-13`
+ Add interface：
  * `UI:set_equip_slot_use_operation` Sets how items operate
  * `UI:set_equip_slot_drag_operation` Set item drag and drop mode

`2023-11-29`
+ Fixed 'Game - Message' event without passing in event IDbug。

`2023-11-28`
+ Instead of the game-Start event, use the Game-Initialize event。
+ The [Lua virtual machine](./doc/Lua virtual machine.md) document is added。

`2023-11-24`
+ Support for reading and writing custom properties of the object (including those pre-configured in the object)）：
  ```lua
  --134274912For "Guan Yu"ID
  y3.object.unit[134274912]:kv_has('Custom attribute')
  y3.object.unit[134274912]:kv_load('Custom property ', 'number') - read with type number
  y3.object.unit[134274912]:kv_save('Another attribute ', 'some string')
  ```

`2023-11-23`
+ The log is now written to 'script/log/lua_player01.log'. When running on the platform, it is written to '<MAP>/custom/lua_player01.log'. When opened multiple times, the client will generate different logs according to its local player serial number。

`2023-11-21`
+ Repair curve motion does not workbug

`2023-11-10`
+ Add interface：
  * `UI:set_anim_pos`
+ Fixed 'clicli.object.item[key].on_add' invalidbug

`2023-11-9`
+ Fix 'initialconfig.bat' did not recursively copy files correctlybug

`2023-11-8`
+ `ECAFunction` Supports automatic conversion of real number arrays
+ Supports modification of object compilation data：
  ```lua
  local M = y3.object.unit[134274912] -- Guan Yu

  M.data.name = 'This is the changed name'
  ```

  For details, please refer to 'demo/Article Compilation'`

`2023-11-7`
+ Add interface：
  * `Unit:is_hero` Determine if the unit's class is a hero
  * `Ability:pre_cast` Set the skill to aim
+ `Unit:damage` Parameter field addition `text_track`
+ Fix 'UI:to_string' return value type is not stringbug

`2023-11-6`
+ Export all interfaces as markdown files and store them `doc/doc.md`
+ Fixed a bug in 'Demo/ECA calls Lua function' (' args' in ECA code was written incorrectly `arg`）


`2023-11-3`
+ The following types can now be managed by Lua, so they can use object events and store data：
  * `Ability` - skill
  * `Area` - region
  * `Cast` - conjure

`2023-10-27`
+ `UI:add_event` Supports incoming custom data, which can be obtained in the 'interface - message' event
+ Add interface：
  * `y3.dump.encode`
  * `y3.dump.decode`

`2023-10-24`
+ Add interface：
  * `y3.save_data.save_table`

`2023-10-20`
+ Add archive module
  * `y3.save_data.load_boolean`
  * `y3.save_data.save_boolean`
  * `y3.save_data.load_integer`
  * `y3.save_data.save_integer`
  * `y3.save_data.load_real`
  * `y3.save_data.save_real`
  * `y3.save_data.load_string`
  * `y3.save_data.save_string`
  * `y3.save_data.load_table`
+ Fixed 'Item:is_in_scene' reporting an error when the item was removedbug
+ Fixed 'Unit:move_to_pos' would report an error if the second parameter was not passedbug

`2023-10-19`
+ Add a local timer module
  * `y3.ltimer.wait`
  * `y3.ltimer.loop`
  * `y3.ltimer.loop_count`
  * `y3.ltimer.wait_frame`
  * `y3.ltimer.loop_frame`
  * `y3.ltimer.loop_count_frame`

`2023-10-12`
+ Regions support persistence
+ Fixed an error when creating a regionbug
+ Fixed selection unit unavailablebug

`2023-10-11`
+ Fix event leak

`2023-10-10`
+ The bound trigger is automatically removed when the region is removed
+ The debugger ADAPTS the 'Lua Debug 2.X' version
+ Add the following interfaces：
  * `y3.buff.get_by_id`
  * `y3.game:set_object_fresnel_visible`
  * `y3.game:set_object_fresnel`

`2023-10-9`
+ Add the following interfaces:
  * `Player:kv_save`
  * `Player:kv_has`
  * `Player:kv_load`

`2023-10-7`
+ Add the following interfaces：
  * `UI:set_anim_opacity`
  * `Unit:attr_to_name`
  * `Unit:attr_pick`

`2023-9-27`
+ This file will not be hot reloaded after fixing the file loading errorbug
+ Fix the following interface return value is not numericbug：
  * `Timer:get_elapsed_time`
  * `Timer:get_remaining_time`
  * `Timer:get_time_out_time`
+ Add the following interfaces：
  * `Ability:get_level() -> integer`

`2023-9-26`
+ Support for registering interface, button and mouse events on the player

`2023-9-25`
+ Support for registering skill events and effect events on units

`2023-9-16`
+ Rename the following interfaces：
  * `Ability:is_destory` -> `Ability:is_exist`: The previous name did not match the reality

`2023-9-15`
+ Added interface：
  * `UI:is_removed`
+ Remove the following events：
  * `Interface - Create ': This event was previously invalid
  * `Interface - Remove ': This event was previously invalid

`2023-9-13`
+ Added Settings：
  * `y3.config.log.logger`：You can set up a custom log handler function that returns' true 'to block the original log flow

`2023-9-11`
+ Supports reading and writing custom key values from entities (interworking with ECA)）
  * Add a series of interfaces in the format of：
    - Save custom key values：`unit:kv_save('ABC', buff)`
    - The user-defined key exists：`unit:kv_has('ABC')`
    - Read from defined key values：`unit:kv_load('ABC', 'Buff')`
  * Container objects that support reading and writing (to whom they are saved) are currently contained：
    - `Ability`
    - `Buff`
    - `Destructible`
    - `Item`
    - `Projectile`
    - `Unit`
    - `Area`
  * What values are currently contained (what is saved) that support reading and writing：
    - `boolean`
    - `integer`
    - `number`
    - `string`
    - `Unit`
    - `Ability`
    - `Item`
    - `Buff`
    - `Point`
    - `Player`
    - `Projectile`
    - `Destructible`
    - `Particle`
    - `Mover`

`2023-9-8`
+ Rename the following interfaces：
  * `y3.ui_prefab.create_ui_prefab_instance` -> `y3.ui_prefab.create`
  * `UIPrefab:remove_ui_prefab` -> `UIPrefab:remove`

`2023-9-5`
+ The following interfaces are added：
  * `y3.timer.wait_frame`
  * `y3.timer.loop_frame`
  * `y3.timer.count_loop_frame`
+ Remove the following events：
  * `Time - after ', switch `y3.timer.wait`
  * `Time - period ', use instead `y3.timer.loop`
  * `Time - After frame ', switch `y3.timer.wait_frame`
  * `Time - period frame ', instead `y3.timer.loop_frame`

`2023-9-4`
+ Rename the following interfaces：
  * `y3.game.get_num_of_item_mat` -> `y3.item.get_num_of_item_mat`
  * `y3.game.get_num_of_player_attr` -> `y3.item.get_num_of_player_attr`
+ The following interfaces are removed：
  * `y3.game.api_has_kv_any`
  * `y3.game.get_server_year`，Switch to `os.date`
  * `y3.game.get_server_month`，Switch to `os.date`
  * `y3.game.get_server_day`，Switch to `os.date`
  * `y3.game.get_server_hour`，Switch to `os.date`
  * `y3.game.string_gsub`，Switch to `string.gsub`
+ Repair：
  * Unit-death events registered as objects cannot fire properly

`2023-9-1`
+ Added back `y3.game.send_custom_event`
+ Rename the following interfaces：
  * `y3.game.set_cure_value` -> `HealInstance:set_heal`
+ The following interfaces are removed：
  * `y3.game.request_server_time`
  * `y3.game.get_client_player`，Switch to `y3.player.get_local`

`2023-8-31`
+ Added event：
  * `Mouse - Hover ': Hover to enter or leave will trigger
+ The following interfaces are removed：
  * `y3.game.number_to_str`，Switch to `tostring`
  * `y3.game.list_loop`，Switch to `y3.helper.wrap_list`
  * `y3.game.set_lua_var`
  * `y3.game.get_lua_var`
  * `y3.game.init_lua_var`
  * `y3.game.send_custom_event`
  * `y3.game.is_in_radius`，Switch to `Unit:is_in_radius`
  * `y3.game.any_var_to_str`
+ Rename the following interfaces：
  * `y3.helper.wrap_list` -> `y3.helper.unpack_list`
  * `y3.helper.unwrap_list` -> `y3.helper.pack_list`
  * `y3.game.iter_role_res` -> `y3.player.get_res_keys`
  * `y3.game.exit_game` -> `Player:exit_game`
  * `y3.game.is_exist_key` -> `y3.game.table_has_key`

`2023-8-29`
+ Modified the implementation of hot reload to make it compatible with "independent process running game". Non-overheat overloading does not work in this mode, use "Run the game in the editor" instead。
+ Repair：
  * `Unit:add_ability` Report an error
  * `y3.beam.create` Report an error（#110）

`2023-8-28`
+ The following interfaces are renamed
  * `Ability:get_ability_id` -> `Ability:get_key` Consistent with other similar methods
+ You can batch specify events for objects of a certain type
  ```lua
  local m = y3.object.ability[134221924]

  function m.on_cast_start(ability, cast)
      log.debug(('The spell begins with the skill %s and the target：%s'):format(ability:get_name(), cast:get_target_unit()))
  end

  function m.on_cast_stop()
      log.debug('End of spell')
  end
  ```
+ Will automatically determine whether the current is a test mode, you can also use 'clicli.game.is_debug_mode()' to determine。
+ In test mode, the built-in test instructions (case sensitive) are enabled）：
  * `.RD` - Overloaded script
  * `.SS` - Print all live objects in Lua and save the results in 'clicli/log/snapshot.txt'
  * `.CT` - Prints all alive objects in Lua and their reference paths, and saves the result in 'clicli/log/catch.txt'

`2023-8-24`
+ Try to use message mode for object events
+ Map configuration addition：
  * `y3.const.log.level = 'debug'` - If you set the log level, only logs with a higher level are displayed。
  * `y3.const.log.toDiaglog = true` - Whether to print logs to the Diaglog window
  * `y3.const.log.toGame = false` - Whether to display the log in the game window

`2023-8-23`
+ ClassA major change to the library, in order to distinguish from common methods and to spell easily, renamed these methods with special features：
  * `constructor` -> `__init`
  * `destructor` --> `__del`
  * `alloc` --> `__alloc`

`2023-8-18`
+ Support engine object events, such as
  * `Unit:event('Unit - Death', callback)`
  * `Area:event('zone-access', callback)`

`2023-8-17`
+ Some hot reloads are supported, see Demo/Hot Reload/Demo.lua`。
  * Tip: If you want to leave it entirely up to the configuration to determine which files can be overridden, you can add a line `require = include`

`2023-8-15`
+ Hot reload is supported, see Demo/Hot Reload/Demo.lua`
+ The following interfaces are added：
  * `include` For hot overload
  * `y3.develop.command.register(callback)`
+ The following configuration was added：
  * `y3.config.debug = true` - Enable development mode to allow the use of features such as test instructions. At present, you need to manually set to 'true' to enable, the future default will automatically determine whether to enable the current running environment。

`2023-8-14`
+ The following interfaces are added：
  * `Unit:exchange_item(item, type, index)`

`2023-8-9`
+ Added a custom event-related interface：
  * `y3.game:event_on`
  * `y3.game:event_notify`
  * `y3.game:event_notify_with_args`
  * `y3.game:event_dispatch`
  * `y3.game:event_dispatch_with_args`
  * `Ability:event_on`
  * `Ability:event_notify`
  * `Ability:event_notify_with_args`
  * `Ability:event_dispatch`
  * `Ability:event_dispatch_with_args`
  * `Buff:event_on`
  * `Buff:event_notify`
  * `Buff:event_notify_with_args`
  * `Buff:event_dispatch`
  * `Buff:event_dispatch_with_args`
  * `Item:event_on`
  * `Item:event_notify`
  * `Item:event_notify_with_args`
  * `Item:event_dispatch`
  * `Item:event_dispatch_with_args`
  * `Unit:event_on`
  * `Unit:event_notify`
  * `Unit:event_notify_with_args`
  * `Unit:event_dispatch`
  * `Unit:event_dispatch_with_args`
  * `Player:event_on`
  * `Player:event_notify`
  * `Player:event_notify_with_args`
  * `Player:event_dispatch`
  * `Player:event_dispatch_with_args`

`2023-8-8`
+ Map configuration addition：
  * `y3.const.sync.key = true` - Key synchronization is enabled. The player's keyboard and mouse key status can be obtained only after it is enabled
+ The following interfaces are added：
  * `Ability:storage_set(k, v)`
  * `Ability:storage_get(k, v)`
  * `Mover:storage_set(k, v)`
  * `Mover:storage_get(k, v)`
  * `Unit:bindGC(obj)`
  * `Item:bindGC(obj)`
  * `Buff:bindGC(obj)`
  * `Ability:bindGC(obj)`
  * `Mover:bindGC(obj)`
+ Modify the name of the following interface：
  * `Player:get_ui_pos_x` -> `Player:get_mouse_pos_x`
  * `Player:get_ui_pos_y` -> `Player:get_mouse_pos_y`
  * `y3.game.player_keyboard_key_is_pressed` -> `Player:is_key_pressed`
  * `y3.game.check_tech_key_precondition` -> `y3.technology.check_precondition_by_key`
  * `y3.game.get_text_config` -> `y3.game.locale`
  * `Point:set_collision` -> `y3.ground.set_collision`
  * `Point:get_ground_collision` -> `y3.ground.get_collision`
  * `Point:get_view_block_type` -> `y3.ground.get_view_block_type`
  * `y3.game.get_point_ground_height` -> `y3.ground.get_height_level`
  * `y3.game.get_random_seed` -> `y3.math.get_random_seed`
+ The following interfaces are removed：
  * `y3.game.player_mouse_key_is_pressed`，This functionality has been merged into 'Player:is_key_pressed'
  * `y3.game.print_to_dialog`，Please change to... `log.info`/`log.debug`/`log.warn`/`log.error`
  * `y3.game.test_show_message_tip`
  * `y3.game.test_log_message`
  * `y3.game.test_add_log_assert_result`
  * `y3.game.joint_string`，Use Lua's string concatenation syntax instead
  * `y3.game.extract_string`，Switch to `string.sub`
  * `y3.game.delete_sub_string`，Switch to `string.gsub`
  * `y3.game.get_random_pool_probability`
  * `y3.game.get_int_value_from_random_pool`
  * `y3.game.get_random_pool_all_weight`
  * `y3.game.get_random_pool_size`
  * `y3.game.get_random_pool_pointed_weight`

`2023-8-7`
+ Added map configuration function, currently available configuration as：
  * `y3.config.sync.mouse = true` - Enable mouse sync. The player's mouse position can only be obtained after it is enabled
  * `y3.config.sync.camera = true` - Enable lens sync, after enabling to get the player's lens orientation and center point position

`2023-8-4`
+ The following interfaces are added：
  * `y3.ui.set_cursor(player, state, key)`
+ Repair：
  * `Buff:set_shield`, `Buff:add_shield` Report an error（#54）

`2023-8-3`
+ The following interfaces are added：
  * `Player:storage_set(k, v)`
  * `Player:storage_get(k)`
  * `Item:storage_set(k, v)`
  * `Item:storage_get(k)`
  * `Buff:storage_set(k, v)`
  * `Buff:storage_get(k)`
+ Repair：
  * `Area:get_all_unit_in_area` Report an error（#69）

`2023-8-2`
+ The following interfaces are added：
  * `Timer:execute(...)`
  * `Unit:storage_set(k, v)`
  * `Unit:storage_get(k)`
+ A reference to 'Unit' is now maintained, and a 'Unit' object for the same unit is always the same
+ Repair：
  * Getting the 'from_unit' field in the event callback parameter results in an error（#59）

`2023-8-1`
* `Unit:add_buff` Will now return `Buff?`
* The following interfaces are added：
  * `UI:set_follow_mouse`
* Added the 'Sound' class
* Remove the Sound related interface in 'clicli.game' and use the methods in the 'sound' class instead
  * `y3.game.play_sound_for_player` -> `y3.sound.play`
  * `y3.game.stop_sound_for_player` -> `Sound:stop`
  * `y3.game.play_3d_sound_for_player` -> `y3.sound.play_3d`
  * `y3.follow_object_play_3d_sound_for_player` -> `y3.sound.play_with_object`
  * `y3.set_sound_volume` -> `Sound:set_volume`

`2023-7-31`
* Fixed an issue where the collision unit event of the Kinetor could not get collision units。
* Add 'damage_instance' to the callback parameter of the damage event, you can modify the damage through the method of this object, modify whether to dodge, etc。
* The field in the event callback parameter of type 'py.Fixed' is now of type 'number'。
* `UI:get_child` Getting a control that doesn't exist will return 'nil' (previously it was an error), now you need to empty it yourself。

`2023-7-28`
* Added a new class 'Cast', which can obtain the target, direction, and other information of a cast on this object。
* Remove the interface related to obtaining the casting target in the Ability class, they did not work properly before。
* New field in callback parameter of cast event `cast: Cast`
* The following interfaces are removed
  * `Ability` Class to get the interface related to the casting target, use the related interface in the 'Cast' class. The 'Cast' object is used as a callback parameter in events related to casting。
  * `y3.math.get_points_angle`，Switch to `Point:get_angle_with()`
  * `y3.math.get_two_points_distance`，Switch to `Point:get_distance_with()`

`2023-7-27`
* The following interfaces are renamed：
  * `y3.game.get_max_tech_level` -> `y3.game.get_tech_max_level`
  * `y3.game.get_tech_type_description` -> `y3.game.get_tech_description`
  * `y3.game.get_tech_type_name` -> `y3.game.get_tech_name`
  * `y3.game.start_new_round_of_game` -> `y3.game.restart_game`
  * `y3.game.set_damage_factor` -> `y3.game.set_damage_ratio`
  * `y3.game.set_game_time_elapsing_rate` -> `y3.game.set_day_night_speed`
  * `y3.game.set_game_time` -> `y3.game.set_day_night_time`
  * `y3.game.create_artificial_time` -> `y3.game.create_day_night_human_time`
  * `y3.game.toggle_time_elapsing_is_on` -> `y3.game.toggle_day_night_time`
  * `y3.game.toggle_target_point_grassland_is_on` -> `y3.game.enable_grass_by_pos`
  * `y3.game.get_current_game_time` -> `y3.game.get_day_night_time`
  * `y3.game.get_damage_factor` -> `y3.game.get_damage_ratio`
  * `y3.game.get_coefficient` -> `y3.game.get_compound_attributes`
  * `y3.game.get_game_environment_of_current_round` -> `y3.game.get_start_mode`
  * `y3.game.if_pri_attr_state_open` -> `y3.game.is_compound_attributes_enabled`
* The following interfaces are removed：
  * For all table related apis, please use Lua's ownAPI。
  * All apis used to get parameters for the event response are available in the callback parameters for the event。
  * `y3.game.get_local_language_environment`
  * `y3.game.get_mover_bound_projectiles`
  * `y3.game.get_ability_owner`，Switch to `Ability:get_owner()`
  * `y3.game.modifier_provider`，Switch to `Buff:get_source()`
  * `y3.game.get_number_interval`，Switch to `y3.math.isBetween`
  * `y3.game.all_units_belonging_to_specified_player`，Switch to `Player:get_all_units()`
  * `y3.game.unit_of_a_specified_unit_type`，Switch to `y3.unit_group.pick_by_key`
  * `y3.game.integer_random_units_from_unit_group`，Switch to `UnitGroup:pick_random_n()`
  * `y3.game.number_of_units_in_unit_group`，Switch to `UnitGroup:count()`
  * `y3.game.get_number_of_units_of_specified_type_in_unit_group`，Switch to `UnitGroup:count_by_key()`
  * `y3.game.get_the_first_unit_in_a_unit_group`，Switch to `UnitGroup:get_first()`
  * `y3.game.get_random_unit_from_unit_group`，Switch to `UnitGroup:get_random()`
  * `y3.game.clear`
  * `y3.game.play_screen_particle_for_a_set_duration`，Switch to `y3.particle.create_screen`
  * `y3.game.is_point_in_area`，Switch to `Area:is_point_in_area()`
