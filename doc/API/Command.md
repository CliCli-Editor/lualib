# Command

Cheat instruction

This feature is only available in development mode

## commands

```lua
{ [string]: fun(...any) }
```

## execute

```lua
function Command.execute(command: string, ...any)
```

 Execute cheat instruction
## register

```lua
function Command.register(command: string, callback: fun(...any))
```

 Register cheat instructions (instruction names are case insensitive）

