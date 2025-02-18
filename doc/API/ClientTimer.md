# ClientTimer

Client timer

A timer, powered by your own computer's CPU, is completely asynchronous (even when executed synchronously)）
It also continues to time and call back when the game is paused
> If you don't know what asynchrony is, please don't use this module！

## all_timers

```lua
table
```

## count

```lua
integer
```

## execute

```lua
(method) ClientTimer:execute(...any)
```

 Immediate execution
## get_elapsed_frame

```lua
(method) ClientTimer:get_elapsed_frame()
  -> integer
```

Gets the number of frames passed
## get_elapsed_time

```lua
(method) ClientTimer:get_elapsed_time()
  -> number
```

 Get the elapsed time
## get_include_name

```lua
(method) ClientTimer:get_include_name()
  -> string?
```

## get_init_count

```lua
(method) ClientTimer:get_init_count()
  -> integer
```

 Get initial count
## get_remaining_count

```lua
(method) ClientTimer:get_remaining_count()
  -> integer
```

 Get residual count
## get_remaining_frame

```lua
(method) ClientTimer:get_remaining_frame()
  -> integer
```

Gets the number of remaining frames
## get_remaining_time

```lua
(method) ClientTimer:get_remaining_time()
  -> number
```

 Get remaining time
## get_time_out_time

```lua
(method) ClientTimer:get_time_out_time()
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

## init_frame

```lua
integer
```

## init_ms

```lua
integer
```

## is_running

```lua
(method) ClientTimer:is_running()
  -> boolean
```

 Whether it is running
## loop

```lua
function ClientTimer.loop(timeout: number, on_timer: ClientTimer.OnTimer)
  -> ClientTimer
```

 Loop execution
## loop_count

```lua
function ClientTimer.loop_count(timeout: number, count: integer, on_timer: ClientTimer.OnTimer)
  -> ClientTimer
```

 Loop execution, you can specify a maximum number of times
## loop_count_frame

```lua
function ClientTimer.loop_count_frame(frame: integer, count: integer, on_timer: ClientTimer.OnTimer)
  -> ClientTimer
```

 You can specify the maximum number of frames to be executed after a certain number of frames
## loop_frame

```lua
function ClientTimer.loop_frame(frame: integer, on_timer: ClientTimer.OnTimer)
  -> ClientTimer
```

 Execute after a certain number of frames
## mode

```lua
ClientTimer.Mode
```

## on_timer

```lua
ClientTimer.OnTimer
```

## pairs

```lua
function ClientTimer.pairs()
  -> fun():ClientTimer?
```

 Iterate over all timers for debugging purposes only (you may iterate over the ones that have expired)）
## pause

```lua
(method) ClientTimer:pause()
```

 Pause timer
## paused_at_frame

```lua
integer?
```

## paused_at_ms

```lua
number?
```

## paused_frame

```lua
integer
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
(method) ClientTimer:pop()
```

## push

```lua
(method) ClientTimer:push()
```

## queue_index

```lua
integer?
```

## remove

```lua
(method) ClientTimer:remove()
```

 Remove timer
## removed

```lua
boolean?
```

## resume

```lua
(method) ClientTimer:resume()
```

 Recovery timer
## runned_count

```lua
integer
```

## set_time_out

```lua
(method) ClientTimer:set_time_out()
```

## start_frame

```lua
integer
```

## start_ms

```lua
integer
```

## target_frame

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

## total_paused_frame

```lua
integer
```

## total_paused_ms

```lua
integer
```

## update_frame

```lua
function ClientTimer.update_frame()
```

Update immediately to the next frame
## wait

```lua
function ClientTimer.wait(timeout: number, on_timer: ClientTimer.OnTimer)
  -> ClientTimer
```

 Wait for the execution time
## wait_frame

```lua
function ClientTimer.wait_frame(frame: integer, on_timer: ClientTimer.OnTimer)
  -> ClientTimer
```

 Wait for a certain number of frames before executing
## wakeup

```lua
(method) ClientTimer:wakeup()
```

## waking_up

```lua
boolean?
```


# ClientTimer.Mode

```lua
ClientTimer.Mode:
    | 'second'
    | 'frame'
```


```lua
'frame'|'second'
```


# ClientTimer.OnTimer


```lua
fun(timer: ClientTimer, count: integer, local_player: Player)
```


