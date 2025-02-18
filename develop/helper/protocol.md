# Games -> Y3 Development Assistant

## print

Print the message in the Terminal window

* `message`: `string` Content to print

## createTreeView

Create a tree view

* `id`: `integer` Uniqueness of viewID
* `name`: `string` Name of view
* `root`: `integer` Unique to the primary nodeID

## removeTreeView

Delete the tree view

* `id`: `integer` Uniqueness of viewID

## refreshTreeNode

Let me know that the node has changed

* `id`: `integer` Uniqueness of nodeID
* `complete?`: `boolean` Whether it is a full push. If not, the helper can then retrieve the data with getTreeNode
* `name?`: `string` Node name
* `desc?`: `string` Node description
* `tip?`: `string` Hover prompt
* `icon?`: `string` Node icon
* `check?`: `boolean` Current check box status
* `hasChilds?`: `boolean` Whether it can be expanded
* `canClick?`: `boolean` Whether you can click

## command

Execute commands, built-in command reference https://code.visualstudio.com/api/references/commands

* `command`: `string` command
* `args?`: `any[]` argument

Back `any`

## prepareForRestart

Notify the development assistant that the game is about to restart

* `debugger?`: `boolean` Whether to start the debugger. If omitted, it determines whether a debugger is needed based on whether it is currently attached。
* `id?`: `integer`  Open your own in multiple modeid

## showInputBox

Create an input box

* `id`: `integer` soleID
* `title?`: `string` title
* `value?`: `string` Initial value
* `valueSelection?`: `[integer, integer]` Initially selected text range (cursor position, before the first character0)
* `prompt?`: `string` Tips
* `placeHolder?`: `string` placeholder
* `password?`: `boolean` Password or not box
* `ignoreFocusOut?`: `boolean` Whether to close when you lose focus
* `hasValidateInput?`: `boolean` Whether there is a 'validateInput' callback

Return input result

* `input?`: `string` Input content。

## updatePlayer

Set your own player profile

* `name`: `string` Player name
* `id`: `integer` PlayerID
* `multiMode?`: `boolean` Whether to open multiple mode

## createTracy

activatetracy

# Y3Development Assistant -> Games

## command

Run the command, such as.rd, 1 + 2, and no value is returned

* `data`: `string` The command to execute

## getTreeNode

Get the tree view node

* `id`: `integer` Uniqueness of nodeID

Returns data for the node

* `name`: `string` Node name
* `desc?`: `string` Node description
* `tip?`: `string` Hover prompt
* `icon?`: `string` Node icon
* `check?`: `boolean` Current check box status
* `hasChilds?`: `boolean` Whether it can be expanded
* `canClick?`: `boolean` Whether you can click

## getChildTreeNodes

Gets the child nodes of the tree view node

* `id`: `integer` Uniqueness of nodeID

Returns a unique array of ids for the child node

* `childs`: `integer[]` An array of unique ids for the child node

## changeTreeNodeVisible

Changes in the visibility of a tree view node

* `ids`: `integer` An array of unique ids for a node
* `visible`: `boolean` Visible or not

## clickTreeNode

Click on the tree view node

* `id`: `integer` Uniqueness of nodeID

## changeTreeNodeExpanded

The expansion status of the tree view changes

* `id`: `integer` Uniqueness of nodeID
* `expanded`: `boolean` Expand or not

## inputBoxValidate

Check the validity of the input box

* `id`: `integer` The input box is uniqueid
* `input`: `string` Input content

## changeTreeNodeCheckBox

The check box of a tree view node changes

* `id`: `integer` Uniqueness of nodeID
* `checked`: `boolean` Checked or not
