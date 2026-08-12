--The entire UI system is asynchronous, so be careful not to use synchronous features
local MAIN = require 'clicli.demo.Interface.Master control'

local DESC = clicli.local_ui.create('CliCli description')

---@type Ability?
local current_ability

---@type Item?
local current_item

---@type UI?
local current_ui

for i = 1, 4 do
    local child_name = string.format('Hero skills.%d', i)

    MAIN:on_event(child_name, 'Mouse - Move in', function (ui, local_player)
        local selecting_unit = local_player:get_local_selecting_unit()
        if selecting_unit then
            current_ability = selecting_unit:get_ability_by_slot(clicli.const.AbilityType.HERO, i)
        else
            current_ability = nil
        end
        current_ui = ui
        DESC:refresh('*')
    end)

    MAIN:on_event(child_name, 'Mouse - Move out', function (ui, local_player)
        current_ability = nil
        current_ui = nil
        DESC:refresh('*')
    end)
end

for i = 1, 6 do
    local child_name = string.format('Props.bg%d.%d', i, i)

    MAIN:on_event(child_name, 'Mouse - Move in', function (ui, local_player)
        local selecting_unit = local_player:get_local_selecting_unit()
        if selecting_unit then
            current_item = selecting_unit:get_item_by_slot(clicli.const.SlotType.BAR, i)
        else
            current_item = nil
        end
        current_ui = ui
        DESC:refresh('*')
    end)

    MAIN:on_event(child_name, 'Mouse - Move out', function (ui, local_player)
        current_item = nil
        current_ui = nil
        DESC:refresh('*')
    end)
end

DESC:on_refresh('', function (ui, local_player)
    if (current_ability or current_item) and current_ui then
        ui:set_visible(true)
    else
        ui:set_visible(false)
    end
end)

DESC:on_refresh('Panel', function (ui, local_player)
    if not current_ui then
        return
    end
    ui:set_absolute_pos(current_ui:get_absolute_x() - 100, current_ui:get_absolute_y() + 100)
end)

DESC:on_refresh('面板.标题.icon', function (ui, local_player)
    if current_ability then
        ui:set_image(current_ability:get_icon())
    elseif current_item then
        ui:set_image(current_item:get_icon())
    else
        return
    end
end)

DESC:on_refresh('面板.标题.text', function (ui, local_player)
    if current_ability then
        ui:set_text(current_ability:get_name())
    elseif current_item then
        ui:set_text(current_item:get_name())
    else
        return
    end
end)

DESC:on_refresh('面板.Description', function (ui, local_player)
    if current_ability then
        ui:set_text(current_ability:get_description())
    elseif current_item then
        ui:set_text(current_item:get_description())
    else
        return
    end
end)
