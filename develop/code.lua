---@class Develop.Code
local M = {}

---@class Develop.Code.SyncHandler
---@field env? fun(data: any): table? # Returns a table to be used as the execution environment
---@field complete? fun(suc: boolean, result: any, data: any) # This function is called after the code executes with the result

---@package
---@type table<string, Develop.Code.SyncHandler>
M._sync_handler = {}

local keywords = { 'and', 'break', 'do', 'else', 'elseif', 'end', 'for', 'function', 'if', 'in', 'local', 'or', 'repeat', 'return', 'then', 'until', 'while' }

---@private
function M.wrap_code(code, env)
    local first_token = code:match('^%s*([%w_]+)')
    if not first_token or not clicli.util.arrayHas(keywords, first_token) then
        local returnedCode = 'return ' .. code
        local f, err = load(returnedCode, '=code', 't', env or _ENV)
        if f then
            return f, returnedCode
        end
    end
    local f, err = load(code, '=code', 't', env or _ENV)
    if f then
        return f, code
    end
    ---@cast err string
    return nil, nil, (err:gsub('^code:1:', '[Error]: '))
end

---Execute native code
---@param code string # Code to execute
---@param env? table # Execution environment
---@return boolean # Whether the execution is successful
---@return any # Execution result
function M.run(code, env)
    local debug_mode = clicli.game.is_debug_mode()

    if not debug_mode then
        if not clicli.config.code.enable_local then
            log.error('Execution of local code: \n is not allowed' .. tostring(code))
            return false, 'Execution of local code is not allowed'
        end
    end

    local f, fcode, err = M.wrap_code(code, env)
    if not f then
        return false, err
    end

    if not debug_mode then
        log.warn('Execute local code: \n' .. fcode)
    end

    local ok, result = pcall(f)
    if not ok then
        return false, result
    end

    if not debug_mode then
        log.debug('Execution result:' .. tostring(result))
    end

    return true, result
end

---The code is executed synchronously after broadcast and must be locally initiated
---@param code string # Code to execute
---@param data? table<string, any> # Data, can be accessed directly in the code
---@param id? string # Processor ID
---@return boolean # Whether the execution is successful
---@return string? # Error message
function M.sync_run(code, data, id)
    local debug_mode = clicli.game.is_debug_mode()

    if not debug_mode then
        if not clicli.config.code.enable_remote then
            log.error('Remote code execution is not allowed: \n' .. tostring(code))
            return false, 'Remote code execution is not allowed'
        end
    end

    local f, fcode, err = M.wrap_code(code)
    if not f then
        return false, err
    end

    if not debug_mode then
        log.warn('Initiate remote code: \n' .. code)
    end

    clicli.sync.send('$sync_run', {
        code = code,
        data = data,
        id = id,
    })

    return true
end

clicli.sync.onSync('$sync_run', function (data, source)
    ---@cast data table
    local debug_mode = clicli.game.is_debug_mode()
    local handler = M._sync_handler[data.id]

    if not debug_mode then
        if not clicli.config.code.enable_remote then
            log.error(string.format('%s broadcast remote code, rejected: \n%s'
                , source
                , tostring(data.code)
            ))
            return
        end
        log.warn(string.format('%s broadcasts the remote code: \n%s'
            , source
            , tostring(data.code)
        ))
    end

    local env
    if handler and handler.env then
        env = handler.env(data)
    elseif data.data then
        env = setmetatable(data.data, { __index = _ENV })
    end

    local f, fcode, err = M.wrap_code(data.code, env)
    if not f then
        log.error(err)
        return
    end

    local ok, result = pcall(f, data.data)
    if not ok then
        log.error(result)
        if handler and handler.complete then
            handler.complete(false, result, data)
        end
        return
    end

    if not debug_mode then
        log.debug('Execution result:' .. tostring(result))
    end

    if handler and handler.complete then
        handler.complete(true, result, data)
    end
end)

---Registered sync processor
---@param id string
---@param handler Develop.Code.SyncHandler
function M.on_sync(id, handler)
    M._sync_handler[id] = handler
end

return M
