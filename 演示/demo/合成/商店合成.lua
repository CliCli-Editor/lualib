local M = {}

require 'clicli.tools.synthesis'
local maker = New 'Synthesis'()

---@type table<string, py.ItemKey> # Item configuration, which maps the item name to its corresponding key, e.g. {item1 = 10001}
local item_config = {}

---@type string[] # Store item collection, {'item1', 'item2'}
local item_names = {}

---Enter the item name and return the corresponding key
---@param name string # Item Name
---@return py.ItemKey? # Corresponding key
function M.get_item_key_by_name(name)
    --Check whether it is in the configuration
    if item_config[name] then
        return item_config[name]
    else
        return nil
    end
end

---Enter the item name to return its purchase price
---@param name string # Item Name
---@return number? # Corresponding price
function M.get_item_price_by_name(name)
    local item_key = M.get_item_key_by_name(name)
    if not item_key then
        return nil
    end
    local price = clicli.item.get_item_buy_price_by_key(item_key, 'gold')
    return price
end

--Initialize item configuration
function M.init_item_config(config)
    item_config = config
end

---Store item initialization
---@param items string[] # Item name {'item1', 'item2'}
function M.init_shop_item(items)
    item_names = items
end

---Registered synthetic formula
---@param result any # Synthetic target" target"
---@param ingredients any[] # Synthetic materials {"material1", "material2", "material3"}
function M.register(result, ingredients)
    maker:register(result, ingredients)
end

--Frame synchronization
clicli.sync.onSync('demo- Buy store items', function (data, source)
    if not data then
        return
    end
    ---@type string
    local item_name = data.item_name
    ---@type Unit
    local u = data.unit

    --Determine if there is enough gold to buy
    local gold = source:get_attr('gold')

    --Gets the name of the item currently in the player's inventory
    local player_item_names = {}
    for i, v in ipairs(u:get_all_items():pick()) do
        table.insert(player_item_names, v:get_name())
    end

    --Calculate current item costs
    local item_cost = M.get_item_price_by_name(item_name)
    --Only items in the recipe need to be calculated for the current cost
    local res = nil
    if maker:get_recipes()[item_name] then
        res = maker:target_check(item_name, player_item_names)
        if res then
            for _, v in ipairs(res.lost) do
                item_cost = item_cost - M.get_item_price_by_name(v)
            end
        end
    end

    if gold >= item_cost then
        --If the purchased item has a recipe, it needs to remove its composition material
        if res then
            for _, v in ipairs(res.lost) do
                local cur_item_key = M.get_item_key_by_name(v)
                if cur_item_key then
                    u:remove_item(cur_item_key, 1)
                end
            end
        end
        --Deduct the player's gold and add it to the player
        source:set('gold', gold - item_cost)
        local item_key = M.get_item_key_by_name(item_name)
        if item_key then
            u:add_item(item_key)
        end
    else
        print('Players are out of gold')
    end
end)

---Return maker object
---@return Synthesis # Composite processing object
function M.get_maker()
    return maker
end

---Returns a collection of store item names
---@return string[]
function M.get_shop_item_names()
    return item_names
end

---Back to store item configuration
---@return table<string, py.ItemKey>
function M.get_item_config()
    return item_config
end

return M
