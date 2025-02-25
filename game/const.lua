--constant
---@class clicli.Const
local M = {}

---@enum clicli.Const.EaseType
M.EaseType = {
    ['ease_inCurve'] = 1,
    ['ease_outCurve'] = 2,
    ['ease_in_outCurve'] = 3,
}

M.IterKey = {
    ['ITER_INT'] = "__iter_int",
    ['ITER_INDEX'] = "__iter_index",
    ['ITER_UNIT'] = 'pick_unit_id',
    ['ITER_ITEM'] = 'item_iter',
    ['ITER_ITEM_NO'] = '__iter_item_no',
    ['ITER_ABILITY'] = "ability_iter",
    ['ITER_MODIFIER'] = "modifier_iter",
    ['ITER_PROJECTILE'] = "pick_projectile_id",
    ['ITER_TECH'] = "__tech_iter",
    ['ITER_DEST'] = "destructible_iter",
    ['ITER_SHOP_ITEM'] = "shop_item_iter",
    ['ITER_UI_COMP'] = "ui_comp_iter",
    ['ITER_RECT_AREA'] = "rect_area_iter",
    ['ITER_CIRCLE_AREA'] = "circle_area_iter",
    ['ITER_POLY_AREA'] = "polygon_area_iter",
    ['ITER_POLY_AREA_POINT'] = "poly_area_point_iter",
    ['ITER_ROAD'] = "iter_road",
    ['ITER_RANDOM_POOL'] = "random_pool_iter",
    ['ITER_ROLE'] = "role_iter",
    ['ITER_ROLE_RES'] = "__role_res_key",
    ['ITER_TABLE_ITEM'] = "__ITER_TABLE_ITEM",
}

M.UnitCategory = {
    HERO = 1,
    BUILDING = 2,
    CREATURE = 4,
}

M.PatrolType = {
    ONE_WAY = 0,
    BACK_AND_FORTH = 1,
    LOOP = 2,
}

M.UnitState = {
    ALIVE = 'Alive',
    DEAD = 'Dead',
    DISSOLVE = 'Dissolve',
}

---@enum(key) clicli.Const.UnitAttr
M.UnitAttr = {
    ['Life'] = 'hp_cur',
    ['Magic'] = 'mp_cur',
    ['MaximumLife'] = 'hp_max',
    ['LifeIsRestored'] = 'hp_rec',
    ['GreatestMagic'] = 'mp_max',
    ['MagicRecovery'] = 'mp_rec',
    ['PhysicalAttack'] = 'attack_phy',
    ['SpellAttack'] = 'attack_mag',
    ['PhysicalDefense'] = 'defense_phy',
    ['SpellDefense'] = 'defense_mag',
    ['AttackSpeed'] = 'attack_speed', --percent
    ['CoolingReduction'] = 'cd_reduce', --percent
    ['HitRate'] = 'hit_rate', --percent
    ['AvoidanceRate'] = 'dodge_rate', --percent
    ['CriticalHitRate'] = 'critical_chance', --percent
    ['CriticalHitDamage'] = 'critical_dmg', --percent
    ['PhysicalPenetration'] = 'pene_phy',
    ['SpellPenetration'] = 'pene_mag',
    ['PhysicalBloodsucking'] = 'vampire_phy', --percent
    ['SpellBloodsucking'] = 'vampire_mag', --percent
    ['PhysicalPenetrationRatio'] = 'pene_phy_ratio', --percent
    ['SpellPenetrationRatio'] = 'pene_mag_ratio', --percent
    ['InjuryRelief'] = 'dmg_reduction', --percent
    ['DamageBonus'] = 'extra_dmg', --percent
    ['HealedBonus'] = 'healing_effect', --percent
    ['MovingSpeed'] = 'ori_speed',
    ['RealVision'] = 'vision_true',
    ['AttackInterval'] = 'attack_interval',
    ['AttackRange'] = 'attack_range',
    ['DaytimeVision'] = 'vision_rng',
    ['NightVision'] = 'vision_night',
    ['DaytimeSectorRadius'] = 'vision_sector_rng',
    ['FanFieldOfViewRadiusAtNight'] = 'vision_sector_night',
    ['DaytimeFan-fieldAngle'] = 'vision_sector_angle_day',
    ['FanAngleOfViewAtNight'] = 'vision_sector_angle_night',
    ['%HealthRestored'] = 'hp_rec_percent',
}

M.UnitKeyFloatAttr = {
    ['ROTATE_SPEED'] = 'rotate_speed', --Turn speed
    ['CANCEL_ALARM_RANGE'] = 'cancel_alarm_range', --de-alert
    ['ALARM_RANGE'] = 'alarm_range', --Warning range
    ['BODY_SIZE'] = 'body_size', --Zoom
    ['CD_REDUCE'] = 'cd_reduce', --Cooling reduction
    ['VISION_RNG'] = 'vision_rng', --Field of vision
    ['HP_MAX'] = 'hp_max', --Maximum life
    ['HP_REC'] = 'hp_rec', --Life recovery
    ['MP_MAX'] = 'mp_max', --Maximum magic
    ['MP_REC'] = 'mp_rec', --Magic recovery
    ['ORI_SPEED'] = 'ori_speed', --Casting speed
    ['ATTACK_PHY'] = 'attack_phy', --Physical attack
    ['ATTACK_MAG'] = 'attack_mag', --Spell damage
    ['DEFENSE_PHY'] = 'defense_phy', --Physical defense
    ['DEFENSE_MAG'] = 'defense_mag', --Spell defense
    ['ATTACK_SPEED'] = 'attack_speed', --Attack speed
    ['CRITICAL_CHANCE'] = 'critical_chance', --Critical Hit Chance
    ['CRITICAL_DMG'] = 'critical_dmg', --Critical hit damage
    ['PENE_PHY'] = 'pene_phy', --Physical penetration
    ['PENE_MAG'] = 'pene_mag', --Spell penetration
    ['VAMPIRE_PHY'] = 'vampire_phy', --Physical blood feeding
    ['VAMPIRE_MAG'] = 'vampire_mag', --Spell sucking
    ['PENE_PHY_RATIO'] = 'pene_phy_ratio', --Physical penetration
    ['PENE_MAG_RATIO'] = 'pene_mag_ratio', --Spell penetration
    ['DMG_REDUCTION'] = 'dmg_reduction', --Injury relief
    ['HIT_RATE'] = 'hit_rate', --Hit rate
    ['DODGE_RATE'] = 'dodge_rate', --Dodge rate
    ['ATTACK_RANGE'] = 'attack_range', --Atk SPD
}

---@enum(key) clicli.Const.UnitAttrType
M.UnitAttrType = {
    ["Foundation"] = "ATTR_BASE",
    ["BaseBonus"] = "ATTR_BASE_RATIO", --percent
    ["Gain"] = "ATTR_BONUS",
    ["GainBonus"] = "ATTR_BONUS_RATIO", --percent
    ["FinalMarkup"] = "ATTR_ALL_RATIO", --percent
}

---@enum(key) clicli.Const.UnitEnumState
M.UnitEnumState = {
    ["NoGeneralAttack"] = 1 << 1,
    ["DoNotCastSpells"] = 1 << 2,
    ["DoNotMove"] = 1 << 3,
    ["NoTurning"] = 1 << 4,
    ["AnimationFrame"] = 1 << 5,
    ["UnableToExertMotion"] = 1 << 6,
    ["CannotBeLockedBySkillIndicator"] = 1 << 7,
    ["CannotBeSelected"] = 1 << 8,
    ["Invisible"] = 1 << 9,
    ["IgnoreStaticCollisions"] = 1 << 10,
    ["IgnoreDynamicCollisions"] = 1 << 11,
    ["WillNotDie"] = 1 << 12,
    ["Invincible"] = 1 << 13,
    ["OutOfControl"] = 1 << 14,
    ["Can'tBeAttacked"] = 1 << 15,
    ["aiIgnores"] = 1 << 16,
    ["PhysicalDamageImmunity"] = 1 << 17,
    ["MagicDamageImmunity"] = 1 << 18,
    ["ImmunityToNegativeMagicEffects"] = 1 << 19,
    ["Hide"] = 1 << 20,
    ["CannotBeSelectedByTheFilter"] = 1 << 21,
    ["RealDamageImmunity"] = 1 << 22,
    ["NoProps"] = 1 << 23,
}

---@enum(key) clicli.Const.PlayerAttr
M.PlayerAttr = {}

M.ModifyType = {
    ADD = 0,
    SUB = 1,
    SET = 2,
}

---@alias clicli.Const.DamageType
---| 'Physics'
---| 'Spells'
---| 'Real'

M.DamageTypeMap = {
    ['Physics'] = 0,
    ['Magic'] = 1,
    ['Real'] = 2,
}

---@enum clicli.Const.DMGType
M.DMGType = {
    PHY = 0,
    MAG = 1,
    REAL = 2,
}

M.AbilityCategory = {
    COMMON_ATK = 1,
    COMMON_ABILITY = 2,
    HERO_ABILITY = 3,
    PASSIVE_ABILITY = 0,
}

---@alias clicli.Const.AbilityTypeAlias
---| 'hidden'
---| 'Ordinary'
---| 'Command'
---| 'Heroes'

---@enum clicli.Const.AbilityType
M.AbilityType = {
   HIDE    = 0,
   NORMAL  = 1,
   COMMON  = 2,
   HERO    = 3,
   ['Hide'] = 0,
   ['Ordinary'] = 1,
   ['Command'] = 2,
   ['Hero'] = 3,
}

M.AbilityCastType = {
    COMMON_ATK = 1,
    ACTIVE_ABILITY = 2,
    PASSIVE_ABILITY = 3,
    BUILDING_ABILITY = 4,
    PICK_ABILITY = 6,
}

---@enum clicli.Const.AbilityIndex
M.AbilityIndex = {
    ['PASSIVE'] = 0,
    ['MOVE'] = 1,
    ['COMMON_ATK'] = 2,
    ['ABILITY1'] = 3,
    ['ABILITY2'] = 4,
    ['ABILITY3'] = 5,
    ['ABILITY4'] = 6,
    ['ABILITY5'] = 7,
    ['ABILITY6'] = 8,
    ['ABILITY7'] = 9,
    ['ABILITY8'] = 10,
    ['ABILITY9'] = 11,
    ['ABILITY10'] = 12,
    ['ABILITY11'] = 13,
    ['ABILITY12'] = 14,
}

---@enum clicli.Const.RoleType
M.RoleType = {
    NONE = 0,
    USER = 1,
    COMPUTER = 2,
    AI_EASY = 5,
    AI_HARD = 6,
    OBSERVER = 10,
}

---@enum clicli.Const.RoleStatus
M.RoleStatus = {
    ['PLAYING'] = 1,
    ['NONE'] = 2,
    ['LOST'] = 3,
    ['LEFT'] = 4,
    ['WATCHING'] = 5,
}

M.MovementObstacleProcessType = {
    ['IGNORE_OBSTACLE'] = 1,
    ['NOT_THROUGH'] = 2,
    ['POINT_BEFORE'] = 4,
    ['POINT_BEHIND'] = 8,
    ['POINT_MIDDLE'] = 16,
}

---@enum(key) clicli.Const.MouseKey
M.MouseKey = {
    LEFT = 0xF0, --Left button
    RIGHT = 0xF1, --Right button
    MIDDLE = 0xF2, --Middle key
    WHEEL_UP = 0xF3, --overroll
    WHEEL_DOWN = 0xF4, --Roll down
}

---@enum(key) clicli.Const.KeyboardKey
M.KeyboardKey = {
    ['NONE'] = 0x00,
    ['ESCAPE'] = 0x01, --ESC
    ['KEY_1'] = 0x02, --one
    ['KEY_2'] = 0x03, --2
    ['KEY_3'] = 0x04, --3
    ['KEY_4'] = 0x05, --4
    ['KEY_5'] = 0x06, --5
    ['KEY_6'] = 0x07, --6
    ['KEY_7'] = 0x08, --7
    ['KEY_8'] = 0x09, --8
    ['KEY_9'] = 0x0A, --9
    ['KEY_0'] = 0x0B, --0
    ['MINUS'] = 0x0C, ---
    ['EQUAL'] = 0x0D, --=
    ['BACKSPACE'] = 0x0E, --Backspace
    ['TAB'] = 0x0F, --Tab
    ['Q'] = 0x10, --Q
    ['W'] = 0x11, --W
    ['E'] = 0x12, --E
    ['R'] = 0x13, --R
    ['T'] = 0x14, --T
    ['Y'] = 0x15, --Y
    ['U'] = 0x16, --U
    ['I'] = 0x17, --I
    ['O'] = 0x18, --O
    ['P'] = 0x19, --P
    ['LBRACKET'] = 0x1A, --[
    ['RBRACKET'] = 0x1B, --]
    ['RETURN'] = 0x1C, --Enter
    ['ENTER'] = 0x1C, --Enter
    ['LCTRL'] = 0x1D, --Left Ctrl
    ['A'] = 0x1E, --A
    ['S'] = 0x1F, --S
    ['D'] = 0x20, --D
    ['F'] = 0x21, --F
    ['G'] = 0x22, --G
    ['H'] = 0x23, --H
    ['J'] = 0x24, --J
    ['K'] = 0x25, --K
    ['L'] = 0x26, --L
    ['SEMICOLON'] = 0x27, --;
    ['APOSTROPHE'] = 0x28, --'
    ['GRAVE'] = 0x29, --`
    ['LSHIFT'] = 0x2A, --Left Shift
    ['BACKSLASH'] = 0x2B, --\
    ['Z'] = 0x2C, --Z
    ['X'] = 0x2D, --X
    ['C'] = 0x2E, --C
    ['V'] = 0x2F, --V
    ['B'] = 0x30, --B
    ['N'] = 0x31, --N
    ['M'] = 0x32, --M
    ['COMMA'] = 0x33, --,
    ['PERIOD'] = 0x34, --.
    ['SLASH'] = 0x35, --/
    ['RSHIFT'] = 0x36, --Right Shift
    ['NUM_STAR'] = 0x37, --Keypad *
    ['LALT'] = 0x38, --Left Alt
    ['SPACE'] = 0x39, --Space
    ['CAPSLOCK'] = 0x3A, --CAPSLOCK
    ['F1'] = 0x3B, --F1
    ['F2'] = 0x3C, --F2
    ['F3'] = 0x3D, --F3
    ['F4'] = 0x3E, --F4
    ['F5'] = 0x3F, --F5
    ['F6'] = 0x40, --F6
    ['F7'] = 0x41, --F7
    ['F8'] = 0x42, --F8
    ['F9'] = 0x43, --F9
    ['F10'] = 0x44, --F10
    ['PAUSE'] = 0x45, --Pause
    ['SCROLL_LOCK'] = 0x46, --Scroll Lock
    ['NUM_7'] = 0x47, --Keypad 7
    ['NUM_8'] = 0x48, --Keypad 8
    ['NUM_9'] = 0x49, --Keypad 9
    ['NUM_MINUS'] = 0x4A, --Keypad -
    ['NUM_4'] = 0x4B, --Keypad 4
    ['NUM_5'] = 0x4C, --Keypad 5
    ['NUM_6'] = 0x4D, --Keypad 6
    ['NUM_ADD'] = 0x4E, --Keypad +
    ['NUM_1'] = 0x4F, --Keypad 1
    ['NUM_2'] = 0x50, --Keypad 2
    ['NUM_3'] = 0x51, --Keypad 3
    ['NUM_0'] = 0x52, --Keypad 0
    ['NUM_PERIOD'] = 0x53, --A small keyboard.
    ['F11'] = 0x57, --F11
    ['F12'] = 0x58, --F12
    ['NUM_ENTER'] = 0x9C, --Keypad Enter
    ['RCTRL'] = 0x9D, --Right Ctrl
    ['NUM_COMMA'] = 0xB3, --Small keyboard,
    ['NUM_SLASH'] = 0xB5, --Keypad /
    ['SYSRQ'] = 0xB7, --System restart
    ['R_ALT'] = 0xB8, --Right Alt
    ['NUM_LOCK'] = 0xC5, --NumLock
    ['HOME'] = 0xC7, --Home
    ['UPARROW'] = 0xC8, --write
    ['PAGEUP'] = 0xC9, --PageUp
    ['LEFTARROW'] = 0xCB, --please
    ['RIGHTARROW'] = 0xCD, ---
    ['END'] = 0xCF, --End
    ['DOWNARROW'] = 0xD0, --left
    ['PAGEDOWN'] = 0xD1, --PageDown
    ['INSERT'] = 0xD2, --Insert
    ['DELETE'] = 0xD3, --Delete
    ['LWIN'] = 0xDB, --Left Win
    ['RWIN'] = 0xDC, --Right Win
    ['APPS'] = 0xDD, --Apply
}

M.GameResult = {
    ['VICTORY'] = 'victory',
    ['DEFEAT'] = 'defeat',
    ['NEUTRAL'] = 'neutral',
}

M.AreaAction = {
    ['ENTER'] = 1,
    ['LEAVE'] = 0,
}

M.StateAction = {
    ['ADD'] = true,
    ['REM'] = false,
}

M.OnOff = {
    ['ON'] = true,
    ['OFF'] = false,
}

M.OnceRecycle = {
    ['ONCE'] = true,
    ['RECYCLE'] = false,
}

---@enum(key) clicli.Const.VisibleType
M.VisibleType = {
    ['All'] = 1,
    ['Myself'] = 2,
    ['FriendlySide'] = 3,
    ['Enemy'] = 4,
}

---@enum clicli.Const.LinkSfxPointType
M.LinkSfxPointType = {
    ['START'] = 1,
    ['END'] = 2,
}

---@enum(key) clicli.Const.SfxRotateType
M.SfxRotateType = {
    ['FollowNode'] = 0,
    ['FollowTheModel'] = 1,
    ['DoNotFollow'] = 2,
}

---@enum clicli.Const.SlotType
M.SlotType = {
    ['NOT_IN_BAG'] = -1,
    ['PKG'] = 0,
    ['BAR'] = 1,
}

---@alias clicli.Const.ShiftSlotTypeAlias
---| 'Inventory'
---| 'Backpack bar'

---@enum clicli.Const.ShiftSlotType
M.ShiftSlotType = {
    ['Inventory'] = 1,
    ['BackpackBar'] = 0,
}

---@enum clicli.Const.EffectType
M.ModifierEffectType = {
    ['NONE'] = 0,
    ['NORMAL'] = 1,
    ['POSITIVE'] = 2,
    ['NEGATIVE'] = 3,
}

---@enum clicli.Const.ModifierType
M.ModifierType = {
    ['NONE'] = 0,
    ['NORMAL'] = 1,
    ['HALO'] = 2,
    ['HALO_EFFECT'] = 3,
    ['SHIELD'] = 4,
}

---@enum clicli.Const.AbilityPointerType
M.AbilityPointerType = {
    ['NONE'] = 0,
    ['SECTOR'] = 1,
    ['ARROW'] = 2,
    ['DOUBLE_CIRCLE'] = 3,
    ['TARGET'] = 4,
    ['LOCATION'] = 5,
    ['BUILD'] = 6,
    ['VECTOR'] = 7,
}

M.DialogDebugType = {
    ['ERROR'] = 1,
    ['WARNING'] = 2,
    ['INFO'] = 3,
}

---@enum(key) clicli.Const.CameraMoveMode
M.CameraMoveMode = {
    ['ACC'] = 1,
    ['SMOOTH'] = 0,
    ['DEC'] = 2,
    ['UniformSpeed'] = 0,
    ['UniformAcceleration'] = 1,
    ['UniformDeceleration'] = 2,
}

M.CameraShakeMode = {
    ['LEFT_RIGHT'] = 1,
    ['UP_DOWN'] = 2,
    ['FORWARD_BACKWARD'] = 4,
    ['LR_UD'] = 3,
    ['LR_FB'] = 5,
    ['UD_FB'] = 6,
    ['LR_UD_FB'] = 7,
}

---@enum(key) clicli.Const.SignalType
M.SignalType = {
    ['Ordinary'] = 1,
    ['Yellow'] = 2,
    ['Blue'] = 3,
}

---@enum clicli.Const.GlobalEventType
M.GlobalEventType = {
    ['GAME_INIT'] = "ET_GAME_INIT",
    ['GAME_PAUSE'] = "ET_GAME_PAUSE",
    ['GAME_RESUME'] = "ET_GAME_RESUME",
    ['GAME_ELAPSE_ONCE'] = "ET_TIMEOUT",
    ['GAME_ELAPSE_REPEAT'] = "ET_REPEAT_TIMEOUT",
    ['BUILD_SUCCESS'] = "ET_ABILITY_BUILD_FINISH",
    ['START_SKILL_POINTER'] = "ET_START_SKILL_POINTER",
    ['STOP_SKILL_POINTER'] = "ET_STOP_SKILL_POINTER",
    ['CUSTOM_EVENT'] = "ET_EVENT_CUSTOM",
    ['UI_EVENT'] = "ET_TRIGGER_COMPONENT_EVENT",
    ['UNIT_ATTR_CHANGE'] = "ET_UNIT_ATTR_CHANGE",
    ['UNIT_START_NAVI'] = "ET_UNIT_START_NAV_EVENT",
    ['UNIT_END_NAVI'] = "ET_UNIT_END_NAV_EVENT",
    ['ITEM_BROKEN'] = "ET_ITEM_BROKEN",
    ['ITEM_SOLD'] = "ET_ITEM_SOLD",
    ['AREA_ENTER'] = "ET_AREA_ENTER",
    ['AREA_LEAVE'] = "ET_AREA_LEAVE",
    ['UNIT_PRECONDITION_MEET'] = "ET_UNIT_PRECONDITION_SUCCEED",
    ['UNIT_PRECONDITION_FAILED'] = "ET_UNIT_PRECONDITION_FAILED",
    ['ITEM_PRECONDITION_MEET'] = "ET_ITEM_PRECONDITION_SUCCEED",
    ['ITEM_PRECONDITION_FAILED'] = "ET_ITEM_PRECONDITION_FAILED",
    ['ABILITY_PRECONDITION_MEET'] = "ET_ABILITY_PRECONDITION_SUCCEED",
    ['ABILITY_PRECONDITION_FAILED'] = "ET_ABILITY_PRECONDITION_FAILED",
    ['TECH_PRECONDITION_MEET'] = "ET_TECH_PRECONDITION_SUCCEED",
    ['TECH_PRECONDITION_FAILED'] = "ET_TECH_PRECONDITION_FAILED",
    ['KEYBOARD_DOWN'] = "ET_KEYBOARD_KEY_DOWN_EVENT",
    ['KEYBOARD_UP'] = "ET_KEYBOARD_KEY_UP_EVENT",
    ['MOUSE_DOWN'] = "ET_MOUSE_KEY_DOWN_EVENT",
    ['MOUSE_UP'] = "ET_MOUSE_KEY_UP_EVENT",
    ['MOUSE_D_CLICK'] = "MOUSE_KEY_DB_CLICK_EVENT",
    ['MOUSE_MOVE'] = "MOUSE_MOVE_EVENT",
    ['MOUSE_WHEEL'] = "ET_MOUSE_WHEEL_EVENT",
    ['MOUSE_DOWN_UNIT'] = "MOUSE_KEY_DOWN_UNIT_EVENT",
    ['MOUSE_UP_UNIT'] = "MOUSE_KEY_UP_UNIT_EVENT",
    ['MOUSE_D_CLICK_UNIT'] = "MOUSE_KEY_DB_CLICK_UNIT_EVENT",
    ['MOUSE_HOVER'] = "ET_MOUSE_HOVER_EVENT",
    ['SELECT_UNIT'] = "ET_SELECT_UNIT",
    ['SELECT_UNIT_GROUP'] = "ET_SELECT_UNIT_GROUP",
    ['SELECT_ITEM'] = "ET_SELECT_ITEM",
    ['D_CLICK_ITEM'] = "ET_DOUBLE_CLICK_ITEM",
    ['SELECT_DEST'] = "ET_SELECT_DEST",
    ['D_CLICK_DEST'] = "ET_DOUBLE_CLICK_DEST",
    ['PLAYER_JOIN'] = "ET_ROLE_JOIN_BATTLE",
    ['PLAYER_EXIT'] = "ET_ROLE_ACTIVE_EXIT_GAME_EVENT",
    ['PLAYER_LOSE_CONNECT'] = "ET_ROLE_LOSE_CONNECT",
    ['PLAYER_RESOURCE_CHANGED'] = "ET_ROLE_RESOURCE_CHANGED",
    ['PLAYER_SEND_STRING'] = "ET_ROLE_INPUT_MSG",
    ['PLAYER_SEND_ANY'] = "ET_CHAT_SEND_GM",
    ['PLAYER_UPGRADE_TECH'] = "ET_ROLE_TECH_UPGRADE",
    ['PLAYER_DOWNGRADE_TECH'] = "ET_ROLE_TECH_DOWNGRADE",
    ['PLAYER_CHANGE_TECH'] = "ET_ROLE_TECH_CHANGED",
}

---@enum clicli.Const.UIEventType
M.UIEventType = {
    ['UI_CREATE'] = "ET_UI_PREFAB_CREATE_EVENT",
    ['UI_DELETE'] = "ET_UI_PREFAB_DEL_EVENT",
}

---@enum clicli.Const.UnitEventType
M.UnitEventType = {
    ['BEFORE_UNIT_DIE'] = "ET_BEFORE_UNIT_DIE",
    ['UNIT_DIE'] = "ET_UNIT_DIE",
    ['KILL_UNIT'] = "ET_KILL_UNIT",
    ['UNIT_BORN'] = "ET_UNIT_BORN",
    ['REVIVE_UNIT'] = "ET_REVIVE_UNIT",
    ['UPGRADE_UNIT'] = "ET_UPGRADE_UNIT",
    ['UNIT_PRE_ADD_EXP'] = "ET_UNIT_PRE_ADD_EXP",
    ['UNIT_ON_ADD_EXP'] = "ET_UNIT_ON_ADD_EXP",
    ['UNIT_BE_HURT'] = "ET_UNIT_BE_HURT",
    ['UNIT_HURT_OTHER'] = "ET_UNIT_HURT_OTHER",
    ['UNIT_BE_HURT_BEFORE_APPLY'] = "ET_UNIT_BE_HURT_BEFORE_APPLY",
    ['UNIT_HURT_OTHER_BEFORE_APPLY'] = "ET_UNIT_HURT_OTHER_BEFORE_APPLY",
    ['UNIT_BE_HURT_COMPLETE'] = "ET_UNIT_BE_HURT_COMPLETE",
    ['UNIT_HURT_OTHER_COMPLETE'] = "ET_UNIT_HURT_OTHER_FINISH",
    ['UNIT_GET_CURE_BEFORE_APPLY'] = "ET_UNIT_GET_CURE_BEFORE_APPLY",
    ['UNIT_GET_CURE_FINISH'] = "ET_UNIT_GET_CURE_FINISH",
    ['UNIT_GET_CURE'] = "ET_UNIT_GET_CURE",
    ['UNIT_RELEASE_ABILITY'] = "ET_UNIT_RELEASE_ABILITY",
    ['UNIT_START_MOVE'] = "ET_UNIT_START_MOVE",
    ['UNIT_ENTER_BATTLE'] = "ET_UNIT_ENTER_BATTLE",
    ['UNIT_EXIT_BATTLE'] = "ET_UNIT_EXIT_BATTLE",
    ['UNIT_ENTER_GRASS'] = "ET_UNIT_ENTER_GRASS",
    ['UNIT_LEAVE_GRASS'] = "ET_UNIT_LEAVE_GRASS",
    ['UNIT_ON_COMMAND'] = "ET_UNIT_ON_COMMAND",
    ['UNIT_ABILITY_UPGRADE'] = "ET_ABILITY_PLUS_POINT",
    ['UNIT_REMOVE'] = "ET_UNIT_REMOVE",
    ['UNIT_SHOP_BUY_UNIT'] = "ET_UNIT_SHOP_BUY_UNIT",
    ['UNIT_SHOP_BUY_ITEM'] = "ET_UNIT_SHOP_BUY_ITEM",
    ['UNIT_ITEM_SELL'] = "ET_UNIT_ITEM_SELL",
    ['UNIT_ITEM_COMPOSE'] = "ET_UNIT_ITEM_COMPOSE",
    ['UNIT_SHOP_BUY_WITH_COMPOSE'] = "ET_UNIT_SHOP_BUY_WITH_COMPOSE",
    ['UNIT_UPGRADE_TECH'] = "ET_UNIT_UPGRADE_TECH",
    ['UNIT_ADD_TECH'] = "ET_UNIT_ADD_TECH",
    ['UNIT_REMOVE_TECH'] = "ET_UNIT_REMOVE_TECH",
    ['UNIT_ROLE_CHANGED'] = "ET_UNIT_ROLE_CHANGED",
}

---@enum clicli.Const.ItemEventType
M.ItemEventType = {
    ['ITEM_CREATE'] = "ET_ITEM_ON_CREATE",
    ['ITEM_ADD'] = "ET_UNIT_ADD_ITEM",
    ['ITEM_ADD_TO_PKG'] = "ET_UNIT_ADD_ITEM_TO_PKG",
    ['ITEM_ADD_TO_BAR'] = 'ET_UNIT_ADD_ITEM_TO_BAR',
    ['ITEM_REMOVE'] = 'ET_UNIT_REMOVE_ITEM',
    ['ITEM_REMOVE_FROM_PKG'] = 'ET_UNIT_REMOVE_ITEM_FROM_PKG',
    ['ITEM_REMOVE_FROM_BAR'] = 'ET_UNIT_REMOVE_ITEM_FROM_BAR',
    ['ITEM_USE'] = 'ET_UNIT_USE_ITEM',
    ['ITEM_CHANGE_STACK'] = "ET_ITEM_STACK_CHANGED",
    ['ITEM_CHANGE_CHARGE'] = "ET_ITEM_CHARGE_CHANGED",
    ['ITEM_DESTROY'] = "ET_ITEM_ON_DESTROY",
    ['ITEM_CREATE_ON_DEST_COLLECTED'] = "ET_ITEM_CREATE_ON_DEST_COLLECTED",
}

---@enum clicli.Const.AbilityEventType
M.AbilityEventType = {
    ['ABILITY_CS_START'] = "ET_ABILITY_CS_START",
    ['ABILITY_PS_START'] = "ET_ABILITY_PS_START",
    ['ABILITY_PS_END'] = "ET_ABILITY_PS_END",
    ['ABILITY_SP_END'] = "ET_ABILITY_SP_END",
    ['ABILITY_CST_END'] = "ET_ABILITY_CST_END",
    ['ABILITY_BS_END'] = "ET_ABILITY_BS_END",
    ['ABILITY_PS_INTERRUPT'] = "ET_ABILITY_PS_INTERRUPT",
    ['ABILITY_SP_INTERRUPT'] = "ET_ABILITY_SP_INTERRUPT",
    ['ABILITY_CST_INTERRUPT'] = "ET_ABILITY_CST_INTERRUPT",
    ['ABILITY_END'] = "ET_ABILITY_END",
    ['ABILITY_OBTAIN'] = "ET_ABILITY_OBTAIN",
    ['ABILITY_LOSE'] = "ET_ABILITY_LOSE",
    ['ABILITY_UPGRADE'] = "ET_ABILITY_PLUS_POINT",
    ['ABILITY_LEVEL_CHANGED'] = "ET_ABILITY_UPGRADE",
    ['ABILITY_CD_END'] = "ET_ABILITY_CD_END",
    ['ABILITY_SWITCH'] = "ET_ABILITY_SWITCH",
}

---@enum clicli.Const.ModifierEventType
M.ModifierEventType = {
    ['OBTAIN_MODIFIER'] = "ET_OBTAIN_MODIFIER",
    ['LOSS_MODIFIER'] = "ET_LOSS_MODIFIER",
    ['MODIFIER_CYCLE_TRIGGER'] = "ET_MODIFIER_CYCLE_TRIGGER",
    ['MODIFIER_LAYER_CHANGE'] = "ET_MODIFIER_LAYER_CHANGE",
    ['MODIFIER_GET_BEFORE_CREATE'] = "ET_MODIFIER_GET_BEFORE_CREATE",
    ['MODIFIER_BE_COVERED'] = "ET_MODIFIER_BE_COVERED",
    ['MODIFIER_ADDTION'] = "ET_MODIFIER_ADDTION",
}

---@enum clicli.Const.ProjectileEventType
M.ProjectileEventType = {
    ['PROJECTILE_PRODUCE'] = "ET_PRODUCE_PROJECTILE",
    ['PROJECTILE_END'] = "ET_DEATH_PROJECTILE",
}

---@enum clicli.Const.PlatformEventType
M.PlatformEventType = {
    ['HOLD_STORE_ITEM'] = "ET_ROLE_HOLD_STORE_ITEM",
    ['USE_STORE_ITEM_END'] = "ET_ROLE_USE_STORE_ITEM_END",
}

---@enum clicli.Const.DestructibleEventType
M.DestructibleEventType = {
    ['DEST_CREATE'] = "ET_DEST_CREATE_NEW",
    ['DEST_DIE'] = "ET_DEST_DIE_NEW",
    ['DEST_REVIVE'] = "ET_DEST_REVIVE_NEW",
    ['DEST_RES_CNT_CHG'] = "ET_DEST_RES_CNT_CHG_NEW",
    ['DEST_COLLECTED'] = "ET_DEST_COLLECTED_NEW",
    ['DEST_GET_HURT'] = "ET_GET_HURT_NEW",
    ['DEST_DELETE'] = "ET_DEST_DELETE",
}

---@alias clicli.Const.UIEvent
---| 'Left - press down'
---| 'Left - lift'
---| 'Left-click'
---| 'Left-double-click'
---| 'Mouse-hover'
---| 'Mouse - move in'
---| 'Mouse - move out'
---| 'Mouse - right click'
---| 'Right click - press down'
---| 'Right-click - lift'
---| 'Right - click'
---| 'Right-click - double-click'

M.UIEventMap = {
    --The old
    ['Empty']       = -1,
    ['Click-start'] = 1,
    ['Click-end'] = 2,
    ['Click-continue'] = 3,
    ['Mouse-DoubleClick'] = 22,
    --[' mouse-hover '] = 23,
    --[' Mouse - move in '] = 24,
    --[' Mouse - move out '] = 25,
    ['Mouse-RightClick'] = 26,
    --new
    ['Left-PressDown'] = 1,
    ['Left-click-Lift'] = 2,
    ['LeftButton-HoldDown'] = 3,
    ['Left-Click'] = 30,
    ['Left-click-DoubleClick'] = 22,
    ['Mouse-hover'] = 23,
    ['Mouse-MoveIn'] = 24,
    ['Mouse-MoveOut'] = 25,
    ['Right-PressDown'] = 32,
    ['Right-Lift'] = 33,
    ['RightClick-Hold'] = 34,
    ['Right-Click'] = 34,
    ['Right-DoubleClick'] = 35,
}

---@alias clicli.Const.DamageTextType
---| 'get_gold' # gets gold coins
---| 'heal' # heal
---| 'magic' # spells
---| 'physics' # Physics
---| 'real' # real

---@alias clicli.Const.UIComponentType
---| 'Articles'
---| 'Button'
---| 'Rich text'
---| 'Text'
---| 'Pictures'
---| 'Progress bar'
---| 'Model'
---| 'empty node'
---| 'TAB pages'
---| 'Settings'
---| 'List'
---| 'Sliders'
---| 'Chat'
---| 'Rotograph'
---| 'Voice switch'
---| 'Input field'
---| 'Map'
---| 'Skills Button'
---| 'Magic Effects'
---| 'Sequence frames'
---| 'Special Effects'

M.UIComponentType = {
    Node = 0,
    Button = 1,
    ['Button'] = 1,
    Layer = 2,
    TextLabel = 3,
    ['Text'] = 3,
    Image = 4,
    ['Picture'] = 4,
    Progress = 5,
    ['ProgressBar'] = 5,
    Model = 6,
    ['Model'] = 6,
    Layout = 7,
    ['EmptyNode'] = 7,
    TabWidget = 8,
    ['Tab'] = 8,
    TabPage = 9,
    ScrollView = 10,
    ['List'] = 10,
    Slider = 11,
    ['Slider'] = 11,
    Background = 14,
    InputField = 15,
    ['InputBox'] = 15,
    MiniMap = 16,
    ['Map'] = 16,
    SkillBtn = 17,
    ['SkillButton'] = 17,
    BuffList = 18,
    ['MagicEffect'] = 18,
    BuffItem = 19,
    EquipSlot = 20,
    ['Article'] = 20,
    ShopPanel = 21,
    GoodsItem = 22,
    ComposePanel = 23,
    ChatBox = 24,
    GridView = 25,
    RichText = 26,
    ['RichText'] = 26,
    SettingPanel = 27,
    ['Settings'] = 27,
    --timeline project animation
    AnimationEffect = 28,
    ComboBox = 29,
    ComboBoxItem = 30,
    --Sequence frame animation
    SequenceAnimation = 31,
    --New Chat
    NewChatBox = 32,
    ['Chat'] = 32,
    PageView = 33,
    ['Carousel'] = 33,
    AudioSwitch = 34,
    ['VoiceSwitch'] = 34,
    --spine animation
    Spine = 35,
    --New sequence frame animation component
    NewSequenceAnimation = 38,
    ['SequenceFrame'] = 38,
    ['SpecialEffects'] = 49,
}

---@alias clicli.Const.UIVAlignmentType
---| 'up'
---| 'middle'
---| 'down'

M.UIVAlignmentType = {
    ['Up'] = 0,
    ['Middle'] = 8,
    ['Down'] = 16,
}

---@alias clicli.Const.UIHAlignmentType
---| 'Left'
---| 'middle'
---| 'Right'

M.UIHAlignmentType = {
    ['Left'] = 1,
    ['Middle'] = 2,
    ['Right'] = 4,
}

---@alias clicli.Const.CursorState
---| 'Normal suspension'
---| 'Normal selection'
---| 'Normally disabled'
---| 'Enemy building unit suspended'
---| 'Enemy non-construction units suspended'
---| 'Enemy Building Unit Selection'
---| 'Enemy non-building unit Selection'
---| 'Own building unit suspended'
---| 'Own non-construction unit suspension'
---| 'Choose your own building unit'
---| 'Choose your own non-building unit'
---| 'Friendly building unit suspension'
---| 'Friendly non-construction Unit suspension'
---| 'Choose a Friendly Building Unit'
---| 'Friendly non-building unit Selection'

M.CursorState = {
    ['NormalSuspension'] = 'nm_hover',
    ['NormalSelection'] = 'nm_selected',
    ['NormalDisabled'] = 'nm_disabled',
    ['EnemyBuildingUnitsAreSuspended'] = 'e_b_u_hover',
    ['EnemyNon-constructionUnitsSuspended'] = 'e_nb_u_hover',
    ['EnemyBuildingUnitSelection'] = 'e_b_u_selected',
    ['EnemyNon-buildingUnitSelection'] = 'e_nb_u_selected',
    ['OwnBuildingUnitSuspended'] = 'o_b_u_hover',
    ['OwnNon-constructionUnitSuspended'] = 'o_nb_u_hover',
    ['OwnBuildingUnitSelection'] = 'o_b_u_selected',
    ['OwnNon-constructionUnitSelection'] = 'o_nb_u_selected',
    ['FriendlyBuildingUnitSuspended'] = 'f_b_u_hover',
    ['FriendlyNon-constructionUnitSuspension'] = 'f_nb_u_hover',
    ['FriendlyBuildingUnitSelection'] = 'f_b_u_selected',
    ['FriendlyNon-constructionUnitSelection'] = 'f_nb_u_selected',
}

---@enum(key) clicli.Const.HarmTextType
M.HarmTextType = {
    ['SystemFont'] = 0,
    ['PhysicalDamage'] = 1,
    ['PhysicalCriticalStrike'] = 2,
    ['Treatment'] = 3,
    ['MagicDamage'] = 4,
    ['MagicCriticalStrike'] = 5,
    ['RealInjury'] = 6,
    ['GoldAcquisition'] = 7,
    ['WarcraftGetsGold'] = 90,
    ['WarcraftGetsWood'] = 91,
    ['Taunt'] = 113,
    ['Silence'] = 114,
    ['Fixed'] = 115,
    ['SlowDown'] = 116,
    ['Dizzy'] = 117,
    ['Blinding'] = 118,
}

---@enum(key) clicli.Const.FloatTextType
M.FloatTextType = {
    ['PhysicalDamage'] = 'physics',
    ['MagicDamage'] = 'magic',
    ['RealInjury'] = 'real',
    ['Treatment'] = 'heal',
    ['GetGold'] = 'get_gold',
    ['SystemFont'] = 0,
    --
    ['MicrosoftYahei'] = 'MSYH',
    ['HuakangBlackBodyW9'] = 'HKHeiW9',
    ['HuakangBlackBodyW12'] = 'HKHeiW12',
    ['HuaKangTitleSongW9'] = 'HKSongW9',
    ['HuaKangWeiSteleW7'] = 'HKWeiBeiW7',
    ['HuakangNewVarietyStyleW7'] = 'HKXinZongYiW7',
    ['HuakangNewVarietyStyleW9'] = 'HKXinZongYiW9',
    ['HuakangRoundBodyW5'] = 'HKYuanW5',
    ['HuakangRoundBodyW7'] = 'HKYuanW7',
    ['HuakangRoundBodyW9'] = 'HKYuanW9',
}

---@enum(key) clicli.Const.FloatTextJumpType
M.FloatTextJumpType = {
    ['Injury_TopLeft'] = 934231441,
    ['Hurt_MiddleUp'] = 934269508,
    ['Damage_TopRight'] = 934266669,
    ['Injury_LowerLeft'] = 934252831,
    ['GoldCoinJump'] = 934277693,
}

---@enum(key) clicli.Const.UIAnimKey
M.UIAnimKey = {}

---@alias clicli.Const.UIRelativeParentPosType
---| 'Top'
---| 'Bottom'
---| 'Left side'
---| 'Right side'

M.UIRelativeParentPosType = {
    ["Top"] = 0,
    ["Bottom"] = 1,
    ["LeftSide"] = 2,
    ["RightSide"] = 3,
}

---@enum clicli.Const.UIButtonStatus
M.UIButtonStatus = {
    ['Normal'] = 1,
    ['Suspension'] = 2,
    ['PressDown'] = 3,
    ['Disable'] = 4,
}

---@enum (key) clicli.Const.UIAttr
M.UIAttr = {
    ["Text"] = "text_bind",
    ["MaximumValue"] = "max_value_bind",
    ["CurrentValue"] = "current_value_bind",
}

---@enum(key) clicli.Const.AbilityIntAttr
M.AbilityIntAttr = {
    ["MaximumLevel"] = "ability_max_level",
    ["MaximumChargeNumber"] = "ability_max_stack_count",
    ["CurrentLevel"] = "ability_level",
    ["CurrentChargeNumber"] = "cur_stack_count",
}

---@enum(key) clicli.Const.AbilityStrAttr
M.AbilityStrAttr = {
    ["Name"] = "name",
    ["Description"] = "description",
}

---@enum(key) clicli.Const.AbilityFloatAttr
M.AbilityFloatAttr = {
    ['SkillDrain'] = 'ability_cost',
    ['HealthCost'] = 'ability_hp_cost',
    ['CooldownTime'] = 'cold_down_time',
    ['AbilityDamage'] = 'ability_damage',
    ['ReleaseRange'] = 'ability_cast_range',
    ['SpellcastingBegins'] = 'ability_cast_point',
    ['SpellComplete'] = 'ability_bw_point',
    ['CastASpell'] = 'ability_channel_time',
    ['CastGuide'] = 'ability_prepare_time',
    ['SkillSphere'] = 'ability_damage_range',
    ['ChargeTime'] = 'ability_stack_cd',
}

---@enum(key) clicli.Const.CollisionLayers
M.CollisionLayers = {
    ['Ground'] = 1 << 5,
    ['InTheAir'] = 1 << 6,
    ['WaterSurface'] = 1 << 7,
    ['Object'] = 1 << 8,
}

---@enum(key) clicli.Const.SceneUI
M.SceneUI = {}

---@enum(key) clicli.Const.PlatFormRoleCommunityType
M.PlatFormRoleCommunityType = {
    ['PostAccumulatedLikes'] = 0,
    ['NumberOfEssencePosts'] = 1,
    ['NumberOfRepliesToPosts'] = 2,
    ['NumberOfHappyPostsReceived'] = 3,
    ['HaveYouPostedInTheCommunity?'] = 4,
    ['WhetherToModerator'] = 5,
    ['NumberOfCommunityTopics'] = 6,
}

---@enum(key) clicli.Const.SignInDaysType
M.SignInDaysType = {
    ['CumulativeCheck-in'] = 0,
    ['MaximumConsecutiveCheck-in'] = 1,
    ['CurrentContinuousCheck-in'] = 2,
}

---@enum clicli.Const.SteamOnlineState
M.SteamOnlineState = {
    ['Offline'] = 1,
    ['Free'] = 2,
    ['InTheRoom'] = 3,
    ['Matching'] = 4,
    ['InTheGame'] = 5,
}

---@enum clicli.Const.SteamRoomState
M.SteamRoomState = {
    ['Hall'] = 0,
    ['Countdown'] = 1,
    ['InTheGame'] = 2,
}

---@enum clicli.Const.SteamRoomSlotState
M.SteamRoomSlotState = {
    ['Open'] = 0,
    ['Close'] = 1,
    ['SimpleComputer'] = 5,
    ['HardComputer'] = 6,
}

---@enum(key) clicli.Const.RoadPatrolType
M.RoadPatrolType = {
    ['One-way'] = 0,
    ['RoundTrip'] = 1,
    ['Loop'] = 2,
}

---@enum(key) clicli.Const.UIEffectCameraMode
M.UIEffectCameraMode = {
    ['CustomMode'] = 0,
    ['IntelligentMode'] = 1,
}

---@enum(key) clicli.Const.CustomEventName
M.CustomEventName = {}

---@enum(key) clicli.Const.WeatherType
M.WeatherType = {
    ['None'] = 0,
    ['LightRain'] = 1,
    ['HeavyRain'] = 2,
    ['LightSnow'] = 3,
    ['HeavySnow'] = 4,
    ['Snowstorm'] = 5,
    ['MagicRises'] = 6,
    ['Moonlight'] = 7,
    ['Daylight'] = 8,
    ['LittleWind'] = 9,
    ['Gale'] = 10,
    ['Dust'] = 11,
    ['BlueFog'] = 12,
    ['GreenMist'] = 13,
    ['RedMist'] = 14,
    ['WhiteFog'] = 15,
}

---@enum(key) clicli.Const.BarNameShowType
M.BarNameShowType = {
    ['None'] = 0,
    ['PlayerName'] = 1,
    ['UnitName'] = 2,
}

---@enum(key) clicli.Const.PointLightAttribute
M.PointLightAttribute = {
    ['xCoordinate'] = 'position_x',
    ['yCoordinate'] = 'position_y',
    ['zCoordinates'] = 'position_z',
    ['Color isR-value'] = 'light_color_r',
    ['GValueOfColor'] = 'light_color_g',
    ['ColorBValue'] = 'light_color_b',
    ['LightSourceRange'] = 'light_range',
    ['LightSourceIntensity'] = 'light_intensity',
}

---@enum(key) clicli.Const.DirectionalLightAttribute
M.DirectionalLightAttribute = {
    ['xCoordinate'] = 'position_x',
    ['yCoordinate'] = 'position_y',
    ['zCoordinates'] = 'position_z',
    ['Color isR-value'] = 'light_color_r',
    ['GValueOfColor'] = 'light_color_g',
    ['ColorBValue'] = 'light_color_b',
    ['LightSourceRange'] = 'light_range',
    ['LightSourceIntensity'] = 'light_intensity',
    ['LightSourceXAxisRotation'] = 'light_direction_x',
    ['LightSourceYAxisRotation'] = 'light_direction_y',
    ['LightSourceZ-axisRotation'] = 'light_direction_z',
    ['LowerLimitOfScatteringAngle'] = 'light_inner_angle',
    ['UpperScatteringAngle'] = 'light_out_angle',
}

return M
