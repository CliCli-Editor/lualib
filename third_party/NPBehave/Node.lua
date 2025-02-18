---@class NPBehave.Node 'abstract', should not be instantiated directly, please use subclass <br>
---@field protected currentState NPBehave.Enum.NodeState
---@field CurrentState NPBehave.Enum.NodeState `__getter`
---@field RootNode NPBehave.Root
---@field ParentNode? NPBehave.Container
---@field Label string Displays labels
---@field Name string
---@field Blackboard NPBehave.Blackboard `__getter`
---@field Clock NPBehave.Clock `__getter`
---@field IsStopRequested boolean `__getter`
---@field IsActive boolean `__getter`
---@overload fun(name: string): self
local Node = Class("NPBehave.Node")

---@class NPBehave.Node: NPBehave.Tool.MethodDecorator
Extends('NPBehave.Node', "NPBehave.Tool.MethodDecorator")




---@diagnostic disable-next-line: undefined-field
Node.__getter.CurrentState = function(self)
    ---@cast self NPBehave.Node
    ---@diagnostic disable-next-line: invisible
    return self.currentState
end

---@diagnostic disable-next-line: undefined-field
Node.__getter.Blackboard = function(self)
    ---@cast self NPBehave.Node
    ---@diagnostic disable-next-line: invisible
    return self.RootNode.Blackboard
end

---@diagnostic disable-next-line: undefined-field
Node.__getter.Clock = function(self)
    ---@cast self NPBehave.Node
    ---@diagnostic disable-next-line: invisible
    return self.RootNode.Clock
end

---@diagnostic disable-next-line: undefined-field
Node.__getter.IsStopRequested = function(self)
    ---@cast self NPBehave.Node
    ---@diagnostic disable-next-line: invisible
    return self.currentState == NPBehave.Enum.NodeState.StopRequested
end

---@diagnostic disable-next-line: undefined-field
Node.__getter.IsActive = function(self)
    ---@cast self NPBehave.Node
    ---@diagnostic disable-next-line: invisible
    return self.currentState == NPBehave.Enum.NodeState.Active
end

---@param name string
---@return self
function Node:__init(name)
    self.name = name
    self.currentState = NPBehave.Enum.NodeState.Inactive
    return self
end

---virtual<br>
---@param rootNode NPBehave.Root
function Node:SetRoot(rootNode)
    self.RootNode = rootNode
end

---@param parentNode NPBehave.Container
function Node:SetParent(parentNode)
    self.ParentNode = parentNode
end

function Node:Start()
    assert(self.currentState == NPBehave.Enum.NodeState.Inactive, "Only inactive nodes can be started")
    self.currentState = NPBehave.Enum.NodeState.Active
    self:DoStart()
end

function Node:CancelWithoutReturnResult()
    assert(self.currentState == NPBehave.Enum.NodeState.Active, "Can only stop the active node, try to stop")
    self.currentState = NPBehave.Enum.NodeState.StopRequested
    self:DoCancel()
end

---@protected
---virtual<br>
function Node:DoStart()
end
---@protected
---virtual<br>
function Node:DoCancel()
end

---@protected
---virtual<br>
---This must absolutely be the last call in the function, do not modify any state after the call stops!!
function Node:Stopped(success)
    assert(self.currentState ~= NPBehave.Enum.NodeState.Inactive, "When 'Stopped' is dropped in the 'INACTIVE' state, something is wrong")
    self.currentState = NPBehave.Enum.NodeState.Inactive
    if self.ParentNode ~= nil then
        self.ParentNode:ChildStopped(self, success)
    end
end

---virtual<br>
---@param composite NPBehave.Composite.Composite
function Node:ParentCompositeStopped(composite)
    self:DoParentCompositeStopped(composite)
end


---@protected
---virtual<br>
--Called when in an inactive state in order to have the decorator remove any waiting observers.
---@param composite NPBehave.Composite.Composite
function Node:DoParentCompositeStopped(composite)
    --Call with care
end

---override<br>
function Node:__tostring()
    return self.Label ~= nil and self.Name .. '{' .. self.Label .. '}' or self.Name
end

---@protected
function Node:GetPath()
    if self.ParentNode ~= nil then
        return self.ParentNode:GetPath() .. '/' .. self.Name
    else
        return self.Name
    end
end

return Node
