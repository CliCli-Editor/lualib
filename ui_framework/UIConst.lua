--[[
    UI Constant definition

    All interface registrations, UUID, mutual exclusion, ESC configuration, button ICONS, etc. are uniformly managed here。

    Usage method：
    1. Add the interface name in the corresponding category (Popup/Hud/Menu/Tips)
    2. Fill in the UUID corresponding to the UI in the UUID (copy from the editor)）
    3. If Mutual exclusion is required, configure it in Mutual
    4. If you do not need to press ESC to close, add to NoEsc
]]

---@class UIConst
local UIConst = {}

----------------------------
--Pop-up interface (can be turned off by ESC, mutually exclusive)
----------------------------
UIConst.Popup = {
    --Example
    --MyPopup  = "MyPopup",
}

----------------------------
--Permanent presence on the HUD interface
----------------------------
UIConst.Hud = {
    --Example
    --MainHUD  = "MainHUD",
}

----------------------------
--Menu interface
----------------------------
UIConst.Menu = {
    --Example
    --MainMenu = "MainMenu",
}

----------------------------
--Floating Tips
----------------------------
UIConst.Tips = {
    --Example
    --SmallTips = "SmallTips",
}

----------------------------
--UUID mapping (Copying interface UUID from the editor)
----------------------------
UIConst.UUID = {
    --Example
    --MyPopup   = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    --MainHUD   = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    --SmallTips = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
}

----------------------------
--Path mapping (optional, if UUID method is not applicable)
----------------------------
UIConst.Path = {
    --Example
    --MyPopup = "ui_prefab/MyPopup",
}

----------------------------
--Mutual exclusion configuration (only one can be displayed simultaneously within the same group)
----------------------------
UIConst.Mutual = {
    --Example
    --group1 = { "PopupA", "PopupB" },
}

----------------------------
--Do not respond to the interface closed by ESC
----------------------------
UIConst.NoEsc = {
    --Example
    --"LoadingPanel",
}

----------------------------
--Button icon mapping (optional)
----------------------------
UIConst.BtnIcon = {
    --Example
    --confirm = {
    --nml = 123456, -- Normal state image ID
    --hov = 123457, -- image ID in hover state
    --sel = 123458, -- Select status image ID
    --dis = 123459, -- disabled status image ID
    --},
}

return UIConst