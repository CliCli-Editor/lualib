--projectile
---@class Projectile
---@field handle py.ProjectileEntity
---@field private _removed_by_py boolean
---@overload fun(id: integer, py_projectile: py.ProjectileEntity): self
local M = Class 'Projectile'
M.type = 'projectile'

---@class Projectile: Storage
Extends('Projectile', 'Storage')
---@class Projectile: GCHost
Extends('Projectile', 'GCHost')
---@class Projectile: CoreObjectEvent
Extends('Projectile', 'CoreObjectEvent')
---@class Projectile: KV
Extends('Projectile', 'KV')

function M:__tostring()
    return string.format('{projectile|%s|%s}'
        , self:get_key()
        , self.handle
    )
end

---@param id integer
---@param py_projectile py.ProjectileEntity
---@return self
function M:__init(id, py_projectile)
    self.handle = py_projectile
    self.id     = id
    return self
end

function M:__del()
    self:remove()
end

function M:__encode()
    return self.id
end

function M:__decode(id)
    local obj = M.get_by_id(id)
    return obj
end

---@package
M.ref_manager = New 'Ref' ('Projectile', function (id)
    local py_proj = GameAPI.get_projectile_by_id(id)
    if not py_proj then
        return nil
    end
    return New 'Projectile' (id, py_proj)
end)

---@param py_projectile py.ProjectileEntity
---@return Projectile? projectile
function M.get_by_handle(py_projectile)
    if not py_projectile then
        return nil
    end
    local id = py_projectile:api_get_id()
    local projectile = M.ref_manager:get(id)
    return projectile
end

---@param id py.ProjectileID
---@return Projectile
function M.get_by_id(id)
    local projectile = M.ref_manager:get(id)
    return projectile
end

clicli.py_converter.register_py_to_lua('py.Projectile', M.get_by_handle)
clicli.py_converter.register_lua_to_py('py.Projectile', function (lua_value)
    return lua_value.handle
end)
clicli.py_converter.register_py_to_lua('py.ProjectileID', M.get_by_id)

---Gets the type ID of the projectile
---@return py.ProjectileKey projectile_key
function M:get_key()
    return self.handle:api_get_key() or 0
end

---Existence or not
---@return boolean is_exist Whether it exists
function M:is_exist()
    return  GameAPI.projectile_is_exist(self.handle)
end

---Gets projectile height
---@return number height Height
function M:get_height()
    ---@diagnostic disable-next-line: undefined-field
    return clicli.helper.tonumber(self.handle:api_get_height()) or 0.0
end

---Gets the remaining duration of the projectile
---@return number duration Remaining duration of projectiles
function M:get_left_time()
    return clicli.helper.tonumber(self.handle:api_get_left_time()) or 0.0
end

---Gets the owner of the projectile
---@return Unit? unit The owner of the projectile
function M:get_owner()
    local py_unit = self.handle:api_get_owner()
    if not py_unit then
        return nil
    end
    return clicli.unit.get_by_handle(py_unit)
end

---Gets projectile orientation
---@return number angle Object orientation
function M:get_facing()
    return clicli.helper.tonumber(self.handle:api_get_face_angle()) or 0.0
end

---Get the point where the projectile is
---@return Point point Indicates the point where the projectile resides
function M:get_point()
    local py_point = self.handle:api_get_position()
    if not py_point then
        return clicli.point(6553600, 6553600)
    end
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    local point = clicli.point.get_by_handle(py_point)
    point.z = self:get_height()
    return point
end

---Have a label or not
---@param tag string Tag
---@return boolean Whether is_has_tag has a tag
function M:has_tag(tag)
    return GlobalAPI.has_tag(self.handle, tag)
end

---Projectiles add labels
---@param tag string Tag
function M:add_tag(tag)
    self.handle:api_add_tag(tag)
end

---Projectile removal tag
---@param tag string Tag
function M:remove_tag(tag)
    self.handle:api_remove_tag(tag)
end

---@class Projectile.CreateData
---@field key py.ProjectileKey Projectiles type ID
---@field target Point|Unit Create location
---@field socket? string projectiles associated with bones, valid only if 'target' is a unit
---@field angle? number Projectile orientation
---@field height? number Projectile height
---@field time? number Projectile duration
---@field owner? Unit|Player Projectile owner
---@field ability? Ability Projectile association skill
---@field visible_rule? integer | clicli.Const.VisibleType The particle effect visibility rule, which defaults to '1'
---@field remove_immediately? boolean Specifies whether to remove the representation immediately. If not filled, the table is read
---@field show_in_fog? boolean Whether to display in fog, default is' false '

--Create projectiles
---@param data Projectile.CreateData Projectiles create data
---@return Projectile
function M.create(data)
    if not data.owner then
        data.owner = clicli.player.get_by_id(31)
    end
    if data.ability and not data.ability:is_exist() then
        data.ability = nil
    end
    local target = data.target
    if target.type == 'point' then
        ---@cast target Point
        local py_obj = GameAPI.create_projectile_in_scene_new(
            data.key,
            target.handle,
            --TODO see question 3
            ---@diagnostic disable-next-line: param-type-mismatch
            data.owner.handle,
            Fix32(data.angle or 0.0),
            data.ability and data.ability.handle or nil,
            Fix32(data.time or 60.0),
            data.time and true or false,
            Fix32(data.height or 0.0),
            clicli.const.VisibleType[data.visible_rule] or data.visible_rule or 1,
            data.remove_immediately or false,
            data.remove_immediately == nil and true or false,
            data.show_in_fog or false
        )
        return M.get_by_handle(py_obj) --[[@as Projectile]]
    else
        ---@cast target Unit
        if not target:is_destroyed() then
            ---@cast target Unit
            local py_obj = GameAPI.create_projectile_on_socket(
                data.key,
                target.handle,
                data.socket or 'origin',
                Fix32(data.angle or 0.0),
                --TODO see question 3
                ---@diagnostic disable-next-line: param-type-mismatch
                data.owner.handle,
                data.ability and data.ability.handle or nil,
                clicli.const.VisibleType[data.visible_rule] or data.visible_rule or 1,
                Fix32(data.time or 60.0),
                data.time and true or false,
                data.remove_immediately or false,
                data.remove_immediately == nil and true or false,
                data.show_in_fog or false
            )
            return M.get_by_handle(py_obj) --[[@as Projectile]]
        end
        error("bind projectile on destroyed unit")
    end
end

---Set a unit
---@param unit Unit to which unit belongs
function M:set_owner(unit)
    GameAPI.change_projectile_owner(self.handle, unit.handle)
end

---Set associated skills
---@param ability Ability Relate skills
function M:set_ability(ability)
    GameAPI.change_projectile_ability(self.handle, ability.handle)
end

---destroy
function M:remove()
    if not self._removed then
        self._removed = true
        if not self._removed_by_py then
            self.handle:api_delete()
        end
    end
end

---Set height
---@param height number Height
function M:set_height(height)
    self.handle:api_raise_height(Fix32(height))
end

---Set coordinates
---@param point Point Point coordinates
function M:set_point(point)
    --TODO see question 3
    ---@diagnostic disable-next-line: param-type-mismatch
    self.handle:api_set_position(point.handle)
end

---orientation
---@param direction number Indicates the direction
function M:set_facing(direction)
    self.handle:api_set_face_angle(direction)
end

---Set rotation
---@param x number x axis
---@param y number y axis
---@param z number z axis
function M:set_rotation(x, y, z)
    self.handle:api_set_rotation(x, y, z)
end

---Set scale
---@param x number x axis
---@param y number y axis
---@param z number z axis
function M:set_scale(x, y, z)
    self.handle:api_set_scale(x, y, z)
end

---Set animation speed
---@param speed number
function M:set_animation_speed(speed)
    self.handle:api_set_animation_speed(speed)
end

---Set duration
---@param duration number Indicates the duration
function M:set_time(duration)
    self.handle:api_set_duration(duration)
end

---Increase duration
---@param duration number Indicates the duration
function M:add_time(duration)
    self.handle:api_add_duration(duration)
end

---Acquire relevant skills
---@return Ability? ability The ability to associate projectiles or magical effects
function M:get_ability()
    local py_ability = GlobalAPI.get_related_ability(self.handle)
    if py_ability then
        return clicli.ability.get_by_handle(py_ability)
    end
    return nil
end

--Sets the visibility of the projectile
---@param visible boolean # Visible or not
---@param player_or_group? Player | PlayerGroup # To which players, default is all players
function M:set_visible(visible, player_or_group)
    player_or_group = player_or_group or clicli.player_group.get_all_players()
    ---@diagnostic disable-next-line: param-type-mismatch
    self.handle:api_set_projectile_visible(player_or_group.handle, visible)
end

function M:is_destroyed()
    ---@diagnostic disable-next-line: undefined-field
    local yes = self.handle:is_destroyed()
    if yes == nil then
        return true
    end
    return yes
end

function M:get_type()
    return 64
end

return M
