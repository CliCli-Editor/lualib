---@class BaseTips : GCHost
---@field _root UI Tips Root node
---@field _localPlayer Player Local player
---@field _localPlayerId integer Local Player ID
---@field _pos integer[] : nil fixed position (nil follows the mouse)
---@field _isAttached boolean whether attach has been completed
local M = Class 'BaseTips'

--Inheriting GCHost, it is consistent with BasePanel/LocalUILogic
Extends("BaseTips", "GCHost")

---Initialize Tips (called externally once)
---@param uiNode? string UUID or path
function M:attach(uiNode)
    if not uiNode or self._isAttached then
        return
    end
    self._localPlayer = clicli.player.get_by_handle(GameAPI.get_client_role())
    self._localPlayerId = 1
    self._root = clicli.ui.get_by_handle(self._localPlayer, uiNode)
    self._isAttached = true

    --Call the subclass on_init
    self:on_init(self._root, self._localPlayer)
end

---Subclass override: Initialization (executed only once after attaching)
---Corresponding to LocalUILogic:on_init
---@param ui UI Tips Root node
---@param local_player Player Local player
function M:on_init(ui, local_player) end

---Subclass override: Called each time it is displayed/refreshed
---Corresponding to LocalUILogic:on_refresh
---@param data? table
function M:on_refresh(data) end

---Subclass override: Called when hidden
---@param data? table
function M:on_hide(data)
    self:_hideRoot()
end

---Display Tips
---@param data? The data passed by table to on_refresh
function M:show(data)
    if self._root then
        self._root:set_visible(true)
    end
    self:on_refresh(data)
end

---Hidden Tips
---@param data? The data passed by table to on_hide
function M:hide(data)
    self:on_hide(data)
end

---Determine whether the Tips are open
---@return boolean
function M:isOpen()
    if self._root == nil then
        return false
    end
    return self._root:is_visible()
end

---The root node is hidden internally
function M:_hideRoot()
    if self._root == nil then
        return
    end
    self._root:set_visible(false)
end

---Set coordinates (Simple mode)
---If nil is passed in, it follows the mouse; otherwise, it is fixed to the specified position
---@param pos? integer[] {x, y}
function M:setPoint(pos)
    self._pos = pos
    local preX = self._localPlayer:get_mouse_ui_x_percent()
    local preY = self._localPlayer:get_mouse_ui_y_percent()
    local x, y = 0, 1
    if preX > 0.5 then
        x = 1
    end
    if preY < 0.5 then
        y = 0
    end
    if not self._pos then
        self._root:set_anchor(x, y)
        self._root:set_follow_mouse(true, 5, 5)
    else
        self._root:set_anchor(0.5, 1)
        self._root:set_pos(self._pos[1], self._pos[2])
    end
end

---Set coordinates (dynamically adjust according to the position where the UI is triggered)
---It will automatically select and display in one of the four directions based on the UI position to avoid going out of the screen
---@param UI triggers the UI element of tips
---@param offset? number[] offset [x offset, y offset], default to [0, 0]
function M:setPointByUI(ui, offset)
    offset = offset or { 0, 0 }
    self._root:set_follow_mouse(false)

    --Obtain the information that triggers the UI
    local uiX = ui:get_absolute_x()
    local uiY = ui:get_absolute_y()
    local uiWidth = ui:get_real_width()
    local uiHeight = ui:get_real_height()

    --Get the percentage position of the UI on the screen
    local mouseXPercent = uiX / clicli.ui.get_window_width()
    local mouseYPercent = uiY / clicli.ui.get_window_height()

    --Determine the display direction of tips based on location (divided into four quadrants)
    local direction
    local isLeft = mouseXPercent < 0.5
    local isTop = mouseYPercent < 0.5

    if isLeft and isTop then
        direction = "right_down" --Top left > bottom right
    elseif not isLeft and isTop then
        direction = "left_down"  --Upper right > lower left
    elseif isLeft and not isTop then
        direction = "right_up"   --Lower left > upper right
    else
        direction = "left_up"    --Lower right > upper left
    end

    --Parameter configuration in four directions
    local directions = {
        right_down = {
            tipsX = function() return uiX + uiWidth / 2 + offset[1] end,
            tipsY = function() return uiY - uiHeight / 2 - offset[2] end,
            anchorX = 0,
            anchorY = 0
        },
        left_down = {
            tipsX = function() return uiX - uiWidth / 2 - offset[1] end,
            tipsY = function() return uiY - uiHeight / 2 - offset[2] end,
            anchorX = 1,
            anchorY = 0
        },
        right_up = {
            tipsX = function() return uiX + uiWidth / 2 + offset[1] end,
            tipsY = function() return uiY + uiHeight / 2 + offset[2] end,
            anchorX = 0,
            anchorY = 1
        },
        left_up = {
            tipsX = function() return uiX - uiWidth / 2 - offset[1] end,
            tipsY = function() return uiY + uiHeight / 2 + offset[2] end,
            anchorX = 1,
            anchorY = 1
        }
    }

    local dirConfig = directions[direction]
    local tipsX = dirConfig.tipsX()
    local tipsY = dirConfig.tipsY()

    self._root:set_anchor(dirConfig.anchorX, dirConfig.anchorY)
    self._root:set_absolute_pos(tipsX, tipsY)
end

return M