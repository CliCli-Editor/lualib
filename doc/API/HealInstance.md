# HealInstance

Treatment instance

Transmission during treatment-related events

## data

```lua
EventParam.Unit-AfterBeingTreated
```

## get_ability

```lua
(method) HealInstance:get_ability()
  -> Ability?
```

 Acquire relevant skills
## get_heal

```lua
(method) HealInstance:get_heal()
  -> number
```

 Access to current treatment
## mode

```lua
'Before treatment '|' after treatment '|' during treatment'
```

## set_heal

```lua
(method) HealInstance:set_heal(value: number)
```

 Modify current treatment

