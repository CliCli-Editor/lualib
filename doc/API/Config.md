# Config

disposition

You can set log and synchronization configurations

## cache

```lua
table
```

## code

```lua
table
```

## debug

```lua
string
```

 Yes No debug mode
## log

```lua
unknown
```

 Log related configuration
## logic_frame

```lua
integer
```

Logical frame rate per second, please set it to the same as set in your map。
The current default is 30 frames, and in the future the Settings in your map will be read by default。
It must be set at the beginning of the game, do not change it in the middle。
## sync

```lua
unknown
```

 Sync-related configurations, which are enabled when set to 'true'，
 It generates additional traffic。  
 Synchronization takes a certain amount of time, and the state obtained is a short period of time ago，
 Therefore, the status cannot be obtained immediately after synchronization is enabled。  

# Config.Log

## level

```lua
Log.Level
```

Log level. The default value is `debug`
## logger

```lua
fun(level: Log.Level, message: string, timeStamp: string):boolean
```

A custom log handler that returns' true 'will block the default log handler. This function is masked during the execution of the handler function。
## toConsole

```lua
boolean
```

Whether to print to the console. The default is `true`
## toDialog

```lua
boolean
```

Whether to print to a Dialog window. The default is `true`
## toFile

```lua
boolean
```

Whether to print to a file. The default value is `true`
## toGame

```lua
boolean
```

Whether to print to the game window. The default is `false`
## toHelper

```lua
boolean
```

Whether to print to CliCli-Helper, the default is `true`

# Config.Sync

 Sync-related configurations, which are enabled when set to 'true'，
 It generates additional traffic。  
 Synchronization takes a certain amount of time, and the state obtained is a short period of time ago，
 Therefore, the status cannot be obtained immediately after synchronization is enabled。  

## camera

```lua
boolean
```

Sync the player's shots
## key

```lua
boolean
```

Sync the player's keyboard and mouse keys
## mouse

```lua
boolean
```

Sync the player's mouse position

