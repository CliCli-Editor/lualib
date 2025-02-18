--Please install the "CliCli Development Assistant" plug-in (version >=0.9.0),
--Using the command 'F1' -> 'CliCli Development Assistant: Start Web server',
--Then proceed with the following demonstration.

local M = {}

--[[
After the client sends a message, it replies "You sent: < received message>”
The client sends "Goodbye!" Will disconnect
]]
function M.test1()
    local client = clicli.network.connect('127.0.0.1', 25895)
    print('Start connecting to server 1...')

    client:on_connected(function (self)
        print('Server 1 is connected!')
        self:send('Hello!')
    end)

    client:on_disconnected(function (self)
        print('Disconnected server 1!')
    end)

    client:on_error(function (self, error)
        print('An error occurred:', error)
    end)

    client:on_data(function (self, data)
        print('Received a message from server 1:', data)
        if data == 'You sent: Hello!' then
            --Send "Goodbye!" After that, the server is disconnected
            self:send('See you later!')
        end
    end)
end

--[[
In actual use, we often use "fixed-length packet head + variable-length packet body" to transmit data。
After connecting to the server, the server sends the following packet every 1 second：
* 4A byte packet header, indicating the length of the packet body (big end）
* JsonThe structure of the inclusion body is as follows
```jsonc
{
    "count": 1, // Indicates the number of times this is sent. A total of 10 times will be sent
    "time": 1234, // Server timestamp
}
```
]]
function M.test2()
    local client = clicli.network.connect('127.0.0.1', 25896)
    print('Start connecting to server 2...')

    client:on_connected(function (self)
        print('Connected server 2!')
    end)

    client:on_disconnected(function (self)
        print('Disconnected server 2!')
    end)

    client:on_error(function (self, error)
        print('An error occurred:', error)
    end)

    ---@async
    client:data_reader(function (read)
        --The packet header is read, and the length of the packet body is represented by 4 bytes at the big end
        local head = read(4)
        --The length of the packet is obtained by analyzing the packet header in big-end order
        local len = string.unpack('>I4', head)
        --Read the package body in json format
        local jsonStr = read(len)
        --Parsing json
        local json = clicli.json.decode(jsonStr)

        print('Received data:')
        print('count:', json.count)
        print('time:', json.time)
    end)
end

return M
