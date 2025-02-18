# Network

## callback

```lua
(method) Network:callback(key: 'connected'|'data'|'disconnected'|'error', ...any)
```

```lua
key:
    | 'connected'
    | 'data'
    | 'disconnected'
    | 'error'
```
## data_reader

```lua
(method) Network:data_reader(callback: fun(read: fun(len: integer|'L'|'l'|nil):string))
```

Create a "blocking" type of data reader that will be executed in a loop `callback`
> It is mutually exclusive with on_data

The callback will give you a read function called 'read'. Here is its description：

Read the data according to the incoming rules, if the data does not meet the rules，
The reader then sleeps until it receives data that satisfies the rule and returns
* If no arguments are passed：
  Read all received data, similar to `on_data`
* If integer：
  Reads a specified number of bytes of data。
* If incoming `'l'`：
  Reads a row of data, excluding newlines。
* If incoming `'L'`：
  Reads a row of data, including newlines。
## handle

```lua
KKNetwork
```

## ip

```lua
string
```

## is_connecting

```lua
(method) Network:is_connecting()
  -> boolean
```

Whether connected
## make_error

```lua
(method) Network:make_error(err: any)
```

## on_connected

```lua
(method) Network:on_connected(on_connected: Network.OnConnected)
```

Callback after successful connection
## on_data

```lua
(method) Network:on_data(on_data: Network.OnData)
```

Callback after receiving data
## on_disconnected

```lua
(method) Network:on_disconnected(on_disconnected: Network.OnDisconnected)
```

Callback after disconnection
## on_error

```lua
(method) Network:on_error(on_error: Network.OnError)
```

A callback after an error occurs
## options

```lua
Network.Options
```

## port

```lua
integer
```

## remove

```lua
(method) Network:remove()
```

## retry_timer

```lua
unknown
```

## send

```lua
(method) Network:send(data: string)
```

## state

```lua
string
```

## update

```lua
(method) Network:update()
```

## update_timer

```lua
unknown
```


# Network.OnConnected


```lua
fun(self: Network)
```


# Network.OnData


```lua
fun(self: Network, data: string)
```


# Network.OnDisconnected


```lua
fun(self: Network)
```


# Network.OnError


```lua
fun(self: Network, error: string)
```


# Network.Options

## buffer_size

```lua
integer
```

Network buffer size (bytes), default is 2MB
## retry_interval

```lua
number
```

Reconnection interval (s). The default value is 5
## timeout

```lua
number
```

Connection timeout (s). The default value is 30 seconds
## update_interval

```lua
number
```

Network update interval (seconds). The default is 0.2

