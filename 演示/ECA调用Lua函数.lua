--Declares a new ECA function to get the unit owner
clicli.eca.def 'Acquire unit owner'
    --Declares the ECA type of the first argument
    : with_param('unit', 'Unit')
    --Declares the ECA type of the return value
    : with_return('Player', 'Player')
    ---@param unit Unit
    ---@return Player?
    : call(function (unit)
        --unit is already the Unit type of the Lua framework
        local p = unit:get_owner()
        --Simply return the Player type of the Lua framework
        return p
    end)

--The ECA "execute Lua code" is used in the editor to call the above functions
--Set variable player = Execute Lua code "Bind[' Get unit owner '](args[1])", parameter list: unit
