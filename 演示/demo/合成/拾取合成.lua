local M = {}

require 'clicli.tools.synthesis'
local maker = New 'Synthesis'()

---@type table<string, py.ItemKey> # Item configuration, which maps the item name to its corresponding key, e.g. {item1 = 10001}
local item_config = {}

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

--Initialize item configuration
function M.init_item_config(config)
    item_config = config
end

---Registered synthetic formula
---@param result any # Synthetic target" target"
---@param ingredients any[] # Synthetic materials {"material1", "material2", "material3"}
function M.register(result, ingredients)
    maker:register(result, ingredients)
end

--After picking up the item, determine whether it can be synthesized
function M.pick_synthesis_check()
    clicli.game:event('Items - Get', function (trg, data)
        --Store all item names of the current unit
        local item_names = {}
        for i, v in ipairs(data.unit:get_all_items():pick()) do
            table.insert(item_names, v:get_name())
        end

        --Get resultant results
        local res = maker:check(item_names)

        --If synthesizable
        if res then
            --Remove the material needed to synthesize the target from the unit
            for _, v in ipairs(res.lost) do
                local item_key = M.get_item_key_by_name(v)
                if item_key then
                    data.unit:remove_item(item_key, 1)
                end
            end

            --Add a synthesized object to the unit
            local item_key = M.get_item_key_by_name(res.get)
            if item_key then
                data.unit:add_item(item_key)
            end
        end
    end)
end

---Return maker object
---@return Synthesis # Composite processing object
function M.get_maker()
    return maker
end


return M
