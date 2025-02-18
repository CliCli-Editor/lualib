# NPBehave.Blackboard

## AddObserver

```lua
(method) NPBehave.Blackboard:AddObserver(key: string, observer: fun(type: NPBehaveBlackboardType, value: any))
```

Add observer
## Disable

```lua
(method) NPBehave.Blackboard:Disable()
```

Forbidden blackboard
## Enable

```lua
(method) NPBehave.Blackboard:Enable()
```

Enable blackboard
## Get

```lua
(method) NPBehave.Blackboard:Get(key: string)
  -> any
```

Get key value
## GetObserverList

```lua
(method) NPBehave.Blackboard:GetObserverList(target: { [string]: fun(type: NPBehaveBlackboardType, value: any)[] }, key: string)
  -> fun(type: NPBehaveBlackboardType, value: any)[]
```

Get the observer list
## IsSet

```lua
(method) NPBehave.Blackboard:IsSet(key: string)
  -> boolean
```

Check whether the key is set
## NotifyObservers

```lua
(method) NPBehave.Blackboard:NotifyObservers()
```

Notify observer
## RemoveObserver

```lua
(method) NPBehave.Blackboard:RemoveObserver(key: string, observer: fun(type: NPBehaveBlackboardType, value: any))
```

Remove observer
## Set

```lua
(method) NPBehave.Blackboard:Set(key: string, value: any)
```

Set key value
## Unset

```lua
(method) NPBehave.Blackboard:Unset(key: string)
```

Example Cancel setting a key value
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## funcBindCache

```lua
table
```


# NPBehave.Blackboard.Notification

## key

```lua
string
```

## type

```lua
NPBehaveBlackboardType
```

## value

```lua
any
```


# NPBehave.Clock

## AddTimer

```lua
(method) NPBehave.Clock:AddTimer(delay: number, repeat_count: number, action: NPBehave.Tool.BindCallback, randomVariance?: number)
```

Register a timer function with random variance

@*param* `delay` — Delay time (in milliseconds)

@*param* `repeat_count` — Number of repetitions. If this parameter is set to -1, repeat until registration is cancelled.

@*param* `action` — Callback function

@*param* `randomVariance` — Random variance
## AddUpdateObserver

```lua
(method) NPBehave.Clock:AddUpdateObserver(action: NPBehave.Tool.BindCallback)
```

Register a function that is called every frame

@*param* `action` — The function to call
## ElapsedTime

```lua
number
```

 Elapsed time
## GetTimerFromPool

```lua
(method) NPBehave.Clock:GetTimerFromPool()
  -> timer: NPBehave.Clock.Timer
```

Gets a timer from the pool

@*return* `timer` — timepiece
## HasTimer

```lua
(method) NPBehave.Clock:HasTimer(action: NPBehave.Tool.BindCallback)
  -> boolean
```

Check for a timer

@*param* `action` — Callback function
## HasUpdateObserver

```lua
(method) NPBehave.Clock:HasUpdateObserver(action: NPBehave.Tool.BindCallback)
  -> boolean
```

Check if there is a function called per frame

@*param* `action` — Function to check

@*return* — Whether there is a function called per frame
## RemoveTimer

```lua
(method) NPBehave.Clock:RemoveTimer(action: NPBehave.Tool.BindCallback)
```

Remove timer

@*param* `action` — Callback function
## RemoveUpdateObserver

```lua
(method) NPBehave.Clock:RemoveUpdateObserver(action: NPBehave.Tool.BindCallback)
```

Removes functions called per frame

@*param* `action` — The function to remove
## Update

```lua
(method) NPBehave.Clock:Update(deltaTime: number)
```

Update function

@*param* `deltaTime` — Time increment

# NPBehave.Clock.AddTimerStruct

## Timer

```lua
NPBehave.Clock.Timer
```

## TimerId

```lua
number
```


# NPBehave.Clock.Timer

## Action

```lua
(NPBehave.Tool.BindCallback)?
```

## Delay

```lua
number
```

## RandomVariance

```lua
number
```

## Repeat

```lua
integer
```

 Number of repetitions. If this parameter is set to -1, repeat until registration is cancelled.
## ScheduleAbsoluteTime

```lua
(method) NPBehave.Clock.Timer:ScheduleAbsoluteTime(elapsedTime: number)
```

## ScheduledTime

```lua
number
```

## Used

```lua
boolean
```

## repeat_count

```lua
integer
```


# NPBehave.Composite.Composite

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Children

```lua
NPBehave.Node[]?
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## DoCancel

```lua
(method) NPBehave.Node:DoCancel()
```

virtual<br>
## DoChildStopped

```lua
(method) NPBehave.Container:DoChildStopped(child: NPBehave.Node, succeeded: boolean)
```

abstract<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Node:DoStart()
```

virtual<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Node:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Composite.Composite:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## StopLowerPriorityChildrenForChild

```lua
fun(self: NPBehave.Composite.Composite, child: NPBehave.Node, immediateRestart: boolean)
```

abstract<br>
## Stopped

```lua
(method) NPBehave.Composite.Composite:Stopped(success: boolean)
```

override<br>
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Composite.Parallel

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Children

```lua
NPBehave.Node[]?
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## DoCancel

```lua
(method) NPBehave.Composite.Parallel:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Composite.Parallel:DoChildStopped(child: NPBehave.Node, result: boolean)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Composite.Parallel:DoStart()
```

override<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Node:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Composite.Composite:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## StopLowerPriorityChildrenForChild

```lua
(method) NPBehave.Composite.Parallel:StopLowerPriorityChildrenForChild(abortForChild: NPBehave.Node, immediateRestart: boolean)
```

## Stopped

```lua
(method) NPBehave.Composite.Composite:Stopped(success: boolean)
```

override<br>
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Composite.RandomSelector

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Children

```lua
NPBehave.Node[]?
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## DoCancel

```lua
(method) NPBehave.Composite.RandomSelector:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Composite.RandomSelector:DoChildStopped(child: NPBehave.Node, result: boolean)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Composite.RandomSelector:DoStart()
```

override<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Node:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## ProcessChildren

```lua
(method) NPBehave.Composite.RandomSelector:ProcessChildren()
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Composite.Composite:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## StopLowerPriorityChildrenForChild

```lua
(method) NPBehave.Composite.RandomSelector:StopLowerPriorityChildrenForChild(abortForChild: NPBehave.Node, immediateRestart: boolean)
```

## Stopped

```lua
(method) NPBehave.Composite.Composite:Stopped(success: boolean)
```

override<br>
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Composite.RandomSequence

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Children

```lua
NPBehave.Node[]?
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## DoCancel

```lua
(method) NPBehave.Composite.RandomSequence:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Composite.RandomSequence:DoChildStopped(child: NPBehave.Node, result: boolean)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Composite.RandomSequence:DoStart()
```

override<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Node:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## ProcessChildren

```lua
(method) NPBehave.Composite.RandomSequence:ProcessChildren()
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Composite.Composite:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## StopLowerPriorityChildrenForChild

```lua
(method) NPBehave.Composite.RandomSequence:StopLowerPriorityChildrenForChild(abortForChild: NPBehave.Node, immediateRestart: boolean)
```

## Stopped

```lua
(method) NPBehave.Composite.Composite:Stopped(success: boolean)
```

override<br>
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Composite.Selector

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Children

```lua
NPBehave.Node[]?
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## DoCancel

```lua
(method) NPBehave.Composite.Selector:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Composite.Selector:DoChildStopped(child: NPBehave.Node, result: boolean)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Composite.Selector:DoStart()
```

override<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Node:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## ProcessChildren

```lua
(method) NPBehave.Composite.Selector:ProcessChildren()
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Composite.Composite:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## StopLowerPriorityChildrenForChild

```lua
(method) NPBehave.Composite.Selector:StopLowerPriorityChildrenForChild(abortForChild: NPBehave.Node, immediateRestart: boolean)
```

## Stopped

```lua
(method) NPBehave.Composite.Composite:Stopped(success: boolean)
```

override<br>
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Composite.Sequence

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Children

```lua
NPBehave.Node[]?
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## DoCancel

```lua
(method) NPBehave.Composite.Sequence:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Composite.Sequence:DoChildStopped(child: NPBehave.Node, result: boolean)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Composite.Sequence:DoStart()
```

override<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Node:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## ProcessChildren

```lua
(method) NPBehave.Composite.Sequence:ProcessChildren()
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Composite.Composite:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## StopLowerPriorityChildrenForChild

```lua
(method) NPBehave.Composite.Sequence:StopLowerPriorityChildrenForChild(abortForChild: NPBehave.Node, immediateRestart: boolean)
```

## Stopped

```lua
(method) NPBehave.Composite.Composite:Stopped(success: boolean)
```

override<br>
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Container

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## DoCancel

```lua
(method) NPBehave.Node:DoCancel()
```

virtual<br>
## DoChildStopped

```lua
(method) NPBehave.Container:DoChildStopped(child: NPBehave.Node, succeeded: boolean)
```

abstract<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Node:DoStart()
```

virtual<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Node:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Node:SetRoot(rootNode: NPBehave.Root)
```

virtual<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Context

abstract<br>

## Blackboards

```lua
table<string, NPBehave.Blackboard>
```

## Clock

```lua
unknown
```

## GetInstance

```lua
function NPBehave.Context.GetInstance()
  -> NPBehave.Context
```

## GetSharedBlackboard

```lua
function NPBehave.Context.GetSharedBlackboard(key: string)
  -> NPBehave.Blackboard
```

Get shared blackboard
## Instance

```lua
nil
```

abstract<br>
## Platform

```lua
nil
```

abstract<br>

# NPBehave.Decorator.BlackboardCondition

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## Decoratee

```lua
NPBehave.Node
```

## DoCancel

```lua
(method) NPBehave.Decorator.ObservingDecorator:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Decorator.ObservingDecorator:DoChildStopped(child: NPBehave.Node, result: boolean)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Decorator.ObservingDecorator:DoParentCompositeStopped(parentComposite: NPBehave.Composite.Composite)
```

override<br>
## DoStart

```lua
(method) NPBehave.Decorator.ObservingDecorator:DoStart()
```

override<br>
## Evaluate

```lua
(method) NPBehave.Decorator.ObservingDecorator:Evaluate()
```

protected
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsConditionMet

```lua
(method) NPBehave.Decorator.BlackboardCondition:IsConditionMet()
  -> boolean
```

override<br>
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## OnValueChanged

```lua
(method) NPBehave.Decorator.BlackboardCondition:OnValueChanged(type: NPBehaveBlackboardType, newValue: any)
```

## ParentCompositeStopped

```lua
(method) NPBehave.Decorator.Decorator:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

override<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Decorator.Decorator:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## StartObserving

```lua
(method) NPBehave.Decorator.BlackboardCondition:StartObserving()
```

override<br>
## StopObserving

```lua
(method) NPBehave.Decorator.BlackboardCondition:StopObserving()
```

override<br>
## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## StopsOnChange

```lua
NPBehave.Enum.Stops
```

## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Decorator.BlackboardQuery

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## Decoratee

```lua
NPBehave.Node
```

## DoCancel

```lua
(method) NPBehave.Decorator.ObservingDecorator:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Decorator.ObservingDecorator:DoChildStopped(child: NPBehave.Node, result: boolean)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Decorator.ObservingDecorator:DoParentCompositeStopped(parentComposite: NPBehave.Composite.Composite)
```

override<br>
## DoStart

```lua
(method) NPBehave.Decorator.ObservingDecorator:DoStart()
```

override<br>
## Evaluate

```lua
(method) NPBehave.Decorator.ObservingDecorator:Evaluate()
```

protected
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsConditionMet

```lua
(method) NPBehave.Decorator.BlackboardQuery:IsConditionMet()
  -> boolean
```

override<br>
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## OnValueChanged

```lua
(method) NPBehave.Decorator.BlackboardQuery:OnValueChanged(type: NPBehaveBlackboardType, newValue: any)
```

## ParentCompositeStopped

```lua
(method) NPBehave.Decorator.Decorator:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

override<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Decorator.Decorator:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## StartObserving

```lua
(method) NPBehave.Decorator.BlackboardQuery:StartObserving()
```

override<br>
## StopObserving

```lua
(method) NPBehave.Decorator.BlackboardQuery:StopObserving()
```

override<br>
## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## StopsOnChange

```lua
NPBehave.Enum.Stops
```

## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Decorator.Condition

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## Decoratee

```lua
NPBehave.Node
```

## DoCancel

```lua
(method) NPBehave.Decorator.ObservingDecorator:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Decorator.ObservingDecorator:DoChildStopped(child: NPBehave.Node, result: boolean)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Decorator.ObservingDecorator:DoParentCompositeStopped(parentComposite: NPBehave.Composite.Composite)
```

override<br>
## DoStart

```lua
(method) NPBehave.Decorator.ObservingDecorator:DoStart()
```

override<br>
## Evaluate

```lua
(method) NPBehave.Decorator.ObservingDecorator:Evaluate()
```

protected
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsConditionMet

```lua
(method) NPBehave.Decorator.Condition:IsConditionMet()
  -> boolean
```

override<br>
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Decorator.Decorator:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

override<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Decorator.Decorator:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## StartObserving

```lua
(method) NPBehave.Decorator.Condition:StartObserving()
```

override<br>
## StopObserving

```lua
(method) NPBehave.Decorator.Condition:StopObserving()
```

override<br>
## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## StopsOnChange

```lua
NPBehave.Enum.Stops
```

## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Decorator.Cooldown

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## Decoratee

```lua
NPBehave.Node
```

## DoCancel

```lua
(method) NPBehave.Decorator.Cooldown:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Decorator.Cooldown:DoChildStopped(child: any, result: any)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Decorator.Cooldown:DoStart()
```

override<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Decorator.Decorator:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

override<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Decorator.Decorator:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## TimeoutReached

```lua
(method) NPBehave.Decorator.Cooldown:TimeoutReached()
```

## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Decorator.Decorator

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## Decoratee

```lua
NPBehave.Node
```

## DoCancel

```lua
(method) NPBehave.Node:DoCancel()
```

virtual<br>
## DoChildStopped

```lua
(method) NPBehave.Container:DoChildStopped(child: NPBehave.Node, succeeded: boolean)
```

abstract<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Node:DoStart()
```

virtual<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Decorator.Decorator:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

override<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Decorator.Decorator:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Decorator.Failer

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## Decoratee

```lua
NPBehave.Node
```

## DoCancel

```lua
(method) NPBehave.Decorator.Failer:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Decorator.Failer:DoChildStopped(child: any, result: any)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Decorator.Failer:DoStart()
```

override<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Decorator.Decorator:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

override<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Decorator.Decorator:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Decorator.Hook

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## Decoratee

```lua
NPBehave.Node
```

## DoCancel

```lua
(method) NPBehave.Decorator.Hook:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Decorator.Hook:DoChildStopped(child: any, result: any)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Decorator.Hook:DoStart()
```

override<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Decorator.Decorator:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

override<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Decorator.Decorator:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Decorator.Inverter

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## Decoratee

```lua
NPBehave.Node
```

## DoCancel

```lua
(method) NPBehave.Decorator.Inverter:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Decorator.Inverter:DoChildStopped(child: any, result: any)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Decorator.Inverter:DoStart()
```

override<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Decorator.Decorator:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

override<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Decorator.Decorator:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Decorator.Observer

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## Decoratee

```lua
NPBehave.Node
```

## DoCancel

```lua
(method) NPBehave.Decorator.Observer:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Decorator.Observer:DoChildStopped(child: any, result: any)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Decorator.Observer:DoStart()
```

override<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Decorator.Decorator:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

override<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Decorator.Decorator:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Decorator.ObservingDecorator

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## Decoratee

```lua
NPBehave.Node
```

## DoCancel

```lua
(method) NPBehave.Decorator.ObservingDecorator:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Decorator.ObservingDecorator:DoChildStopped(child: NPBehave.Node, result: boolean)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Decorator.ObservingDecorator:DoParentCompositeStopped(parentComposite: NPBehave.Composite.Composite)
```

override<br>
## DoStart

```lua
(method) NPBehave.Decorator.ObservingDecorator:DoStart()
```

override<br>
## Evaluate

```lua
(method) NPBehave.Decorator.ObservingDecorator:Evaluate()
```

protected
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsConditionMet

```lua
fun()
```

abstract
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Decorator.Decorator:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

override<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Decorator.Decorator:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## StartObserving

```lua
fun()
```

abstract
## StopObserving

```lua
fun()
```

abstract
## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## StopsOnChange

```lua
NPBehave.Enum.Stops
```

## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Decorator.Random

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## Decoratee

```lua
NPBehave.Node
```

## DoCancel

```lua
(method) NPBehave.Decorator.Random:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Decorator.Random:DoChildStopped(child: any, result: any)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Decorator.Random:DoStart()
```

override<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Decorator.Decorator:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

override<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Decorator.Decorator:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Decorator.Repeater

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## Decoratee

```lua
NPBehave.Node
```

## DoCancel

```lua
(method) NPBehave.Decorator.Repeater:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Decorator.Repeater:DoChildStopped(child: any, result: any)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Decorator.Repeater:DoStart()
```

override<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Decorator.Decorator:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

override<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RestartDecorator

```lua
(method) NPBehave.Decorator.Repeater:RestartDecorator()
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Decorator.Decorator:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Decorator.Service

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## Decoratee

```lua
NPBehave.Node
```

## DoCancel

```lua
(method) NPBehave.Decorator.Service:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Decorator.Service:DoChildStopped(child: any, result: any)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Decorator.Service:DoStart()
```

override<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## InvokeServiceMethodWithRandomVariation

```lua
(method) NPBehave.Decorator.Service:InvokeServiceMethodWithRandomVariation()
```

Invoke service methods with random variation
## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Decorator.Decorator:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

override<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Decorator.Decorator:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Decorator.Succeeder

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## Decoratee

```lua
NPBehave.Node
```

## DoCancel

```lua
(method) NPBehave.Decorator.Succeeder:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Decorator.Succeeder:DoChildStopped(child: any, result: any)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Decorator.Succeeder:DoStart()
```

override<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Decorator.Decorator:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

override<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Decorator.Decorator:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Decorator.TimeMax

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## Decoratee

```lua
NPBehave.Node
```

## DoCancel

```lua
(method) NPBehave.Decorator.TimeMax:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Decorator.TimeMax:DoChildStopped(child: any, result: any)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Decorator.TimeMax:DoStart()
```

override<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Decorator.Decorator:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

override<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Decorator.Decorator:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## TimeoutReached

```lua
(method) NPBehave.Decorator.TimeMax:TimeoutReached()
```

## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Decorator.TimeMin

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## Decoratee

```lua
NPBehave.Node
```

## DoCancel

```lua
(method) NPBehave.Decorator.TimeMin:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Decorator.TimeMin:DoChildStopped(child: any, result: any)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Decorator.TimeMin:DoStart()
```

override<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Decorator.Decorator:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

override<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Decorator.Decorator:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## TimeoutReached

```lua
(method) NPBehave.Decorator.TimeMin:TimeoutReached()
```

## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Decorator.WaitForCondition

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## CheckCondition

```lua
(method) NPBehave.Decorator.WaitForCondition:CheckCondition()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## Decoratee

```lua
NPBehave.Node
```

## DoCancel

```lua
(method) NPBehave.Decorator.WaitForCondition:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Decorator.WaitForCondition:DoChildStopped(child: any, result: any)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Decorator.WaitForCondition:DoStart()
```

override<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Decorator.Decorator:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

override<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Decorator.Decorator:SetRoot(rootNode: NPBehave.Root)
```

override<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Enum.NodeState

```lua
{
    Inactive: string = Inactive,
    Active: string = Active,
    StopRequested: string = StopRequested,
}
```


# NPBehave.Enum.NodeState.Active


# NPBehave.Enum.NodeState.Inactive


# NPBehave.Enum.NodeState.StopRequested


# NPBehave.Enum.Operator

```lua
{
    IsSet: string = IsSet,
    IsNotSet: string = IsNotSet,
    IsEqual: string = IsEqual,
    IsNotEqual: string = IsNotEqual,
    IsGreaterOrEqual: string = IsGreaterOrEqual,
    IsGreater: string = IsGreater,
    IsSmallerOrEqual: string = IsSmallerOrEqual,
    IsSmaller: string = IsSmaller,
    AlwaysTrue: string = AlwaysTrue,
}
```


# NPBehave.Enum.Operator.AlwaysTrue


# NPBehave.Enum.Operator.IsEqual


# NPBehave.Enum.Operator.IsGreater


# NPBehave.Enum.Operator.IsGreaterOrEqual


# NPBehave.Enum.Operator.IsNotEqual


# NPBehave.Enum.Operator.IsNotSet


# NPBehave.Enum.Operator.IsSet


# NPBehave.Enum.Operator.IsSmaller


# NPBehave.Enum.Operator.IsSmallerOrEqual


# NPBehave.Enum.ParallelPolicy

```lua
{
    One: string = One,
    All: string = All,
}
```


# NPBehave.Enum.ParallelPolicy.All


# NPBehave.Enum.ParallelPolicy.One


# NPBehave.Enum.Stops

```lua
{
    None: string = None,
    Self: string = Self,
    LowerPriority: string = LowerPriority,
    Both: string = Both,
    ImmediateRestart: string = ImmediateRestart,
    LowerPriorityImmediateRestart: string = LowerPriorityImmediateRestart,
}
```


# NPBehave.Enum.Stops.Both


# NPBehave.Enum.Stops.ImmediateRestart


# NPBehave.Enum.Stops.LowerPriority


# NPBehave.Enum.Stops.LowerPriorityImmediateRestart


# NPBehave.Enum.Stops.None


# NPBehave.Enum.Stops.Self


# NPBehave.GameContext

## Blackboards

```lua
table<string, NPBehave.Blackboard>
```

## Clock

```lua
unknown
```

## GetInstance

```lua
function NPBehave.Context.GetInstance()
  -> NPBehave.Context
```

## GetSharedBlackboard

```lua
function NPBehave.Context.GetSharedBlackboard(key: string)
  -> NPBehave.Blackboard
```

Get shared blackboard
## Instance

```lua
nil
```

abstract<br>
## Platform

```lua
nil
```

abstract<br>
## Update

```lua
function NPBehave.GameContext.Update(gameTime: number)
```


# NPBehave.GamePlatform

## GenerateRandom

```lua
(method) NPBehave.GamePlatform:GenerateRandom()
  -> number
```

override<br>

# NPBehave.Node

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## DoCancel

```lua
(method) NPBehave.Node:DoCancel()
```

virtual<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Node:DoStart()
```

virtual<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Node:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Node:SetRoot(rootNode: NPBehave.Root)
```

virtual<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Platform

abstract<br>

## GenerateRandom

```lua
fun():number
```

abstract<br>

# NPBehave.Root

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## ChildStopped

```lua
(method) NPBehave.Container:ChildStopped(child: NPBehave.Node, succeeded: boolean)
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## Collapse

```lua
boolean
```

collapse
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## Decoratee

```lua
NPBehave.Node
```

## DoCancel

```lua
(method) NPBehave.Root:DoCancel()
```

override<br>
## DoChildStopped

```lua
(method) NPBehave.Root:DoChildStopped(node: any, success: any)
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Root:DoStart()
```

override<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Decorator.Decorator:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

override<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Root:SetRoot(rootNode: NPBehave.Root)
```

## Start

```lua
(method) NPBehave.Node:Start()
```

## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Task.Action

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## DoCancel

```lua
(method) NPBehave.Task.Action:DoCancel()
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Task.Action:DoStart()
```

override<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## OnUpdateFunc

```lua
(method) NPBehave.Task.Action:OnUpdateFunc()
```

## ParentCompositeStopped

```lua
(method) NPBehave.Node:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Node:SetRoot(rootNode: NPBehave.Root)
```

virtual<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Task.Action.InitParam

## action

```lua
fun()?
```

## multiFrameFunc

```lua
(fun(param: boolean):NPBehaveTaskActionResult)?
```

## singleFrameFunc

```lua
(fun():boolean)?
```


# NPBehave.Task.Task

abstract<br>

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## DoCancel

```lua
(method) NPBehave.Node:DoCancel()
```

virtual<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Node:DoStart()
```

virtual<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Node:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Node:SetRoot(rootNode: NPBehave.Root)
```

virtual<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Task.Wait

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## DoCancel

```lua
(method) NPBehave.Task.Wait:DoCancel()
```

override<br>
## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Task.Wait:DoStart()
```

override<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## OnTimer

```lua
(method) NPBehave.Task.Wait:OnTimer()
```

## ParentCompositeStopped

```lua
(method) NPBehave.Node:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Node:SetRoot(rootNode: NPBehave.Root)
```

virtual<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Task.Wait.Data

## blackboardKey

```lua
string?
```

## callback

```lua
(fun():number)?
```

## randomVariance

```lua
number?
```

## seconds

```lua
number?
```


# NPBehave.Task.WaitUntilStopped

## Blackboard

```lua
NPBehave.Blackboard
```

`__getter`
## CancelWithoutReturnResult

```lua
(method) NPBehave.Node:CancelWithoutReturnResult()
```

## Clock

```lua
NPBehave.Clock
```

`__getter`
## CurrentState

```lua
NPBehave.Enum.NodeState
```

`__getter`
## DoCancel

```lua
(method) NPBehave.Task.WaitUntilStopped:DoCancel()
```

## DoParentCompositeStopped

```lua
(method) NPBehave.Node:DoParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
 Called when in an inactive state in order to have the decorator remove any waiting observers.
## DoStart

```lua
(method) NPBehave.Node:DoStart()
```

virtual<br>
## GetPath

```lua
(method) NPBehave.Node:GetPath()
  -> string|unknown
```

## IsActive

```lua
boolean
```

`__getter`
## IsStopRequested

```lua
boolean
```

`__getter`
## Label

```lua
string
```

Display label
## Name

```lua
string
```

## ParentCompositeStopped

```lua
(method) NPBehave.Node:ParentCompositeStopped(composite: NPBehave.Composite.Composite)
```

virtual<br>
## ParentNode

```lua
(NPBehave.Container)?
```

## RootNode

```lua
NPBehave.Root
```

## SetParent

```lua
(method) NPBehave.Node:SetParent(parentNode: NPBehave.Container)
```

## SetRoot

```lua
(method) NPBehave.Node:SetRoot(rootNode: NPBehave.Root)
```

virtual<br>
## Start

```lua
(method) NPBehave.Node:Start()
```

## Stopped

```lua
(method) NPBehave.Node:Stopped(success: any)
```

virtual<br>
This must absolutely be the last call in the function, and do not modify any state after the call stops!!! 
## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## currentState

```lua
NPBehave.Enum.NodeState
```

## funcBindCache

```lua
table
```

## name

```lua
string
```


# NPBehave.Tool.BindCallback


# NPBehave.Tool.MethodDecorator

## bind

```lua
(method) NPBehave.Tool.MethodDecorator:bind(func: fun(...any))
  -> NPBehave.Tool.BindCallback
```

Functions are bound to objects
## funcBindCache

```lua
table
```


