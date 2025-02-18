clicli.game:event_on('#417 Modified', 1, function(trg, ...)
    print('It`s the only one that got it. Integer parameters')
end)

clicli.game:event_on('#417 Modified', 2, function(trg, ...)
    print('Integer parameter')
end)

clicli.game:event_on('#417 Modified', '1', function (trg, ...)
    print('It`s the only one that got it. String argument')
end)

clicli.game:event_on('#417 Modified', '2', function(trg, ...)
    print('String parameter')
end)

clicli.game:event_on('#417 Modified', clicli.player(1), function(trg, ...)
    print('This is the only place I received the CliCli instance')
end)

clicli.game:event_on('#417 Modified', clicli.player(2), function(trg, ...)
    print('Example of CliCli')
end)




clicli.game:event("Keyboard. - Press it", clicli.const.KeyboardKey["F1"], function(trg, data)
    ---@param args any[]
    ---@param match_func fun(fire_args: any[]? , event_args: any[]?) : boolean
    ---@return table
    local function creat_custom_match(args, match_func)
        local custom_match = {
            __eq = function(fire_args, event_args)
                return match_func(fire_args, event_args)
            end
        }
        return setmetatable(args, custom_match)
    end

    ---User-defined matching rules
    ---@param fire_args any[]? The parameters passed by the trigger
    ---@param event_args any[]? Event listening parameters
    ---@return boolean
    local function custom_match_rule(fire_args, event_args)
        print(string.format("fire_args: %s, \r\nevent_args: %s", clicli.util.dump(fire_args), clicli.util.dump(event_args)))
        --If true is returned, the match is successful
        return true
    end


    data.player:event_on('obtained', function()
        print('Trigger acquisition')
        print('Before removal')
        data.player:event_notify('Remove 1', "000 1")
        data.player:event_dispatch('Remove 1')
        --Unable to match
        data.player:event_dispatch_with_args('Remove 2', { 123 }, "111 1")
        --Can match
        data.player:event_dispatch_with_args('Remove 2', creat_custom_match({ 123 }, custom_match_rule), "111 2")
        data.player:event_notify('Remove 2', "000 2")

        print('After removal')
    end)


    data.player:event_on('Remove 1', function(trg, key)
        print('Trigger removal 1', key)
    end)

    data.player:event_on('Remove 2', { 456 }, function(trg, key)
        print('Trigger removal 2', key)
    end)


    data.player:event_notify('obtained')



    clicli.game:event_dispatch_with_args('#417 Modified', 1)
    clicli.game:event_dispatch_with_args('#417 Modified', '1')
    clicli.game:event_dispatch_with_args('#417 Modified', clicli.player(1))


end)
