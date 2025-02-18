# Unit

unit

## add_ability

```lua
(method) Unit:add_ability(type: y3.Const.AbilityType|y3.Const.AbilityTypeAlias, id: py.AbilityKey, slot?: y3.Const.AbilityIndex, level?: integer)
  -> Ability?
```

Add skills

@*param* `type` — Skill type

@*param* `id` — knitwearid

@*param* `slot` — Skill Slot

@*param* `level` — Lv.

```lua
type:
    | 'Hidden'
    | 'Normal'
    | 'command'
    | 'Hero'
```
## add_ability_point

```lua
(method) Unit:add_ability_point(skill_point: integer)
```

Increase skill points

@*param* `skill_point` — Skill Points
## add_attr

```lua
(method) Unit:add_attr(attr_name: string|y3.Const.UnitAttr, value: number, attr_type?: string|y3.Const.UnitAttrType)
```

Add attribute

@*param* `attr_name` — Attribute name

@*param* `value` — Attribute value

@*param* `attr_type` — Property type. The default value is Gain”
## add_attr_gc

```lua
(method) Unit:add_attr_gc(attr_name: string|y3.Const.UnitAttr, value: number, attr_type: string|y3.Const.UnitAttrType)
  -> GCNode
```

Add attribute

@*param* `attr_name` — Attribute name

@*param* `value` — Attribute value

@*param* `attr_type` — Attribute type
## add_buff

```lua
(method) Unit:add_buff(data: Buff.AddData)
  -> Buff?
```

Adds magic effects to units
## add_exp

```lua
(method) Unit:add_exp(exp: number)
```

Increase experience

@*param* `exp` — EXP
## add_goods

```lua
(method) Unit:add_goods(tag_name: py.TabName, item_key: py.ItemKey)
```

Add merchantable items

@*param* `tag_name` — Tag name

@*param* `item_key` — itemid
## add_hp

```lua
(method) Unit:add_hp(hp: number)
```

Increases current health

@*param* `hp` — Current health
## add_item

```lua
(method) Unit:add_item(item_id: py.ItemKey, slot_type?: y3.Const.ShiftSlotTypeAlias)
  -> Item?
```

Unit addition

@*param* `item_id` — itemid

@*param* `slot_type` — Slot type

```lua
slot_type:
    | 'Inventory Panel'
    | 'Backpack rail'
```
## add_level

```lua
(method) Unit:add_level(level: integer)
```

Increase level

@*param* `level` — Lv.
## add_mp

```lua
(method) Unit:add_mp(mp: number)
```

Increases current mana

@*param* `mp` — Current mana
## add_multi_state

```lua
(method) Unit:add_multi_state(state_enum: integer)
```

Add multiple states
Use the enumeration value in 'clicli.const.UnitEnumState'

@*param* `state_enum` — status
## add_state

```lua
(method) Unit:add_state(state_enum: integer|y3.Const.UnitEnumState)
```

Add state

@*param* `state_enum` — Status name
## add_state_gc

```lua
(method) Unit:add_state_gc(state_enum: integer|y3.Const.UnitEnumState)
  -> GCNode
```

Add state

@*param* `state_enum` — Status name
## add_tag

```lua
(method) Unit:add_tag(tag: string)
```

Add tag

@*param* `tag` — tag
## add_tech

```lua
(method) Unit:add_tech(tech_id: py.TechKey)
```

Unit addition technology

@*param* `tech_id` — Science and technologyid
## attack_move

```lua
(method) Unit:attack_move(point: Point, range?: number)
  -> py.UnitCommand
```

 Command attack move

@*param* `point` — 点

@*param* `range` — Radius

@*return* — command
## attack_target

```lua
(method) Unit:attack_target(target: Unit, range: number)
  -> py.UnitCommand
```

 Command attack target

@*param* `target` — goal

@*param* `range` — Radius

@*return* — command
## attr_to_name

```lua
function Unit.attr_to_name(key: string)
  -> Attribute name: string
```

Unit attribute to unit attribute name

@*param* `key` — Statskey
## blink

```lua
(method) Unit:blink(point: Point)
```

Transfer to point

@*param* `point` — 点
## break_mover

```lua
(method) Unit:break_mover()
```

interrupter
## buy

```lua
(method) Unit:buy(unit: Unit, tag_num: py.TabIdx, item_key: py.ItemKey)
```

Buy goods from the store

@*param* `unit` — unit

@*param* `tag_num` — TABid

@*param* `item_key` — itemid
## can_blink_to

```lua
(method) Unit:can_blink_to(point: Point)
  -> can_teleport: boolean
```

Can transmit to the point

@*param* `point` — 点

@*return* `can_teleport` — Can transmit to the point
## can_visible

```lua
(method) Unit:can_visible(target_unit: Unit)
  -> visibility: boolean
```

Visible or not

@*param* `target_unit` — Target unit

@*return* `visibility` — Whether the target is visible
## can_walk_to

```lua
(method) Unit:can_walk_to(start_point: Point, end_point: Point)
  -> is_reach: boolean
```

Whether it is routable

@*param* `start_point` — Initial point

@*param* `end_point` — End point

@*return* `is_reach` — Whether it is routable
## cancel_change_animation

```lua
(method) Unit:cancel_change_animation(replace_anim_name: string, bereplace_anim_name: string)
```

Unanimate replace

@*param* `replace_anim_name` — Animation name

@*param* `bereplace_anim_name` — Animation name
## cancel_replace_model

```lua
(method) Unit:cancel_replace_model(model_id: py.ModelKey)
```

Cancel model replacement

@*param* `model_id` — modelid
## cast

```lua
(method) Unit:cast(ability: Ability, target?: Destructible|Item|Point|Unit, extra_target?: Point)
  -> py.UnitCommand
```

 Command activation skill

@*param* `ability` — skill

@*param* `target` — goal

@*param* `extra_target` — Extra target
## change_animation

```lua
(method) Unit:change_animation(replace_anim_name: string, bereplace_anim_name: string)
```

Replacement animation

@*param* `replace_anim_name` — Animation name

@*param* `bereplace_anim_name` — Animation name
## change_owner

```lua
(method) Unit:change_owner(player: Player)
```

Change players

@*param* `player` — Owned player
## check_precondition_by_key

```lua
function Unit.check_precondition_by_key(player: Player, unit_key: py.UnitKey)
  -> unit_precondition: boolean
```

Unit Type Preconditions Whether it passes

@*param* `player` — Player

@*param* `unit_key` — Unit type

@*return* `unit_precondition` — Unit Type Preconditions Whether it passes
## clear_change_animation

```lua
(method) Unit:clear_change_animation(anim_name: string)
```

Reset animation replacement

@*param* `anim_name` — Animation name
## command

```lua
(method) Unit:command(command: py.UnitCommand)
```

Issue an order

@*param* `command` — command
## create_illusion

```lua
function Unit.create_illusion(illusion_unit: Unit, call_unit: Unit, player: Player, point: Point, direction: number, clone_hp_mp: boolean)
  -> Unit?
```

Create illusion

@*param* `illusion_unit` — Phantom copy unit

@*param* `call_unit` — Call unit

@*param* `player` — Player

@*param* `point` — 点

@*param* `direction` — direction

@*param* `clone_hp_mp` — Copy the current health and mana
## create_unit

```lua
function Unit.create_unit(owner: Player|Unit, unit_id: py.UnitKey, point: Point, direction: number)
  -> Unit
```

Create unit

@*param* `unit_id` — Unit type

@*param* `point` — 点

@*param* `direction` — direction
## custom_event_manager

```lua
EventManager?
```

## damage

```lua
(method) Unit:damage(data: Unit.DamageData)
```

## drop_item

```lua
(method) Unit:drop_item(item: Item, point: Point)
  -> py.UnitCommand
```

 Order to discard items
## event

```lua
fun(self: Unit, event: "Unit - Research and development technology ", callback: fun(trg: Trigger, data: EventParam). Unit - Research and development technology)):Trigger
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

## exchange_item

```lua
(method) Unit:exchange_item(item: Item, type: y3.Const.ShiftSlotTypeAlias, index: integer)
```

 barter
 If the target location is empty, it is equivalent to moving the item

@*param* `item` — item

@*param* `index` — slot

```lua
type:
    | 'Inventory Panel'
    | 'Backpack rail'
```
## find_ability

```lua
(method) Unit:find_ability(type: y3.Const.AbilityType|y3.Const.AbilityTypeAlias, id: py.AbilityKey)
  -> ability: Ability?
```

Find skills by skill name

@*param* `type` — Skill type

@*param* `id` — knitwearid

@*return* `ability` — skill

```lua
type:
    | 'Hidden'
    | 'Normal'
    | 'command'
    | 'Hero'
```
## find_buff

```lua
(method) Unit:find_buff(buff_key: py.ModifierKey, index?: integer)
  -> Buff?
```

Gets the magic effect for the unit specified id

@*param* `buff_key` — Magic effectid

@*param* `index` — How many

@*return* — Unit specifies the type of magic effect
## follow

```lua
(method) Unit:follow(target: Unit, refresh_interval?: number, near_offset?: number, far_offset?: number, follow_angle?: number, follow_dead_target?: boolean)
  -> py.UnitCommand
```

 Command follower unit

@*param* `refresh_interval` — Refresh interval

@*param* `near_offset` — Following distance

@*param* `far_offset` — Refollowing distance

@*param* `follow_angle` — Following Angle

@*param* `follow_dead_target` — Whether to follow the death unit
## get_abilities_by_type

```lua
(method) Unit:get_abilities_by_type(type: y3.Const.AbilityType)
  -> Ability[]
```

Gets all skills for a specified type
## get_ability_by_seq

```lua
(method) Unit:get_ability_by_seq(seq: py.AbilitySeq)
  -> Ability?
```

Get skills according to skill number
## get_ability_by_slot

```lua
(method) Unit:get_ability_by_slot(type: y3.Const.AbilityType|y3.Const.AbilityTypeAlias, slot: integer)
  -> ability: Ability?
```

Acquire the skill of a certain skill level

@*param* `type` — Skill type

@*param* `slot` — Skill Slot

@*return* `ability` — skill

```lua
type:
    | 'Hidden'
    | 'Normal'
    | 'command'
    | 'Hero'
```
## get_ability_point

```lua
(method) Unit:get_ability_point()
  -> hero_ability_point_number: integer
```

Gain the number of skill points the hero has

@*return* `hero_ability_point_number` — The number of skill points the hero has
## get_affect_techs

```lua
(method) Unit:get_affect_techs()
  -> py.TechKey[]
```

Get all technologies affected by the unit
## get_alert_range

```lua
(method) Unit:get_alert_range()
  -> alert_range: number
```

Get a unit alert

@*return* `alert_range` — Unit warning range
## get_all_items

```lua
(method) Unit:get_all_items()
  -> item_group: ItemGroup
```

All items of the unit

@*return* `item_group` — All items
## get_armor_type

```lua
(method) Unit:get_armor_type()
  -> DAMAGE_ARMOR_TYPE: integer
```

Get armor type

@*return* `DAMAGE_ARMOR_TYPE` — Type of armor
## get_attack_type

```lua
(method) Unit:get_attack_type()
  -> DAMAGE_ATTACK_TYPE: integer
```

Get attack type

@*return* `DAMAGE_ATTACK_TYPE` — Attack type
## get_attr

```lua
(method) Unit:get_attr(attr_name: y3.Const.UnitAttr, attr_type?: 'Actual '|' extra'|y3.Const.UnitAttrType)
  -> number
```

Get the property (default is the actual property）

```lua
attr_type:
    | 'actual'
    | 'Additional'
```
## get_attr_all_ratio

```lua
(method) Unit:get_attr_all_ratio(attr_name: string|y3.Const.UnitAttr)
  -> number
```

Get attributes (final bonus）
## get_attr_base

```lua
(method) Unit:get_attr_base(attr_name: string|y3.Const.UnitAttr)
  -> attr_base: number
```

Gets a single attribute (base）

@*return* `attr_base` — Attributes of the unit base attribute type
## get_attr_base_ratio

```lua
(method) Unit:get_attr_base_ratio(attr_name: string|y3.Const.UnitAttr)
  -> number
```

Get properties (Base bonus）
## get_attr_bonus

```lua
(method) Unit:get_attr_bonus(attr_name: string|y3.Const.UnitAttr)
  -> number
```

Get properties (gain）
## get_attr_bonus_ratio

```lua
(method) Unit:get_attr_bonus_ratio(attr_name: string|y3.Const.UnitAttr)
  -> number
```

Get properties (Gain bonus）
## get_attr_growth_by_key

```lua
function Unit.get_attr_growth_by_key(unit_key: py.UnitKey, attr_name: string|y3.Const.UnitAttr)
  -> unit_attribute_growth: number
```

Gets unit attribute growth

@*return* `unit_attribute_growth` — Unit attribute growth
## get_attr_other

```lua
(method) Unit:get_attr_other(attr_name: string|y3.Const.UnitAttr)
  -> number
```

Get properties (extra）

@*param* `attr_name` — Attribute name
## get_bar_cnt

```lua
(method) Unit:get_bar_cnt()
  -> slot_number: integer
```

Gets the number of slots in the unit inventory

@*return* `slot_number` — Number of slots in the unit inventory
## get_buffs

```lua
(method) Unit:get_buffs()
  -> Buff[]
```

Gain magic effects on units

@*return* — Magic effect table
## get_by_handle

```lua
function Unit.get_by_handle(py_unit: py.Unit)
  -> Unit?
```

Get the unit instance of the lua layer from the unit instance of the py layer
## get_by_id

```lua
function Unit.get_by_id(id: py.UnitID)
  -> Unit?
```

 Gets units based on unique ids。
## get_by_res_id

```lua
function Unit.get_by_res_id(res_id: integer)
  -> Unit
```

 Gets the units placed on the scene
## get_by_string

```lua
function Unit.get_by_string(str: string)
  -> Unit?
```

According to the string gets the unit, the string is passed `tostring(Unit)`
Or using the "Convert any variable to string" in ECA。
## get_camp_id

```lua
(method) Unit:get_camp_id()
  -> py.CampID
```

Get unit campID
## get_cancel_alert_range

```lua
(method) Unit:get_cancel_alert_range()
  -> cancel_alert_range: number
```

Get the range of units to de-alert

@*return* `cancel_alert_range` — The area where the unit called off the alert
## get_collision_radius

```lua
(method) Unit:get_collision_radius()
  -> collision_radius: number
```

Gets the unit collision radius

@*return* `collision_radius` — Unit collision radius
## get_common_attack

```lua
(method) Unit:get_common_attack()
  -> Ability?
```

comment Gain general attack skills
## get_custom_event_manager

```lua
(method) CustomEvent:get_custom_event_manager()
  -> EventManager?
```

## get_description

```lua
(method) Unit:get_description()
  -> unit_description: string
```

Gets a description of the unit

@*return* `unit_description` — Description of units
## get_description_by_key

```lua
function Unit.get_description_by_key(unit_key: py.UnitKey)
  -> des: string
```

Gets a description of the unit type

@*param* `unit_key` — Unit type

@*return* `des` — Description of the unit type
## get_exp

```lua
(method) Unit:get_exp()
  -> exp: integer
```

Gets the unit's current experience

@*return* `exp` — Current experience value of the unit
## get_exp_reward

```lua
(method) Unit:get_exp_reward()
  -> exp: integer
```

Gain unit kill experience

@*return* `exp` — Unit kill experience
## get_facing

```lua
(method) Unit:get_facing()
  -> angle: number
```

Gets the orientation of the unit

@*return* `angle` — Orientation of unit
## get_final_attr

```lua
(method) Unit:get_final_attr(attr_name: string|y3.Const.UnitAttr)
  -> number
```

Get final attribute

@*param* `attr_name` — Attribute name
## get_goods_cd

```lua
(method) Unit:get_goods_cd(page: py.TabIdx, index: integer)
  -> cd: number
```

Get inventory intervals for store items

@*param* `page` — TABid

@*param* `index` — Serial number

@*return* `cd` — Default interval
## get_goods_key

```lua
(method) Unit:get_goods_key(tag_index: py.TabIdx, item_index: integer)
  -> item: py.ItemKey
```

Get items from the storeid

@*param* `tag_index` — TAB

@*param* `item_index` — Serial number

@*return* `item` — Item type
## get_goods_remaining_cd

```lua
(method) Unit:get_goods_remaining_cd(page: py.TabIdx, index: integer)
  -> recovery_time: number
```

Gets the remaining recovery time for store items

@*param* `page` — TABid

@*param* `index` — Serial number

@*return* `recovery_time` — Residual recovery time
## get_goods_stack

```lua
(method) Unit:get_goods_stack(tag_index: py.TabIdx, item_key: py.ItemKey)
  -> item_stock: integer
```

Get the store's inventory of items

@*param* `tag_index` — TAB

@*param* `item_key` — Item type

@*return* `item_stock` — Commodity inventory
## get_height

```lua
(method) Unit:get_height()
  -> height: number
```

Gain unit altitude

@*return* `height` — Unit flight altitude
## get_hp

```lua
(method) Unit:get_hp()
  -> current_unit_hp: number
```

Gets the current health

@*return* `current_unit_hp` — Current health
## get_icon

```lua
(method) Unit:get_icon()
  -> image: py.Texture
```

Get the unit's avatar

@*return* `image` — Unit head
## get_icon_by_key

```lua
function Unit.get_icon_by_key(unit_key: py.UnitKey)
  -> image: py.Texture
```

Gets the avatar of the unit type

@*param* `unit_key` — Unit type

@*return* `image` — The avatar of the unit type
## get_id

```lua
(method) Unit:get_id()
  -> integer
```

 Get uniqueID
## get_illusion_owner

```lua
(method) Unit:get_illusion_owner()
  -> unit: Unit?
```

The summoner of the vision

@*return* `unit` — Summoner of the vision
## get_item_by_slot

```lua
(method) Unit:get_item_by_slot(type: y3.Const.ShiftSlotTypeAlias|y3.Const.SlotType, slot: integer)
  -> item: Item?
```

Get the items in the unit backpack slot

@*param* `type` — Slot type

@*param* `slot` — position

@*return* `item` — item

```lua
type:
    | 'Inventory Panel'
    | 'Backpack rail'
```
## get_item_type_number_of_unit

```lua
(method) Unit:get_item_type_number_of_unit(item_key: py.ItemKey)
  -> item_type_number: integer
```

Gets the number of item types owned by a unit

@*param* `item_key` — Item typeid

@*return* `item_type_number` — Item type quantity
## get_key

```lua
(method) Unit:get_key()
  -> type_id: py.UnitKey
```

Gets the unit typeID

@*return* `type_id` — unit-typeID
## get_last_created_unit

```lua
function Unit.get_last_created_unit()
  -> unit: Unit?
```

Last created unit

@*return* `unit` — Last created unit
## get_level

```lua
(method) Unit:get_level()
  -> unit_level: integer
```

Get unit level

@*return* `unit_level` — Unit level
## get_life_cycle

```lua
(method) Unit:get_life_cycle()
  -> number
```

Gets the remaining life cycle of a unit
## get_main_attr

```lua
(method) Unit:get_main_attr()
  -> string
```

Gets the unit primary properties (requires composite properties to be enabled)
## get_model

```lua
(method) Unit:get_model()
  -> model: py.ModelKey
```

Gets the current model of the unit

@*return* `model` — Current model
## get_model_by_key

```lua
function Unit.get_model_by_key(unit_key: py.UnitKey)
  -> model: py.ModelKey
```

Gets the model for the unit type

@*param* `unit_key` — unitid

@*return* `model` — model
## get_mp

```lua
(method) Unit:get_mp()
  -> current_mp: number
```

Gets the current mana

@*return* `current_mp` — Current mana
## get_name

```lua
(method) Unit:get_name()
  -> unit_name: string
```

Get unit name

@*return* `unit_name` — Unit name
## get_name_by_key

```lua
function Unit.get_name_by_key(unit_key: py.UnitKey)
  -> type_name: string
```

Gets the name of the unit type

@*return* `type_name` — Unit type name
## get_nearest_valid_point

```lua
(method) Unit:get_nearest_valid_point()
  -> point: Point
```

Gets the nearest passable point of the unit

@*return* `point` — The nearest passable point of the unit
## get_owner

```lua
(method) Unit:get_owner()
  -> player: Player
```

Gets the player the unit belongs to

@*return* `player` — Unit player
## get_owner_player

```lua
(method) Unit:get_owner_player()
  -> Player
```

 Get a player
## get_parent_unit

```lua
(method) Unit:get_parent_unit()
  -> unit: Unit?
```

Gets the owner of the unit (unit）

@*return* `unit` — Owner of a unit
## get_pkg_cnt

```lua
(method) Unit:get_pkg_cnt()
  -> slot_number: integer
```

Gets the number of slots in the unit backpack field

@*return* `slot_number` — Number of slots in the unit backpack bar
## get_point

```lua
(method) Unit:get_point()
  -> unit_point: Point
```

Get the point where the unit resides

@*return* `unit_point` — Unit point
## get_reward_res

```lua
(method) Unit:get_reward_res(player_attr_name: py.RoleResKey)
  -> player_attr: number
```

Get the resources available to kill (player attributes）

@*param* `player_attr_name` — Player attribute name

@*return* `player_attr` — Unit killed player attributes
## get_scale

```lua
(method) Unit:get_scale()
  -> model_scale: number
```

Get unit scaling

@*return* `model_scale` — Unit scaling
## get_shield

```lua
(method) Unit:get_shield(shield_type: integer)
  -> shield_value: integer
```

Gets the shield value for the unit's specified shield type

@*param* `shield_type` — Shield type

@*return* `shield_value` — Shield type Shield value
## get_shop_item_list

```lua
(method) Unit:get_shop_item_list(page: py.TabIdx)
  -> py.ItemKey[]
```

Get all store items

@*param* `page` — TAB
## get_shop_range

```lua
(method) Unit:get_shop_range()
  -> purchase_range: number
```

Get the store's purchase range

@*return* `purchase_range` — Purchase range
## get_shop_tab_name

```lua
(method) Unit:get_shop_tab_name(tag_index: py.TabIdx)
  -> tab_name: string
```

Get the page signature for the store

@*param* `tag_index` — TAB

@*return* `tab_name` — Page signature
## get_shop_tab_number

```lua
(method) Unit:get_shop_tab_number()
  -> tab_number: number
```

Gets the number of store tabs

@*return* `tab_number` — Number of tabs
## get_source_model

```lua
(method) Unit:get_source_model()
  -> model: py.ModelKey
```

Gets the original model of the unit

@*return* `model` — Original model
## get_subtype

```lua
(method) Unit:get_subtype()
  -> unit_subtype: py.UnitType
```

Acquisition unit classification

@*return* `unit_subtype` — Unit classification
## get_team

```lua
(method) Unit:get_team()
  -> team: py.Camp
```

Get units for the team

@*return* `team` — Get units for the team
## get_tech_list

```lua
(method) Unit:get_tech_list()
  -> py.TechKey[]
```

Access to all the technology that the unit can research
## get_turning_speed

```lua
(method) Unit:get_turning_speed()
  -> turning_speed: number
```

Gets unit turn speed

@*return* `turning_speed` — Unit turn speed
## get_type

```lua
(method) Unit:get_type()
  -> unit_type: py.UnitType
```

Gets the unit type of the unitID

@*return* `unit_type` — Unit typeID
## get_type_by_id

```lua
function Unit.get_type_by_id(unit_key: py.UnitKey)
  -> integer
```

Gets the classification of the unit type

@*param* `unit_key` — unitid
## get_unit_resource_cost

```lua
(method) Unit:get_unit_resource_cost(unit_id: py.UnitKey, player_attr_name: py.RoleResKey)
  -> player_attr: integer
```

Gets the resources it takes to build this unit (player attributes）

@*param* `unit_id` — Unit type

@*param* `player_attr_name` — Player attribute name

@*return* `player_attr` — Unit killed player attributes
## get_unit_selection_range_scale

```lua
(method) Unit:get_unit_selection_range_scale()
  -> range_scale: number
```

Gets unit selection circle scaling

@*return* `range_scale` — Selection circle scaling
## get_upgrade_exp

```lua
(method) Unit:get_upgrade_exp()
  -> exp: number
```

Gain experience required for the current upgrade of your organization

@*return* `exp` — Experience required for the current upgrade
## get_x_scale

```lua
(method) Unit:get_x_scale()
  -> xaxis: number
```

Gets the X-axis scaling of the unit

@*return* `xaxis` — XAxis scaling
## get_y_scale

```lua
(method) Unit:get_y_scale()
  -> yaxis: number
```

Gets the Y-axis scaling of the unit

@*return* `yaxis` — YAxis scaling
## get_z_scale

```lua
(method) Unit:get_z_scale()
  -> zaxis: number
```

Gets the z-axis scaling of the unit

@*return* `zaxis` — ZAxis scaling
## give_item

```lua
(method) Unit:give_item(item: Item, target: Unit)
  -> py.UnitCommand
```

 Order to give goods
## handle

```lua
py.Unit
```

pyLayer unit object
## has_ability_by_key

```lua
(method) Unit:has_ability_by_key(ability_key: py.AbilityKey)
  -> has_ability_type: boolean
```

Whether the skill with the specified id exists

@*param* `ability_key` — Skill type

@*return* `has_ability_type` — Have a specified type of skill
## has_buff_by_effect_type

```lua
(method) Unit:has_buff_by_effect_type(effect_type: y3.Const.EffectType)
  -> has_modifier_style: boolean
```

Whether there is a specified type of magic effect

@*param* `effect_type` — Magic effect type

@*return* `has_modifier_style` — Has a specified type of magic effect
## has_buff_by_key

```lua
(method) Unit:has_buff_by_key(buff_key: py.ModifierKey)
  -> has_modifier: boolean
```

Whether there is a magic effect with a specified id

@*param* `buff_key` — Magic effectid

@*return* `has_modifier` — Have magical effect
## has_buff_status

```lua
(method) Unit:has_buff_status(state_name: integer)
  -> has_buff_status: boolean
```

Whether the specified status exists
> Use the 'has_state' method instead

@*param* `state_name` — status

@*return* `has_buff_status` — Assigned state
## has_item

```lua
(method) Unit:has_item(item: Item)
  -> has_item: boolean
```

Whether there is a specified item

@*param* `item` — item

@*return* `has_item` — Have item
## has_item_by_key

```lua
(method) Unit:has_item_by_key(item_key: py.ItemKey)
  -> has_item_name: boolean
```

Whether there are items of the specified type

@*param* `item_key` — Item type

@*return* `has_item_name` — There are specified types of items
## has_move_collision

```lua
(method) Unit:has_move_collision(collision_layer: integer|y3.Const.CollisionLayers)
  -> boolean
```

Whether the specified collision type exists

@*param* `collision_layer` — Collision type

@*return* — Whether the specified collision type exists
## has_state

```lua
(method) Unit:has_state(state_enum: integer|y3.Const.UnitEnumState)
  -> boolean?
```

Whether there is a state

@*param* `state_enum` — Status name
## has_tag

```lua
(method) Unit:has_tag(tag_name: string)
  -> has_tag: boolean
```

Tagged or not

@*param* `tag_name` — tag

@*return* `has_tag` — tagged
## heals

```lua
(method) Unit:heals(value: number, skill?: Ability, source_unit?: Unit, text_type?: string)
```

Cause treatment

@*param* `value` — Healing value

@*param* `skill` — skill

@*param* `source_unit` — unit

@*param* `text_type` — Hop type
## hold

```lua
(method) Unit:hold(point: Point)
  -> py.UnitCommand
```

 Command garrison

@*param* `point` — 点

@*return* — command
## id

```lua
integer
```

## is_alive

```lua
(method) Unit:is_alive()
  -> alive: boolean
```

Survive or not

@*return* `alive` — Survive or not
## is_ally

```lua
(method) Unit:is_ally(target_unit: Unit)
  -> is_enemy: boolean
```

Friendly or not

@*param* `target_unit` — Target unit

@*return* `is_enemy` — Is a hostile relationship
## is_building

```lua
(method) Unit:is_building()
  -> boolean
```

Building or not
## is_casting

```lua
(method) Unit:is_casting()
  -> boolean
```

Whether the unit has a skill that is being released
## is_collided_with_point

```lua
(method) Unit:is_collided_with_point(point: Point, range: number)
  -> can_collide: boolean
```

Whether it collided with the point

@*param* `point` — 点

@*param* `range` — Radius

@*return* `can_collide` — Whether it collided with the point
## is_destroyed

```lua
(method) Unit:is_destroyed()
  -> boolean
```

## is_enemy

```lua
(method) Unit:is_enemy(target_unit: Unit)
  -> is_enemy: boolean
```

Enemy or not

@*param* `target_unit` — Target unit

@*return* `is_enemy` — Is a hostile relationship
## is_exist

```lua
(method) Unit:is_exist()
  -> is_exist: boolean
```

Existence or not

@*return* `is_exist` — Existence or not
## is_hero

```lua
(method) Unit:is_hero()
  -> boolean
```

Be a hero or not
## is_illusion

```lua
(method) Unit:is_illusion()
  -> illusion: boolean
```

Phantom unit or not

@*return* `illusion` — It's a phantom unit.
## is_in_battle

```lua
(method) Unit:is_in_battle()
  -> in_battle: boolean
```

Whether in combat mode

@*return* `in_battle` — In combat
## is_in_group

```lua
(method) Unit:is_in_group(group: UnitGroup)
  -> in_group: boolean
```

Whether it is in the unit group

@*param* `group` — Unit group

@*return* `in_group` — In the unit group
## is_in_radius

```lua
(method) Unit:is_in_radius(other: Point|Unit, range: number)
  -> in_radius: boolean
```

Whether it is near another unit or point

@*param* `other` — Unit/point

@*param* `range` — Radius

@*return* `in_radius` — Near the unit
## is_moving

```lua
(method) Unit:is_moving()
  -> is_moving: boolean
```

Are you moving?

@*return* `is_moving` — On the move
## is_shop

```lua
(method) Unit:is_shop()
  -> is_shop: boolean
```

Shop or not

@*return* `is_shop` — It's a store
## key

```lua
integer?
```

## kill_by

```lua
(method) Unit:kill_by(killer: Unit)
```

Kill unit

@*param* `killer` — Killer unit
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
## learn

```lua
(method) Unit:learn(ability_key: py.AbilityKey)
```

Learning skill

@*param* `ability_key` — skillid
## move_along_road

```lua
(method) Unit:move_along_road(road: Road, patrol_mode: integer, can_attack: boolean, start_from_nearest: boolean, back_to_nearest: boolean)
  -> py.UnitCommand
```

 The command moves along the path

@*param* `road` — path

@*param* `patrol_mode` — Mobile mode

@*param* `can_attack` — Automatic attack or not

@*param* `start_from_nearest` — Select the nearest starting point

@*param* `back_to_nearest` — Deviation from the nearest return

@*return* — command
## move_to_pos

```lua
(method) Unit:move_to_pos(point: Point, range?: number)
  -> py.UnitCommand
```

 Command move

@*param* `point` — 点

@*param* `range` — Radius

@*return* — command
## mover_curve

```lua
(method) Unit:mover_curve(mover_data: Mover.CreateData.Curve)
  -> Mover
```

Create a curve mover
## mover_line

```lua
(method) Unit:mover_line(mover_data: Mover.CreateData.Line)
  -> Mover
```

Create a linear motion device
## mover_round

```lua
(method) Unit:mover_round(mover_data: Mover.CreateData.Round)
  -> Mover
```

Create a surround motion
## mover_target

```lua
(method) Unit:mover_target(mover_data: Mover.CreateData.Target)
  -> Mover
```

Create a tracker
## object_event_manager

```lua
EventManager?
```

## pause_life_cycle

```lua
(method) Unit:pause_life_cycle(is_stop: boolean)
```

The life cycle is suspended

@*param* `is_stop` — The life cycle is suspended
## phandle

```lua
py.Unit
```

Proxy objects, using this to call the engine's methods will be much faster
## pick_item

```lua
(method) Unit:pick_item(item: Item)
  -> py.UnitCommand
```

 Command to pick up items
## play_animation

```lua
(method) Unit:play_animation(anim_name: string, speed?: number, start_time?: number, end_time?: number, is_loop?: boolean, is_back_normal?: boolean)
```

*******************Play animations globally unified
Play animation

@*param* `anim_name` — Animation name

@*param* `speed` — speed

@*param* `start_time` — Start time

@*param* `end_time` — End time (Default -1 indicates last playback)

@*param* `is_loop` — Cyclic or not

@*param* `is_back_normal` — Whether to return the default state
## player_shop_check

```lua
(method) Unit:player_shop_check(player: Player)
  -> boolean
```

Whether the player can purchase items from the store
## reborn

```lua
(method) Unit:reborn(point?: Point)
```

Reactivation unit

@*param* `point` — 点
## ref_manager

```lua
unknown
```

## remove

```lua
(method) Unit:remove()
```

Delete unit
## remove_abilitiy_by_key

```lua
(method) Unit:remove_abilitiy_by_key(type: y3.Const.AbilityType|y3.Const.AbilityTypeAlias, ability_key: py.AbilityKey)
```

Remove skill (specify type)
> Spelled wrong, please change `Unit:remove_ability_by_key`

@*param* `type` — Skill type

@*param* `ability_key` — knitwearid

```lua
type:
    | 'Hidden'
    | 'Normal'
    | 'command'
    | 'Hero'
```
## remove_ability

```lua
(method) Unit:remove_ability(type: y3.Const.AbilityType, slot: y3.Const.AbilityIndex)
```

Remove skill

@*param* `type` — Skill type

@*param* `slot` — Skill Slot
## remove_ability_by_key

```lua
(method) Unit:remove_ability_by_key(type: y3.Const.AbilityType|y3.Const.AbilityTypeAlias, ability_key: py.AbilityKey)
```

Remove skill (specify type)

@*param* `type` — Skill type

@*param* `ability_key` — knitwearid

```lua
type:
    | 'Hidden'
    | 'Normal'
    | 'command'
    | 'Hero'
```
## remove_buffs_by_effect_type

```lua
(method) Unit:remove_buffs_by_effect_type(effect_type: y3.Const.EffectType)
```

Removes all magic effects of the specified type

@*param* `effect_type` — Affect the type of magic effect
## remove_buffs_by_key

```lua
(method) Unit:remove_buffs_by_key(buff_key: py.ModifierKey)
```

Removes all magic effects with the specified id

@*param* `buff_key` — Affect the type of magic effect
## remove_goods

```lua
(method) Unit:remove_goods(item_name: py.TabName, item_key: py.ItemKey)
```

Remove merchantable goods

@*param* `item_name` — Item Name

@*param* `item_key` — itemid
## remove_item

```lua
(method) Unit:remove_item(item_id: py.ItemKey, num?: integer)
```

Unit removal items

@*param* `item_id` — itemid

@*param* `num` — quantity
## remove_mover

```lua
(method) Unit:remove_mover()
```

Removal motor
## remove_multi_state

```lua
(method) Unit:remove_multi_state(state_enum: integer)
```

Remove multiple states
Use the enumeration value in 'clicli.const.UnitEnumState'

@*param* `state_enum` — status
## remove_state

```lua
(method) Unit:remove_state(state_enum: integer|y3.Const.UnitEnumState)
```

Removed state
 The status can be removed only when the number of removals is the same as the number of additions

@*param* `state_enum` — Status name
## remove_tag

```lua
(method) Unit:remove_tag(tag: string)
```

Remove tag

@*param* `tag` — tag
## remove_tech

```lua
(method) Unit:remove_tech(tech_id: py.TechKey)
```

Unit deletion technology

@*param* `tech_id` — Science and technologyid
## replace_model

```lua
(method) Unit:replace_model(model_id: py.ModelKey)
```

Replacement model

@*param* `model_id` — modelid
## research_tech

```lua
(method) Unit:research_tech(tech_id: py.TechKey)
```

Research technology

@*param* `tech_id` — Science and technologyid
## sell

```lua
(method) Unit:sell(unit: Unit, item: Item)
```

Units sell items to shops

@*param* `unit` — unit

@*param* `item` — item
## set_Xray_is_open

```lua
(method) Unit:set_Xray_is_open(is_open: boolean)
```

Set perspective

@*param* `is_open` — Perspective or not
## set_ability_point

```lua
(method) Unit:set_ability_point(skill_point: integer)
```

Set skill points

@*param* `skill_point` — Skill Points
## set_afterimage_time

```lua
(method) Unit:set_afterimage_time(interval: number, duration: number, start_time: number, end_time: number)
```

Set the shadow time

@*param* `interval` — Interval time

@*param* `duration` — Display time

@*param* `start_time` — Start time

@*param* `end_time` — End time
## set_alert_range

```lua
(method) Unit:set_alert_range(range: number)
```

Set an alert

@*param* `range` — Radius
## set_animation_speed

```lua
(method) Unit:set_animation_speed(speed: number)
```

Set the animation playback rate

@*param* `speed` — speed
## set_armor_type

```lua
(method) Unit:set_armor_type(armor_type: integer)
```

Set the armor type

@*param* `armor_type` — Type of armor
## set_attack_type

```lua
(method) Unit:set_attack_type(attack_type: integer)
```

Setting attack type

@*param* `attack_type` — Attack type
## set_attr

```lua
(method) Unit:set_attr(attr_name: string|y3.Const.UnitAttr, value: number, attr_type?: string|y3.Const.UnitAttrType)
```

Set attribute

@*param* `attr_name` — Attribute name

@*param* `value` — Attribute value

@*param* `attr_type` — Attribute type. The default value is Base”
## set_attr_growth

```lua
function Unit.set_attr_growth(unit_key: py.UnitKey, attr_name: string, value: number)
```

******************************************
Set attribute growth

@*param* `unit_key` — unitid

@*param* `attr_name` — Attribute name

@*param* `value` — Attribute growth
## set_bar_cnt

```lua
(method) Unit:set_bar_cnt(number: integer)
```

Sets the number of slots in the inventory

@*param* `number` — Number of slots
## set_base_speed

```lua
(method) Unit:set_base_speed(speed: number)
```

Set the walking animation benchmark speed

@*param* `speed` — speed
## set_behavior

```lua
(method) Unit:set_behavior(behavior: py.UnitBehavior)
```

Set the default unit behavior

@*param* `behavior` — Unit behavior
## set_blood_bar_type

```lua
(method) Unit:set_blood_bar_type(bar_type: integer)
```

Set the blood bar style

@*param* `bar_type` — Blood stripe pattern
## set_cancel_alert_range

```lua
(method) Unit:set_cancel_alert_range(range: number)
```

Set a de-alert zone

@*param* `range` — de-alert
## set_collision_radius

```lua
(method) Unit:set_collision_radius(radius: number)
```

Set the unit collision radius
## set_day_vision

```lua
(method) Unit:set_day_vision(value: number)
```

 Set the daytime field of view
## set_description

```lua
(method) Unit:set_description(description: string)
```

Set description

@*param* `description` — Description
## set_enemy_minimap_icon

```lua
(method) Unit:set_enemy_minimap_icon(img_id: py.Texture)
```

Set enemy unit minimap avatars

@*param* `img_id` — Enemy unit minimap avatar
## set_exp

```lua
(method) Unit:set_exp(exp: number)
```

Setup experience

@*param* `exp` — EXP
## set_facing

```lua
(method) Unit:set_facing(direction: number, turn_time: number)
```

orientation

@*param* `direction` — orientation

@*param* `turn_time` — Turning time
## set_ghost_color

```lua
(method) Unit:set_ghost_color(red: number, green: number, blue: number, alpha: number)
```

Set the shadow color

@*param* `red` — 绿

@*param* `green` — 绿

@*param* `blue` — 蓝

@*param* `alpha` — transparency
## set_goods_stack

```lua
(method) Unit:set_goods_stack(tag_name: py.TabName, item_key: py.ItemKey, number: integer)
```

Set inventory

@*param* `tag_name` — Tag name

@*param* `item_key` — itemid

@*param* `number` — Inventory of goods
## set_health_bar_display

```lua
(method) Unit:set_health_bar_display(bar_show_type: integer)
```

Set the blood bar display mode

@*param* `bar_show_type` — Blood strip display mode
## set_height

```lua
(method) Unit:set_height(height: number, trans_time: number)
```

Set altitude

@*param* `height` — Altitude

@*param* `trans_time` — Transition time
## set_hp

```lua
(method) Unit:set_hp(hp: number)
```

Set the current health

@*param* `hp` — Current health
## set_icon

```lua
(method) Unit:set_icon(img_id: py.Texture)
```

Set the unit profile picture

@*param* `img_id` — Unit head
## set_level

```lua
(method) Unit:set_level(level: integer)
```

Set level

@*param* `level` — Lv.
## set_life_cycle

```lua
(method) Unit:set_life_cycle(time: number)
```

Set life cycle

@*param* `time` — Life cycle
## set_minimap_icon

```lua
(method) Unit:set_minimap_icon(img_id: py.Texture)
```

***************Merge one with the other
Set the unit minimap avatar

@*param* `img_id` — Unit minimap avatar
## set_move_channel_air

```lua
(method) Unit:set_move_channel_air(air_limitation?: boolean)
```

Set the movement type of the unit to air

@*param* `air_limitation` — Air restriction
## set_move_channel_land

```lua
(method) Unit:set_move_channel_land(land_limitation?: boolean, item_limitation?: boolean, water_limitation?: boolean)
```

Set the movement type of the unit to ground

@*param* `land_limitation` — Land restriction

@*param* `item_limitation` — Object restriction

@*param* `water_limitation` — Marine limitation
## set_move_collision

```lua
(method) Unit:set_move_collision(collision_layer: integer|y3.Const.CollisionLayers, enable: boolean)
```

Sets whether the unit counts a collision type

@*param* `collision_layer` — collisionmask

@*param* `enable` — On state
## set_mp

```lua
(method) Unit:set_mp(mp: number)
```

Sets the current mana value

@*param* `mp` — Current mana
## set_name

```lua
(method) Unit:set_name(name: string)
```

Set name

@*param* `name` — name
## set_night_value

```lua
(method) Unit:set_night_value(value: number)
```

 Set your view at night
## set_outline_visible

```lua
(method) Unit:set_outline_visible(bool: boolean)
```

Set unit stroke on

@*param* `bool` — Boolean value
## set_outlined_color

```lua
(method) Unit:set_outlined_color(color_r: number, color_g: number, color_b: number)
```

Sets the unit stroke color

@*param* `color_r` — R

@*param* `color_g` — G

@*param* `color_b` — B
## set_pkg_cnt

```lua
(method) Unit:set_pkg_cnt(number: integer)
```

Set the number of slots for the backpack bar

@*param* `number` — Number of slots
## set_point

```lua
(method) Unit:set_point(point: Point, isSmooth: boolean)
```

Force transfer to point

@*param* `point` — 点

@*param* `isSmooth` — Silky or not
## set_recycle_on_remove

```lua
(method) Unit:set_recycle_on_remove(is_recycle: boolean)
```

Set whether to retrieve the body after it disappears

@*param* `is_recycle` — Recycle or not
## set_reward_exp

```lua
(method) Unit:set_reward_exp(exp: number)
```

Set the XP bonus for being killed

@*param* `exp` — EXP
## set_reward_res

```lua
(method) Unit:set_reward_res(player_attr_name: py.RoleResKey, value: number)
```

Set the player stat bonus for being killed

@*param* `player_attr_name` — Attribute name

@*param* `value` — Attribute reward
## set_scale

```lua
(method) Unit:set_scale(scale: number)
```

Set model scaling

@*param* `scale` — Model scaling
## set_select_effect_visible

```lua
(method) Unit:set_select_effect_visible(bool: boolean)
```

Sets the visibility of the unit selection box

@*param* `bool` — Boolean value
## set_transparent_when_invisible

```lua
(method) Unit:set_transparent_when_invisible(is_visible: boolean)
```

**********************What is this
Sets whether to be translucent when invisible

@*param* `is_visible` — Translucent or not
## set_turning_speed

```lua
(method) Unit:set_turning_speed(speed: number)
```

Set turn speed

@*param* `speed` — Turn speed
## set_unit_scale

```lua
(method) Unit:set_unit_scale(sx: number, sy: number, sz: number)
```

Set unit triaxial scaling

@*param* `sx` — XAxis scaling

@*param* `sy` — YAxis scaling

@*param* `sz` — ZAxis scaling
## shift_item

```lua
(method) Unit:shift_item(item: Item, type: y3.Const.ShiftSlotTypeAlias, index?: integer, force?: boolean)
```

Moving items

@*param* `item` — item

@*param* `index` — slot

@*param* `force` — Whether to force a move, 'true' : If the target has an item, move to another space; 'false' : If the target has an item, the item to be moved will drop

```lua
type:
    | 'Inventory Panel'
    | 'Backpack rail'
```
## start_ghost

```lua
(method) Unit:start_ghost(red: number, green: number, blue: number, alpha: number, interval: number, duration: number, start_time: number, end_time: number, is_origin_martial: boolean)
```

************************Shadow optimization
Open shadow

@*param* `red` — 红

@*param* `green` — 绿

@*param* `blue` — 蓝

@*param* `alpha` — transparency

@*param* `interval` — Interval time

@*param* `duration` — Display time

@*param* `start_time` — Start time

@*param* `end_time` — End time

@*param* `is_origin_martial` — Use native materials
## stop

```lua
(method) Unit:stop()
  -> py.UnitCommand
```

 Stop order

@*return* — command
## stop_all_abilities

```lua
(method) Unit:stop_all_abilities()
```

Stop all skills
## stop_animation

```lua
(method) Unit:stop_animation(anim_name: string)
```

Stop animation

@*param* `anim_name` — Animation name
## stop_cur_animation

```lua
(method) Unit:stop_cur_animation()
```

Stop the animation that is currently playing
## stop_ghost

```lua
(method) Unit:stop_ghost()
```

Close shadow
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

## switch_ability

```lua
(method) Unit:switch_ability(ability_1: Ability, ability_2: Ability)
```

Swap skill positions

@*param* `ability_1` — First skill

@*param* `ability_2` — Second skill
## switch_ability_by_slot

```lua
(method) Unit:switch_ability_by_slot(type_1: y3.Const.AbilityType, slot_1: y3.Const.AbilityIndex, type_2: y3.Const.AbilityType, slot_2: y3.Const.AbilityIndex)
```

Trade skills based on pit position

@*param* `type_1` — The first skill type

@*param* `slot_1` — The first skill pit bit

@*param* `type_2` — Second skill type

@*param* `slot_2` — The second skill pit bit
## type

```lua
string
```

## unit_gains_tech

```lua
(method) Unit:unit_gains_tech(tech_key: py.TechKey)
```

Unit acquisition of technology

@*param* `tech_key` — Science and technology type
## unit_has_modifier_tag

```lua
(method) Unit:unit_has_modifier_tag(tag_name: string)
  -> has_modifier_tag: boolean
```

Whether there is a magic effect for the specified label

@*param* `tag_name` — tag

@*return* `has_modifier_tag` — Magic effects with specified labels
## use_item

```lua
(method) Unit:use_item(item: Item, target?: Destructible|Item|Point|Unit, extra_target?: Point)
  -> py.UnitCommand
```

 Command use item

# Unit.DamageData

 Cause injury

## ability

```lua
Ability
```

Relevance skill
## common_attack

```lua
boolean
```

Regarded as a general attack
## critical

```lua
boolean
```

Certain critical strike
## damage

```lua
number
```

## no_miss

```lua
boolean
```

Sure hit
## particle

```lua
py.SfxKey
```

VFX
## socket

```lua
string
```

Special effect peg
## target

```lua
Destructible|Item|Unit
```

unit
## text_track

```lua
integer
```

Skip trace type
## text_type

```lua
y3.Const.DamageTextType
```

Hop type
## type

```lua
integer|y3.Const.DamageType
```

You can also pass any number

