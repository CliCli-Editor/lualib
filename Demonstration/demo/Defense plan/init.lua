local battle_wave = require 'clicli. demo. Defense chart. Brush troops'
local game_result = require 'clicli. demo. Defense chart. Game result'

clicli.ltimer.wait(0.5, function ()
    --Create a master hero for Player 1 and select it
    local hero = clicli.player(1):create_unit(134274912, clicli.point.create(0, 0, 0), 180.0)
    clicli.player(1):select_unit(hero)

    --Make the hero stronger
    hero:set_level(10)
    hero:add_attr('Physical attack', 70)
    hero:add_attr('Spell attack', 150)
    hero:add_attr('Attack speed', 200)
    hero:add_attr('Physical blood feeding', 20)
    hero:add_attr('Critical Hit Chance', 20)
    hero:add_attr('Skill sucking', 200)
    hero:add_attr('Magic recovery', 10)
    hero:add_attr('Cooling reduction', 50)

    --The player hero dies and the game fails
    hero:event('Unit - Death', function()
        game_result.lose()
        battle_wave.stop()
    end)
end)

--Wait 2 seconds to start brushing
clicli.ltimer.wait(2, function ()
    battle_wave.next_wave()
    --Every 15 seconds after the first attack
    clicli.ltimer.loop(15, function ()
        battle_wave.next_wave()
    end)
end)

clicli.ltimer.loop(1, function(timer)
    --If there are more than 30 monsters on the field, the game is declared lost
    if battle_wave.get_alive_count() >= 30 then
        game_result.lose()
        battle_wave.stop()
        timer:remove()
    end
    --If there are no more monsters on the field, and there are no more monsters on the next wave, the game is awarded
    if battle_wave.get_alive_count() == 0 and not battle_wave.has_next() then
        game_result.win()
        battle_wave.stop()
        timer:remove()
    end
end)
