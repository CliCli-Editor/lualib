--Projectile set
---@class ProjectileGroup
---@field handle py.ProjectileGroup
---@overload fun(py_projectile_group: py.ProjectileGroup): self
local M = Class 'ProjectileGroup'

M.type = 'projectile_group'

---@param py_projectile_group py.ProjectileGroup
---@return self
function M:__init(py_projectile_group)
    self.handle = py_projectile_group
    return self
end

function M:__pairs()
    return self:pairs()
end

---@param py_projectile_group py.ProjectileGroup
---@return ProjectileGroup
function M.create_lua_projectile_group_from_py(py_projectile_group)
    local projectile_group = New 'ProjectileGroup' (py_projectile_group)
    return projectile_group
end

clicli.py_converter.register_py_to_lua('py.ProjectileGroup', M.create_lua_projectile_group_from_py)
clicli.py_converter.register_lua_to_py('py.ProjectileGroup', function (lua_value)
    return lua_value.handle
end)

---Screen all projectiles within range
---@param point Point
---@param shape Shape Filtering range
---@return ProjectileGroup
function M.get_all_projectile_in_shapes(point, shape)
    local py_projectile_group = GameAPI.filter_projectile_id_list_in_area(
        --TODO see question 2
        ---@diagnostic disable-next-line: param-type-mismatch
        point.handle,
        shape.handle)
    return M.create_lua_projectile_group_from_py(py_projectile_group)
end

---Gets the projectile with the specified label
---@param tag string
---@return ProjectileGroup
function M.get_all_projectiles_with_tag(tag)
    local py_projectile_group = GameAPI.get_all_projectiles_with_tag(tag)
    return M.create_lua_projectile_group_from_py(py_projectile_group)
end

---Take the intersection of two projectile groups
---@param projectile_group ProjectileGroup Another projectile group
---@return ProjectileGroup Intersection projectiles group
function M:intersection(projectile_group)
    local py_projectile_group = GameAPI.get_projectile_group_intersection(self.handle, projectile_group.handle)
    return M.create_lua_projectile_group_from_py(py_projectile_group)
end

---Take the difference set of two groups of projectiles (projectiles belonging to one group but not the other)
---@param projectile_group ProjectileGroup Another projectile group
---@return ProjectileGroup Difference projectileGroup
function M:difference(projectile_group)
    local py_projectile_group = GameAPI.get_projectile_group_diff(self.handle, projectile_group.handle)
    return M.create_lua_projectile_group_from_py(py_projectile_group)
end

---Move through projectiles in the projectiles group
---@return Projectile[]
function M:pick()
    local lua_table ={}
    for _, id in pairs(self.handle) do
        table.insert(lua_table,clicli.projectile.get_by_id(id))
    end
    return lua_table
end

---Traverse the projectile group, do not modify the projectile group during the traverse.
---```lua
---for projectile in ProjectileGroup:pairs() do
---print(projectile)
---end
---```
---You can also iterate directly with 'pairs' :
---```lua
---for projectile in pairs(ProjectileGroup) do
---print(projectile)
---end
---```
---@return fun(): Projectile?
function M:pairs()
    local i = -1
    local len = #self.handle
    return function ()
        i = i + 1
        if i >= len then
            return
        end
        local id = self.handle[i]
        local pr = clicli.projectile.get_by_id(id)
        return pr
    end
end

return M
