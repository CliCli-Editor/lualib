local shop = require 'clicli. demo. Synthesis. Shop synthesis'
local pick = require 'clicli. demo. Synthesis. Pickup synthesis'

--To implement the store purchase interface, click the store button UI (or press the Z key) to open or close the store interface
include 'clicli. demo. Synthesis. Shop interface'

--Set the player is gold attribute
clicli.player(1):set('gold', 2000)

--Store arrangement
local shop_item_config = {
    PunishmentHeavenAxe      = 134257216,
    BloodwingDemonBlade    = 134268943,
    Schizorpion      = 134233952,
    FullMoonCutlass    = 134244701,
    Gragmodont        = 134280428,
    FeatherSplitAxe      = 201390088,
    InstantBoots      = 134276637,
    DashingBoots      = 134250168,
    DemonruncherBoots      = 134257230
}

--Initialize the store configuration
shop.init_item_config(shop_item_config)

--Register store item synthesis recipes
shop.register('PunishmentHeavenAxe', {'BloodwingDemonBlade', 'Schizorpion', 'Schizorpion', 'Schizorpion'})
shop.register('InstantBoots', {'DashingBoots', 'DemonruncherBoots'})
shop.register('FeatherSplitAxe', {'PunishmentHeavenAxe', 'PunishmentHeavenAxe', 'PunishmentHeavenAxe'})

--Store item initialization
shop.init_shop_item({'PunishmentHeavenAxe', 'BloodwingDemonBlade', 'Schizorpion', 'FeatherSplitAxe', 'InstantBoots', 'DashingBoots', 'DemonruncherBoots'})

--Pick up item configuration
local pick_item_config = {
    EyeInHeavenTally      = 134245520,
    flint        = 201390023,
    DivinePowerPellet      = 201390001,
    MagicPellet      = 201390002,
    WolfBladeBreak      = 134253209
}

--Initialize the pick configuration
pick.init_item_config(pick_item_config)

--Register the pickup item synthesis recipe
pick.register('EyeInHeavenTally', {'DivinePowerPellet', 'MagicPellet'})
pick.register('DivinePowerPellet', {'WolfBladeBreak', 'WolfBladeBreak'})
pick.register('flint', {'EyeInHeavenTally', 'DivinePowerPellet'})

--Monitor whether the item is synthesized when acquired
pick.pick_synthesis_check()
