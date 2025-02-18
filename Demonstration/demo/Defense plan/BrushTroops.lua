local M = {}

local generate_monsters_config = {
    --Number of monster type spawns
    { monster_type = 134251991, count = 10 }, --Scorpion
    { monster_type = 134246732, count = 10 }, --treant
    { monster_type = 134251991, count = 12 }, --Scorpion
    { monster_type = 134246732, count = 12 }, --treant
    { monster_type = 134251991, count = 15 }, --Scorpion
    { monster_type = 134246732, count = 15 }, --treant
}

for _, config in ipairs(generate_monsters_config) do
    local monster_type = config.monster_type
    if not clicli.object.unit[monster_type].data then
        error [[
This diagram depends on specific object data, so follow these steps to install it：

In the editor click 'Menu Bar' -> 'Plugins' ->' Plugins Mall ', search for 'LuaLib', install 'LuaLib Example - Defense Chart' (hero, skill, monster compilation data）]]
    end
end

--Monster birth coordinates
local spawn_point = clicli.point.create(0, -2000, 0)
--Monster attack target
local attack_point = clicli.point.create(0, -2000, 0)

--It starts with wave 0 monsters
local wave_index = 0

--Total number of waves
local total_batch_count = #generate_monsters_config

--Monsters alive on the field
local alive_count = 0

local stopped = false

--Brush the next wave of monsters
function M.next_wave()
    if not M.has_next() then
        return
    end

    if stopped then
        return
    end

    wave_index = wave_index + 1

    --Monster type
    local monster_type = generate_monsters_config[wave_index].monster_type

    --Number of monsters to be brushed in this wave
    local count = generate_monsters_config[wave_index].count

    --Brush one monster every second
    clicli.timer.count_loop(1, count, function()
        if stopped then
            return
        end

        --Spawn monster
        local monster = clicli.unit.create_unit(clicli.player(31), monster_type, spawn_point, 0)

        --Command the monster to attack and move to the target position
        monster:attack_move(attack_point)

        alive_count = alive_count + 1

        monster:event('Unit - Death', function(_, data)
            alive_count = alive_count - 1
        end)
    end)
end

---@return boolean Specifies whether there is an underwave monster
function M.has_next()
    return wave_index < total_batch_count
end

function M.get_alive_count()
    return alive_count
end

function M.stop()
    stopped = true
end

return M
