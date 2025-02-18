local M = {}

local files

local function normalize(fileName)
    local paths = {}
    for path in fileName:gmatch('[^/\\]+') do
        if path == '.' then
            --do nothing
        elseif path == '..' then
            if #path == 0 then
                return nil, 'The path cannot go back before the root node'
            end
            table.remove(paths)
        elseif path:match '^%a:$' then
            return nil, 'Relative paths must be used'
        else
            paths[#paths+1] = path
        end
    end
    return table.concat(paths, '/')
end

local function init()
    if files then
        return
    end
    files = {}

    for name, content in pairs(_G['game_lua_files']) do
        local fname = normalize(name:gsub('virtual_script/', ''))
        if fname then
            files[fname:lower()] = content
        end
    end
end

---Load the file in the 'script' directory with a case-insensitive file name.
---The path cannot contain a directory that begins with. Only relative paths can be used.
---@param fileName string
---@return string? content
---@return string? errmsg
function M.load(fileName)
    init()
    local fname, err = normalize(fileName)
    if not fname then
        return nil, err
    end
    local content = files[fname:lower()]
    if not content then
        return nil, 'File does not exist'
    end
    return content
end

---Save the file. Saved in 'script' directory when starting with editor or assistant,
---It is saved in the 'custom' directory when the platform is started. Only relative paths can be used.
---The path can contain a directory beginning with., but it will not be read the next time you start the game.
---The directory must exist; otherwise, the save will fail.
---File names are case insensitive.
---@param fileName string
---@param content string
---@return boolean success
---@return string? errmsg
function M.save(fileName, content)
    if type(content) ~= 'string' then
        return false, 'The file content must be a string'
    end
    init()
    local fname, err = normalize(fileName)
    if not fname then
        return false, err
    end
    local f, err = io.open(script_path:match('^(.-)%?') .. '/' .. fname, 'wb')
    if not f then
        f, err = io.open(fname, 'wb')
        if not f then
            return false, err
        end
    end
    f:write(content)
    f:close()
    files[fname:lower()] = content
    return true
end

return M
