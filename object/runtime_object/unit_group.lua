--Unit group
---@class UnitGroup
---@field handle py.UnitGroup
---@overload fun(py_unit_group?: py.UnitGroup): self
local M = Class 'UnitGroup'

---@param py_unit_group py.UnitGroup
---@return self
function M:__init(py_unit_group)
    self.handle = py_unit_group
    return self
end

function M:__len()
    return self:count()
end

function M:__pairs()
    return self:pairs()
end

---@param py_unit_group py.UnitGroup
---@return UnitGroup
function M.get_by_handle(py_unit_group)
    local unit_group = New 'UnitGroup' (py_unit_group)
    return unit_group
end

clicli.py_converter.register_py_to_lua('py.UnitGroup', M.get_by_handle)
clicli.py_converter.register_lua_to_py('py.UnitGroup', function (lua_value)
    return lua_value.handle
end)

--Example Create an empty unit group
---@return UnitGroup
function M.create()
    return M.get_by_handle(GameAPI.create_unit_group())
end

--Converts a group of units to an array of units in Lua
---@return Unit[]
function M:pick()
    local lua_table ={}
    for i = 1, python_len(self.handle) do
        local iter_unit = python_index(self.handle,i-1)
        table.insert(lua_table,clicli.unit.get_by_id(iter_unit))
    end
    return lua_table
end

---遍历单位组，请勿在遍历过程中修改单位组。
---```lua
---for unit in UnitGroup:pairs() do
---    print(unit)
---end
---```
---也可以直接用 `pairs` 遍历：
---```lua
---for unit in pairs(UnitGroup) do
---    print(unit)
---end
---```
---@return fun(): Unit?
function M:pairs()
    local i = -1
    local len = python_len(self.handle)
    return function ()
        i = i + 1
        if i >= len then
            return
        end
        local id = python_index(self.handle, i)
        local u = clicli.unit.get_by_id(id)
        return u
    end
end

--Select units by unit group
function M:select_units()
    GameAPI.set_unit_group_selected(self.handle)
end

--Add unit
---@param unit Unit 单位
function M:add_unit(unit)
    GameAPI.add_unit_to_group(unit.handle,self.handle)
end

--Remove unit
---@param unit Unit 单位
function M:remove_unit(unit)
    GameAPI.remove_unit_in_group(self.handle, unit.handle)
end

--Remove unit type
---@param unit_key py.UnitKey 单位类型id
function M:remove_units_by_key(unit_key)
    GameAPI.remove_unit_in_group_by_key(self.handle, unit_key)
end

--Empty unit group
function M:clear()
    GlobalAPI.clear_group(self.handle)
end

--A random integer in a unit group
---@param count integer
---@return UnitGroup unit_group  随机整数个单位
function M:pick_random_n(count)
    local py_unit_group =GameAPI.get_random_n_unit_in_group(self.handle, count)
    return M.get_by_handle(py_unit_group)
end

--Selects the unit for the specified unit type
---@param unit_key py.UnitKey 单位类型id
---@return UnitGroup unit_group 单位组
function M.pick_by_key(unit_key)
    local py_unit_group = GameAPI.get_units_by_key(unit_key)
    return M.get_by_handle(py_unit_group)
end

--Gets the number of units in a unit group
---@return integer unit_group_num 单位数量
function M:count()
    return GameAPI.get_unit_group_num(self.handle)
end

--The number of unit types in a unit group
---@param unit_key py.UnitKey
---@return integer num_of_unit 单位类型的数量
function M:count_by_key(unit_key)
    return GameAPI.get_num_of_unit_key_in_group(self.handle,unit_key)
end

--Gets the first unit in the unit group
---@return Unit? unit 单位组内第一个单位
function M:get_first()
    local py_unit = GameAPI.get_first_unit_in_group(self.handle)
    if not py_unit then
        return nil
    end
    return clicli.unit.get_by_handle(py_unit)
end

--Gets a random unit in a unit group
---@return Unit? unit 单位组中随机一个单位
function M:get_random()
    local py_unit = GameAPI.get_random_unit_in_unit_group(self.handle)
    if not py_unit then
        return nil
    end
    return clicli.unit.get_by_handle(py_unit)
end

--Gets the last unit in the unit group
---@return Unit? unit 最后一个单位
function M:get_last()
    local py_unit = GameAPI.get_last_unit_in_group(self.handle)
    if not py_unit then
        return nil
    end
    return clicli.unit.get_by_handle(py_unit)
end

return M
