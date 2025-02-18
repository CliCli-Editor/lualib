# KKNetwork

## destroy

```lua
(method) KKNetwork:destroy()
```

 Release network resources. If the network connection is not already disconnected, the network connection will be disconnected
## init

```lua
(method) KKNetwork:init(ip: any, port: any, buffer_size: any)
```

 Example Initialize the network environment
 @param ip Remote IP address. The value is a string
 @param port Port number type
 @param buffer_size Network buffer size
 @return Returns whether the initialization succeeded. If it failed, an error message will be displayed
 @detail This function will check whether the ip port is valid, but will not actually start the network loop, but will request the corresponding resources in advance
## is_connecting

```lua
(method) KKNetwork:is_connecting()
  -> boolean
```

 Returns the active status of the network connection
## peek

```lua
(method) KKNetwork:peek(length: any)
```

 Detection of network messages, not removed from the message queue, mostly used to determine whether the message header is sufficient
 @return message The message body, string, is returned after acceptance failurenil 
 @return result The actual length of the received message
 @detail The receiving message function does not remove the message from the buffer
## recv

```lua
(method) KKNetwork:recv(length: any)
```

 Receive network message
 @param length The length of the message expected to be received or, if insufficient, the length actually received
 @return message The message body, string, is returned after acceptance failurenil 
 @return result The actual length of the received message
 @detail The accept message function removes the message from the buffer and is the actual accept message
## run_once

```lua
(method) KKNetwork:run_once()
```

 Main loop, which needs to be called in the user main loop
## send

```lua
(method) KKNetwork:send(message_body: any, length: any)
```

 Send network message
 @param message_body Message body, type string, can be a string, or can be a binary array after pb serialization
 @param length message_body Length
 @return The length of the actual message sent, failure returns a value of <= 0
## start

```lua
(method) KKNetwork:start()
```

 Start a network connection
 @return true or false
 @detail Start the network connection, this function call will actually connect to the server
 If the connection is successful, the is_connecting method returnstrue
## stop

```lua
(method) KKNetwork:stop()
```

 Disconnect the network connection and stop receiving network message events
 @detail Disconnect the current connection and release the corresponding resources. As long as destory is not called, you can also call the start method again to start the network connection

