local monster_wave = require 'clicli.demo.Practice room.Grinding'

clicli.ltimer.wait(0.5, function ()
    --Create a master hero for Player 1 and select it
    local hero = clicli.player(1):create_unit(134242543, clicli.point.create(0, 0, 0), 180.0)
    clicli.player(1):select_unit(hero)

    --Set hero properties
    hero:set_level(10)
    hero:add_attr('Physical attack', 70)
    hero:add_attr('Spell attack', 150)
    hero:add_attr('Attack speed', 200)
    hero:add_attr('Physical blood feeding', 20)
    hero:add_attr('Critical Hit Chance', 80)
    hero:add_attr('Skill sucking', 500)
    hero:add_attr('Magic recovery', 20)
    hero:add_attr('Cooling reduction', 50)

    --Create a practice room area
    local circle_area = clicli.area.create_circle_area(clicli.point.create(-1000, -1000, 0), 800)

    --Start spawning when the hero enters the training room
    circle_area:event('zone-access', function (trg, data)
        if data.unit:is_hero() then
            monster_wave.start()
        end
    end)

    --1. Delete monsters in the area 5 seconds after the hero leaves the training room
    --2. If the hero returns within 5 seconds, the hero is not deleted
    circle_area:event('Zone - leave', function (trg, data)
        if data.unit:is_hero() then
            monster_wave.delete(circle_area, 5)
        end
    end)
end)
