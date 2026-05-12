---@class UIManager
---@field _allView table<string, BasePanel> manages all interfaces
---@field _allBaseView table<string, BaseView> manages all view controllers
---@field _allTips table<string, BaseTips> manages all prompt interfaces
---@field _uiStack string[] UI stack (for ESC to close)
---@field _uiLock table<string, any> locked status
---@overload fun():self
local M = Class "UIManager"

local UIConst = require "clicli.ui_framework.UIConst"
local share = require "clicli.ui_framework.share"

----------------------------
--Interface enumeration (synchronized from UIConst)
----------------------------
M.Popup = UIConst.Popup
M.Hud = UIConst.Hud
M.Menu = UIConst.Menu
M.Tips = UIConst.Tips
M.UUID = UIConst.UUID

----------------------------
--Mutual exclusion and ESC configuration
----------------------------
M.MutualParent = {}
M.Mutual = UIConst.Mutual or {}
M.NoEsc = UIConst.NoEsc or {}

----------------------------
--Lock configuration
----------------------------
M.LockFrame = 300   --The default frame count is locked
M.CDFrame = 1       --The number of CD frames after unlocking
M.Strength = {
    [1] = 1,
    [2] = 5,
    [3] = 15,
}

---@return self
function M:__init()
    self._allView = {}
    self._allBaseView = {}
    self._allTips = {}
    self._uiStack = {}
    self._uiLock = {}
    return self
end

---Start the UI manager (called during game initialization)
function M:start()
    self:initUI()
end

---Initialize all interfaces
function M:initUI()
    local uiClasses = { self.Popup, self.Hud, self.Menu }

    for _, uiList in pairs(uiClasses) do
        for uiName in pairs(uiList) do
            --Try instantiating the interface class
            local success, instance = pcall(function()
                return New(uiName)()
            end)
            if success and instance then
                self._allView[uiName] = instance
            else
                log.warn("UIManager: Failed to create UI class: " .. uiName)
            end
        end
    end

    --Initialization Tips
    for uiName in pairs(M.Tips) do
        local uuid = M.UUID[uiName]
        if uuid then
            local success, instance = pcall(function()
                return New(uiName)()
            end)
            if success and instance then
                self._allTips[uiName] = instance
                --attach replaces the old baseInit + initHide
                instance:attach(uuid)
                instance:_hideRoot()
            else
                log.warn("UIManager: Failed to create Tips class: " .. uiName)
            end
        end
    end

    --Build mutually exclusive mappings
    for key, NameData in pairs(M.Mutual) do
        for _, name in ipairs(NameData) do
            M.MutualParent[name] = key
        end
    end
end

----------------------------
--Interface control
----------------------------

---Display interface (supports multiple parameters
---@param viewName string Interface name
---@param ... The parameter passed by any to on_refresh
function M:openUI(viewName, ...)
    self:hideMutual(viewName)
    local panel = self._allView[viewName]
    if panel then
        --Initialize first (if not attached yet)
        if not panel._isAttached then
            log.info("[UIManager] Initialization interface:" .. viewName)

            --Obtain UI controls
            local localPlayer = panel:getLocalPlayer()
            local uuid = self:getUUID(viewName)
            local ui = nil

            if uuid then
                ui = clicli.ui.get_by_handle(localPlayer, uuid)
                if not ui then
                    log.error("[UIManager] cannot obtain the UI through UUID:" .. viewName .. ", UUID: " .. uuid)
                    return
                end
            else
                local uiPath = self:getUIPath(viewName)
                ui = clicli.ui.get_ui(localPlayer, uiPath)
                if not ui then
                    log.error("[UIManager] cannot obtain the UI through the path:" .. viewName .. ", Path: " .. uiPath)
                    return
                end
            end

            --attach: Bind the UI node and execute on_init
            panel:attach(ui)
            log.info("[UIManager] interface attach completed:" .. viewName)
        end

        --Call open (internally it will use set_visible + on_refresh)
        log.info("[UIManager] Open interface:" .. viewName)
        panel:open(...)

        --If it is a pop-up window, add it to the stack
        for dlgName in pairs(self.Popup) do
            if dlgName == viewName then
                self:uiStackInsert(viewName)
                break
            end
        end

        --Open events through the event bus broadcast interface
        if share.event then
            share.event:emit("ui:open", viewName)
            share.event:emit("ui:open:" .. viewName)
        end
    else
        log.warn("[UIManager] interface not found:" .. viewName)
    end
end

---Close the interface
---@param viewName string
function M:closeUI(viewName)
    local panel = self._allView[viewName]
    if panel then
        --Call close (internally set_visible(false) + on_hide)
        panel:close()
        --Remove from the stack
        for i = #self._uiStack, 1, -1 do
            if self._uiStack[i] == viewName then
                table.remove(self._uiStack, i)
                break
            end
        end

        --Close events through the event bus broadcast interface
        if share.event then
            share.event:emit("ui:close", viewName)
            share.event:emit("ui:close:" .. viewName)
        end
    else
        log.info("UIManager: UI " .. viewName .. " not found")
    end
end

---Close the stack top interface (ESC response)
function M:closeTopUI()
    if #self._uiStack == 0 then
        return
    end
    local topIndex = #self._uiStack
    local viewName = self._uiStack[topIndex]
    self:closeUI(viewName)
end

---Determine whether the interface is open
---@param viewName string
---@return boolean
function M:isUIOpen(viewName)
    if self._allView[viewName] then
        return self._allView[viewName]:isOpen()
    elseif self._allTips[viewName] then
        return self._allTips[viewName]:isOpen()
    else
        return false
    end
end

---Determine if there is a pop-up window open
---@return boolean
function M:isExistUIOpen()
    return #self._uiStack > 0
end

---Close all pop-up Windows
---@param uiNameExcept? The interface name excluded by string
function M:closeAllPopup(uiNameExcept)
    for uiName in pairs(M.Popup) do
        if self._allView[uiName] and self._allView[uiName]:isOpen() then
            if uiName ~= uiNameExcept then
                self:closeUI(uiName)
            end
        end
    end
end

---@private
---Add the interface to the stack
---@param viewName string
function M:uiStackInsert(viewName)
    --Check if it is in the NoEsc list
    for _, name in ipairs(self.NoEsc) do
        if viewName == name then
            return
        end
    end
    table.insert(self._uiStack, viewName)
end

---@private
---Hide the mutual exclusion interface
---@param viewName string
function M:hideMutual(viewName)
    if M.MutualParent[viewName] then
        local parent_name = M.MutualParent[viewName]
        for _, uiName in ipairs(M.Mutual[parent_name]) do
            if self:isUIOpen(uiName) and viewName ~= uiName then
                self:closeUI(uiName)
            end
        end
    end
end

----------------------------
--Tips Control
----------------------------

---Display Tips
---@param tipsName string
---@param param? "table Parameter table"
function M:showTips(tipsName, param)
    if not tipsName or not self._allTips[tipsName] then
        return
    end
    self._allTips[tipsName]:show(param)
end

---Hidden Tips
---@param tipsName string
---@param param? "table Parameter table"
function M:hideTips(tipsName, param)
    if not tipsName or not self._allTips[tipsName] then
        return
    end
    self._allTips[tipsName]:hide(param)
end

----------------------------
--Controller access
----------------------------

---Obtain the interface controller (BasePanel)
---@param uiName string
---@return BasePanel|nil
function M:getUICtrl(uiName)
    return self._allView[uiName]
end

---Get the view controller (BaseView)
---@param uiName string
---@return BaseView|nil
function M:getUIViewCtrl(uiName)
    return self._allBaseView[uiName]
end

---Set the view controller
---@param uiName string
---@param ctrl BaseView
function M:setUIViewCtrl(uiName, ctrl)
    self._allBaseView[uiName] = ctrl
end

---Obtain the interface UUID
---@param uiName string
---@return string|nil
function M:getUUID(uiName)
    return M.UUID[uiName]
end

---Obtain the interface path
---@param uiName string
---@return string
function M:getUIPath(uiName)
    if UIConst.Path and UIConst.Path[uiName] then
        return UIConst.Path[uiName]
    end
    if M.Popup[uiName] then
        return M.Popup[uiName]
    end
    if M.Hud[uiName] then
        return M.Hud[uiName]
    end
    if M.Menu[uiName] then
        return M.Menu[uiName]
    end
    return "?"
end

---Clean all interfaces
function M:clear()
    for key, value in pairs(self._allView) do
        value:destroy()
    end
    self._allView = {}
    self._allBaseView = {}
    self._uiStack = {}
end

----------------------------
--Locking mechanism (anti-connection)
----------------------------

---Lock button
---@param str string lock identifier
function M:lock(str)
    if self._uiLock[str] then
        self._uiLock[str]:remove()
    end
    self._uiLock[str] = clicli.ltimer.wait_frame(self.LockFrame, function()
        self._uiLock[str] = nil
    end)
end

---Unlock button
---@param str string lock identifier
function M:unlock(str)
    if self._uiLock[str] then
        self._uiLock[str]:remove()
    end
    self._uiLock[str] = clicli.ltimer.wait_frame(self.CDFrame, function()
        self._uiLock[str] = nil
    end)
end

---Determine whether it is locked
---@param str string lock identifier
---@return boolean
function M:islock(str)
    return self._uiLock[str] ~= nil
end

---Automatic unlock (with strength)
---@param str string lock identifier
---@param strength? number: Lock strength 1-1, 2-5,3-15
function M:autoLock(str, strength)
    strength = strength or 1
    local time = self.Strength[strength] or self.Strength[1]
    self:lock(str)
    clicli.ltimer.wait_frame(time, function()
        self:unlock(str)
    end)
end

----------------------------
--Button Icon Tool
----------------------------

---Set button image (by type)
---@param ui UI button control
---@param btnType string Button type (corresponding to the key of UIConst.BtnIcon)
function M:setBtnIconByType(ui, btnType)
    if not UIConst.BtnIcon[btnType] or not UIConst.BtnIcon[btnType].nml then
        return
    end
    local baseIcon = UIConst.BtnIcon[btnType].nml
    ui:set_btn_status_image(1, UIConst.BtnIcon[btnType].nml)
    ui:set_btn_status_image(2, UIConst.BtnIcon[btnType].hov or baseIcon)
    ui:set_btn_status_image(3, UIConst.BtnIcon[btnType].sel or baseIcon)
    ui:set_btn_status_image(4, UIConst.BtnIcon[btnType].dis or baseIcon)
end

return M