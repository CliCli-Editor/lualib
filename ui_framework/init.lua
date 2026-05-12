--[[
    UI Framework entry

    Responsible：
    1. Load all UI base classes and Manager
    2. Initialize event and in share uiMgr
    3. Register the game initialization event and start UIManager

    Usage method：
    UI The framework is automatically loaded along with clicli-lualib without the need for manual import。
    Modules that need to use event/uiMgr can be obtained through require 'clicli.ui_framework.share'。

    ```lua
    local share = require 'clicli.ui_framework.share'
    share.uiMgr:openUI("MyPanel")
    share.event:emit("data_change", data)
    ```
]]

----------------------------
--Load the UI framework class definitions
----------------------------
include 'clicli.ui_framework.base.init'
include 'clicli.ui_framework.UIManager'

----------------------------
--Initialize the shared state
----------------------------
local share = require 'clicli.ui_framework.share'

--Event bus (initialized first, and other modules may rely on it)
share.event = New "EventBus" ()

--UI Manager
share.uiMgr = New "UIManager" ()

log.info("[UI Framework] share initialization completed")
log.info("[UI Framework] - share.event: " .. tostring(share.event ~= nil))
log.info("[UI Framework] - share.uiMgr: " .. tostring(share.uiMgr ~= nil))

----------------------------
--Game startup initialization
----------------------------
clicli.game:event('Game - initialization', function(trg, data)
    log.info("[UI Framework] receives the 'Game - Initialization' event")

    if not share.uiMgr then
        log.error("[UI Framework] share.uiMgr is not instantiated!")
        return
    end

    log.info("[UI Framework] start share.uiMgr:start()")
    share.uiMgr:start()
    log.info("[UI Framework] UIManager has been successfully launched")
end)

--Export the public API to clicli.ui_manager
clicli.ui_manager = require 'clicli.ui_framework.api'

log.info("The UI Framework has been loaded successfully")
