--shape
---@class Shape
---@field handle py.Shape
---@overload fun(py_shape: py.Shape): self
local M = Class 'Shape'

M.type = 'shape'

---@param py_shape py.Shape
---@return self
function M:__init(py_shape)
    self.handle = py_shape
    return self
end

---@param py_shape py.Shape
---@return Shape
function M.get_by_handle(py_shape)
    return New 'Shape' (py_shape)
end

---Create a ring
---@param in_radius number Internal radius
---@param out_radius number External radius
---@return Shape
function M.create_annular_shape(in_radius, out_radius)
    local py_shape = GlobalAPI.create_annular_shape(Fix32(in_radius), Fix32(out_radius))
    return M.get_by_handle(py_shape)
end

---Create a circle
---@param radius number Radius
---@return Shape
function M.create_circular_shape(radius)
    local py_shape = GlobalAPI.create_circular_shape(Fix32(radius))
    return M.get_by_handle(py_shape)
end

---Create a rectangular area
---@param width number Width
---@param length number Length
---@param angle number Indicates the Angle
---@param offset_x_ratio? number # Offset x
---@param offset_y_ratio? number # Offset y
---@return Shape
function M.create_rectangle_shape(width, length, angle, offset_x_ratio, offset_y_ratio)
    local py_shape = GlobalAPI.create_rectangle_shape(Fix32(width), Fix32(length), angle,
    offset_x_ratio and Fix32(offset_x_ratio) or nil, offset_y_ratio and Fix32(offset_y_ratio) or nil)
    return M.get_by_handle(py_shape)
end

---sector
---@param radius number Radius
---@param angle number Indicates the Angle
---@param direction number Indicates the direction
---@return Shape
function M.create_sector_shape(radius, angle, direction)
    local py_shape = GlobalAPI.create_sector_shape(Fix32(radius), Fix32(angle), direction)
    return M.get_by_handle(py_shape)
end

return M
