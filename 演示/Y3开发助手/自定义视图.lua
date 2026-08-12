--The VSCode extension CliCli Development Assistant, version >= 1.8.0, needs to be installed

--The interface name of the created node is long, so rename it here:
local Node = clicli.develop.helper.createTreeNode

--Create your view on the tree view of the CliCli development Assistant
clicli.develop.helper.createTreeView('Cheat function', Node('Cheat function', {
    --Available icon, please refer to https://code.visualstudio.com/api/references/icons-in-labels#icon-listing
    icon = 'call-incoming',
    --Define child node
    childs = {
        Node('Full back condition', {
            onClick = function (node)
                --Click events are local, and if you need to test them online,
                --Use the 'clicli.sync' library for synchronization
                clicli.player.with_local(function (local_player)
                    local unit = local_player:get_local_selecting_unit()
                    if unit then
                        unit:set_attr('HP', unit:get_attr("Maximum life"))
                        unit:set_attr('magic', unit:get_attr("Maximum magic"))
                    end
                end)
            end
        }),
        Node('Kill unit', {
            onClick = function (node)
                clicli.player.with_local(function (local_player)
                    local unit = local_player:get_local_selecting_unit()
                    if unit then
                        unit:kill_by(unit)
                    end
                end)
            end
        }),
        --Some of the more complex functions can be encapsulated into functions,
        --But I'm just going to write it here as a demonstration
        (function ()
            local node = Node('The currently selected unit', {
                description = 'no',
            })

            node:bindGC(clicli.ltimer.loop(0.2, function ()
                clicli.player.with_local(function (local_player)
                    local unit = local_player:get_local_selecting_unit()
                    if unit then
                        node.description = tostring(unit)
                    else
                        node.description = 'no'
                    end
                end)
            end))

            return node
        end)(),
    }
}))

--You must have noticed that custom views already have a default Dashboard view.
--The source code can be found in 'clicli\develop\helper\explorer.lua'.
