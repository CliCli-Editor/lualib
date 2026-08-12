require 'clicli.tools.log'

---@param path string
---@param mode openmode
---@return file*?
---@return string? errmsg
local function io_open(path, mode)
    if not io then
        return nil, 'No io module'
    end
    if not io.open then
        return nil, 'No io.open'
    end
    local file, err
    local suc, res = pcall(function ()
        file, err = io.open(path, mode)
    end)
    if not suc then
        return nil, res
    end
    return file, err
end

local log_cache = {}
local function sanitize_log_file_part(value)
    value = tostring(value or '')
    value = value:gsub('[\\/:*?"<>|%c]', '_')
    value = value:gsub('%s+', '_')
    value = value:gsub('^_+', ''):gsub('_+$', '')
    return value
end

local function get_client_role_log_name()
    local role = GameAPI.get_client_role()
    if not role then
        return 'unknown', 0
    end

    local role_id = role:get_role_id_num() or 0
    local ok, role_name = pcall(function()
        return role:get_role__unique_name()
    end)
    if not ok or not role_name or tostring(role_name) == '' then
        ok, role_name = pcall(function()
            return role:get_role_name()
        end)
    end
    if not ok or not role_name or tostring(role_name) == '' then
        role_name = 'unknown'
    end
    return sanitize_log_file_part(role_name), role_id
end

local role_log_name, role_id = get_client_role_log_name()
if role_log_name == '' then
    role_log_name = 'unknown'
end
local log_name = ('lua_player%02d_%s.log'):format(role_id, role_log_name)
local log_file = io_open(script_path:match('^(.-)%?') .. '/.log/' .. log_name, 'w+b')
            or   io_open(log_name, 'w+b')
if log_file then
    log_file:setvbuf 'no'
end

---@param text string
---@return string
local function remove_bad_utf8(text)
    local buf = {}
    local cur = 1
    while cur <= #text do
        local suc, errpos = utf8.len(text, cur)
        if suc then
            buf[#buf+1] = text:sub(cur, #text)
            break
        end
        buf[#buf+1] = text:sub(cur, errpos - 1)
        cur = errpos + 1
    end
    return table.concat(buf)
end

local function print_to_game(message)
    log_cache[#log_cache+1] = message
    if #log_cache > 10 then
        table.remove(log_cache, 1)
    end
    ---@diagnostic disable-next-line: deprecated
    clicli.ui.display_message(clicli.player.get_local(), remove_bad_utf8(table.concat(log_cache, '\n')), 60)
end

local enable_print = true

---@diagnostic disable-next-line: lowercase-global
log = New 'Log' {
    level = 'trace',
    file  = log_file,
    clock = function ()
        return GameAPI.get_cur_game_time():float()
    end,
    startTime = (function ()
        local timeStamp = GameAPI.get_game_init_time_stamp()
        return timeStamp
    end)(),
    print = function (level, message, timeStamp)
        local message_with_level = string.format('[%5s]%s', level, message)
        if level == 'error' or level == 'fatal' then
            if upload_traceback then
                upload_traceback(message_with_level)
            end
        end
        local logger = clicli.config.log.logger
        if logger then
            clicli.config.log.logger = nil
            local suc, res = xpcall(logger, log.error, level, message, timeStamp)
            clicli.config.log.logger = logger
            if suc and res then
                return
            end
        end
        if clicli.config.log.toDialog then
            if level == 'error' or level == 'fatal' then
                GameAPI.print_to_dialog(1, message)
            elseif level == 'warn' then
                GameAPI.print_to_dialog(2, message)
            else
                GameAPI.print_to_dialog(3, message)
            end
        end
        if enable_print then
            if clicli.config.log.toConsole then
                consoleprint(message_with_level)
            end
            if clicli.config.log.toGame then
                print_to_game(message_with_level)
            end
            if clicli.config.log.toHelper then
                clicli.develop.helper.print(message_with_level)
            end
        end
    end,
    traceback = function (message, level)
        local err = debug.traceback(message, level + 1)
        if python and python.get_exc_info then
            local py_traceback = python.get_exc_info()
            if py_traceback then
                err = tostring(py_traceback) .. '\n' .. err
            end
        end
        return err
    end,
}

--Overload print

--Equivalent to 'log.debug'. In development mode, it is also made sure to print to the game window.
---@param ... any
function print(...)
    local strs = {...}
    for i = 1, select('#', ...) do
        strs[i] = tostring(strs[i])
    end
    local message = table.concat(strs, '\t')
    if clicli.game.is_debug_mode() then
        print_to_game(message)
    end
    consoleprint(message)
    clicli.develop.helper.print(message)
    enable_print = false
    log.print(...)
    enable_print = true
end
