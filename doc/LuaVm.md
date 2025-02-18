Y3The virtual machine version of Lua is' 5.4 ', with some customization：

* The implementation of real numbers was changed from floating point numbers to fixed point numbers. This is to ensure consistency across platforms. Usually you don't have to think about this, and out of habit we'll continue to call it "floating point". Here are some details：
    + Fixed-point numbers suffer a slight performance loss because floating-point numbers are implemented in hardware。
    + Fixed-point numbers have low precision and can only represent decimal numbers of about 13 digits, and significant digits are about 9 digits. Floating-point numbers can represent decimal numbers of around 308 bits and significant digits of around 15 bits, so you are more likely to observe some accuracy problems。
* If all the indexes of a table ** are numbers or strings ** and ** insert in the same order **, then traversing the table with 'pairs' and' next 'will guarantee a stable traversing order. If these premises cannot be guaranteed, use instead `y3.util.sortPairs` 。
* `math.random` Instead, the interface provided by the engine was used to ensure consistency between players。
* `os.clock` Returns the current logical time to be used by the original implementation `os.clock_banned` 
* For security reasons, the following functions can only be used in development mode and are set to as when running maps in the platform `nil`:
    + `dofile`
    + `loadfile`
    + `debug.debug`
    + `debug.gethook`
    + `debug.getlocal`
    + `debug.getmetatable`
    + `debug.getregistry`
    + `debug.getupvalue`
    + `debug.getuservalue`
    + `debug.sethook`
    + `debug.setlocal`
    + `debug.setupvalue`
    + `debug.setuservalue`
    + `debug.upvaluejoin`
    + `io.close`
    + `io.flush`
    + `io.input`
    + `io.lines`
    + `io.output`
    + `io.popen`
    + `io.read`
    + `io.stdin`
    + `io.stdout`
    + `io.tmpfile`
    + `io.write`
    + `os.execute`
    + `os.exit`
    + `os.getenv`
    + `os.remove`
    + `os.rename`
    + `os.setlocale`
    + `os.tmpname`
    + `package.loadlib`
* For security reasons, the following functions are restricted when running maps on the platform：
    + `io.open`: Absolute paths cannot be used, and paths cannot contain '... The relative path will be based on the map's custom directory。
    + `io.open`: Unable to open file in 'r' mode。
    + `debug.getinfo`: The returned table will not contain the 'func' field。
    + `debug.setmetatable`: When used with 'table' or 'userdata', it is downgraded to 'setmetatable' to ensure that the '__metatable' metamethod cannot be bypassed。
