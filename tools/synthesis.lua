---@class Synthesis
---@field private recipes table<any, table<any, integer>> # Record the number of occurrences of the synthetic object and its corresponding synthetic material {'target1':{'material1':2, 'material2':4}}
---@field private material_map table<any, table<any, boolean>> # Record the object object that the composition material can synthesize {'material1':{'target1':true, 'target2':true}}
---@overload fun(): self
local M = Class 'Synthesis'

function M:__init()
    ---Composite formula table
    ---@private
    self.recipes = {}
    ---Composite material dictionary
    ---@private
    self.material_map = {}
    return self
end

---Registered synthetic formula
---@param result any # Synthetic target" target"
---@param ingredients any[] # Synthetic materials {"material1", "material2", "material3"}
function M:register(result, ingredients)
    self.recipes[result] = {}
    --Record the number of times the composite material appears
    for i, v in ipairs(ingredients) do
        if self.recipes[result][v] then
            self.recipes[result][v] = self.recipes[result][v] + 1
        else
            self.recipes[result][v] = 1
        end

        --Record the object that the composite material can synthesize
        if not self.material_map[v] then
            self.material_map[v] = {}
        end
        if not self.material_map[v][result] then
            self.material_map[v][result] = true
        end
    end
end

---Get its recipe according to the item
---@param item any # item
---@return { parents: any[], children: any[] } # The synthetic material of this item {parents:{"parent1"}, children:{"child1", "child2"}}
function M:get_recipes_by_item(item)
    local result = {
        parents = {},
        children = {}
    }

    --Get the composite material for the item
    if self.recipes[item] then
        for material, cnt in pairs(self.recipes[item]) do
            for i = 1, cnt do
                table.insert(result.children, material)
            end
        end
    end

    --Gets the item that the item can synthesize
    if self.material_map[item] then
        for target, _ in pairs(self.material_map[item]) do
            table.insert(result.parents, target)
        end
    end

    return result
end

---Get the result table
---@param items_map table<any, integer> # Item count dictionary {'item1':3, 'item2':1}
---@param target any # Synthetic target
---@param cur_recipes table<any, table<any, integer>> # recipe
---@return { lost: any[], get: any } # lost material, resultant resultant {lost:{"material1", "material2"}, get:"target1"}
local function get_result(items_map, target, cur_recipes)
    local result = {
        get = target,
        lost = {}
    }
    --Subtract the corresponding amount of composite materials from the items dictionary
    for material, cnt in pairs(cur_recipes[target]) do
        items_map[material] = items_map[material] - cnt
        --At the same time, the lost composite material is added to the lost table
        for i = 1, cnt do
            table.insert(result.lost, material)
        end
    end
    return result
end

---Determine whether inventory items can be synthesized into an item
---@param items_map table<any, integer> # Item count dictionary {'item1':3, 'item2':1}
---@param target any # Synthetic target
---@param cur_recipes table<any, table<any, integer>> # recipe
---@return boolean # Whether it can be synthesized
local function check_target_synthesis(items_map, target, cur_recipes)
    for material, cnt in pairs(cur_recipes[target]) do
        --If the object does not exist in the item list, or is less than the required number of the object, it is directly judged that the object cannot be synthesized
        if not items_map[material] or items_map[material] < cnt then
            return false
        end
    end
    return true
end

---Pass in the current inventory item and check the composition
---@param items any[]? # Inventory items {"material1", "material2", "material3"}
---@return { lost: any[], get: any } | nil # The result of the composition {lost:{"material1", "material2"}, get:"target1"}
function M:check(items)
    if not items then
        return nil
    end

    --Counts the number of occurrences of different items in items and stores them in the dictionary
    local items_map = {}
    if items then
        for _, v in ipairs(items) do
            if items_map[v] then
                items_map[v] = items_map[v] + 1
            else
                items_map[v] = 1
            end
        end
    end

    --Record whether the recipe still needs to be accessed
    local is_recipe_visited = {}
    for item, cnt in pairs(items_map) do
        --Select the item that the current source can synthesize
        local targets = self.material_map[item]
        if targets then
            for target, _ in pairs(targets) do
                if not is_recipe_visited[target] then
                    --Marks the currently composable item accessed
                    is_recipe_visited[target] = true
                    --Determines whether a currently composable item can be synthesized
                    local can_synthesis = check_target_synthesis(items_map, target, self.recipes)
                    --Evaluates and returns the result table if it can be synthesized
                    if can_synthesis then
                        return get_result(items_map, target, self.recipes)
                    end
                end
            end
        end
    end

    return nil
end

---Recursive function to update the result table
---@param target any # target item "target"
---@param items_map any[] # Item collection {"material1", "material2"}
---@param cur_recipes table<any, table<any, integer>> # recipe
---@param result { needs: any[], lost: any[] } # {needs:{}, lost:{}}}
local function target_check_backtrack(target, items_map, cur_recipes, result)
    --Traverse the composition of the current item
    for material, cnt in pairs(cur_recipes[target]) do
        local need_num = 0
        local cost_num = 0
        --Count the amount of footage needed and the amount of footage consumed
        if not items_map[material] then
            need_num = cnt
            cost_num = 0
        elseif items_map[material] < cnt then
            need_num = cnt - items_map[material]
            cost_num = items_map[material]
        else
            need_num = 0
            cost_num = cnt
        end

        --Update the lost table and items dictionary
        for i = 1, cost_num do
            table.insert(result.lost, material)
            items_map[material] = items_map[material] - 1
        end
        --Determine whether the material is in the recipe table
        if not cur_recipes[material] then
            --If it is not indicated in the recipe table that it has no child material, it is directly added to the needs table
            for i = 1, need_num do
                table.insert(result.needs, material)
            end
        else
            for i = 1, need_num do
                --Recursively update the result table if there are child materials indicated in the recipe table
                target_check_backtrack(material, items_map, cur_recipes, result)
            end
        end
    end
end

---Pass in the target item and the existing item and return the result
---@param target any # target item "target"
---@param items any[]? # Item collection {"material1", "material2"}
---@return { needs: any[], lost: any[] } | nil # Materials needed to synthesize and existing materials that will be lost. {needs:{"material3"}, lost:{"material1", "material2"}}
function M:target_check(target, items)
    local result = {
        needs = {},
        lost = {}
    }

    --Return directly if the target item is not in the recipe table
    if not self.recipes[target] then
        return nil
    end

    --Counts the number of occurrences of different items in items and stores them in the dictionary
    local items_map = {}
    if items then
        for _, v in ipairs(items) do
            if items_map[v] then
                items_map[v] = items_map[v] + 1
            else
                items_map[v] = 1
            end
        end
    end

    --Update the resul table
    target_check_backtrack(target, items_map, self.recipes, result)
    return result
end

---Back to recipe list
---@return table<any, table<any, integer>> # recipe
function M:get_recipes()
    return self.recipes
end

---Returns the composite material dictionary
---@return table<any, table<any, boolean>> # Composite material dictionary
function M:get_material_map()
    return self.material_map
end
