--The entire UI system is asynchronous, so be careful not to use synchronous features

local MAIN = clicli.local_ui.create('CliCli master control')

MAIN:bind_unit_attr('头像.属性.攻击速度.text', 'text', 'Attack speed')
MAIN:bind_unit_attr('头像.属性.移动速度.text', 'text', 'Moving speed')
MAIN:bind_unit_attr('血条.Progress bar', 'Current value', 'HP')
MAIN:bind_unit_attr('血条.Progress bar', 'Maximum value', 'Maximum life')
MAIN:bind_unit_attr('血条.文本.Current value', 'text', 'HP')
MAIN:bind_unit_attr('血条.文本.Maximum value', 'text', 'Maximum life')
MAIN:bind_unit_attr('蓝条.Progress bar', 'Current value', 'magic')
MAIN:bind_unit_attr('蓝条.Progress bar', 'Maximum value', 'Maximum magic')
MAIN:bind_unit_attr('蓝条.文本.Current value', 'text', 'magic')
MAIN:bind_unit_attr('蓝条.文本.Maximum value', 'text', 'Maximum magic')
MAIN:bind_unit_attr('属性栏.攻击.text', 'text', 'Physical attack')
MAIN:bind_unit_attr('属性栏.防御.text', 'text', 'Physical defense')
MAIN:bind_unit_attr('属性栏.力量.text', 'text', 'strength')
MAIN:bind_unit_attr('属性栏.敏捷.text', 'text', 'Agility')
MAIN:bind_unit_attr('属性栏.智力.text', 'text', 'intelligence')

MAIN:on_refresh('头像.picture', function (ui, local_player)
    if not local_player:get_local_selecting_unit() then
        return
    end
    ui:set_image(local_player:get_local_selecting_unit():get_icon())
end)

MAIN:on_refresh('头像.名字.text', function (ui, local_player)
    if not local_player:get_local_selecting_unit() then
        return
    end
    ui:set_text(local_player:get_local_selecting_unit():get_name())
end)

MAIN:on_refresh('Hero skill', function (ui, local_player)
    if not local_player:get_local_selecting_unit() then
        return
    end

    for i, slot in ipairs(ui:get_childs()) do
        local ability = local_player:get_local_selecting_unit():get_ability_by_slot(clicli.const.AbilityType.HERO, i)
        if ability then
            slot:set_visible(true)
            --It must be actively bound, otherwise it will flicker
            slot:bind_ability(ability)
        else
            slot:set_visible(false)
        end
    end
end)

MAIN:on_refresh('经验条.Progress bar', function (ui, local_player)
    if not local_player:get_local_selecting_unit() then
        return
    end

    ui:set_max_progress_bar_value(local_player:get_local_selecting_unit():get_upgrade_exp())
    ui:set_current_progress_bar_value(local_player:get_local_selecting_unit():get_exp())
end)

MAIN:on_refresh('经验条.EmpiricalText', function (ui, local_player)
    if not local_player:get_local_selecting_unit() then
        return
    end

    local exp = local_player:get_local_selecting_unit():get_exp()
    local max_exp = local_player:get_local_selecting_unit():get_upgrade_exp()

    if max_exp > 0 then
        ui:set_text(string.format('%d/%d', exp, max_exp))
    else
        ui:set_text('Max')
    end
end)

MAIN:on_refresh('经验条.HierarchicalText', function (ui, local_player)
    if not local_player:get_local_selecting_unit() then
        return
    end

    ui:set_text(string.format('Grade %d', local_player:get_local_selecting_unit():get_level()))
end)

MAIN:on_refresh('', function (ui, local_player)
    if local_player:get_local_selecting_unit() then
        ui:set_visible(true)
    else
        ui:set_visible(false)
    end
end)

MAIN:on_event('avatar', 'Left button. - Press it', function (ui, local_player)
    local u = local_player:get_local_selecting_unit()
    if not u then
        return
    end

    clicli.camera.set_camera_follow_unit(local_player, u, 0, 0, 0)
end)

MAIN:on_event('avatar', 'Left click - Lift', function (ui, local_player)
    clicli.camera.cancel_camera_follow_unit(local_player)
end)

clicli.game:event('select-unit', function (trg, data)
    MAIN:refresh('*', data.player)
end)

clicli.game:event('Select - Unit Group', function (trg, data)
    MAIN:refresh('*', data.player)
end)

clicli.game:event('Unit - After gaining experience', function (trg, data)
    clicli.player.with_local(function (local_player)
        if local_player:get_local_selecting_unit() == data.unit then
            MAIN:refresh('Experience bar')
        end
    end)
end)

clicli.game:event('Unit - Upgrade', function (trg, data)
    clicli.player.with_local(function (local_player)
        if local_player:get_local_selecting_unit() == data.unit then
            MAIN:refresh('Experience bar')
        end
    end)
end)

clicli.game:event('Local - Keyboard - Press', clicli.const.KeyboardKey['SPACE'], function (trg, data)
    local u = data.player:get_local_selecting_unit()
    if not u then
        return
    end

    clicli.camera.set_camera_follow_unit(data.player, u, 0, 0, 0)
end)

clicli.game:event('Local - Keyboard - Lift', clicli.const.KeyboardKey['SPACE'], function (trg, data)
    clicli.camera.cancel_camera_follow_unit(data.player)
end)

MAIN:on_refresh('property', function (ui, local_player)
    local u = local_player:get_local_selecting_unit()
    if not u then
        return
    end

    for i, slot in ipairs(ui:get_childs()) do
        slot:get_child(tostring(i)):set_ui_unit_slot(u, clicli.const.SlotType.BAR, i - 1)
    end
end)

clicli.game:event('Items - Get', function (trg, data)
    MAIN:refresh('property', data.unit:get_owner_player())
end)

return MAIN
