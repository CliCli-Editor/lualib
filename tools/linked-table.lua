---@class LinkedTable
---@field package _left  table
---@field package _right table
local M = {}
M.__index = M

---@private
M._size = 0

local HEAD = {'<HEAD>'}
local TAIL = {'<TAIL>'}

---@param node any
---@return boolean
function M:has(node)
    return self._left[node] ~= nil
end

---@param node any
---@return boolean
function M:isValidNode(node)
    if node == nil
    or node == HEAD
    or node == TAIL then
        return false
    end
    return true
end

---@param node any
---@param afterWho any
---@return boolean
function M:pushAfter(node, afterWho)
    if not self:isValidNode(node) then
        return false
    end
    if self:has(node) then
        return false
    end
    local right = self._right[afterWho]
    if not right then
        return false
    end
    self._right[afterWho] = node
    self._right[node]     = right
    self._left[right]     = node
    self._left[node]      = afterWho

    self._size = self._size + 1
    return true
end

---@param node any
---@param beforeWho any
---@return boolean
function M:pushBefore(node, beforeWho)
    if node == nil then
        return false
    end
    local left = self._left[beforeWho]
    if not left then
        return false
    end
    return self:pushAfter(node, left)
end

---@param node any
---@return boolean
function M:pop(node)
    if not self:isValidNode(node) then
        return false
    end
    local left = self._left[node]
    if not left then
        return false
    end
    local right = self._right[node]
    self._right[left] = right
    self._left[right] = left

    self._right[node] = nil
    self._left[node]  = nil

    self._size = self._size - 1
    return true
end

---@param node any
---@return boolean
function M:pushHead(node)
    return self:pushAfter(node, HEAD)
end

---@param node any
---@return boolean
function M:pushTail(node)
    return self:pushBefore(node, TAIL)
end

---@param node any
---@return any
function M:getAfter(node)
    if node == nil then
        node = HEAD
    end
    local right = self._right[node]
    if right == TAIL then
        return nil
    end
    return right
end

---@return any
function M:getHead()
    return self:getAfter(HEAD)
end

---@param node any
---@return any
function M:getBefore(node)
    if node == nil then
        node = TAIL
    end
    local left = self._left[node]
    if left == HEAD then
        return nil
    end
    return left
end

---@return any
function M:getTail()
    return self:getBefore(TAIL)
end

---@return boolean
function M:popHead()
    return self:pop(self:getHead())
end

---@return boolean
function M:popTail()
    return self:pop(self:getTail())
end

---@param old any
---@param new any
---@return boolean
function M:replace(old, new)
    if not self:isValidNode(old)
    or not self:isValidNode(new) then
        return false
    end
    local left = self._left[old]
    if not left then
        return false
    end
    local right = self._right[old]
    self._right[left] = new
    self._right[new]  = right
    self._left[right] = new
    self._left[new]   = left

    self._right[old]  = nil
    self._left[old]   = nil
    return true
end

---@return integer
function M:getSize()
    return self._size
end

---@param lt LinkedTable
---@param current any
---@return any
local function pairsLeftNode(lt, current)
    local node = lt._left[current or TAIL]
    if node == HEAD then
        return nil
    end
    return node
end

---@param lt LinkedTable
---@param current any
---@return any
local function pairsRightNode(lt, current)
    local node = lt._right[current or HEAD]
    if node == TAIL then
        return nil
    end
    return node
end

--Traversing the linked list is fast, but does not support changing the current node
---@param start any
---@param revert? boolean
---@return fun():any
---@return LinkedTable
---@return any
function M:pairsFast(start, revert)
    if revert then
        if start ~= nil then
            start = self._right[start]
        end
        return pairsLeftNode, self, start
    else
        if start ~= nil then
            start = self._left[start]
        end
        return pairsRightNode, self, start
    end
end

--Traversing the linked list, traversing to the current node has identified the next node,
--So change the current node (for example, delete the current node)
--Does not affect the next node to be traversed
---@param start any
---@param revert? boolean
---@return fun():any
function M:pairs(start, revert)
    if revert then
        if start == nil then
            start = self._left[TAIL]
        end
        local next = start
        return function ()
            local current = next
            if current == HEAD then
                return nil
            end
            next = self._left[current]
            return current
        end
    else
        if start == nil then
            start = self._right[HEAD]
        end
        local next = start
        return function ()
            local current = next
            if current == TAIL then
                return nil
            end
            next = self._right[current]
            return current
        end
    end
end

--We go through the nodes, we make a copy of the list before we start,
--So changing the list during traversal does not affect the traversal result,
--But at a slower pace
function M:pairsSafe(start, revert)
    local nodes = {}
    for node in self:pairsFast(start, revert) do
        nodes[#nodes+1] = node
    end
    local i = 0
    return function ()
        i = i + 1
        return nodes[i]
    end
end

---@param start any
---@param revert? boolean
---@return string
function M:dump(start, revert)
    local t = {}
    for node in self:pairsFast(start, revert) do
        t[#t+1] = tostring(node)
    end
    return table.concat(t, ' ')
end

function M:reset()
    self._left  = { [TAIL] = HEAD }
    self._right = { [HEAD] = TAIL }

    self._size = 0
end

---@param start any
---@param revert? boolean
---@return any[]
function M:toArray(start, revert)
    local nodes = {}
    for node in self:pairsFast(start, revert) do
        nodes[#nodes+1] = node
    end
    return nodes
end

---@class LinkedTable.API
local API = {}

---@return LinkedTable
function API.create()
    local lt = setmetatable({}, M)
    lt:reset()
    return lt
end

return API
