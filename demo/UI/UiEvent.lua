--First place an image 'panel_1.image_1' in the interface editor

clicli.game:event('Game - initialization', function ()
    --The UI can only be retrieved after the initialization event
    local ui = clicli.ui.get_ui(clicli.player(1), 'panel_1.image_1')

    --Adds events to the UI and sends UI events when the mouse moves in
    ui:add_event('Mouse - Move in', 'Test event', {
        custom = 'Custom data',
    })

    --Also actively sends UI events when you press space
    clicli.game:event('Keyboard. - Press it', clicli.const.KeyboardKey['SPACE'], function ()
        ui:send_event('Test event')
    end)
end)

--Receive UI events
clicli.game:event('Interface - Message', 'Test event', function (trg, data)
    print('Interface message:', data.data.custom)
end)
