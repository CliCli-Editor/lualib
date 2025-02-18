require 'clicli.unittest.eventhead'

do --Performance Test 1
    local o = New 'UnitTest.EventObject' ()

    local count = 0
    for i = 1, 100000 do
        o:event_on('test', function ()
            count = count + 1
        end)
    end

    local c1 = os.clock()
    o:event_notify('test')
    local c2 = os.clock()

    assert(count == 100000)

    print('event Performance test #1', c2 - c1)
end

do --Performance Test 2
    local o = New 'UnitTest.EventObject' ()

    local count = 0
    o:event_on('test', function ()
        count = count + 1
    end)

    local c1 = os.clock()
    for i = 1, 100000 do
        o:event_notify('test')
    end
    local c2 = os.clock()

    assert(count == 100000)

    print('event Performance test #1', c2 - c1)
end

do --Performance Test 3
    local o = New 'UnitTest.EventObject' ()

    local count = 0
    for i = 1, 100000 do
        o:event_on('test', { i }, function ()
            count = count + 1
        end)
    end

    local c1 = os.clock()
    for i = 1, 100000 do
        o:event_notify_with_args('test', { i })
    end
    local c2 = os.clock()

    assert(count == 100000)

    print('event Performance Test #3', c2 - c1)
end
