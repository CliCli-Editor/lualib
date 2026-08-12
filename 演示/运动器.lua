
clicli.game:event('Player - Send message', function (trg, data)
    if data.str1 == '1' then
        --Create a unit and move it in a straight line 1000 distance to the right
        local unit = clicli.player(1):create_unit(134274912, clicli.point(0, 0), 0)
        unit:mover_line {
            speed = 1000,
            angle = 90,
            distance = 1000,
            on_remove = function ()
                unit:kill_by(unit)
            end
        }
    end
    if data.str1 == '2' then
        --Create a unit, then create a projectile 1000 distance to its right and have the projectile track the unit
        --Projectiles track units and kill them
        local unit = clicli.player(1):create_unit(134274912, clicli.point(0, 0), 0)
        local dummy = clicli.projectile.create {
            key    = 134267518,
            target = unit:get_point():move(1000, 0),
            height = 100,
        }
        dummy:mover_target {
            target_distance = 100,
            speed = 100,
            target = unit,
            on_remove = function ()
                dummy:remove()
            end,
            on_finish = function ()
                unit:kill_by(unit)
            end
        }
    end
end)
