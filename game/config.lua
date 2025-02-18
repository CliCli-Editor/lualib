---disposition
---
---You can set log and synchronization configurations
---@class Config
local M = Class 'Config'

---Synchronization related configuration, when set to 'true' will enable synchronization,
---It generates additional traffic.
---Synchronization takes a certain amount of time, and what you get is the state from a short time ago,
---Therefore, the status cannot be obtained immediately after synchronization is enabled.
---@class Config.Sync
---@field mouse boolean # Sync the player's mouse position
---@field key boolean # Sync the player's keyboard and mouse keys
---@field camera boolean # Sync the player's shots
M.sync = clicli.proxy.new({
    mouse  = false,
    key    = false,
    camera = false,
}, {
    updateRaw = true,
    setter = {
        mouse = function (self, raw, key, value, config)
            assert(type(value) == 'boolean', ('The assignment type of `Config.sync.%s` must be` boolean `'):format(key))
            GameAPI.force_enable_mouse_sync(value)
            return value
        end,
        key = function (self, raw, key, value, config)
            assert(type(value) == 'boolean', ('The assignment type of `Config.sync.%s` must be` boolean `'):format(key))
            GameAPI.force_enable_keyboard_sync(value)
            return value
        end,
        camera = function (self, raw, key, value, config)
            assert(type(value) == 'boolean', ('The assignment type of `Config.sync.%s` must be` boolean `'):format(key))
            GameAPI.force_enable_camera_sync(value)
            return value
        end,
    },
})

--Yes No debug mode
---@type boolean|'auto'
M.debug = 'auto'

---@class Config.Log
---@field level Log.Level # The default log level is debug
---@field toFile boolean # Whether to print to a file. The default is true
---@field toDialog boolean # Whether to print to the Dialog window. The default is true
---@field toConsole boolean # Whether to print to the console, defaults to true
---@field toGame boolean # Whether to print to the game window, the default is' false '
---@field toHelper boolean # Whether to print to CliCli Development Assistant, the default is true
---@field logger fun(level: Log.Level, message: string, timeStamp: string): boolean # A custom log handler that returns' true 'will block the default log handler. This function is masked during the execution of the handler function.
--Log related configuration
M.log = clicli.proxy.new({
    level     = 'debug',
    toFile    = true,
    toDialog  = true,
    toConsole = true,
    toGmae    = false,
    toHelper  = true,
}, {
    updateRaw = true,
    setter = {
        level = function (self, raw, key, value, config)
            log.level = value
        end,
        toFile = function (self, raw, key, value, config)
            log.enable = value
        end,
    }
})

---Logical frame rate per second, please set it to the same as set in your map.
---The current default is 30 frames, and in the future the Settings in your map will be read by default.
---It must be set at the beginning of the game, do not change it in the middle.
M.logic_frame = GameAPI.api_get_logic_fps
            and GameAPI.api_get_logic_fps()
            or  30

---Cache-related configurations generally require that you do not manipulate related objects in the ECA to use the cache.
M.cache = {
    ---Whether to cache the UI. Make sure you're not operating the UI in the ECA.
    ui = false,
}

---Dynamically execute code related Settings
M.code = {
    ---Whether native code execution is allowed in non-debug mode.
    enable_local = false,
    ---Whether to allow remote code broadcast by other players to be executed in non-debug mode.
    enable_remote = false,
}

---Interface related Settings
M.ui = {
}

---The motor is registered directly using the engine interface
M.mover = {
    enable_internal_regist = false
}

return M
