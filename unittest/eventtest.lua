require 'clicli.unittest.eventhead'

do --Basic function
    local o = New 'UnitTest.EventObject' ()

    local count = 0

    o:event_on('test', function ()
        count = count + 1
    end)

    o:event_notify('test')

    assert(count == 1)

    o:event_dispatch('test')

    assert(count == 2)
end

do --The settlement queue of notify
    local o = New 'UnitTest.EventObject' ()

    local r = {}

    o:event_on('Test 1', function ()
        r[#r+1] = 1
        o:event_notify('Test 2')
        r[#r+1] = 3
    end)

    o:event_on('Test 2', function ()
        r[#r+1] = 2
    end)

    o:event_notify('Test 1')

    assert(#r == 3)
    assert(r[1] == 1)
    assert(r[2] == 3)
    assert(r[3] == 2)
end

do --dispatch insert settlement
    local o = New 'UnitTest.EventObject' ()

    local r = {}

    o:event_on('Test 1', function ()
        r[#r+1] = 1
        o:event_dispatch('Test 2')
        r[#r+1] = 3
    end)

    o:event_on('Test 2', function ()
        r[#r+1] = 2
    end)

    o:event_notify('Test 1')

    assert(#r == 3)
    assert(r[1] == 1)
    assert(r[2] == 2)
    assert(r[3] == 3)
end

do --Event registration parameter matching rule
    local o = New 'UnitTest.EventObject' ()

    local r = {}

    o:event_on('test', {1}, function ()
        r[#r+1] = 1
    end)

    o:event_on('test', {1, 2}, function ()
        r[#r+1] = 2
    end)

    o:event_on('test', {1, 2, 3}, function ()
        r[#r+1] = 3
    end)

    o:event_on('test', {1, 2, 3, 4}, function ()
        r[#r+1] = 4
    end)

    o:event_notify_with_args('test', {1 ,2, 3})

    assert(#r == 3)
    assert(r[1] == 1)
    assert(r[2] == 2)
    assert(r[3] == 3)
end

do --Event callback parameters
    local o = New 'UnitTest.EventObject' ()

    local r = {}

    o:event_on('Test 1', function (trg, ...)
        r[#r+1] = { ... }
        o:event_notify('Test 2', 4, 5, 6)
        r[#r+1] = { ... }
    end)

    o:event_on('Test 2', function (trg, ...)
        r[#r+1] = { ... }
    end)

    o:event_notify('Test 1', 1, 2, 3)

    assert(clicli.util.equal(r, {
        {1, 2, 3},
        {1, 2, 3},
        {4, 5, 6},
    }))
end

do --Contains both registration parameters and callback parameters
    local o = New 'UnitTest.EventObject' ()

    local r = {}

    o:event_on('test', {1}, function (trg, ...)
        r[#r+1] = {1, ... }
    end)

    o:event_on('test', {1, 2}, function (trg, ...)
        r[#r+1] = {2, ...}
    end)

    o:event_on('test', {1, 2, 3}, function (trg, ...)
        r[#r+1] = {3, ...}
    end)

    o:event_on('test', {1, 2, 3, 4}, function (trg, ...)
        r[#r+1] = {4, ...}
    end)

    o:event_notify_with_args('test', {1 ,2, 3}, 1, 2, 3)

    assert(clicli.util.equal(r, {
        {1, 1, 2, 3},
        {2, 1, 2, 3},
        {3, 1, 2, 3},
    }))
end
