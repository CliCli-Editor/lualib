--[[
    UI Framework shared state (internal module)）

    Internal modules of the framework share events and uiMgr instances by requiring this file。
    Users should not directly require this file. Please use it clicli.ui_manager API。
]]

---@class UIFrameworkShare
---@field event EventBus Global Event bus
---@field uiMgr UIManager UIManager
local M = {}

return M