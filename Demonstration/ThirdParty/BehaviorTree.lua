--[[
    Reference: https://github.com/meniku/NPBehave/tree/2.0-dev, this Example is the title of the link ` Example: An event - driven behaviors tree ` Example
 ]]


require("clicli.third_party.NPBehave")
--This is a built-in context, and you can implement your own independent context according to the format
local GameContext = require("clicli.third_party.NPBehave.GameContext")
local ClassName = NPBehave.ClassName
--Declare the behavior tree in advance
---@type NPBehave.Root
local behaviorTree

--Construct tree
local tree = New(ClassName.Service)(0.5,
    function()
        local v = not behaviorTree.Blackboard:Get("foo")
        behaviorTree.Blackboard:Set("foo", v)
    end,
    New(ClassName.Selector)(
        New(ClassName.BlackboardCondition)("foo", NPBehave.Enum.Operator.IsEqual, true,
            NPBehave.Enum.Stops.ImmediateRestart,
            New(ClassName.Sequence)(
                New(ClassName.Action)({
                    action = function() print("foo") end
                }),
                New(ClassName.WaitUntilStopped)()
            )
        ),
        New(ClassName.Sequence)(
            New(ClassName.Action)({
                action = function()
                    print("bar")
                end
            }),
            New(ClassName.WaitUntilStopped)()
        )
    )
)
--Place the tree in Root
behaviorTree = New(ClassName.Root)(tree)
behaviorTree:Start()
---@type Timer
local timer
clicli.game:event("Keyboard. - Press it", clicli.const.KeyboardKey["NUM_4"], function(trg, data)
    local player = data.player
    timer        = clicli.timer.loop(0.5, function()
        --Update context time, the tree is executed when the context time is updated
        GameContext.Update(0.5)
    end)
end)


clicli.game:event("Keyboard. - Press it", clicli.const.KeyboardKey["NUM_5"], function(trg, data)
    local player = data.player
    --timer:remove()
    --When the behavior tree is stopped, the context still updates the time, but the behavior tree no longer executes
    if behaviorTree ~= nil and behaviorTree.CurrentState == NPBehave.Enum.NodeState.Active then
        behaviorTree:CancelWithoutReturnResult()
    end
end)
