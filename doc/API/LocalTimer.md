# LocalTimer

Local timer

Support asynchronous creation or callbacks (as long as you promise not to cause other out-of-sync problems)）
If it is executed synchronously, then synchronous callbacks are ensured

## all_timers

```lua
table
```

## clock

```lua
function LocalTimer.clock()
  -> number
```

Gets the current logical time (milliseconds）
## count

```lua
integer
```

## execute

```lua
(method) LocalTimer:execute(...any)
```

 Immediate execution
## get_elapsed_time

```lua
(method) LocalTimer:get_elapsed_time()
  -> number
```

 Get the elapsed time
## get_include_name

```lua
(method) LocalTimer:get_include_name()
  -> string?
```

## get_init_count

```lua
(method) LocalTimer:get_init_count()
  -> integer
```

 Get initial count
## get_remaining_count

```lua
(method) LocalTimer:get_remaining_count()
  -> integer
```

 Get residual count
## get_remaining_time

```lua
(method) LocalTimer:get_remaining_time()
  -> number
```

 Get remaining time
## get_time_out_time

```lua
(method) LocalTimer:get_time_out_time()
  -> number
```

 Gets the time set by the timer
## id

```lua
integer
```

## include_name

```lua
string?
```

## init_ms

```lua
integer
```

## is_running

```lua
(method) LocalTimer:is_running()
  -> boolean
```

 Whether it is running
## loop

```lua
function LocalTimer.loop(timeout: number, on_timer: LocalTimer.OnTimer)
  -> LocalTimer
```

 Loop execution
## loop_count

```lua
function LocalTimer.loop_count(timeout: number, count: integer, on_timer: LocalTimer.OnTimer)
  -> LocalTimer
```

 Loop execution, you can specify a maximum number of times
## loop_count_frame

```lua
function LocalTimer.loop_count_frame(frame: integer, count: integer, on_timer: LocalTimer.OnTimer)
  -> LocalTimer
```

 You can specify the maximum number of frames to be executed after a certain number of frames
## loop_frame

```lua
function LocalTimer.loop_frame(frame: integer, on_timer: LocalTimer.OnTimer)
  -> LocalTimer
```

 Execute after a certain number of frames
## mode

```lua
LocalTimer.Mode
```

## on_timer

```lua
LocalTimer.OnTimer
```

## pairs

```lua
function LocalTimer.pairs()
  -> fun():LocalTimer?
```

 Iterate over all timers for debugging purposes only (you may iterate over the ones that have expired)）
## pause

```lua
(method) LocalTimer:pause()
```

 Pause timer
## paused_at

```lua
number?
```

## paused_ms

```lua
integer
```

## pausing

```lua
boolean?
```

## pop

```lua
(method) LocalTimer:pop()
```

## push

```lua
(method) LocalTimer:push()
```

## queue_index

```lua
integer?
```

## remove

```lua
(method) LocalTimer:remove()
```

 Remove timer
## removed

```lua
boolean?
```

## resume

```lua
(method) LocalTimer:resume()
```

 Recovery timer
## runned_count

```lua
integer
```

## set_time_out

```lua
(method) LocalTimer:set_time_out()
```

## start_ms

```lua
integer
```

## target_ms

```lua
number
```

## time

```lua
number
```

## total_paused_ms

```lua
integer
```

## wait

```lua
function LocalTimer.wait(timeout: number, on_timer: LocalTimer.OnTimer)
  -> LocalTimer
```

 Wait for the execution time
## wait_frame

```lua
function LocalTimer.wait_frame(frame: integer, on_timer: LocalTimer.OnTimer)
  -> LocalTimer
```

 Wait for a certain number of frames before executing
## wakeup

```lua
(method) LocalTimer:wakeup()
```

## waking_up

```lua
boolean?
```


# LocalTimer.Mode

```lua
LocalTimer.Mode:
    | 'second'
    | 'frame'
```


```lua
'frame'|'second'
```


# LocalTimer.OnTimer


```lua
fun(timer: LocalTimer, count: integer)
```


