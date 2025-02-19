local event_configs = require 'clicli.meta.eventconfig'
local get_master    = require 'clicli.util.get_master'

--Object editor
---@class EditorObject
local M = Class 'EditorObject'

---@class EditorObject.DataModule
---@field private data_key string
local DataModule = Class 'EditorObject.DataModule'

---@diagnostic disable-next-line: undefined-field
DataModule.__getter.data = function (self)
    return GameAPI.api_get_editor_type_data(self.data_key, self.key), true
end

---@diagnostic disable-next-line: undefined-field
DataModule.__getter.lua_data = function (self)
    local data = GameAPI.api_get_editor_type_data(self.data_key, self.key)
    return setmetatable({}, {
        __index = function (_, k)
            local v = data[k]
            return clicli.helper.as_lua(v, true)
        end,
        __newindex = function (_, k, v)
            data[k] = clicli.helper.as_py(v)
        end
    })
end

---@private
local last_key = 910000000

---@package
function DataModule:make_new_key()
    for i = last_key + 1, last_key + 10000 do
        if not GameAPI.api_get_editor_type_data(self.data_key, i) then
            last_key = i
            return i
        end
    end
    error('No available item found. key:' .. tostring(last_key))
end

---@class EditorObject.Event
---@field package type string
---@field get_key fun(self: any): integer
local Event = Class 'EditorObject.Event'

local gameEvents = {}

---@param self EditorObject.Event
---@param name string
---@return Trigger
local function initGameEventProxy(self, name)
    local otype = self.type
    local objects = M[otype]
    local config = event_configs.config[name]
    if not config or not config.object then
        error(string.format('Event `%s` cannot be treated as an object event', name))
    end
    return clicli.game:event(name, function (trg, data)
        local master = get_master(name, data)
        if not master then
            return
        end
        local key = master:get_key()
        local object = objects[key]
        ---@type EventManager?
        local event_manager = object and object.event_manager
        if not event_manager then
            return
        end
        data['_master'] = master
        event_manager:notify(name, nil, data)
    end)
end

---@param name string
---@param callback function
---@return Trigger
function Event:event(name, callback)
    if not self.event_manager then
        ---@private
        self.event_manager = New 'EventManager' (self)
    end
    if not gameEvents[name] then
        gameEvents[name] = initGameEventProxy(self, name)
    end
   local trg = self.event_manager:event(name, nil, callback)
   return trg
end

---@class EditorObject.Unit: EditorObject.DataModule
---@field key py.UnitKey
---@field on_create? fun(unit: Unit) # Execute after the unit is created
---@field on_remove? fun(unit: Unit) # Execute after the unit is removed
---@field on_dead? fun(unit: Unit) # Executed after the death of the unit
---Unit of object data, you can read or modify any object from it (some fields cannot be modified)
---If you want to modify the data, create a new object using the 'new' method and pass in the data to be modified at creation time
---@field data Object.Unit
---Unit of object data, you can read or modify any object from it (some fields cannot be modified)
---If you want to modify the data, create a new object using the 'new' method and pass in the data to be modified at creation time
---Data read using this field is automatically converted to lua type and is automatically converted to python type when written.
---@field lua_data Object.Unit
local Unit = Class 'EditorObject.Unit'

Extends('EditorObject.Unit', 'EditorObject.DataModule')
---@class EditorObject.Unit: EditorObject.Event
Extends('EditorObject.Unit', 'EditorObject.Event')
---@class EditorObject.Unit: KV
Extends('EditorObject.Unit', 'KV')
Unit.kv_key = 'unit_key'

---@private
Unit.data_key = 'editor_unit'

Unit.type = 'unit'

function Unit:__init(key)
    self.key = key
end

--Use this unit as a template to create a new unit object
---@param new_default_key? py.UnitKey
---@param data? Object.UnitOptions
---@return EditorObject.Unit
function Unit:new(new_default_key, data)
    ---@diagnostic disable: undefined-field
    local new_key = new_default_key or self:make_new_key()
    GameAPI.create_unit_editor_data_lua(self.key, new_key, data)
    ---@diagnostic enable: undefined-field
    return M.unit[new_key]
end

---@type table<integer, EditorObject.Unit>
M.unit = clicli.util.defaultTable(function (key)
    return New 'EditorObject.Unit' (key)
end)

---@class EditorObject.Item: EditorObject.DataModule
---@field key py.ItemKey
---@field on_add? fun(item: Item) # Execute after the item is acquired
---@field on_lose? fun(item: Item) # Item lost after execution
---@field on_create? fun(item: Item) # Item created after execution
---@field on_remove? fun(item: Item) # Execute after item removal
---@field on_add_to_pkg? fun(item: Item) # Execute after the item enters the backpack
---@field on_add_to_bar? fun(item: Item) # Execute after the item enters the equipment bar
---@field on_use? fun(item: Item) # Item is executed when used
---Item's catalog data, you can read or modify any catalog from it (some fields cannot be modified)
--> Warning: Make sure the data type is correct, otherwise it may cause a crash
--> Warning: If you create this item and then modify the data, the behavior is undefined
---@field data Object.Item
---Item's catalog data, you can read or modify any catalog from it (some fields cannot be modified)
---Data read using this field is automatically converted to lua type and is automatically converted to python type when written.
---@field lua_data Object.Item
local Item = Class 'EditorObject.Item'

Extends('EditorObject.Item', 'EditorObject.DataModule')
---@class EditorObject.Item: EditorObject.Event
Extends('EditorObject.Item', 'EditorObject.Event')
---@class EditorObject.Item: KV
Extends('EditorObject.Item', 'KV')
Item.kv_key = 'item_key'

---@private
Item.data_key = 'editor_item'

Item.type = 'item'

function Item:__init(key)
    self.key = key
end

--Use this item as a template to create a new item
---@return EditorObject.Item
function Item:new()
    local new_key = GameAPI.create_item_editor_data(self.key)
    return M.item[new_key]
end

---@type table<integer, EditorObject.Item>
M.item = clicli.util.defaultTable(function (key)
    return New 'EditorObject.Item' (key)
end)

---@class EditorObject.Buff: EditorObject.DataModule
---@field key py.ModifierKey
---@field on_can_add? fun(buff: Buff) # Execute when the effect is about to be obtained
---@field on_add? fun(buff: Buff) # After the effect is obtained, execute
---@field on_lose? fun(buff: Buff) # Effect lost after execution
---@field on_pulse? fun(buff: Buff) # The effect is executed after heartbeat
---@field on_stack_change? fun(buff: Buff) # Execute after the number of effect layers changes
---Magic effect object data, you can read or modify any object from it (some fields cannot be modified)
--> Warning: Make sure the data type is correct, otherwise it may cause a crash
--> Warning: If you modify the data after creating this magic effect, the behavior is undefined
---@field data Object.Buff
---Magic effect object data, you can read or modify any object from it (some fields cannot be modified)
---Data read using this field is automatically converted to lua type and is automatically converted to python type when written.
---@field lua_data Object.Buff
local Buff = Class 'EditorObject.Buff'

Extends('EditorObject.Buff', 'EditorObject.DataModule')
---@class EditorObject.Buff: EditorObject.Event
Extends('EditorObject.Buff', 'EditorObject.Event')
---@class EditorObject.Buff: KV
Extends('EditorObject.Buff', 'KV')
Buff.kv_key = 'modifier_key'

---@private
Buff.data_key = 'modifier_all'

Buff.type = 'buff'

function Buff:__init(key)
    self.key = key
end

--Create a new magic effect for the template from this magic effect
---@return EditorObject.Buff
function Buff:new()
    local new_key = GameAPI.create_modifier_editor_data(self.key)
    return M.buff[new_key]
end

---@type table<integer, EditorObject.Buff>
M.buff = clicli.util.defaultTable(function (key)
    return New 'EditorObject.Buff' (key)
end)

---@class EditorObject.Ability: EditorObject.DataModule
---@field key py.AbilityKey
---@field on_add? fun(ability: Ability) # Execute after skills are acquired
---@field on_lose? fun(ability: Ability) # Skills lost after execution
---@field on_cooldown? fun(ability: Ability) # Execute when cooldown ends
---@field on_upgrade? fun(ability: Ability) # Execute after skill upgrade
---@field on_can_cast? fun(ability: Ability, cast: Cast) # Execute when the skill is about to cast
---@field on_cast_start? fun(ability: Ability, cast: Cast) # The skill is executed when the spell begins
---@field on_cast_channel? fun(ability: Ability, cast: Cast) # Skills guide when casting
---@field on_cast_shot? fun(ability: Ability, cast: Cast) # The skill is executed when casting spells
---@field on_cast_finish? fun(ability: Ability, cast: Cast) # The skill is executed when the spell is completed
---@field on_cast_stop? fun(ability: Ability, cast: Cast) # The skill is executed when it stops casting spells
---Skill's object compilation data, you can read any object compilation from it
---If you want to modify the data, create a new object using the 'new' method and pass in the data to be modified at creation time
---@field data Object.Ability
---Skill's object compilation data, you can read any object compilation from it
---If you want to modify the data, create a new object using the 'new' method and pass in the data to be modified at creation time
---Data read using this field is automatically converted to lua type and is automatically converted to python type when written.
---@field lua_data Object.Ability
local Ability = Class 'EditorObject.Ability'

Extends('EditorObject.Ability', 'EditorObject.DataModule')
---@class EditorObject.Ability: EditorObject.Event
Extends('EditorObject.Ability', 'EditorObject.Event')
---@class EditorObject.Ability: KV
Extends('EditorObject.Ability', 'KV')
Ability.kv_key = 'ability_key'

---@private
Ability.data_key = 'ability_all'

Ability.type = 'ability'

function Ability:__init(key)
    self.key = key
end

--Create a new skill set from this skill template
---@param new_default_key? py.AbilityKey # If no key is specified, a new key is automatically generated
---@param data? Object.AbilityOptions # Data to be modified
---@return EditorObject.Ability
function Ability:new(new_default_key, data)
    ---@diagnostic disable: undefined-field
    local new_key = new_default_key or self:make_new_key()
    GameAPI.create_ability_editor_data_lua(self.key, new_key, data)
    ---@diagnostic enable: undefined-field
    return M.ability[new_key]
end

---@type table<integer, EditorObject.Ability>
M.ability = clicli.util.defaultTable(function (key)
    return New 'EditorObject.Ability' (key)
end)

---@class EditorObject.Projectile: EditorObject.DataModule
---@field key py.ProjectileKey
---@field on_create? fun(projectile: Projectile) # Executed when the projectile is created
---@field on_remove? fun(projectile: Projectile) # Execute when the projectile is destroyed
---The object compilation data of the projectile, you can read or modify any object compilation from it (some fields cannot be modified)
--> Warning: Make sure the data type is correct, otherwise it may cause a crash
--> Warning: If you create this projectile and modify the data, the behavior is undefined
---@field data Object.Projectile
---The object compilation data of the projectile, you can read or modify any object compilation from it (some fields cannot be modified)
---Data read using this field is automatically converted to lua type and is automatically converted to python type when written.
---@field lua_data Object.Projectile
local Projectile = Class 'EditorObject.Projectile'

Extends('EditorObject.Projectile', 'EditorObject.DataModule')
---@class EditorObject.Projectile: EditorObject.Event
Extends('EditorObject.Projectile', 'EditorObject.Event')
---@class EditorObject.Projectile: KV
Extends('EditorObject.Projectile', 'KV')
Projectile.kv_key = 'projectile_key'

---@private
Projectile.data_key = 'projectile_all'

Projectile.type = 'projectile'

function Projectile:__init(key)
    self.key = key
end

--Create a new projectile from this projectile as a template
---@return EditorObject.Projectile
function Projectile:new()
    local new_key = GameAPI.create_projectile_editor_data(self.key)
    return M.projectile[new_key]
end

---@type table<integer, EditorObject.Projectile>
M.projectile = clicli.util.defaultTable(function (key)
    return New 'EditorObject.Projectile' (key)
end)


---@class EditorObject.Destructible: EditorObject.DataModule
---@field key py.DestructibleKey
---Destructible object compilation data from which you can read or modify any object compilation (some fields cannot be modified)
--> Warning: Make sure the data type is correct, otherwise it may cause a crash
--> Warning: If you create this destructible and then modify the data, the behavior is undefined
---@field data Object.Destructible
---Destructible object compilation data from which you can read or modify any object compilation (some fields cannot be modified)
---Data read using this field is automatically converted to lua type and is automatically converted to python type when written.
---@field lua_data Object.Destructible
local Destructible = Class 'EditorObject.Destructible'

Extends('EditorObject.Destructible', 'EditorObject.DataModule')
---@class EditorObject.Projectile: EditorObject.Event
Extends('EditorObject.Destructible', 'EditorObject.Event')
---@class EditorObject.Projectile: KV
Extends('EditorObject.Destructible', 'KV')
Destructible.kv_key = 'destructible_key'

---@private
Destructible.data_key = 'editor_destructible'

Destructible.type = 'destructible'

function Destructible:__init(key)
    self.key = key
end

--Create a new destructible from this projectile as a template
---@return EditorObject.Destructible
function Destructible:new()
    local new_key = GameAPI.create_destructible_editor_data(self.key)
    return M.destructible[new_key]
end

---@type table<integer, EditorObject.Destructible>
M.destructible = clicli.util.defaultTable(function (key)
    return New 'EditorObject.Destructible' (key)
end)

--abandoned
do
    ---@package
    M.lock_count_map = setmetatable({}, {
        __mode = 'k',
        __index = function (t, k)
            t[k] = 0
            return 0
        end,
    })
    ---@package
    M.call_stack_map = setmetatable({}, {
        __mode = 'k',
        __index = function (t, k)
            t[k] = {}
            return t[k]
        end,
    })

    local function applyMethod(stack, key, func, arg1, arg2)
        M.lock_count_map[key] = M.lock_count_map[key] + 1
        xpcall(func, log.error, arg1, arg2)
        M.lock_count_map[key] = M.lock_count_map[key] - 1
        if #stack > 0 and M.lock_count_map[key] == 0 then
            table.remove(stack, 1)()
        end
    end

    ---@package
    ---@param otype string
    ---@param mname string
    ---@param key any
    ---@param lock_obj any
    ---@param arg1 any
    ---@param arg2 any
    function M.callMethod(otype, mname, key, lock_obj, arg1, arg2)
        local def  = M[otype][key]
        local func = def[mname]
        if not func then
            return
        end
        if not lock_obj then
            xpcall(func, log.error, arg1, arg2)
            return
        end
        local stack = M.call_stack_map[lock_obj]
        if M.lock_count_map[key] > 0 then
            stack[#stack+1] = function ()
                applyMethod(stack, key, func, arg1, arg2)
            end
            return
        end
        applyMethod(stack, key, func, arg1, arg2)
    end

    local function subscribe(class, method, callback)
        local mark
        class.__setter[method] = function (self, value)
            if not mark then
                mark = true
                callback()
            end
            return value
        end
    end

    subscribe(Unit, 'on_create', function ()
        clicli.game:event('Unit - Create', function (trg, data)
            M.callMethod('unit', 'on_create', data.unit:get_key(), data.unit, data.unit)
        end)
    end)

    subscribe(Unit, 'on_remove', function ()
        clicli.game:event('Unit - Remove', function (trg, data)
            M.callMethod('unit', 'on_remove', data.unit:get_key(), data.unit, data.unit)
        end)
    end)

    subscribe(Unit, 'on_dead', function ()
        clicli.game:event('Unit - Death', function (trg, data)
            M.callMethod('unit', 'on_dead', data.unit:get_key(), data.unit, data.unit)
        end)
    end)

    subscribe(Item, 'on_add', function ()
        clicli.game:event('Items - Get', function (trg, data)
            M.callMethod('item', 'on_add', data.item:get_key(), data.item, data.item)
        end)
    end)

    subscribe(Item, 'on_lose', function ()
        clicli.game:event('Item - lost', function (trg, data)
            M.callMethod('item', 'on_lose', data.item:get_key(), data.item, data.item)
        end)
    end)

    subscribe(Item, 'on_create', function ()
        clicli.game:event('Items - Create', function (trg, data)
            M.callMethod('item', 'on_create', data.item:get_key(), data.item, data.item)
        end)
    end)

    subscribe(Item, 'on_remove', function ()
        clicli.game:event('Items - Removal', function (trg, data)
            M.callMethod('item', 'on_remove', data.item:get_key(), data.item, data.item)
        end)
    end)

    subscribe(Item, 'on_add_to_pkg', function ()
        clicli.game:event('Items - Enter backpack', function(trg, data)
            M.callMethod('item', 'on_add_to_pkg', data.item:get_key(), data.item, data.item)
        end)
    end)

    subscribe(Item, 'on_add_to_bar', function ()
        clicli.game:event('Items - Enter the inventory', function(trg, data)
            M.callMethod('item', 'on_add_to_bar', data.item:get_key(), data.item, data.item)
        end)
    end)

    subscribe(Item, 'on_use', function ()
        clicli.game:event('Items - Use', function(trg, data)
            M.callMethod('item', 'on_use', data.item:get_key(), data.item, data.item)
        end)
    end)

    subscribe(Buff, 'on_can_add', function ()
        clicli.game:event('Effect - Coming soon', function (trg, data)
            M.callMethod('buff', 'on_can_add', data.buff:get_key(), data.buff, data.buff)
        end)
    end)

    subscribe(Buff, 'on_add', function ()
        clicli.game:event('Effect - gain', function (trg, data)
            M.callMethod('buff', 'on_add', data.buff:get_key(), data.buff, data.buff)
        end)
    end)

    subscribe(Buff, 'on_lose', function ()
        clicli.game:event('effect-loss', function (trg, data)
            M.callMethod('buff', 'on_lose', data.buff:get_key(), data.buff, data.buff)
        end)
    end)

    subscribe(Buff, 'on_pulse', function ()
        clicli.game:event('Effect - Heartbeat', function (trg, data)
            M.callMethod('buff', 'on_pulse', data.buff:get_key(), data.buff, data.buff)
        end)
    end)

    subscribe(Buff, 'on_stack_change', function ()
        clicli.game:event('Effect - Number of layers change', function (trg, data)
            M.callMethod('buff', 'on_stack_change', data.buff:get_key(), data.buff, data.buff)
        end)
    end)

    subscribe(Ability, 'on_add', function ()
        clicli.game:event('Skills - Acquisition', function (trg, data)
            M.callMethod('ability', 'on_add', data.ability:get_key(), data.ability, data.ability)
        end)
    end)

    subscribe(Ability, 'on_lose', function ()
        clicli.game:event('Skill loss', function (trg, data)
            M.callMethod('ability', 'on_lose', data.ability:get_key(), data.ability, data.ability)
        end)
    end)

    subscribe(Ability, 'on_cooldown', function ()
        clicli.game:event('Skill - Cooldown ends', function (trg, data)
            M.callMethod('ability', 'on_cooldown', data.ability:get_key(), data.ability, data.ability)
        end)
    end)

    subscribe(Ability, 'on_upgrade', function ()
        clicli.game:event('Skills - Upgrades', function (trg, data)
            M.callMethod('ability', 'on_upgrade', data.ability:get_key(), data.ability, data.ability)
        end)
    end)

    subscribe(Ability, 'on_can_cast', function ()
        clicli.game:event('Casting. - About to begin', function (trg, data)
            M.callMethod('ability', 'on_can_cast', data.ability:get_key(), nil, data.ability, data.cast)
        end)
    end)

    subscribe(Ability, 'on_cast_start', function ()
        clicli.game:event('Cast the spell. - Here we go', function (trg, data)
            M.callMethod('ability', 'on_cast_start', data.ability:get_key(), nil, data.ability, data.cast)
        end)
    end)

    subscribe(Ability, 'on_cast_channel', function ()
        clicli.game:event('Cast - Guide', function (trg, data)
            M.callMethod('ability', 'on_cast_channel', data.ability:get_key(), nil, data.ability, data.cast)
        end)
    end)

    subscribe(Ability, 'on_cast_shot', function ()
        clicli.game:event('Cast spells. - Strike', function (trg, data)
            M.callMethod('ability', 'on_cast_shot', data.ability:get_key(), nil, data.ability, data.cast)
        end)
    end)

    subscribe(Ability, 'on_cast_finish', function ()
        clicli.game:event('Cast a spell. - Finished', function (trg, data)
            M.callMethod('ability', 'on_cast_finish', data.ability:get_key(), nil, data.ability, data.cast)
        end)
    end)

    subscribe(Ability, 'on_cast_stop', function ()
        clicli.game:event('Cast spells. - Stop', function (trg, data)
            M.callMethod('ability', 'on_cast_stop', data.ability:get_key(), nil, data.ability, data.cast)
        end)
    end)

    subscribe(Projectile, 'on_create', function ()
        clicli.game:event('Projectiles - Created', function (trg, data)
            M.callMethod('projectile', 'on_create', data.projectile:get_key(), data.projectile, data.projectile)
        end)
    end)

    subscribe(Projectile, 'on_remove', function ()
        clicli.game:event('Projectiles - Death', function (trg, data)
            M.callMethod('projectile', 'on_remove', data.projectile:get_key(), data.projectile, data.projectile)
        end)
    end)

end

return M
