local assert = assert
local IsInstanceOf = IsInstanceOf
---@class NPBehave.Decorator.ObservingDecorator
---@field StartObserving fun() abstract
---@field StopObserving fun() abstract
---@field IsConditionMet fun() abstract
---@overload fun(name: string, stopsOnChange: NPBehave.Enum.Stops, decoratee: NPBehave.Node): self
local ObservingDecorator = Class(NPBehave.ClassName.ObservingDecorator)
local superName = NPBehave.ClassName.Decorator

---@class NPBehave.Decorator.ObservingDecorator: NPBehave.Decorator.Decorator
Extends(NPBehave.ClassName.ObservingDecorator, superName, function(self, super, ...)
    local name, _, decoratee = ...
    super(name, decoratee)
end)


---@param name string
---@param stopsOnChange NPBehave.Enum.Stops
---@param decoratee NPBehave.Node
---@return self
function ObservingDecorator:__init(name, stopsOnChange, decoratee)
    self.StopsOnChange = stopsOnChange
    self._isObserving = false;
    return self
end

---override<br>
---@protected
function ObservingDecorator:DoStart()
    if self.StopsOnChange ~= NPBehave.Enum.Stops.None then
        if not self._isObserving then
            self._isObserving = true
            self:StartObserving()
        end
    end

    if not self:IsConditionMet() then
        self:Stopped(false)
    else
        self.Decoratee:Start()
    end
end

---override<br>
---@protected
function ObservingDecorator:DoCancel()
    self.Decoratee:CancelWithoutReturnResult()
end

---override<br>
---@protected
---@param child NPBehave.Node
---@param result boolean
function ObservingDecorator:DoChildStopped(child, result)
    assert(self.CurrentState ~= NPBehave.Enum.NodeState.Inactive)
    if self.StopsOnChange == NPBehave.Enum.Stops.None or self.StopsOnChange == NPBehave.Enum.Stops.Self then
        if self._isObserving then
            self._isObserving = false
            self:StopObserving()
        end
    end
    self:Stopped(result)
end

---override<br>
---@protected
---@param parentComposite NPBehave.Composite.Composite
function ObservingDecorator:DoParentCompositeStopped(parentComposite)
    if self._isObserving then
        self._isObserving = false
        self:StopObserving()
    end
end

---protected
function ObservingDecorator:Evaluate()
    --If the blackboard value that is active and has a listening value does not meet the conditions, it stops itself
    if self.IsActive and not self:IsConditionMet() then
        if self.StopsOnChange == NPBehave.Enum.Stops.Self or self.StopsOnChange == NPBehave.Enum.Stops.Both or self.StopsOnChange == NPBehave.Enum.Stops.ImmediateRestart then
            --Debug.Log( this.key + " stopped self ")
            self:CancelWithoutReturnResult()
        end
        --If the blackboard value that is inactive and has a listening value meets the conditions, the others are stopped
    elseif not self.IsActive and self:IsConditionMet() then
        if self.StopsOnChange == NPBehave.Enum.Stops.LowerPriority or self.StopsOnChange == NPBehave.Enum.Stops.Both or self.StopsOnChange == NPBehave.Enum.Stops.ImmediateRestart or self.StopsOnChange == NPBehave.Enum.Stops.LowerPriorityImmediateRestart then
            --Debug.Log( this.key + " stopped other ")
            local parentNode = self.ParentNode
            ---@type NPBehave.Node
            local childNode = self

            while parentNode ~= nil and not IsInstanceOf(parentNode, NPBehave.ClassName.Composite) do
                childNode = parentNode
                parentNode = parentNode.ParentNode
            end
            assert(parentNode ~= nil, "Stops are valid only when attached to the parent group.")
            assert(childNode ~= nil)
            if IsInstanceOf(parentNode, NPBehave.ClassName.Parallel) then
                assert(self.StopsOnChange == NPBehave.Enum.Stops.ImmediateRestart,
                    "On parallel nodes, all child nodes have the same priority, so Stops.LowerPriority or Stops.Both! Are not supported in this case.")
            end
            if self.StopsOnChange == NPBehave.Enum.Stops.ImmediateRestart or self.StopsOnChange == NPBehave.Enum.Stops.LowerPriorityImmediateRestart then
                if self._isObserving then
                    self._isObserving = false
                    self:StopObserving()
                end
            end
            local parentComposite = IsInstanceOf(parentNode, NPBehave.ClassName.Composite) and parentNode or nil
            if parentComposite ~= nil then
                ---@cast parentComposite NPBehave.Composite.Composite
                parentComposite:StopLowerPriorityChildrenForChild(childNode,
                    self.StopsOnChange == NPBehave.Enum.Stops.ImmediateRestart or
                    self.StopsOnChange == NPBehave.Enum.Stops.LowerPriorityImmediateRestart)
            end
        end
    end
end
