local M = clicli.object.unit[134274912] --Guan Yu

M.data.name = 'This is the changed name'

clicli.game:event('Keyboard. - Press it', clicli.const.KeyboardKey['SPACE'], function ()
    clicli.player(1):create_unit(134274912)
end)
