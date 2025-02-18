# Synthesis

## check

```lua
(method) Synthesis:check(items?: any[])
  -> { lost: any[], get: any }|nil
```

Pass in the current inventory item and check the composition

@*param* `items` — Shelf item {"material1", "material2", "material3"}

@*return* — The object used as the material of synthesis, the result of synthesis {lost:{"material1", "material2"}, get:"target1"}
## get_material_map

```lua
(method) Synthesis:get_material_map()
  -> table<any, table<any, boolean>>
```

Returns the composite material dictionary

@*return* — Composite material dictionary
## get_recipes

```lua
(method) Synthesis:get_recipes()
  -> table<any, table<any, integer>>
```

Back to recipe list

@*return* — recipe
## get_recipes_by_item

```lua
(method) Synthesis:get_recipes_by_item(item: any)
  -> { parents: any[], children: any[] }
```

Get its recipe according to the item

@*param* `item` — item

@*return* — The article that can be synthesized, the synthetic material of the article {parents:{"parent1"}, children:{"child1", "child2"}}
## material_map

```lua
table<any, table<any, boolean>>
```

Record the object that the composite material can synthesize {'material1':{'target1':true, 'target2':true}}
## recipes

```lua
table<any, table<any, integer>>
```

Record the number of occurrences of the composite object and its corresponding composite material {'target1':{'material1':2, 'material2':4}}
## register

```lua
(method) Synthesis:register(result: any, ingredients: any[])
```

Registered synthetic formula

@*param* `result` — Synthetic target "target"

@*param* `ingredients` — Composite material {"material1", "material2", "material3"}
## target_check

```lua
(method) Synthesis:target_check(target: any, items?: any[])
  -> { needs: any[], lost: any[] }|nil
```

Pass in the target item and the existing item and return the result

@*param* `target` — Target item "target"

@*param* `items` — Item collection {"material1", "material2"}

@*return* — Synthesize the material that is still needed and the existing material that will be lost {needs:{"material3"}, lost:{"material1", "material2"}}

