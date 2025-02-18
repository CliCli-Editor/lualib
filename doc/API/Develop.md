# Develop.Arg

Startup parameter


# Develop.Attr

## attr

```lua
y3.Const.UnitAttr
```

## unit

```lua
Unit
```

unit
## watch

```lua
(method) Develop.Attr:watch(value: Develop.Attr.Accept, callback: Develop.Attr.Watch.Callback)
  -> Develop.Attr.Watch
```

The callback is triggered when the attribute changes from Not Met to Met

@*param* `value` — Expressions such as' >= 100 ', '==' maximum life` ```

@*param* `callback` — Callback function

# Develop.Attr.Accept


```lua
string|number|Develop.Attr.Condition
```


# Develop.Attr.Condition


```lua
fun(unit: Unit, value: number):boolean
```


# Develop.Attr.Watch

## attr

```lua
Develop.Attr
```

## callback

```lua
fun(attr: Develop.Attr, watch: Develop.Attr.Watch)
```

## condition

```lua
(Develop.Attr.Condition)?
```

## conditionStr

```lua
string?
```

## isSatisfied

```lua
boolean
```

## remove

```lua
(method) Develop.Attr.Watch:remove()
```

## trigger

```lua
Trigger
```

flip-flop

# Develop.Attr.Watch.Callback


```lua
fun(attr: Develop.Attr, watch: Develop.Attr.Watch, oldValue: number)
```


# Develop.Code

## on_sync

```lua
function Develop.Code.on_sync(id: string, handler: Develop.Code.SyncHandler)
```

Registered sync processor
## run

```lua
function Develop.Code.run(code: string, env?: table)
  -> boolean
  2. any
```

Execute native code

@*param* `code` — Code to execute

@*param* `env` — Execution environment

@*return* — Whether the execution is successful

@*return* — Execution result
## sync_run

```lua
function Develop.Code.sync_run(code: string, data?: table<string, any>, id?: string)
  -> boolean
  2. string?
```

The code is executed synchronously after broadcast and must be locally initiated

@*param* `code` — Code to execute

@*param* `data` — Data, can be accessed directly in the code

@*param* `id` — processorID

@*return* — Whether the execution is successful

@*return* — Error message
## wrap_code

```lua
function Develop.Code.wrap_code(code: any, env: any)
  -> function|nil
  2. unknown|nil
  3. string|nil
```


# Develop.Code.SyncHandler

## complete

```lua
fun(suc: boolean, result: any, data: any)
```

This function is called after the code executes with the result
## env

```lua
fun(data: any):table?
```

Returns a table to be used as the execution environment

# Develop.Command

Cheat instruction

This feature is only available in development mode

## commands

```lua
{ [string]: Develop.Command.Info }
```

## execute

```lua
function Develop.Command.execute(command: string, ...any)
```

 Execute cheat instruction
## getAllCommands

```lua
function Develop.Command.getAllCommands()
  -> string[]
```

## getCommandInfo

```lua
function Develop.Command.getCommandInfo(command: string)
  -> (Develop.Command.Info)?
```

## getParams

```lua
function Develop.Command.getParams()
  -> Develop.Command.ExecuteParam
```

## input

```lua
function Develop.Command.input(prefix: string, input: string, player?: Player)
```

 Enter cheat instruction
## params

```lua
Develop.Command.ExecuteParam
```

## register

```lua
function Develop.Command.register(command: string, info: function|Develop.Command.InfoParam)
```

 Register cheat instructions (instruction names are case insensitive）

# Develop.Command.ExecuteParam

## args

```lua
string[]
```

Command parameter
## command

```lua
string
```

The entered command is the same as the input, and case status is not guaranteed）
## player

```lua
Player
```

The player who invokes the command

# Develop.Command.Info

## desc

```lua
string?
```

## name

```lua
string
```

## needSync

```lua
boolean?
```

## onCommand

```lua
fun(...any)?
```

## priority

```lua
number
```


# Develop.Command.InfoParam

## desc

```lua
string?
```

## needSync

```lua
boolean?
```

## onCommand

```lua
fun(...any)?
```

## priority

```lua
number?
```


# Develop.Console

## getHelpInfo

```lua
function Develop.Console.getHelpInfo()
  -> string
```

## input

```lua
function Develop.Console.input(input: string)
```

Console input
## show_result

```lua
function Develop.Console.show_result(ok: boolean, result: any)
  -> any
```


# Develop.Helper

## awaitRequest

```lua
(async) function Develop.Helper.awaitRequest(method: string, params: table)
  -> any
```

Send a request to the Y3 Development Assistant (coroutine）
## createAttrWatcher

```lua
function Develop.Helper.createAttrWatcher(unit: Unit, attrType: y3.Const.UnitAttr, condition?: Develop.Attr.Accept)
  -> Develop.Helper.TreeNode
```

Create a property monitor on the Y3 Development Assistant

@*param* `unit` — Units to be monitored

@*param* `attrType` — Attribute name

@*param* `condition` — Breakpoint expressions, such as' >= 100 ', '<=' maximum life` / 2 ```
## createInputBox

```lua
function Develop.Helper.createInputBox(optional?: Develop.Helper.InputBox.Optional)
  -> Develop.Helper.InputBox
```

Create an input box on Y3 Development Assistant
## createTreeNode

```lua
function Develop.Helper.createTreeNode(name: string, optional?: Develop.Helper.TreeNode.Optional)
  -> Develop.Helper.TreeNode
```

Create a node on the Y3 Developer Assistant tree view
## createTreeView

```lua
function Develop.Helper.createTreeView(name: string, root: Develop.Helper.TreeNode)
  -> Develop.Helper.TreeView
```

Create a tree view on the Y3 Developer Assistant view
## init

```lua
function Develop.Helper.init(port?: integer)
```

Initializes the connection to the Y3 Development Assistant. If you start the game with VSCode, it will connect automatically。
In other cases, you can call this function connection if required。
## isReady

```lua
function Develop.Helper.isReady()
  -> boolean
```

《Y3Whether Development Assistant is ready
## notify

```lua
function Develop.Helper.notify(method: string, params: table)
```

Send notifications to Y3 Development Assistant
## onReady

```lua
function Develop.Helper.onReady(callback: fun())
```

Called when Y3 Development Assistant is ready
## prepareForRestart

```lua
function Develop.Helper.prepareForRestart(options: Develop.Helper.RestartOptions)
```

Ready to restart the game
## print

```lua
function Develop.Helper.print(message: string)
```

Print a message on the terminal of the Y3 Development Assistant
## registerMethod

```lua
function Develop.Helper.registerMethod(method: string, callback: fun(params: any):any)
```

## request

```lua
function Develop.Helper.request(method: string, params: table, callback?: fun(data: any))
```

Send a request to Y3 Development Assistant

@*param* `callback` — Received return value
## requestCommand

```lua
function Develop.Helper.requestCommand(command: string, args?: any[], callback?: fun(result: any))
```

## response

```lua
function Develop.Helper.response(id: integer, result: any, err?: string)
```

## treeViewMap

```lua
{ [string]: Develop.Helper.TreeView }
```


# Develop.Helper.Attr

## add

```lua
(method) Develop.Helper.Attr:add(unit: Unit, attr: y3.Const.UnitAttr)
  -> Develop.Helper.TreeNode
  2. fun(value: Develop.Attr.Accept)
```

@*return*

@*return* — Set breakpoint
## childs

```lua
Develop.Helper.TreeNode[]
```

## root

```lua
unknown
```

## tree

```lua
unknown
```


# Develop.Helper.Attr.ModifyOptions

## attr_type

```lua
(y3.Const.UnitAttrType)?
```

## can_create_watch

```lua
boolean?
```


# Develop.Helper.Explorer

## attrLayout

```lua
string
```

Reassigning this variable redefines the layout. You can study the syntax yourself
## create

```lua
function Develop.Helper.Explorer.create()
```

## createGamePause

```lua
function Develop.Helper.Explorer.createGamePause()
```

## createGameSpeed

```lua
function Develop.Helper.Explorer.createGameSpeed()
```

## createGameTimer

```lua
function Develop.Helper.Explorer.createGameTimer()
  -> Develop.Helper.TreeNode
```

## createMemoryWatcher

```lua
function Develop.Helper.Explorer.createMemoryWatcher()
  -> Develop.Helper.TreeNode
```

## createRefWatcher

```lua
function Develop.Helper.Explorer.createRefWatcher()
  -> Develop.Helper.TreeNode
```

## createReloadButton

```lua
function Develop.Helper.Explorer.createReloadButton()
  -> unknown
```

## createRestartGameButton

```lua
function Develop.Helper.Explorer.createRestartGameButton()
  -> unknown
```

## createRoot

```lua
function Develop.Helper.Explorer.createRoot(name: string)
  -> Develop.Helper.TreeNode
```

## createSelectingButton

```lua
function Develop.Helper.Explorer.createSelectingButton()
  -> unknown
```

## createTimerWatcher

```lua
function Develop.Helper.Explorer.createTimerWatcher()
  -> Develop.Helper.TreeNode
```

## createTriggerWatcher

```lua
function Develop.Helper.Explorer.createTriggerWatcher()
  -> Develop.Helper.TreeNode
```

## createUnitButton

```lua
function Develop.Helper.Explorer.createUnitButton(unit: Unit)
  -> Develop.Helper.TreeNode
```

## gamePauseButton

```lua
unknown
```

## gamePaused

```lua
any
```

## gameSpeed

```lua
number
```

## gameSpeedApply

```lua
boolean
```

## gameSpeedButton

```lua
unknown
```


# Develop.Helper.InputBox

## id

```lua
integer
```

## ignoreFocusOut

```lua
boolean
```

Whether to close when you lose focus
## inputBoxMap

```lua
{ [integer]: Develop.Helper.InputBox }
```

## password

```lua
boolean
```

Password or not box
## placeHolder

```lua
string
```

placeholder
## prompt

```lua
string
```

Tips
## remove

```lua
(method) Develop.Helper.InputBox:remove()
```

Delete input field
## show

```lua
(method) Develop.Helper.InputBox:show(callback: fun(value?: string))
```

Display input box

@*param* `callback` — Input the callback function after completion. If the user cancels the input, 'value' is `nil`。
## title

```lua
string
```

title
## validateInput

```lua
fun(value: string):string|nil
```

An error message is returned indicating that the input is invalid
## value

```lua
string
```

Initial value
## valueSelection

```lua
[integer, integer]
```

Initially selected text range (cursor position, before the first character0)

# Develop.Helper.InputBox.Optional

Input box options that copy exactly VSCode's interface

## ignoreFocusOut

```lua
boolean
```

Whether to close when you lose focus
## password

```lua
boolean
```

Password or not box
## placeHolder

```lua
string
```

placeholder
## prompt

```lua
string
```

Tips
## title

```lua
string
```

title
## validateInput

```lua
fun(value: string):string|nil
```

An error message is returned indicating that the input is invalid
## value

```lua
string
```

Initial value
## valueSelection

```lua
[integer, integer]
```

Initially selected text range (cursor position, before the first character0)

# Develop.Helper.RestartOptions

## debugger

```lua
boolean
```

Whether to start the debugger. If omitted, it determines whether a debugger is needed based on whether it is currently attached。

# Develop.Helper.TreeNode

## changeChecked

```lua
(method) Develop.Helper.TreeNode:changeChecked(checked: boolean)
```

## changeExpanded

```lua
(method) Develop.Helper.TreeNode:changeExpanded(expanded: boolean)
```

## changeVisible

```lua
(method) Develop.Helper.TreeNode:changeVisible(visible: boolean)
```

## check

```lua
boolean
```

Checkbox status
## childs

```lua
Develop.Helper.TreeNode[]?
```

## description

```lua
string
```

Description
## icon

```lua
string
```

icon
## id

```lua
integer
```

## isExpanded

```lua
(method) Develop.Helper.TreeNode:isExpanded()
  -> boolean
```

## isVisible

```lua
(method) Develop.Helper.TreeNode:isVisible()
  -> boolean
```

## lastChilds

```lua
Develop.Helper.TreeNode[]?
```

## makeNodeInfo

```lua
(method) Develop.Helper.TreeNode:makeNodeInfo()
  -> table
```

## name

```lua
string
```

## nodeMap

```lua
{ [integer]: Develop.Helper.TreeNode }
```

## optional

```lua
Develop.Helper.TreeNode.Optional
```

## refresh

```lua
(method) Develop.Helper.TreeNode:refresh()
```

Notify the child node of a change。
## remove

```lua
(method) Develop.Helper.TreeNode:remove()
```

## tooltip

```lua
string
```

Tips
## update

```lua
(method) Develop.Helper.TreeNode:update()
```

Update the data for this node (excluding child nodes)）。

# Develop.Helper.TreeNode.Optional

## check

```lua
boolean?
```

Check box status should be used with 'onCheck' and 'onUnCheck'
## childs

```lua
Develop.Helper.TreeNode[]
```

List of child nodes. If the child node is computationally heavy, you can use 'childsGetter' to get the child node
## childsGetter

```lua
fun(node: Develop.Helper.TreeNode):Develop.Helper.TreeNode[]
```

When trying to expand a node, this function is called to get the child node, and 'childs' is mutually exclusive
## description

```lua
string?
```

Description
## icon

```lua
string?
```

Icon, see https://code.visualstudio.com/api/references/icons-in-labels#icon-listing
## onCheck

```lua
fun(node: Develop.Helper.TreeNode)
```

Called when the node check box is checked
## onClick

```lua
fun(node: Develop.Helper.TreeNode)
```

Called when a node is clicked
## onCollapse

```lua
fun(node: Develop.Helper.TreeNode)
```

Called when a node is collapsed
## onExpand

```lua
fun(node: Develop.Helper.TreeNode)
```

Called when a node is expanded
## onInit

```lua
fun(node: Develop.Helper.TreeNode)
```

Called when the node is created for the first time visible
## onInvisible

```lua
fun(node: Develop.Helper.TreeNode)
```

Called when the node is not visible
## onUnCheck

```lua
fun(node: Develop.Helper.TreeNode)
```

Called when the node check box is unchecked
## onVisible

```lua
fun(node: Develop.Helper.TreeNode)
```

Called when the node can be seen
## tooltip

```lua
string?
```

Tips

# Develop.Helper.TreeView

## id

```lua
integer
```

## name

```lua
string
```

## remove

```lua
(method) Develop.Helper.TreeView:remove()
```

## root

```lua
Develop.Helper.TreeNode
```


# Develop.TimerWatcher

## count

```lua
function Develop.TimerWatcher.count()
  -> table<string, { all: integer, alive: integer }>
```


# Develop.TriggerWatcher

## activeWatcher

```lua
unknown
```

## count

```lua
function Develop.TriggerWatcher.count()
  -> { all: integer, alive: integer }
```

## lastWatcher

```lua
Develop.TriggerWatcherInstance
```

## report

```lua
function Develop.TriggerWatcher.report()
  -> { count: integer, cost: number, time: number, average: number, tops: string[] }|nil
```

Obtain monitoring report
## start

```lua
function Develop.TriggerWatcher.start()
```

Start monitor trigger
## stop

```lua
function Develop.TriggerWatcher.stop()
```

Stop monitor trigger

# Develop.TriggerWatcherInstance

## endTime

```lua
unknown
```

End time (milliseconds）
## makeReport

```lua
(method) Develop.TriggerWatcherInstance:makeReport(inTime?: number, topCount?: integer)
  -> { count: integer, cost: number, time: number, average: number, tops: string[] }
```

@*param* `inTime` — Only the last X seconds are counted

@*param* `topCount` — The positions of the first X functions that take the longest time are counted
## originalExecute

```lua
function
```

## runnedCallback

```lua
table
```

## runnedClock

```lua
table
```

## runnedCost

```lua
table
```

## startTime

```lua
unknown
```

Start time (milliseconds）

