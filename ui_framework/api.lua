--[[
    UI Manager public API

    It can be accessed through clicli.ui_manager, providing functions such as interface registration, control, and events。
    Users do not need to modify the internal files of lualib; all operations are conducted through the API。

    Usage example：
    ```lua
    --Registration interface
    clicli.ui_manager.register_popup("ShopDialog", "xxxxxxxx-xxxx-xxxx")
    clicli.ui_manager.register_hud("MainHUD", "yyyyyyyy-yyyy-yyyy")
    clicli.ui_manager.register_tips("SmallTips", "zzzzzzzz-zzzz-zzzz")

    --Control interface
    clicli.ui_manager.open("ShopDialog")
    clicli.ui_manager.close("ShopDialog")

    --Event bus
    clicli.ui_manager.on("gold_change", function(data) ... end)
    clicli.ui_manager.emit("gold_change", { gold = 100 })
    ```
]]

local share = require 'clicli.ui_framework.share'
local UIConst = require 'clicli.ui_framework.UIConst'

---@class clicli.UIManagerAPI
local API = {}

----------------------------
--Interface registration
----------------------------

---Registration pop-up interface (can be closed by ESC, supports mutual exclusion)
---@param name string Interface name (must be consistent with Class name)
---@param uuid string interface UUID (Copy from the editor)
function API.register_popup(name, uuid)
    UIConst.Popup[name] = name
    UIConst.UUID[name] = uuid
end

---Register for the permanent HUD interface
---@param name string Interface name
---@param uuid string interface UUID
function API.register_hud(name, uuid)
    UIConst.Hud[name] = name
    UIConst.UUID[name] = uuid
end

---Registration menu interface
---@param name string Interface name
---@param uuid string interface UUID
function API.register_menu(name, uuid)
    UIConst.Menu[name] = name
    UIConst.UUID[name] = uuid
end

---Registration Tips interface
---@param name string Interface name
---@param uuid string interface UUID
function API.register_tips(name, uuid)
    UIConst.Tips[name] = name
    UIConst.UUID[name] = uuid
end

---Configure mutex groups (only one can be displayed simultaneously within the same group)
---@param group_name string group name
---@param ui_names string[] interface list
function API.set_mutual(group_name, ui_names)
    UIConst.Mutual[group_name] = ui_names
end

---The configuration does not respond to the interface closed by ESC
---@param names string[] interface list
function API.set_no_esc(names)
    UIConst.NoEsc = names
end

----------------------------
--Interface control
----------------------------

---Open the interface
---@param name string Interface name
---@param ... The parameter passed by any to on_refresh
function API.open(name, ...)
    share.uiMgr:openUI(name, ...)
end

---Close the interface
---@param name string Interface name
function API.close(name)
    share.uiMgr:closeUI(name)
end

---Close the stack top pop-up (ESC response)
function API.close_top()
    share.uiMgr:closeTopUI()
end

---Close all pop-up Windows
---@param except? The interface name excluded by string
function API.close_all_popup(except)
    share.uiMgr:closeAllPopup(except)
end

---Determine whether the interface is open
---@param name string Interface name
---@return boolean
function API.is_open(name)
    return share.uiMgr:isUIOpen(name)
end

---Determine if there is a pop-up window open
---@return boolean
function API.has_popup()
    return share.uiMgr:isExistUIOpen()
end

---Obtain the interface controller (BasePanel instance)
---@param name string Interface name
---@return BasePanel|nil
function API.get_ctrl(name)
    return share.uiMgr:getUICtrl(name)
end

---Obtain the view controller (BaseView instance)
---@param name string Interface name
---@return BaseView|nil
function API.get_view_ctrl(name)
    return share.uiMgr:getUIViewCtrl(name)
end

----------------------------
--Tips Control
----------------------------

---Display Tips
---@param name string Tips name
---@param param? "table parameter"
function API.show_tips(name, param)
    share.uiMgr:showTips(name, param)
end

---Hidden Tips
---@param name string Tips name
---@param param? "table parameter"
function API.hide_tips(name, param)
    share.uiMgr:hideTips(name, param)
end

----------------------------
--Event bus
----------------------------

---Subscribe to events
---@param event string event name
---@param callback function Callback function
---@return function unsubscribe function
function API.on(event, callback)
    return share.event:on(event, callback)
end

---One-time subscription (automatically cancelled after triggering once)
---@param event string event name
---@param callback function Callback function
---@return function unsubscribe function
function API.once(event, callback)
    return share.event:once(event, callback)
end

---Unsubscribe
---@param event string event name
---@param callback function Callback function
function API.off(event, callback)
    share.event:off(event, callback)
end

---Release event
---@param event string event name
---@param ... any parameter
function API.emit(event, ...)
    share.event:emit(event, ...)
end

---Clear all listeners for a certain event
---@param event string event name
function API.clear_event(event)
    share.event:clear(event)
end

----------------------------
--Anti-connection point locking
----------------------------

---Automatic locking (anti-connection point)
---@param key string Lock identifier
---@param strength? number lock strength: 1/2/3
function API.auto_lock(key, strength)
    share.uiMgr:autoLock(key, strength)
end

---Determine whether it is locked
---@param key string Lock identifier
---@return boolean
function API.is_locked(key)
    return share.uiMgr:islock(key)
end

return API