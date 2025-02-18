---@class Player
---@field package _selecting_unit? Unit
---@field package _selecting_group? UnitGroup
---@field package _local_selecting_unit? Unit
---@field package _local_selecting_group? UnitGroup
local M = Class 'Player'

---Get selected units (sync)
---@return Unit?
function M:get_selecting_unit()
    return self._selecting_unit
end

---Get the selected unit group (Sync)
---@return UnitGroup?
function M:get_selecting_unit_group()
    return self._selecting_group
end

---Get Local Selected units (Local)
---@return Unit?
function M:get_local_selecting_unit()
    return self._local_selecting_unit
end

---Get Local Selected Unit Group (Local)
---@return UnitGroup?
function M:get_local_selecting_unit_group()
    return self._local_selecting_group
end

clicli.game:event('select-unit', function (trg, data)
    data.player._selecting_unit = data.unit
    data.player._selecting_group = nil
end)

clicli.game:event('Select - Unit Group', function (trg, data)
    data.player._selecting_unit = data.unit_group_id_list:get_first()
    data.player._selecting_group = data.unit_group_id_list
end)

clicli.game:event('Check - cancel', function (trg, data)
    data.player._selecting_unit = nil
    data.player._selecting_group = nil
end)

clicli.game:event('Local - Select - Unit', function (trg, data)
    data.player._local_selecting_unit = data.unit
    data.player._local_selecting_group = nil
end)

clicli.game:event('Local - Select - Unit Group', function (trg, data)
    data.player._local_selecting_unit = data.unit_group_id_list:get_first()
    data.player._local_selecting_group = data.unit_group_id_list
end)

clicli.game:event('Local - Select - Cancel', function (trg, data)
    data.player._local_selecting_unit = nil
    data.player._local_selecting_group = nil
end)
