local shop = require 'clicli.demo.Synthesis.Shop synthesis'
local MAIN = require 'clicli.demo.Interface.Master control'
local maker = shop.get_maker()

---@type boolean # Check whether the equipment composition UI is open
local is_equipment_ui_open = false

---@type boolean # Determine whether the Compositing branch UI is open
local is_synthesis_ui_visible = false

---@type boolean # Determine if the item description UI is open
local is_description_ui_visible = false

---@type boolean # Determine if the buy button UI is open
local is_buy_btn_visible = false

---@type string? # The item that is currently clicked in the item list screen
local cur_click_list_item = nil

---@type string? # The item that is currently clicked in the Item composition screen
local cur_click_synthesis_item = nil

---@type string[]? # A collection of store item names
local shop_item_names = nil

---@type integer # Quantity of items in store
local shop_item_num = 7

---@type table<string, string?> # Synthesize the UI-bound item on the branch
local ui_bound_item = {
    TargetEquipment = nil,
    Material1 = nil,
    Material2 = nil,
    Material3 = nil,
    Material4 = nil,
    ParentEquipment1 = nil,
    ParentEquipment2 = nil
}

--Press Z to open the equipment purchase screen
clicli.game:event('Local - Keyboard - Press', clicli.const.KeyboardKey['Z'], function (trg, data)
    local u = data.player:get_local_selecting_unit()
    if not u then
        return
    end

    if not is_equipment_ui_open then
        is_equipment_ui_open = true
        if not shop_item_names then
            shop_item_names = shop.get_shop_item_names()
        end
    else
        is_equipment_ui_open = false
        is_synthesis_ui_visible = false
        is_description_ui_visible = false
        is_buy_btn_visible = false

        cur_click_list_item = nil
        cur_click_synthesis_item = nil
    end
    MAIN:refresh('Equipment synthesis')
end)

--Click the equipment interface button to open the equipment purchase interface
MAIN:on_event('Device screen button.btn', 'Left button. - Press it', function (ui, local_player)
    local u = local_player:get_local_selecting_unit()
    if not u then
        return
    end

    if not is_equipment_ui_open then
        is_equipment_ui_open = true
        if not shop_item_names then
            shop_item_names = shop.get_shop_item_names()
        end
    else
        is_equipment_ui_open = false
        is_synthesis_ui_visible = false
        is_description_ui_visible = false
        is_buy_btn_visible = false

        cur_click_list_item = nil
        cur_click_synthesis_item = nil
    end
    MAIN:refresh('Equipment synthesis')
end)

MAIN:on_refresh('Equipment synthesis', function (ui, local_player)
    if not local_player:get_local_selecting_unit() then
        return
    end
    ui:set_visible(is_equipment_ui_open)
end)

--Add click events to the item list UI
for i = 1, shop_item_num do
    local child_name = string.format('装备合成.ListOfItems.lines.line1.bg%d', i)
    MAIN:on_refresh(child_name, function (ui, local_player)
        if shop_item_names then
            local item_key = shop.get_item_config()[shop_item_names[i]]
            if item_key then
                ui:set_visible(true)
                ui:get_child('highlight'):set_visible(false)
                ui:get_child('bg'):set_image(clicli.item.get_icon_id_by_key(item_key))
                ui:get_child('name'):set_text(clicli.item.get_name_by_key(item_key))
            else
                ui:set_visible(false)
            end
        end
    end)

    MAIN:on_event(child_name..'.btn'..tostring(i), 'Left button. - Press it', function (ui, local_player)
        if shop_item_names then
            is_synthesis_ui_visible = true
            is_description_ui_visible = false
            is_buy_btn_visible = false
            cur_click_list_item = shop_item_names[i]

            MAIN:refresh('装备合成.SyntheticBranch')
            MAIN:refresh('装备合成.Description')
            MAIN:refresh('装备合成.BuyButton')
        end
    end)

    MAIN:on_event(child_name..'.btn'..i, 'Mouse - Move in', function (ui, local_player)
        if shop_item_names then
            ui:get_parent():get_child('highlight'):set_visible(true)
        end
    end)

    MAIN:on_event(child_name..'.btn'..i, 'Mouse - Move out', function (ui, local_player)
        if shop_item_names then
            ui:get_parent():get_child('highlight'):set_visible(false)
        end
    end)
end

MAIN:on_refresh('装备合成.SyntheticBranch', function (ui, local_player)
    if not local_player:get_local_selecting_unit() then
        return
    end
    ui:set_visible(is_synthesis_ui_visible)

    --Start by making the item UI in the composition branch invisible
    ui:get_child('bg'):set_visible(false)
    for i = 1, 4 do
        ui:get_child('cbg'..i):set_visible(false)
    end
    for i = 1, 2 do
        ui:get_child('pbg'..i):set_visible(false)
    end

    --If the item list UI bound item is currently clicked
    if cur_click_list_item then
        local cur_click_list_item_key =  shop.get_item_config()[cur_click_list_item]
        --Gets all the recipes for the currently clicked item
        local result = maker:get_recipes_by_item(cur_click_list_item)
        --Counts all item names in the current player inventory
        local cur_player_item_names = {}
        for i, v in ipairs(local_player:get_local_selecting_unit():get_all_items():pick()) do
            table.insert(cur_player_item_names, v:get_name())
        end

        --Sets the UI display of the current item
        ui:get_child('bg'):set_visible(true)
        ui:get_child('bg.TargetEquipment'):set_image(clicli.item.get_icon_id_by_key(cur_click_list_item_key))
        ui:get_child('bg.highlight'):set_visible(false)
        --Calculate the cost
        local cur_cost = shop.get_item_price_by_name(cur_click_list_item)
        --Only items in the formula are calculated for the current cost, otherwise the original price is maintained
        if maker:get_recipes()[cur_click_list_item] then
            local cur_res = maker:target_check(cur_click_list_item, cur_player_item_names)
            if cur_res then
                for _, v in ipairs(cur_res.lost) do
                    cur_cost = cur_cost - shop.get_item_price_by_name(v)
                end
            end
        end
        --Update the current UI bound items
        Ui_bound_item.TargetEquipment = cur_click_list_item
        ui:get_child('bg.cost'):set_text(tostring(math.tointeger(cur_cost)))

        --Sets the material UI display for the current item
        for i, name in ipairs(result.children) do
            local child_key =  shop.get_item_config()[name]
            if child_key then
                ui:get_child(string.format('cbg%d', i)):set_visible(true)
                ui:get_child(string.format('cbg%d.Material %d', i, i)):set_image(clicli.item.get_icon_id_by_key(child_key))
                ui:get_child(string.format('cbg%d.highlight', i)):set_visible(false)
                --Calculate the cost
                local child_cost = shop.get_item_price_by_name(name)
                --Only items in the recipe are calculated for the current cost
                if maker:get_recipes()[name] then
                    local child_res = maker:target_check(name, cur_player_item_names)
                    if child_res then
                        for _, v in ipairs(child_res.lost) do
                            child_cost = child_cost - shop.get_item_price_by_name(v)
                        end
                    end
                end
                --Update the current UI bound items
                ui_bound_item[string.format('Material %d', i)] = name
                ui:get_child(string.format('cbg%d.cost', i)):set_text(tostring(math.tointeger(child_cost)))
            end
        end

        --Sets the parent item UI display for the current item
        for i, name in ipairs(result.parents) do
            local parent_key = shop.get_item_config()[name]
            if parent_key then
                ui:get_child(string.format('pbg%d', i)):set_visible(true)
                ui:get_child(string.format('pbg%d.Parent device %d', i, i)):set_image(clicli.item.get_icon_id_by_key(parent_key))
                ui:get_child(string.format('pbg%d.highlight', i)):set_visible(false)
                ui:get_child(string.format('pbg%d.name', i)):set_text(name)
                ui_bound_item[string.format('Parent device %d', i)] = name
            end
        end
    end
end)

--Register click events for the composition UI
MAIN:on_event('装备合成.SyntheticBranch.bg.btn', 'Left button. - Press it', function (ui, local_player)
    cur_click_synthesis_item = ui_bound_item.TargetEquipment
    is_description_ui_visible = true
    is_buy_btn_visible = true
    MAIN:refresh('装备合成.Description')
    MAIN:refresh('装备合成.BuyButton')
end)
MAIN:on_event('装备合成.SyntheticBranch.bg.btn', 'Mouse - Move in', function (ui, local_player)
    ui:get_parent():get_child('highlight'):set_visible(true)
end)
MAIN:on_event('装备合成.SyntheticBranch.bg.btn', 'Mouse - Move out', function (ui, local_player)
    ui:get_parent():get_child('highlight'):set_visible(false)
end)
for i = 1, 4 do
    local child_name = string.format('装备合成.SyntheticBranch', i, i)
    MAIN:on_event(child_name, 'Left button. - Press it', function (ui, local_player)
        cur_click_synthesis_item = ui_bound_item[string.format('Material %d', i)]
        is_description_ui_visible = true
        is_buy_btn_visible = true
        MAIN:refresh('装备合成.Description')
        MAIN:refresh('装备合成.BuyButton')
    end)
    MAIN:on_event(child_name, 'Mouse - Move in', function (ui, local_player)
        ui:get_parent():get_child('highlight'):set_visible(true)
    end)
    MAIN:on_event(child_name, 'Mouse - Move out', function (ui, local_player)
        ui:get_parent():get_child('highlight'):set_visible(false)
    end)
end
for i = 1, 2 do
    local child_name = string.format('装备合成.SyntheticBranch.pbg%d.btn%d', i, i)
    MAIN:on_event(child_name, 'Left button. - Press it', function (ui, local_player)
        is_synthesis_ui_visible = true
        is_description_ui_visible = false
        is_buy_btn_visible = false
        cur_click_list_item = ui_bound_item[string.format('Parent device %d', i)]

        MAIN:refresh('装备合成.SyntheticBranch')
        MAIN:refresh('装备合成.Description')
        MAIN:refresh('装备合成.BuyButton')
    end)
    MAIN:on_event(child_name, 'Mouse - Move in', function (ui, local_player)
        ui:get_parent():get_child('highlight'):set_visible(true)
    end)
    MAIN:on_event(child_name, 'Mouse - Move out', function (ui, local_player)
        ui:get_parent():get_child('highlight'):set_visible(false)
    end)
end

MAIN:on_refresh('装备合成.Description', function (ui, local_player)
    if not local_player:get_local_selecting_unit() then
        return
    end
    ui:set_visible(is_description_ui_visible)

    if cur_click_synthesis_item then
        local cur_click_synthesis_item_key = nil
        if shop_item_names then
            cur_click_synthesis_item_key = shop.get_item_config()[cur_click_synthesis_item]
        end
        if cur_click_synthesis_item_key then
            ui:get_child('icon'):set_image(clicli.item.get_icon_id_by_key(cur_click_synthesis_item_key))
            ui:get_child('title'):set_text(clicli.item.get_name_by_key(cur_click_synthesis_item_key))
            ui:get_child('txt'):set_text(clicli.item.get_description_by_key(cur_click_synthesis_item_key))
        end
    end
end)

MAIN:on_event('装备合成.BuyButton', 'Left button. - Press it', function (ui, local_player)
    local u = local_player:get_local_selecting_unit()
    if not u then
        return
    end

    if cur_click_synthesis_item then
        --Send a purchase request
        clicli.sync.send('demo- Buy store items', {
            item_name = cur_click_synthesis_item,
            unit = u,
        })
        MAIN:refresh('装备合成.SyntheticBranch')
        MAIN:refresh('装备合成.PlayerGold')
    end
end)

MAIN:on_refresh('装备合成.BuyButton', function (ui, local_player)
    if not local_player:get_local_selecting_unit() then
        return
    end
    ui:set_visible(is_buy_btn_visible)
end)

MAIN:on_refresh('装备合成.PlayerGold', function (ui, local_player)
    local player_gold = local_player:get_attr("gold")
    ui:get_child('num'):set_text(tostring(math.tointeger(player_gold)))
end)

MAIN:on_event('装备合成.Off', 'Left button. - Press it', function (ui, local_player)
    is_equipment_ui_open = false
    is_synthesis_ui_visible = false
    is_description_ui_visible = false
    is_buy_btn_visible = false

    cur_click_list_item = nil
    cur_click_synthesis_item = nil
    MAIN:refresh('Equipment synthesis')
end)
