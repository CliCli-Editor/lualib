local M = clicli.object.unit[134274912] --Guan Yu

M:event('Unit - Create', function (trg, data)
    local unit = data.unit
    print('Unit - Create:', unit)

    --Bind the timer to the unit and the timer will automatically destroy when the unit is removed
    unit:bindGC(clicli.ltimer.loop(0.5, function ()
        print('Cause damage!')
        unit:damage {
            damage = 100,
            target = unit,
            type = 'physics',
        }
    end))
end)

M:event('Unit - Death', function (trg, data)
    local unit = data.unit
    print('Unit - Death:', unit)
    clicli.ltimer.wait(2, function (timer, count)
        unit:remove()
    end)
end)

M:event('Unit - Remove', function (trg, data)
    print('Unit - Remove:', data.unit)
end)
