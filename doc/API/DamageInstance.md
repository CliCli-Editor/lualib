# DamageInstance

Injury instance

Will be transmitted during injury-related events

## data

```lua
EventParam.Unit-AfterTakingDamage
```

## get_ability

```lua
(method) DamageInstance:get_ability()
  -> Ability?
```

 Acquire relevant skills
## get_attack_type

```lua
(method) DamageInstance:get_attack_type()
  -> unknown
```

## get_damage

```lua
(method) DamageInstance:get_damage()
  -> number
```

 Get current damage
## get_damage_type

```lua
(method) DamageInstance:get_damage_type()
  -> unknown
```

## is_critical

```lua
(method) DamageInstance:is_critical()
  -> boolean
```

 Gets whether the current damage is critical
## is_missed

```lua
(method) DamageInstance:is_missed()
  -> boolean
```

 Gets whether the current damage is evaded
## mode

```lua
'Before damage '|' after damage '|' when damage'
```

## origin_damage

```lua
number
```

Record the original damage
## set_critical

```lua
(method) DamageInstance:set_critical(critical: boolean)
```

 Sets whether the current damage is critical
## set_damage

```lua
(method) DamageInstance:set_damage(damage: number)
```

 Modify current damage
## set_missed

```lua
(method) DamageInstance:set_missed(missed: boolean)
```

 Sets whether to dodge the current damage

