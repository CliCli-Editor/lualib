rawset(clicli, 'timer', {
    loop_frame = function (...) end,
})
rawset(clicli, 'config', {
    logic_frame = 30,
})

clicli.ltimer = require 'clicli.util.local_timer'

do
    local r = {}
    local t = clicli.ltimer.loop_count_frame(1, 10, function (timer, count)
        r[#r+1] = timer:get_remaining_count()
    end)

    assert(#r == 0)
    clicli.ltimer.debug_fastward(5)
    assert(#r == 5)
    clicli.ltimer.debug_fastward(10)
    assert(#r == 10)
    assert(table.concat(r, ',') == '9,8,7,6,5,4,3,2,1,0')
end

do
    local r = {}
    local t = clicli.ltimer.loop_count_frame(1, 10, function (timer, count)
        r[#r+1] = timer:get_remaining_count()
        if count == 5 then
            timer:set_remaining_count(2)
        end
    end)

    assert(#r == 0)
    clicli.ltimer.debug_fastward(5)
    assert(#r == 5)
    clicli.ltimer.debug_fastward(10)
    assert(#r == 7)
    assert(table.concat(r, ',') == '9,8,7,6,5,1,0')
end

do
    local t = clicli.ltimer.loop_count(1, 10, function (timer, count)
    end)

    assert(t:get_remaining_time() == 1)
    clicli.ltimer.debug_fastward(15)
    assert(t:get_remaining_time() == 0.5)

    t:set_remaining_time(1)
    clicli.ltimer.debug_fastward(15)
    assert(t:get_remaining_time() == 0.5)

    clicli.ltimer.debug_fastward(15)
    assert(t:get_remaining_time() == 1)

    clicli.ltimer.debug_fastward(15)
    assert(t:get_remaining_time() == 0.5)

    t:pause()
    clicli.ltimer.debug_fastward(15)
    assert(t:get_remaining_time() == 0.5)

    t:set_remaining_time(1)
    assert(t:get_remaining_time() == 1)

    clicli.ltimer.debug_fastward(15)
    assert(t:get_remaining_time() == 1)

    t:resume()
    clicli.ltimer.debug_fastward(15)
    assert(t:get_remaining_time() == 0.5)

    clicli.ltimer.debug_fastward(15)
    assert(t:get_remaining_time() == 1)

    clicli.ltimer.debug_fastward(15)
    assert(t:get_remaining_time() == 0.5)
end

do
    local t = clicli.ltimer.loop_count(1, 10, function (timer, count)
    end)

    assert(t:get_remaining_time() == 1)

    clicli.ltimer.debug_fastward(15)
    assert(t:get_remaining_time() == 0.5)

    t:set_time_out_time(2)
    clicli.ltimer.debug_fastward(10)
    assert(t:get_remaining_time() == 0.167)

    clicli.ltimer.debug_fastward(5)
    assert(t:get_remaining_time() == 2)

    clicli.ltimer.debug_fastward(30)
    assert(t:get_remaining_time() == 1)

    clicli.ltimer.debug_fastward(60)
    assert(t:get_remaining_time() == 1)

    t:set_time_out_time(3)
    clicli.ltimer.debug_fastward(30)
    assert(t:get_remaining_time() == 3)
end

do
    local res = {}
    local t1 = clicli.ltimer.loop(1, function (timer, count)
        res[#res+1] = '1'
    end)
    local t2 = clicli.ltimer.loop(1, function (timer, count)
        res[#res+1] = '2'
    end)
    local t3 = clicli.ltimer.loop(1, function (timer, count)
        res[#res+1] = '3'
    end)

    clicli.ltimer.debug_fastward(30)
    t1:remove()
    clicli.ltimer.debug_fastward(60)

    assert(table.concat(res, ',') == '1,2,3,2,3,2,3')
end

print('The ltimer test passed')
