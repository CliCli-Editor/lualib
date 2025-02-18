# Item

item

## add_attribute

```lua
(method) Item:add_attribute(key: string, value: number)
```

Add base attributes

@*param* `key` — Statskey

@*param* `value` — Attribute value
## add_bonus_attribute

```lua
(method) Item:add_bonus_attribute(key: string, value: number)
```

Increase gain attribute

@*param* `key` — Statskey

@*param* `value` — Attribute value
## add_charge

```lua
(method) Item:add_charge(charge: integer)
```

Increase charge number

@*param* `charge` — Charge number
## add_passive_ability

```lua
(method) Item:add_passive_ability(ability_id: py.AbilityKey, level: integer)
```

Adds passive abilities to items

@*param* `ability_id` — skillid

@*param* `level` — Lv.
## add_stack

```lua
(method) Item:add_stack(stack: integer)
```

Increase stack count

@*param* `stack` — Stack number
## add_tag

```lua
(method) Item:add_tag(tag: string)
```

Add tag

@*param* `tag` — tag
## attr_pick

```lua
(method) Item:attr_pick()
  -> keys: string[]
```

Traverse the unit properties of the item

@*return* `keys` — Statskey
## attr_pick_by_key

```lua
function Item.attr_pick_by_key(item_key: py.ItemKey)
  -> keys: string[]
```

Iterate over the unit properties of the item type

@*param* `item_key` — Item type

@*return* `keys` — Statskey
## check_precondition_by_key

```lua
function Item.check_precondition_by_key(player: Player, item_key: py.ItemKey)
  -> boolean
```

Check item type preconditions

@*param* `player` — Player

@*param* `item_key` — Item typeID
## create_item

```lua
function Item.create_item(point: Point, item_key: py.ItemKey, player?: Player)
  -> Item
```

Create item to point

@*param* `point` — 点

@*param* `item_key` — Item type

@*param* `player` — Player
## custom_event_manager

```lua
EventManager?
```

## drop

```lua
(method) Item:drop(point: Point, count: integer)
```

Discard items to point

@*param* `point` — Target point

@*param* `count` — Discard quantity
## event

```lua
fun(self: Item, event: "Item - Get ", callback: fun(trg: Trigger, data: EventParam. Items - Get)):Trigger
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

## get_ability

```lua
(method) Item:get_ability()
  -> ability: Ability?
```

The active skill of acquiring objects

@*return* `ability` — Active skill
## get_attribute

```lua
(method) Item:get_attribute(key: string)
  -> number
```

Gets the basic properties of an item

@*param* `key` — Statskey
## get_attribute_by_key

```lua
function Item.get_attribute_by_key(item_key: py.ItemKey, key: string)
  -> number
```

Gets the base attributes of the item type

@*param* `key` — Statskey

@*param* `item_key` — Item type
## get_bonus_attribute

```lua
(method) Item:get_bonus_attribute(key: string)
  -> number
```

Gets the item's gain attribute

@*param* `key` — Statskey
## get_by_handle

```lua
function Item.get_by_handle(py_item: py.Item)
  -> Item?
```

Get an item instance in lua from a skill instance in py

@*param* `py_item` — pyLayer of prop instances

@*return* — Returns the lua layer item instance after being initialized in the lua layer
## get_by_id

```lua
function Item.get_by_id(id: py.ItemID)
  -> Item
```

 Get the item instance of the lua layer by id

@*return* — Returns the lua layer item instance after being initialized in the lua layer
## get_charge

```lua
(method) Item:get_charge()
  -> charges: integer
```

Item charge number

@*return* `charges` — Charge number
## get_custom_event_manager

```lua
(method) CustomEvent:get_custom_event_manager()
  -> EventManager?
```

## get_description

```lua
(method) Item:get_description()
  -> description: string
```

Get item description

@*return* `description` — Item description
## get_description_by_key

```lua
function Item.get_description_by_key(item_key: py.ItemKey)
  -> string
```

Get a description of the item type

@*param* `item_key` — Item type
## get_facing

```lua
(method) Item:get_facing()
  -> angel: number
```

Gets the orientation of the item

@*return* `angel` — orientation
## get_hp

```lua
(method) Item:get_hp()
  -> hp: number
```

Gain item health

@*return* `hp` — The item's health
## get_icon

```lua
(method) Item:get_icon()
  -> py.Texture
```

Gets the icon of the item
## get_icon_id_by_key

```lua
function Item.get_icon_id_by_key(item_key: py.ItemKey)
  -> py.Texture
```

Gets a picture of the icon of the item typeid

@*param* `item_key` — Item type
## get_id

```lua
(method) Item:get_id()
  -> integer
```

 Get uniqueID
## get_item_buy_price_by_key

```lua
function Item.get_item_buy_price_by_key(item_key: py.ItemKey, key: string|y3.Const.PlayerAttr)
  -> price: number
```

Get item purchase price

@*param* `item_key` — type

@*param* `key` — Player attributes

@*return* `price` — Price
## get_item_group_in_area

```lua
function Item.get_item_group_in_area(area: Area)
  -> ItemGroup
```

Get all items in the area

@*param* `area` — region
## get_item_sell_price_by_key

```lua
function Item.get_item_sell_price_by_key(item_key: py.ItemKey, key: string|y3.Const.PlayerAttr)
  -> price: number
```

Get item selling price

@*param* `item_key` — type

@*param* `key` — Player attributes

@*return* `price` — Price
## get_key

```lua
(method) Item:get_key()
  -> key: py.ItemKey
```

Get item typeid

@*return* `key` — type
## get_level

```lua
(method) Item:get_level()
  -> level: integer
```

Get item level

@*return* `level` — Item level
## get_max_charge

```lua
(method) Item:get_max_charge()
  -> max_charge: integer
```

Get the maximum charge number

@*return* `max_charge` — Maximum charge number
## get_model

```lua
(method) Item:get_model()
  -> model_key: py.ModelKey
```

Get item model

@*return* `model_key` — Model type
## get_model_by_key

```lua
function Item.get_model_by_key(item_key: py.ItemKey)
  -> model_key: py.ModelKey
```

Gets a model of the item type

@*param* `item_key` — Item type

@*return* `model_key` — Model type
## get_name

```lua
(method) Item:get_name()
  -> name: string
```

Get item name

@*return* `name` — Item name
## get_name_by_key

```lua
function Item.get_name_by_key(item_key: py.ItemKey)
  -> string
```

Gets the item type name

@*param* `item_key` — Item type
## get_num_of_item_mat

```lua
function Item.get_num_of_item_mat(item_key: py.ItemKey, comp_item_key: py.ItemKey)
  -> integer
```

Item Type The number of item types required for composition
## get_num_of_player_attr

```lua
function Item.get_num_of_player_attr(item_key: py.ItemKey, role_res_key: py.RoleResKey)
  -> number
```

The number of player attributes required for item type synthesis
## get_owner

```lua
(method) Item:get_owner()
  -> owner: Unit?
```

possessor

@*return* `owner` — holder
## get_owner_player

```lua
(method) Item:get_owner_player()
  -> player: Player?
```

The owning player who acquires the item

@*return* `player` — Player
## get_passive_ability

```lua
(method) Item:get_passive_ability(index: integer)
  -> ability: Ability?
```

Passive ability to acquire items

@*return* `ability` — Passive skill
## get_point

```lua
(method) Item:get_point()
  -> position: Point
```

Item location

@*return* `position` — Item location
## get_scale

```lua
(method) Item:get_scale()
  -> scale: number
```

Get item scaling

@*return* `scale` — Item scaling
## get_slot

```lua
(method) Item:get_slot()
  -> index: integer
```

Gets the grid position of the item on the body of the unit

@*return* `index` — Lattice position
## get_slot_type

```lua
(method) Item:get_slot_type()
  -> Knapsack slot type: py.SlotType
```

Get items on the unit body in the backpack slot type
## get_stack

```lua
(method) Item:get_stack()
  -> stacks: integer
```

Item stack

@*return* `stacks` — Stack number
## get_tags_by_key

```lua
function Item.get_tags_by_key(item_key: py.ItemKey)
  -> string[]
```

Get all labels for the item
## handle

```lua
py.Item
```

Item object
## has_tag

```lua
(method) Item:has_tag(tag: string)
  -> is_has_tag: boolean
```

Presence tag

@*param* `tag` — Remove label

@*return* `is_has_tag` — Label or not
## has_tag_by_key

```lua
function Item.has_tag_by_key(tag: string, item_key: py.ItemKey)
  -> is_has_tag: boolean
```

Item type Whether a label exists

@*param* `tag` — tag

@*param* `item_key` — Item type

@*return* `is_has_tag` — Label or not
## id

```lua
py.ItemID
```

itemID
## is_destroyed

```lua
(method) Item:is_destroyed()
  -> boolean|unknown
```

## is_exist

```lua
(method) Item:is_exist()
  -> is_exist: boolean
```

Existence or not

@*return* `is_exist` — Existence or not
## is_in_bag

```lua
(method) Item:is_in_bag()
  -> is_in_bag: boolean
```

Items in the backpack bar

@*return* `is_in_bag` — Whether in the backpack bar
## is_in_bar

```lua
(method) Item:is_in_bar()
  -> is_in_bar: boolean
```

Items are in the inventory

@*return* `is_in_bar` — Whether it's in the inventory
## is_in_scene

```lua
(method) Item:is_in_scene()
  -> is_in_scene: boolean
```

Whether it is in the scene

@*return* `is_in_scene` — Whether it is in the scene
## key

```lua
integer?
```

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

## phandle

```lua
py.Item
```

Item object
## ref_manager

```lua
unknown
```

## remove

```lua
(method) Item:remove()
```

Delete item
## remove_tag

```lua
(method) Item:remove_tag(tag: string)
```

@*param* `tag` — tag
## set_attr

```lua
(method) Item:set_attr(attr_name: string, value: number, attr_type: string)
```

Set attribute

@*param* `attr_name` — Attribute name

@*param* `value` — Attribute value

@*param* `attr_type` — Attribute type
## set_attribute

```lua
(method) Item:set_attribute(key: string, value: number)
```

Set base properties

@*param* `key` — Statskey

@*param* `value` — Attribute value
## set_bonus_attribute

```lua
(method) Item:set_bonus_attribute(key: string, value: number)
```

Set gain attribute

@*param* `key` — Statskey

@*param* `value` — Attribute value
## set_charge

```lua
(method) Item:set_charge(charge: integer)
```

Set the charge amount

@*param* `charge` — Charge number
## set_description

```lua
(method) Item:set_description(description: string)
```

Set the description of the item

@*param* `description` — Description
## set_droppable

```lua
(method) Item:set_droppable(dropable: boolean)
```

Set discard state

@*param* `dropable` — status
## set_facing

```lua
(method) Item:set_facing(facing: number)
```

Orient items

@*param* `facing` — orientation
## set_hp

```lua
(method) Item:set_hp(value: number)
```

Set health

@*param* `value` — Vitality
## set_icon

```lua
(method) Item:set_icon(picture_id: py.Texture)
```

Set the item's icon

@*param* `picture_id` — pictureid
## set_level

```lua
(method) Item:set_level(level: integer)
```

Set level

@*param* `level` — Lv.
## set_max_charge

```lua
(method) Item:set_max_charge(charge: integer)
```

Set the maximum charge number

@*param* `charge` — Maximum charge number
## set_name

```lua
(method) Item:set_name(name: string)
```

Set the name of the item

@*param* `name` — Name
## set_owner_player

```lua
(method) Item:set_owner_player(player: Player)
```

Set owned players

@*param* `player` — Owned player
## set_point

```lua
(method) Item:set_point(point: Point)
```

Move to point 

@*param* `point` — 点
## set_sale_state

```lua
(method) Item:set_sale_state(state: boolean)
```

Sets whether items can be sold

@*param* `state` — Availability for sale
## set_scale

```lua
(method) Item:set_scale(scale: number)
```

Set item scale

@*param* `scale` — Zoom
## set_shop_price

```lua
function Item.set_shop_price(id: py.ItemKey, player_attr_name: py.RoleResKey, price: number)
```

Set item prices

@*param* `id` — itemid

@*param* `player_attr_name` — Player attributes

@*param* `price` — Price
## set_stack

```lua
(method) Item:set_stack(stack: integer)
```

Set the number of stacks

@*param* `stack` — Stack number
## set_visible

```lua
(method) Item:set_visible(is_visible: boolean)
```

Set item visibility

@*param* `is_visible` — Visible or not
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


# Item.DrapOperation

```lua
"No "|" left button and "|" right button"
```


# Item.UseOperation

```lua
"No |. Left-click |. Right-click |"
```


