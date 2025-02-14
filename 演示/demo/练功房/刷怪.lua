local M = {}

local monster_types = {
    134254286,  -- 人鱼法师
    134246749   -- 雪狐
}

for _, monster_type in ipairs(monster_types) do
    if not clicli.object.unit[monster_type].data then
        error [[
该演示图依赖特定的物编数据，请按照以下步骤安装：

在编辑器中点击 `菜单栏` -> `插件` -> `插件商城`，搜索 `LuaLib`，安装 `LuaLib示例-练功房`（英雄、技能、怪物的物编数据）]]
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

    -- 每间隔一秒进行是否刷怪的判断
    timer_start = clicli.ltimer.loop(1, function (timer, count)
        -- 如果停止标志不为真并且场上怪的数量为0时开始刷怪
        if (not is_stop and alive_cnt == 0) then
            alive_cnt = 10
            for i = 1, alive_cnt, 1 do
                -- 随机生成一个怪物
                local monster_type = monster_types[math.random(1, #monster_types)]
                local monster = clicli.unit.create_unit(clicli.player(31), monster_type, spawn_point, 0)
                monsters:add_unit(monster)

                -- 命令怪物攻击移动到目标位置
                monster:attack_move(attack_point)

                monster:event("单位-死亡", function (_, data)
                    monsters:remove_unit(data.unit)
                    alive_cnt = alive_cnt - 1
                end)
            end
        end
    end)
end

--- 删除怪物逻辑
--- @param area Area
--- @param time number
function M.delete(area, time)
    -- 英雄离开区域时停止刷怪，并移除刷怪计时器
    is_stop = true
    if timer_start then
        timer_start:remove()
    end

    -- 该变量来判断英雄是否折回区域
    local is_hero_enter = false
    area:event('区域-进入', function (trg, data)
        -- 如果折回区域则为真
        if data.unit:is_hero() then
            is_hero_enter = true
        end
    end)

    -- 判断英雄离开区域一定时间后是否进行删除怪物
    clicli.ltimer.wait(time, function (timer)
        -- 如果英雄没有折回则删除所有怪物单位
        if not is_hero_enter then
            for _, v in ipairs(monsters:pick()) do
                v:remove()
            end
            monsters:clear()
            alive_cnt = 0
        else
            -- 如果英雄有折回区域则移除此计时器
            timer:remove()
        end
    end)
end

return M
