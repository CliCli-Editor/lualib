---@class BasePanel
---@field _panelObj UI panel root node
---@field _controls table<string, UI> The table key is the control name and the value is the control itself (controls beginning with "_")
---@field _localPlayer Player Local player
---@field _localPlayerId integer Local Player ID
---@field _name string Interface name
---@field _isAttached boolean whether attach has been completed
---@field _eventHandlers table<string, function[]> panel internal event listener
---@field _eventBusUnsubscribes function[] List of unsubscribes functions for the global event bus
---@field __class_events? table[] class-level event registration (written by on_event)
---@field _gcHost GCHost Lifecycle Garbage Collection host
local M = Class "BasePanel"

local share = require 'clicli.ui_framework.share'

---@return self
function M:__init()
    self._panelObj = nil
    self._controls = {}
    self._isAttached = false
    self._eventHandlers = {}
    self._eventBusUnsubscribes = {}
    self._localPlayerId = nil
    self._localPlayer = nil
    self._gcHost = New "GCHost" ()
    return self
end

---Acquire local players (delayed initialization)
---@return Player
function M:getLocalPlayer()
    if not self._localPlayer then
        self._localPlayer = clicli.player.get_by_handle(GameAPI.get_client_role())
    end
    return self._localPlayer
end

---Obtain the local player ID (delayed initialization)
---@return integer
function M:getLocalPlayerId()
    if not self._localPlayerId then
        self._localPlayerId = 1
    end
    return self._localPlayerId
end

---Recursively search for all child controls starting with '_' and automatically bind them to self
---@param parent UI parent control
function M:findAllUnderscoreControls(parent)
    local children = parent:get_childs()
    for _, child in pairs(children) do
        local controlName = child:get_name()
        if clicli.util.stringStartWith(controlName, "_") then
            self._controls[controlName] = child
        end
        --Recursively search for the child controls of the child controls
        self:findAllUnderscoreControls(child)
    end
end

---Get the control (by control name)
---@param name string Control name (beginning with "_")
---@return UI|nil
function M:getControl(name)
    local control = self._controls[name]
    if control == nil then
        log.warn("Error: Failed to get control for " .. name)
        return nil
    end
    return control
end

---Determine whether the interface is open
---@return boolean
function M:isOpen()
    if self._panelObj then
        return self._panelObj:is_visible()
    end
    return false
end

---Hide the root node (used during initialization)
function M:_hideRoot()
    if self._panelObj then
        self._panelObj:set_visible(false)
    end
end

----------------------------
--Lifecycle Hook (Align lualib LocalUILogic)
--Subclasses should override these methods
----------------------------

---Subclass override: Initialization (executed only once after attaching)
---Corresponding to LocalUILogic:on_init
---@param ui UI interface root node
---@param local_player Player Local player
function M:on_init(ui, local_player) end

---Subclass override: Called each time it is opened/refreshed
---Corresponding to LocalUILogic:on_refresh
---@param ... The parameters passed in when any is opened
function M:on_refresh(...) end

---Subclass override: Called when hidden
---@param ... The parameters passed in when any is closed
function M:on_hide(...) end

---Subclass override: Called when destroyed
function M:on_destroy() end

---Register global event bus listeners (class level, defined in parallel with on_init)
---It is automatically bound to the event bus when attached and automatically cleared when destroyed
---The first parameter of the callback is the panel instance self
---
---Usage:
---```lua
---Panel2:on_event("gold_change", function(self, data)
---log.info(" Gold Coin Changes: ".." data.gold)
---end)
---```
---@param eventName string Event name
---@param callback fun(self: BasePanel, ...) Callback function, with the first parameter being the panel instance
function M:on_event(eventName, callback)
    --Class-level invocation: Stored on the class table and automatically registered when attached
    if not rawget(self, '__class_events') then
        rawset(self, '__class_events', {})
    end
    table.insert(rawget(self, '__class_events'), {
        event = eventName,
        callback = callback,
    })
end

----------------------------
--Internal lifecycle method (called by UIManager)
----------------------------

---Internal attachment: Bind the UI node and perform initialization (called by UIManager)
---Corresponding to the logic of LocalUILogic:attach
---@param ui UI/string interface root node or UUID string
function M:attach(ui)
    if self._isAttached then
        return
    end

    --Defensive initialization: Ensure the existence of critical fields
    self._controls = self._controls or {}
    self._eventHandlers = self._eventHandlers or {}
    self._eventBusUnsubscribes = self._eventBusUnsubscribes or {}
    self._gcHost = self._gcHost or New "GCHost" ()

    --Support the input of UUID strings
    if type(ui) == "string" then
        local localPlayer = self:getLocalPlayer()
        ui = clicli.ui.get_by_handle(localPlayer, ui)
        if not ui then
            log.error("[BasePanel] attach: UI cannot be obtained through UUID")
            return
        end
    end

    self._panelObj = ui

    --Recursively search for all child controls starting with '_'
    self:findAllUnderscoreControls(ui)

    --Automatically bind controls to self (fields starting with _)
    for name, control in pairs(self._controls) do
        self[name] = control
    end

    local localPlayer = self:getLocalPlayer()

    --Register class-level event listening (defined via on_event)
    local classEvents = self.__class_events
    if classEvents then
        for _, handler in ipairs(classEvents) do
            local cb = handler.callback
            local unsubscribe = share.event:on(handler.event, function(...)
                cb(self, ...)  --Pass in the instance as the first parameter
            end)
            table.insert(self._eventBusUnsubscribes, unsubscribe)
        end
    end

    --Call the subclass on_init
    self:on_init(ui, localPlayer)

    self._isAttached = true
end

---Internal open (invoked by UIManager)
---@param ... The parameter passed by any to on_refresh
function M:open(...)
    if not self._panelObj then
        log.warn("[BasePanel] open: panelObj is nil")
        return
    end

    self._panelObj:set_visible(true)

    --Call the subclass on_refresh
    self:on_refresh(...)
end

---Internal closure (invoked by UIManager)
function M:close()
    if not self._panelObj then
        return
    end

    self._panelObj:set_visible(false)

    --Call the subclass on_hide
    self:on_hide()
end

---Internal destruction (invoked by UIManager)
function M:destroy()
    --Call the subclass on_destroy
    self:on_destroy()

    --Clean up internal events of the panel
    self._eventHandlers = {}

    --Clean up the subscriptions of the global event bus
    if self._eventBusUnsubscribes then
        for _, unsubscribe in ipairs(self._eventBusUnsubscribes) do
            unsubscribe()
        end
        self._eventBusUnsubscribes = {}
    end

    --Destroy GCHost (automatically clean up all bound resources
    if self._gcHost then
        Delete(self._gcHost)
        self._gcHost = nil
    end

    --Clean up control references
    self._controls = {}
    self._panelObj = nil
    self._isAttached = false
end

----------------------------
--Integrate with clicli.local_ui
----------------------------

---Bind resources to the lifecycle (managed through internal GCHost)
---@param obj any objects to be bound (timers, triggers, etc.)
---@return any obj returns the passed object
function M:bindGC(obj)
    if self._gcHost then
        return self._gcHost:bindGC(obj)
    end
    return obj
end

---Create local UI logic (for complex UIs such as lists)
---@param childPath string Child control path
---@return LocalUILogic?
function M:createLocalUI(childPath)
    local child = self._panelObj:get_child(childPath)
    if not child then
        log.warn("Error: Failed to get child for LocalUI: " .. childPath)
        return nil
    end
    local logic = clicli.local_ui.create(child)
    self:bindGC(logic)  --Through BasePanel is bindGC proxy
    return logic
end

---Create component logic (for reusable UI components)
---@param prefabName string Component name
---@return LocalUILogic
function M:createPrefabLogic(prefabName)
    return clicli.local_ui.prefab(prefabName)
end

----------------------------
--Click on event binding
----------------------------

---Binding click events (Standard method)
---@param control UI control
---@param callback function Click the callback
function M:bindClick(control, callback)
    if not control then
        log.warn("[BasePanel] bindClick: control is nil")
        return
    end

    local trigger = control:add_fast_event("Left - click", function(trg, data)
        if callback then
            callback()
        end
    end)

    if trigger then
        self:bindGC(trigger)
    end
end

---The event of pressing the binding button
---@param control UI control
---@param callback function callback
function M:bindPress(control, callback)
    if not control then return end

    ---@diagnostic disable-next-line: param-type-mismatch
    local trigger = control:add_fast_event("Left button. - Press it", function(trg, data)
        if callback then
            callback()
        end
    end)

    if trigger then
        self:bindGC(trigger)
    end
end

---Bind the button lift event
---@param control UI control
---@param callback function callback
function M:bindRelease(control, callback)
    if not control then return end

    ---@diagnostic disable-next-line: param-type-mismatch
    local trigger = control:add_fast_event("Left click - Lift", function(trg, data)
        if callback then
            callback()
        end
    end)

    if trigger then
        self:bindGC(trigger)
    end
end

----------------------------
--Timer encapsulation (based on clicli.ctimer client timer)
----------------------------

---Create a loop timer
---@param interval number: Interval seconds
---@param callback function Callback function
---@return table Timer object (can be stopped by calling :remove())
function M:loop(interval, callback)
    local timer = clicli.ctimer.loop(interval, function(t, count, localPlayer)
        if callback then
            callback(t, count)
        end
    end)

    if timer then
        self:bindGC(timer)
    end

    return timer
end

---Create a delay timer
---@param delay number delay seconds
---@param callback function Callback function
---@return table Timer object
function M:wait(delay, callback)
    local timer = clicli.ctimer.wait(delay, function(t, count, localPlayer)
        if callback then
            callback(t)
        end
    end)

    if timer then
        self:bindGC(timer)
    end

    return timer
end

---Create a finite number of loop timers
---@param interval number: Interval seconds
---@param count integer Number of executions
---@param callback function Callback function
---@return table Timer object
function M:loopCount(interval, count, callback)
    local timer = clicli.ctimer.loop_count(interval, count, function(t, c, localPlayer)
        if callback then
            callback(t, c)
        end
    end)

    if timer then
        self:bindGC(timer)
    end

    return timer
end

----------------------------
--Custom event system
----------------------------

---Trigger event
---@param eventName string Event name
---@param ... any event parameter
function M:emit(eventName, ...)
    local handlers = self._eventHandlers[eventName]
    if handlers then
        for _, handler in ipairs(handlers) do
            handler(...)
        end
    end
end

---Monitoring events
---@param eventName string Event name
---@param callback function Callback function
---@return function The function that cancels the listening
function M:on(eventName, callback)
    if not self._eventHandlers[eventName] then
        self._eventHandlers[eventName] = {}
    end
    table.insert(self._eventHandlers[eventName], callback)

    --Return the cancellation function
    return function()
        self:off(eventName, callback)
    end
end

---Cancel the monitoring event
---@param eventName string Event name
---@param callback? The function specifies the callback. If it is not passed, all listeners for this event will be removed
function M:off(eventName, callback)
    if not self._eventHandlers[eventName] then
        return
    end

    if callback then
        for i, handler in ipairs(self._eventHandlers[eventName]) do
            if handler == callback then
                table.remove(self._eventHandlers[eventName], i)
                break
            end
        end
    else
        self._eventHandlers[eventName] = nil
    end
end

return M
