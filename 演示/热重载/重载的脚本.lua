--Try swapping comments on the next 2 lines before reloading!
print('The file is loaded for the first time')
--print(' File is loaded a second time ')

clicli.game:event('Keyboard. - Press it', clicli.const.KeyboardKey['SPACE'], function (trg, data)
    --Try swapping comments on the next 2 lines before reloading!
    print('The first type is blank')
    --print(' Second type of space ')
end)

clicli.timer.loop(1, function (timer, count)
    --Try swapping comments on the next 2 lines before reloading!
    print('The first timer expires')
    --print(' Second timer expires ')
end)
