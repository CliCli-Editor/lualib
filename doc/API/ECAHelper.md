# ECAHelper

## call

```lua
function ECAHelper.call(...any)
```

Invoke custom events defined in the ECA
## def

```lua
function ECAHelper.def(name: string)
  -> ECAFunction
```

Register ECA functions

You can use this feature to have lua functions called in ECA。
## register_custom_event_impl

```lua
function ECAHelper.register_custom_event_impl(name: string, impl: function)
```


