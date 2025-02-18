local M = {}

local monster_types = {
    134254286,  --Mermaid mage
    134246749   --Snow fox
}

for _, monster_type in ipairs(monster_types) do
    if not clicli.object.unit[monster_type].data then
        error [[
This diagram depends on specific object data, so follow these steps to install it：

In the editor, click 'Menu Bar' -> 'Plugins' ->' Plugins Mall ', search for 'LuaLib', install 'LuaLib Example - Training Room' (heroes, skills, monsters compilation data）]]
    end
end

--Monster birth coordinates
local spawn_point = clicli.point.create(-1000, -1000, 0)
--Monster attack coordinates
local attack_point = clicli.point.create(-1000, -1000, 0)

--Number of monsters alive in the field
local alive_cnt = 0

--Whether to stop producing monsters
local is_stop = false

--Spawn monster timer
local timer_start = nil

--Monster unit group
local monsters = clicli.unit_group.create()

--Spawning logic
function M.start()
    is_stop = false

    --Check whether to spawn at intervals of one second
    timer_start = clicli.ltimer.loop(1, function (timer, count)
        --If the stop flag is not true and the number of monsters on the field is 0, spawns begin
        if (not is_stop and alive_cnt == 0) then
            alive_cnt = 10
            for i = 1, alive_cnt, 1 do
                --Spawn a random monster
                local monster_type = monster_types[math.random(1, #monster_types)]
                local monster = clicli.unit.create_unit(clicli.player(31), monster_type, spawn_point, 0)
                monsters:add_unit(monster)

                --Command the monster to attack and move to the target position
                monster:attack_move(attack_point)

                monster:event("Unit - Death", function (_, data)
                    monsters:remove_unit(data.unit)
                    alive_cnt = alive_cnt - 1
                end)
            end
        end
    end)
end

---Delete monster logic
---@param area Area
---@param time number
function M.delete(area, time)
    --Stop spawns when the hero leaves the area and remove the spawns timer
    is_stop = true
    if timer_start then
        timer_start:remove()
    end

    --This variable determines whether the hero relocates to the area
    local is_hero_enter = false
    area:event('zone-access', function (trg, data)
        --True if the retrace area
        if data.unit:is_hero() then
            is_hero_enter = true
        end
    end)

    --Determine whether to delete monsters after the hero has left the area for a certain amount of time
    clicli.ltimer.wait(time, function (timer)
        --Delete all monster units if the hero does not turn back
        if not is_hero_enter then
            for _, v in ipairs(monsters:pick()) do
                v:remove()
            end
            monsters:clear()
            alive_cnt = 0
        else
            --Remove this timer if the hero has a backtrack area
            timer:remove()
        end
    end)
end

return M
