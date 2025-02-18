--Item group
---@class ItemGroup
---@field handle py.ItemGroup
---@overload fun(py_item_group: py.ItemGroup): self
local M = Class 'ItemGroup'
M.type = 'item_group'

---@param py_item_group py.ItemGroup
---@return self
function M:__init(py_item_group)
    self.handle = py_item_group
    return self
end

function M:__pairs()
    return self:pairs()
end

---@param py_item_group py.ItemGroup
---@return ItemGroup
function M.create_lua_item_group_from_py(py_item_group)
    local item_group = New 'ItemGroup' (py_item_group)
    return item_group
end

---@param py_item_group py.ItemGroup
---@return ItemGroup
function M.get_by_handle(py_item_group)
    return M.create_lua_item_group_from_py(py_item_group)
end

clicli.py_converter.register_py_to_lua('py.ItemGroup', M.get_by_handle)
clicli.py_converter.register_lua_to_py('py.ItemGroup', function (lua_value)
    return lua_value.handle
end)

--Go through the item group and the player does the action
---@return Item[]
function M:pick()
    local lua_table ={}
    for i = 0, python_len(self.handle)-1 do
        local iter_item = python_index(self.handle,i)
        table.insert(lua_table,clicli.item.get_by_id(iter_item))
    end
    return lua_table
end

---Walk through the item group, do not modify the item group during the walk.
---```lua
---for item in ItemGroup:pairs() do
---print(item)
---end
---```
---You can also iterate directly with 'pairs' :
---```lua
---for item in pairs(ItemGroup) do
---print(item)
---end
---```
---@return fun(): Item?
function M:pairs()
    local i = -1
    local len = python_len(self.handle)
    return function ()
        i = i + 1
        if i >= len then
            return
        end
        local id = python_index(self.handle, i)
        local it = clicli.item.get_by_id(id)
        return it
    end
end

---Sift through all items in the range
---@param point Point
---@param shape Shape Filtering range
---@return ItemGroup
function M.get_all_items_in_shapes(point,shape)
    local py_item_group = GameAPI.get_all_items_in_shapes(
        --TODO see question 2
        ---@diagnostic disable-next-line: param-type-mismatch
        point.handle,
        shape.handle
    )
    return M.create_lua_item_group_from_py(py_item_group)
end

function M.create()
    return M.get_by_handle(GameAPI.create_unit_group()--[[@as py.ItemGroup]])
end

return M
