--Lightning Effects (Beam)
---@class Beam
---@field handle py.LinkSfx
---@overload fun(py_beam: py.LinkSfx): self
local M = Class 'Beam'
M.type = 'beam'

---@param py_beam py.LinkSfx
---@return self
function M:__init(py_beam)
    self.handle = py_beam
    return self
end

function M:__del()
    GameAPI.remove_link_sfx(self.handle)
end

---@param py_beam py.LinkSfx
---@return Beam beam
function M.create_lua_beam_by_py(py_beam)
    local beam = New 'Beam' (py_beam)
    return beam
end

clicli.py_converter.register_py_to_lua('py.LinkSfx', M.create_lua_beam_by_py)
clicli.py_converter.register_lua_to_py('py.LinkSfx', function (lua_value)
    return lua_value.handle
end)

---@class Beam.CreateData
---@field key py.SfxKey Special effect id
---@field source Unit|Point Target
---@field target Unit|Point Target
---@field time? number time of existence
---@field source_height? number Height (only if the target is a point)
---@field target_height? number Height (only if the target is a point)
---@field source_socket? string Mount contact (only if the target is a unit)
---@field target_socket? string Mount contact (only if the target is a unit)
---@field follow_scale? boolean Whether to follow scaling (only if starting point is a unit)
---@field immediate? boolean Specifies whether there is an overshoot when destroying

---@param data Beam.CreateData
---@return Beam
function M.create(data)
    ---@type py.LinkSfx
    local link_sfx
    local key    = data.key
    local source = data.source
    local target = data.target
    local time   = Fix32(data.time or -1)
    local source_height = data.source_height or 0
    local target_height = data.target_height or 0
    local source_socket = data.source_socket or 'origin'
    local target_socket = data.target_socket or 'origin'
    local follow_scale  = data.follow_scale
    local immediate     = data.immediate
    if source.type == 'unit' then
        ---@cast source Unit
        if target.type == 'point' then
            ---@cast target Point
            link_sfx = GameAPI.create_link_sfx_from_unit_to_point(
                key,
                source.handle,
                source_socket,
                target.handle,
                Fix32(target_height),
                ---@diagnostic disable-next-line: param-type-mismatch
                time,
                immediate,
                immediate == nil,
                follow_scale
            )
        else
            ---@cast target Unit
            link_sfx = GameAPI.create_link_sfx_from_unit_to_unit(
                key,
                source.handle,
                source_socket,
                target.handle,
                target_socket,
                ---@diagnostic disable-next-line: param-type-mismatch
                time,
                immediate,
                immediate == nil,
                follow_scale
            )
        end
    else
        ---@cast source Point
        if target.type == 'point' then
            ---@cast target Point
            link_sfx = GameAPI.create_link_sfx_from_point_to_point(
                key,
                source.handle,
                Fix32(source_height),
                target.handle,
                Fix32(target_height),
                ---@diagnostic disable-next-line: param-type-mismatch
                time,
                immediate,
                immediate == nil
            )
        else
            ---@cast target Unit
            link_sfx = GameAPI.create_link_sfx_from_point_to_unit(
                key,
                source.handle,
                Fix32(source_height),
                target.handle,
                target_socket,
                ---@diagnostic disable-next-line: param-type-mismatch
                time,
                immediate,
                immediate == nil
            )
        end
    end

    local beam = M.create_lua_beam_by_py(link_sfx)
    return beam
end


---Link effects - Destroy
function M:remove()
    Delete(self)
end


---@param is_show boolean Specifies whether to display
---Link effects - Show/Hide
function M:show(is_show)
    GameAPI.enable_link_sfx_show(self.handle, is_show)
end

---@class Beam.LinkData
---@ field point_type clicli. Const. LinkSfxPointType starting point or a destination
---@field target Unit|Point Target
---@field height? number Height (only if the target is a point)
---@field socket? string Mount contact (only if the target is a unit)

---Link Effects - Set the location
---@param data Beam.LinkData
function M:set(data)
    local target = data.target
    if target.type == 'point' then
        ---@cast target Point
        GameAPI.set_link_sfx_point(
            self.handle,
            data.point_type,
            --TODO see question 2
            ---@diagnostic disable-next-line: param-type-mismatch
            target.handle,
            data.height or 0
        )
    end
    if target.type == 'unit' then
        ---@cast target Unit
        GameAPI.set_link_sfx_unit_socket(
            self.handle,
            data.point_type,
            target.handle,
            data.socket or 'origin'
        )
    end
end

return M
