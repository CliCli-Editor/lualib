---@class BaseView : GCHost
---@field _root UI view root node
---@field _isVisible boolean is visible
---@field _localPlayer Player Local player
---@field _localPlayerId integer Local Player ID
---@field _refresh boolean Whether refresh is needed
---@field _isAttached boolean whether attach has been completed
---@field _controls table<string, UI> child controls beginning with '_'
local M = Class 'BaseView'

--Inheriting GCHost, it is consistent with BasePanel/LocalUILogic
Extends("BaseView", "GCHost")

local class = require "clicli.tools.class"
local share = require "clicli.ui_framework.share"

---Initialize the view (called externally once)
---Corresponding to the logic of LocalUILogic:attach
---@param uiNode UI UI node
function M:attach(uiNode)
    if not uiNode or self._isAttached then
        return
    end
    self._root = uiNode
    self._isVisible = false
    self._controls = {}

    --Acquire local players
    self._localPlayer = clicli.player.get_by_handle(GameAPI.get_client_role())
    self._localPlayerId = 1

    --Recursively search for child controls starting with '_'
    self:_findControls(uiNode)

    --Automatically bind controls to self
    for name, control in pairs(self._controls) do
        self[name] = control
    end

    --Automatically register to UIManager for easy access via getUIViewCtrl
    local className = class.type(self)
    if className and share.uiMgr then
        share.uiMgr:setUIViewCtrl(className, self)
    end

    self._isAttached = true

    --Call the subclass on_init
    self:on_init(self._root, self._localPlayer)
end

---@private
---Recursively search for child controls starting with '_'
---@param parent UI
function M:_findControls(parent)
    local children = parent:get_childs()
    for _, child in pairs(children) do
        local controlName = child:get_name()
        if clicli.util.stringStartWith(controlName, "_") then
            self._controls[controlName] = child
        end
        self:_findControls(child)
    end
end

---Subclass override: Initialization (executed only once after attaching)
---Corresponding to LocalUILogic:on_init
---@param ui UI view root node
---@param local_player Player Local player
function M:on_init(ui, local_player) end

---Subclass override: Called each time it is displayed/refreshed
---Corresponding to LocalUILogic:on_refresh
---@param data? table
function M:on_refresh(data) end

---Subclass override: Called when hidden
function M:on_hide() end

---Subclass override: Called when destroyed
function M:on_destroy() end

---Display view (called externally)
---@param data? table
function M:show(data)
    self._isVisible = true
    self._refresh = true
    self._root:set_visible(true)
    self:on_refresh(data)
end

---Hidden view (called from the outside
function M:hide()
    self._isVisible = false
    self._root:set_visible(false)
    self:on_hide()
end

---Determine whether the view is open
---@return boolean
function M:isOpen()
    return self._isVisible
end

---Clean up resources
function M:clear()
    self:on_destroy()
    --GCHost will automatically clean the bound resources
end

return M