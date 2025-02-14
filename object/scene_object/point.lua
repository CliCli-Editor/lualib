---@alias Point.HandleType py.FVector3

--point
---@class Point
---@field handle Point.HandleType
---@field res_id? integer
---@overload fun(py_point: Point.HandleType): self
---@overload fun(x: number, y: number, z?: number): self
local M = Class 'Point'

M.type = 'point'

function M:__tostring()
    return string.format('{Point|%.3f,%.3f,%.3f}'
        , self:get_x()
        , self:get_y()
        , self:get_z()
    )
end

---@param py_point Point.HandleType
---@return self
function M:__init(py_point)
    if not py_point then
        error('传进来的 py_point 为空！')
    end
    self.handle = py_point
    return self
end

---@private
---@param x number
---@param y number
---@param z? number
---@return Point
function M:__alloc(x, y, z)
    return M.create(x, y, z)
end

---@private
M.map = {}

---@param res_id integer
---@return Point
function M.get_point_by_res_id(res_id)
    if not M.map[res_id] then
        local py_point = GameAPI.get_point_by_res_id(res_id)
        local point = M.get_by_handle(py_point)
        point.res_id = res_id
        M.map[res_id] = point
    end
    return M.map[res_id]
end

---根据py对象创建点
---@param py_point Point.HandleType
---@return Point
function M.get_by_handle(py_point)
    local point = New 'Point' (py_point)
    return point
end

clicli.py_converter.register_type_alias('py.Point', 'Point')
clicli.py_converter.register_py_to_lua('py.Point', M.get_by_handle)
clicli.py_converter.register_lua_to_py('py.Point', function (lua_value)
    return lua_value.handle
end)
clicli.py_converter.register_py_to_lua('py.Vector3', M.get_by_handle)
clicli.py_converter.register_lua_to_py('py.Vector3', function (lua_value)
    return lua_value.handle
end)

---点的x坐标
---@return number
function M:get_x()
    if not self.x then
        ---@diagnostic disable-next-line: undefined-field
        self.x = self.handle:get_x()
    end
    return self.x
end

---点的y坐标
---@return number
function M:get_y()
    if not self.y then
        ---@diagnostic disable-next-line: undefined-field
        self.y = self.handle:get_y()
    end
    return self.y
end

---点的z坐标
---@return number
function M:get_z()
    if not self.z then
        ---@diagnostic disable-next-line: undefined-field
        self.z = self.handle:get_z()
    end
    return self.z
end

---@return Point
function M:get_point()
    return self
end

--Moving point
---@param x number?
---@param y number?
---@param z number?
---@return Point
function M:move(x, y, z)
    local nx = self:get_x() + (x or 0)
    local ny = self:get_y() + (y or 0)
    local nz = self:get_z() + (z or 0)
    return M.create(nx, ny, nz)
end

---坐标转化为点
---@param x number 点X坐标
---@param y number 点Y坐标
---@param z? number 点Z坐标
---@return Point
function M.create(x, y, z)
    ---@diagnostic disable-next-line: param-type-mismatch
    local py_point = Fix32Vec3(x / 100, (z or 0) / 100, y / 100)
    -- TODO 见问题2
    ---@diagnostic disable-next-line: param-type-mismatch
    local p = M.get_by_handle(py_point)
    p.x = x
    p.y = y
    p.z = z or 0
    return p
end

---点向方向偏移
---@param point Point 点
---@param direction number 偏移方向点
---@param offset number 偏移量
---@return Point
function M.get_point_offset_vector(point, direction, offset)
    ---@diagnostic disable-next-line: undefined-field
    local py_point = point.handle:get_point_offset_vector(direction, offset)
    -- TODO 见问题2
    ---@diagnostic disable-next-line: param-type-mismatch
    return M.get_by_handle(py_point)
end

---路径中的点
---@param path table 目标路径
---@param index integer 索引
---@return Point
function M.get_point_in_path(path,index)
    local py_point = GlobalAPI.get_point_in_route(path.handle, index)
    return M.get_by_handle(py_point)
end

--Gets the direction with another point
---@param other Point
---@return number
function M:get_angle_with(other)
    -- TODO 见问题2
    ---@diagnostic disable-next-line: param-type-mismatch, undefined-field
    return clicli.helper.tonumber(self.handle:get_angle_with(other.handle)) or 0.0
end

--Gets the distance from another point
---@param other Point
---@return number
function M:get_distance_with(other)
    -- TODO 见问题2
    ---@diagnostic disable-next-line: param-type-mismatch, undefined-field
    return clicli.helper.tonumber(self.handle:get_distance_with(other.handle)) or 0.0
end

--Gets random points in a circle range
function M:get_random_point(radius)
    ---@diagnostic disable-next-line: undefined-field
    local p = self.handle:get_random_point(radius)
    ---@diagnostic disable-next-line: param-type-mismatch
    return M.get_by_handle(p)
end

return M
