--This file will run automatically when the game starts

--In development mode, print logs into the game
if clicli.game.is_debug_mode() then
    clicli.config.log.toGame = true
    clicli.config.log.level  = 'debug'
else
    clicli.config.log.toGame = false
    clicli.config.log.level  = 'info'
end

clicli.game:event('Game - initialization', function (trg, data)
    print('Hello, CliCli!')
end)

clicli.timer.loop(5, function (timer, count)
    print('Displaying text every 5 seconds is the first' .. tostring(count) .. 'time')
end)

clicli.game:event('Keyboard. - Press it', 'SPACE', function ()
    print('You hit the space bar!')
end)

--The code in this file can be hot overloaded
include 'Overloadable code'
