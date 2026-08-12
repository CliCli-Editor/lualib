--Files loaded with include are marked as overloadable
include 'clicli.example. Hot reload. Overloaded script'

--Send the chat message ".rd "to reload the above file

--You can further specify through configuration that only partial files are overloaded.
--If this is not configured, all reloadable files (files loaded with 'include') are overridden by default.
clicli.reload.setDefaultOptional {
    --Specify files through a list
    list = {
        'clicli.example. Hot reload. Overloaded script',
    },
    --Files that are not in the above list will attempt to call this function. If true is returned, it means overloading is required, otherwise it is not
    filter = function (name, reload)
        if clicli.util.stringStartWith(name, 'clicli.example. Hot reload.') then
            return true
        else
            return false
        end
    end,
}
