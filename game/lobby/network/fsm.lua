---@class fsm The template of Finite state machine
local fsm = {}



---Create a new fsm object
---@class fsm # fsm object
---@field states table<string, fsm.State>|nil The states of the fsm
---@field transitions table<string, table<string, boolean>> The transitions of the fsm
---@field current_state fsm.State|nil The current state of the fsm

---@alias fsm.State table<string, function> The state of the fsm
---@alias fsm.OnEnter fun(any...) : boolean The function to be called when entering the
---@alias fsm.OnExit fun(): boolean The function to be called when exiting the state
---@return fsm # fsm object
function fsm:new()
    ---@type fsm
    local new_statem = {
        states = nil,
        transitions = {},
        current_state = nil
    }
    self.__index = self
    setmetatable(new_statem, self)
    return new_statem
end

---@public
--initialize the fsm
function fsm:init()
    self.states = {}
    self.transitions = {}
    self.current_state = nil
end

--change to a new state
---@param to_state string The name of the state to change to
---@param ... any The arguments to pass to the state is onEnter function
---@return boolean
function fsm:change_state(to_state, ...)
    local state = self.states[to_state]
    if state == nil then
        return false
    end

    local from_state = self.current_state and self.current_state.name or ""

    --if the state is the same as the current state, return true
    if from_state == to_state then
        return true
    end

    --skip the transition check if the from_state is empty
    if from_state ~= "" then
        if not self.transitions[from_state][to_state] then
            return false
        end
    end

    local result = true

    --exit the current statement
    result = self.current_state and self.current_state.onExit and self.current_state.onExit() or true

    --failed to exit the current statement
    if not result then
        return false
    end

    --enter the new state
    result = state.onEnter and state.onEnter(...) or true

    self.current_state = state

    return true
end

--add a new state to the fsm
---@param state_name string The name of the state
---@param on_enter fsm.OnEnter The function to be called when entering the state
---@param on_exit fsm.OnExit|nil The function to be called when exiting the state
function fsm:add_state(state_name, on_enter, on_exit)
    local state = {
        name = state_name,
        onEnter = on_enter,
        onExit = on_exit
    }
    self.states[state_name] = state
end

--add a new transition to the fsm
---@param from_state string The name of the state to transition from
---@param to_state string The name of the state to transition to
function fsm:add_transition(from_state, to_state)
    if self.transitions[from_state] == nil then
        self.transitions[from_state] = {}
    end
    self.transitions[from_state][to_state] = true
end

return fsm
