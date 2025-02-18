local template = clicli.object.unit[134274912] --Take Guan Yu as a template

---@type EditorObject.Unit[]
local new_units = {}

for i = 1, 5 do
    new_units[i] = template:new()
    new_units[i].data.name = 'Newly built flat' .. tostring(i)
    print('Created new units:', new_units[i].key, new_units[i].data.name)
end

clicli.game:event('Keyboard. - Press it', clicli.const.KeyboardKey['SPACE'], function (trg, data)
    for _, unit in ipairs(new_units) do
        clicli.player(1):create_unit(unit.key)
    end
end)
