# Timer

Synchronous timer

All players must use the same timer, otherwise it will be out of sync

## all_timers

```lua
table
```

## count_loop

```lua
function Timer.count_loop(timeout: number, times: integer, on_timer: fun(timer: Timer, count: integer), desc?: string, immediate?: boolean)
  -> Timer
```

 Loop execution, you can specify a maximum number of times

@*param* `desc` — Description

@*param* `immediate` — Whether to execute once immediately (count the maximum number of times)
## count_loop_frame

```lua
function Timer.count_loop_frame(frame: integer, times: integer, on_timer: fun(timer: Timer, count: integer), desc?: string)
  -> Timer
```

 You can specify the maximum number of frames to be executed after a certain number of frames
> Please change to... `y3.ltimer.count_loop_frame`

@*param* `desc` — Description
## desc

```lua
string
```

## execute

```lua
(method) Timer:execute(...any)
```

 Immediate execution
## get_by_handle

```lua
function Timer.get_by_handle(py_timer: py.Timer, on_timer: Timer.OnTimer)
  -> Timer
```

## get_elapsed_time

```lua
(method) Timer:get_elapsed_time()
  -> time: number
```

Gets the elapsed time of the timer

@*return* `time` — The elapsed time of the timer
## get_include_name

```lua
(method) Timer:get_include_name()
  -> string?
```

## get_init_count

```lua
(method) Timer:get_init_count()
  -> count: integer
```

Gets the timer initial count

@*return* `count` — Initial count
## get_remaining_count

```lua
(method) Timer:get_remaining_count()
  -> count: integer
```

Gets the remaining timer count

@*return* `count` — Residual count
## get_remaining_time

```lua
(method) Timer:get_remaining_time()
  -> time: number
```

Gets the remaining time on the timer

@*return* `time` — Timer remaining time
## get_time_out_time

```lua
(method) Timer:get_time_out_time()
  -> time: number
```

Gets the time set by the timer

@*return* `time` — Set time
## handle

```lua
py.Timer
```

timepiece
## id

```lua
unknown
```

## id_counter

```lua
unknown
```

## include_name

```lua
(string|false)?
```

## is_removed

```lua
(method) Timer:is_removed()
  -> boolean
```

## is_running

```lua
(method) Timer:is_running()
  -> boolean
```

 Whether it is running
## loop

```lua
function Timer.loop(timeout: number, on_timer: fun(timer: Timer, count: integer), desc?: string, immediate?: boolean)
  -> Timer
```

 Loop execution

@*param* `desc` — Description

@*param* `immediate` — Whether to execute it immediately
## loop_frame

```lua
function Timer.loop_frame(frame: integer, on_timer: fun(timer: Timer, count: integer), desc?: string)
  -> Timer
```

 Execute after a certain number of frames
> Please change to... `y3.ltimer.loop_frame`

@*param* `desc` — Description
## mode

```lua
Timer.Mode
```

## on_timer

```lua
Timer.OnTimer
```

## pairs

```lua
function Timer.pairs()
  -> fun():Timer?
```

 Iterate over all timers for debugging purposes only (you may iterate over the ones that have expired)）
## pause

```lua
(method) Timer:pause()
```

 Pause timer
## remove

```lua
(method) Timer:remove()
```

 Remove timer
## resume

```lua
(method) Timer:resume()
```

 Continue timer
## type

```lua
string
```

## wait

```lua
function Timer.wait(timeout: number, on_timer: fun(timer: Timer), desc?: string)
  -> Timer
```

 Wait for the execution time

@*param* `desc` — Description
## wait_frame

```lua
function Timer.wait_frame(frame: integer, on_timer: fun(timer: Timer), desc?: string)
  -> Timer
```

 Wait for a certain number of frames before executing
> Please change to... `y3.ltimer.wait_frame`

@*param* `desc` — Description

# Timer.Mode

```lua
Timer.Mode:
    | 'second'
    | 'frame'
```


```lua
'frame'|'second'
```


# Timer.OnTimer


```lua
fun(timer: Timer, ...any)
```


