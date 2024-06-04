local helper = require 'y3.develop.helper.helper'

---@class Develop.Helper.TreeView: GCHost
---@overload fun(name: string, root: Develop.Helper.TreeNode): Develop.Helper.TreeView
local View = Class 'Develop.Helper.TreeView'
Extends('Develop.Helper.TreeView', 'GCHost')

View.maxID = 0

---@param name string
---@param root Develop.Helper.TreeNode
function View:__init(name, root)
    self.name = name
    self.root = root

    View.maxID = View.maxID + 1
    self.id = View.maxID

    helper.onReady(function ()
        helper.notify('createTreeView', {
            id = self.id,
            name = self.name,
            root = self.root.id,
        })
    end)
end

function View:__del()
    helper.onReady(function ()
        helper.notify('removeTreeView', {
            id = self.id,
        })
    end)
    Delete(self.root)
end

---@class Develop.Helper.TreeNode.Optional
---@field icon? string # 图标，见 https://code.visualstudio.com/api/references/icons-in-labels#icon-listing
---@field description? string # 描述
---@field tooltip? string # 提示
---@field childs? Develop.Helper.TreeNode[] # 子节点列表。如果子节点计算量较大，可以改用 `childsGetter` 来获取子节点
---@field childsGetter? fun(node: Develop.Helper.TreeNode): Develop.Helper.TreeNode[] # 当试图展开节点时，会调用这个函数获取子节点，和 `childs` 互斥
---@field onVisible? fun(node: Develop.Helper.TreeNode) # 当节点能被看到时调用
---@field onInvisible? fun(node: Develop.Helper.TreeNode) # 当节点看不到时调用
---@field onClick? fun(node: Develop.Helper.TreeNode) # 当节点被点击时调用
---@field onExpand? fun(node: Develop.Helper.TreeNode) # 当节点被展开时调用
---@field onCollapse? fun(node: Develop.Helper.TreeNode) # 当节点被折叠时调用

---@class Develop.Helper.TreeNode: GCHost, Class.Base
---@field name string
---@field description? string # 描述
---@field icon? string # 图标
---@field tooltip? string # 提示
---@field package childs? Develop.Helper.TreeNode[]
---@overload fun(name: string, optional: Develop.Helper.TreeNode.Optional): Develop.Helper.TreeNode
local Node = Class 'Develop.Helper.TreeNode'
Extends('Develop.Helper.TreeNode', 'GCHost')

---@private
Node.maxID = 0

---@private
---@type table<integer, Develop.Helper.TreeNode>
Node.nodeMap = {}

---@param name string
---@param optional Develop.Helper.TreeNode.Optional
function Node:__init(name, optional)
    optional = optional or {}
    self.name = name
    self.optional = optional
    self.description = optional.description
    self.tooltip = optional.tooltip
    self.icon = optional.icon
    Node.maxID = Node.maxID + 1
    self.id = Node.maxID

    Node.nodeMap[self.id] = self
end

function Node:__del()
    Node.nodeMap[self.id] = nil

    self:changeVisible(false)

    if self.childs then
        for _, child in ipairs(self.childs) do
            Delete(child)
        end
    end
end

---@package
Node._description = nil

---@param self Develop.Helper.TreeNode
---@return string?
Node.__getter.description = function (self)
    return self._description
end

---@param self Develop.Helper.TreeNode
---@param desc string
Node.__setter.description = function (self, desc)
    if self._description == desc then
        return
    end
    self._description = desc
    self:refresh()
end

---@package
Node._tooltip = nil

---@param self Develop.Helper.TreeNode
---@return string?
Node.__getter.tooltip = function (self)
    return self._tooltip
end

---@param self Develop.Helper.TreeNode
---@param tooltip string
Node.__setter.tooltip = function (self, tooltip)
    if self._tooltip == tooltip then
        return
    end
    self._tooltip = tooltip
    self:refresh()
end

---@package
Node._icon = nil

---@param self Develop.Helper.TreeNode
---@return string?
Node.__getter.icon = function (self)
    return self._icon
end

---@param self Develop.Helper.TreeNode
---@param icon string
Node.__setter.icon = function (self, icon)
    if self._icon == icon then
        return
    end
    self._icon = icon
    self:refresh()
end

---@package
function Node:refresh()
    if not Node.nodeMap[self.id] then
        return
    end
    if not self._visible then
        return
    end
    helper.notify('refreshTreeNode', {
        id = self.id,
    })
end

---@private
Node._visible = false

---@param visible boolean
function Node:changeVisible(visible)
    if not Node.nodeMap[self.id] then
        visible = false
    end
    if self._visible == visible then
        return
    end
    self._visible = visible
    if visible then
        if self.optional.onVisible then
            xpcall(self.optional.onVisible, log.error, self)
        end
    else
        if self.optional.onInvisible then
            xpcall(self.optional.onInvisible, log.error, self)
        end
    end
end

---@return boolean
function Node:isVisible()
    return self._visible
end

---@private
Node._expanded = false

---@param expanded boolean
function Node:changeExpanded(expanded)
    if self._expanded == expanded then
        return
    end
    self._expanded = expanded
    if expanded then
        if self.optional.onExpand then
            xpcall(self.optional.onExpand, log.error, self)
        end
    else
        if self.optional.onCollapse then
            xpcall(self.optional.onCollapse, log.error, self)
        end
    end
end

---@return boolean
function Node:isExpanded()
    return self._expanded
end

helper.registerMethod('getTreeNode', function (params)
    ---@type integer
    local id = params.id
    local node = Node.nodeMap[id]
    if not node then
        return
    end

    node:changeVisible(true)

    return {
        name = node.name,
        desc = node.description,
        tip  = node.tooltip,
        icon = node.icon,
        hasChilds = (node.optional.childs or node.optional.childsGetter) and true,
        canClick  = node.optional.onClick and true,
    }
end)

helper.registerMethod('getChildTreeNodes', function (params)
    ---@type integer
    local id = params.id
    local node = Node.nodeMap[id]
    if not node then
        return
    end
    local childs = node.optional.childs
    local childsGetter = node.optional.childsGetter
    if not childs and not childsGetter then
        return
    end

    ---@param nodes Develop.Helper.TreeNode[]
    ---@return integer[]
    local function packList(nodes)
        local list = {}
        for i, v in ipairs(nodes) do
            list[i] = v.id
        end
        return list
    end

    ---@param newChilds Develop.Helper.TreeNode[]
    local function updateChilds(newChilds)
        local lastChilds = node.childs
        if lastChilds and lastChilds ~= newChilds then
            local newMap = {}
            for _, v in ipairs(newChilds) do
                newMap[v] = true
            end
            for _, v in ipairs(lastChilds) do
                if not newMap[v] then
                    Delete(v)
                end
            end
        end
        node.childs = newChilds
    end

    if childsGetter then
        local suc, newChilds = xpcall(childsGetter, log.error, node)
        if suc then
            updateChilds(newChilds)
            return packList(newChilds)
        end
    end
    if childs then
        updateChilds(childs)
        return packList(childs)
    end
end)

helper.registerMethod('changeTreeNodeVisible', function (params)
    ---@type integer[]
    local ids = params.ids
    for _, id in ipairs(ids) do
        local node = Node.nodeMap[id]
        if node then
            node:changeVisible(params.visible)
        end
    end
end)

helper.registerMethod('clickTreeNode', function (params)
    ---@type integer
    local id = params.id
    local node = Node.nodeMap[id]
    if node and node.optional.onClick then
        xpcall(node.optional.onClick, log.error, node)
    end
end)

helper.registerMethod('changeTreeNodeExpanded', function (params)
    ---@type integer
    local id = params.id
    local node = Node.nodeMap[id]
    if node then
        node:changeExpanded(params.expanded)
    end
end)
