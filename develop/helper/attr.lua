local dattr = require 'clicli.develop.attr'

---@class Develop.Helper.Attr
local M = Class 'Develop.Helper.Attr'

---@class Develop.Helper.Attr.API
local API = {}

function M:__init()
    ---@type Develop.Helper.TreeNode[]
    self.childs = {}
    self.root = clicli.develop.helper.createTreeNode('Attribute monitoring', {
        icon = 'compass',
        childs = self.childs,
    })
    self.tree = clicli.develop.helper.createTreeView('Attribute monitoring', self.root)
end

function M:__del()
    self.tree:remove()
end

---@param unit Unit
---@param attr clicli.Const.UnitAttr
---@return Develop.Helper.TreeNode
---@return fun(value: Develop.Attr.Accept) # Set breakpoint
function M:add(unit, attr)
    local core = dattr.create(unit, attr)
    local name = string.format('%s(%d): %s'
        , unit:get_name()
        , unit:get_id()
        , attr
    )

    local watch
    local break_point
    local function set_break_point(value)
        if not value then
            return
        end
        if watch then
            watch:remove()
            watch = nil
        end
        if value == '' then
            break_point.description = nil
            return
        end
        watch = core:watch(value, function (_, watch, oldValue)
            if not break_point.check then
                return
            end
            local template = [[

Attribute breakpoints have been triggered：
%s(%d)：%s
%s -> %s

The breakpoint expression is：
%s]]
            local msg = string.format(template
                , unit:get_name()
                , unit:get_id()
                , attr
                , ('%.2f'):format(oldValue)
                , ('%.2f'):format(unit:get_attr(attr))
                , watch.conditionStr
            )
            pcall(error, msg)
        end)
        break_point.description = watch.conditionStr
        break_point.check = true
        break_point:bindGC(watch)
    end

    break_point = clicli.develop.helper.createTreeNode('breakpoint', {
        icon = 'eye',
        check = true,
        onClick = function ()
            local prompt = 'Please enter expressions such as ">= 100", "<= `Max life` / 2"'
            clicli.develop.helper.createInputBox {
                title = 'Monitor attribute change',
                value = watch and watch.conditionStr,
                prompt = prompt,
                validateInput = function (value)
                    if value == '' then
                        return nil
                    end
                    local f, err = dattr.compileCondition(value)
                    if not f then
                        return 'Expression error:' .. err .. '\n' .. prompt
                    end
                    return nil
                end,
            }:show(set_break_point)
        end,
    })

    local node = clicli.develop.helper.createTreeNode(name, {
        onInit = function (node)
            node:bindGC(clicli.ltimer.loop(0.5, function (timer, count)
                node.description = ('%.2f'):format(unit:get_attr(attr))
            end)):execute()
        end,
        onClick = function (node)
            API.show_modify(unit, attr)
        end,
        childsGetter = function (node)
            return {
                break_point,
                clicli.develop.helper.createTreeNode('details', {
                    icon = 'info',
                    onInit = function (node)
                        local attrTypes = {'Basics', 'Base markup', 'gain', 'Gain addition', 'Final markup'}
                        local childs = {}

                        for _, attr_type in ipairs(attrTypes) do
                            childs[#childs+1] = clicli.develop.helper.createTreeNode(attr_type, {
                                onClick = function (node)
                                    API.show_modify(unit, attr, {
                                        attr_type = attr_type,
                                    })
                                end
                            })
                        end

                        node:bindGC(clicli.ltimer.loop(0.5, function (timer, count)
                            for i, child in ipairs(childs) do
                                local attrValue = unit:get_attr(attr, attrTypes[i])
                                child.description = ('%.2f'):format(attrValue)
                            end
                        end)):execute()

                        node.childs = childs
                    end,
                }),
                clicli.develop.helper.createTreeNode('delete', {
                    icon = 'trash',
                    onClick = function ()
                        node:remove()
                    end,
                }),
            }
        end
    })
    node:bindGC(core)
    node:bindGC(function ()
        clicli.util.arrayRemove(self.childs, node)
        self.root:refresh()
    end)

    self.childs[#self.childs+1] = node
    self.root:refresh()
    return node, set_break_point
end

---@param unit Unit
---@param attr clicli.Const.UnitAttr
---@param condition? Develop.Attr.Accept
---@return Develop.Helper.TreeNode
function API.add(unit, attr, condition)
    local node, set_break_point = API.create():add(unit, attr)
    if condition then
        set_break_point(condition)
    end
    return node
end

---@class Develop.Helper.Attr.ModifyOptions
---@field attr_type? clicli.Const.UnitAttrType
---@field can_create_watch? boolean

---@param unit Unit
---@param attr clicli.Const.UnitAttr
---@param options? Develop.Helper.Attr.ModifyOptions
function API.show_modify(unit, attr, options)
    local attr_type = options and options.attr_type
    local can_create_watch = options and options.can_create_watch or false
    local prompt = ('Example Modify the %s value. Use a + to indicate value added.'):format(attr_type or 'Basics')
    if can_create_watch then
        prompt = prompt .. 'Create a new monitor using ~. Use expressions to create breakpoints.'
    end
    clicli.develop.helper.createInputBox({
        title = string.format('Modify "%s" of "%s(%d)"'
            , unit:get_name()
            , unit:get_id()
            , attr
        ),
        value = ('%.3f'):format(unit:get_attr(attr, attr_type))
            : gsub('(%..-)0+$', '%1')
            : gsub('%.$', ''),
        prompt = prompt,
        validateInput = function (value)
            if value == '' then
                return 'Please enter the value you want to modify!'
            end
            if value == '~' and can_create_watch then
                return nil
            end
            local op = value:sub(1, 1)
            if op == '>' or op == '<' or op == '=' or op == '~' then
                local f, err = dattr.compileCondition(value)
                if f then
                    return nil
                else
                    return 'Breakpoint expression error:' .. err
                end
            end
            if op == '+' then
                value = value:sub(2)
            end
            local num = tonumber(value)
            if num then
                return nil
            else
                return 'Not a significant number!'
            end
        end
    }):show(function (value)
        if not value then
            return
        end
        if value == '~' and can_create_watch then
            API.add(unit, attr)
            return
        end
        local op = value:sub(1, 1)
        if op == '>' or op == '<' or op == '=' or op == '~' then
            API.add(unit, attr, value)
            return
        end
        if op == '+' then
            value = value:sub(2)
        end
        local num = tonumber(value)
        if not num then
            return
        end
        if op == '+' then
            clicli.develop.code.sync_run('unit:add_attr(name, num, attr_type)', {
                unit = unit,
                name = attr,
                num = num,
                attr_type = attr_type,
            })
        else
            clicli.develop.code.sync_run('unit:set_attr(name, num, attr_type)', {
                unit = unit,
                name = attr,
                num = num,
                attr_type = attr_type,
            })
        end
    end)
end

---@return Develop.Helper.Attr
function API.create()
    if not API.instance then
        API.instance = New 'Develop.Helper.Attr' ()
    end
    return API.instance
end

return API
