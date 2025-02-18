# Reload

Hot heavy duty

For methods related to hot reload, see 'Demo/Hot Reload' for details`。

## afterReloadCallbacks

```lua
{ name: string, callback: Reload.afterReloadCallback }[]
```

## beforeReloadCallbacks

```lua
{ name: string, callback: Reload.beforeReloadCallback }[]
```

## defaultReloadOptional

```lua
nil
```

## filter

```lua
(fun(name: string, reload: Reload):boolean)?
```

## fire

```lua
(method) Reload:fire()
```

## getCurrentIncludeName

```lua
function Reload.getCurrentIncludeName()
  -> string?
```

## getIncludeName

```lua
function Reload.getIncludeName(func: function)
  -> string?
```

## include

```lua
function Reload.include(modname: string)
  -> any
  2. loaderdata: unknown
```

 Similar to 'require', but reloads the file on reload。
 An error while loading a file returns false instead of throwing an exception。
## includeStack

```lua
table
```

## includedNameMap

```lua
{ [string]: boolean }
```

## includedNames

```lua
string[]
```

## isReloading

```lua
function Reload.isReloading()
  -> boolean
```

Is loading
## isValidName

```lua
(method) Reload:isValidName(name?: string)
  -> boolean
```

 Whether the module name will be overloaded
## modNameMap

```lua
table
```

## onAfterReload

```lua
function Reload.onAfterReload(callback: Reload.afterReloadCallback)
```

 Register callbacks after reloading
## onBeforeReload

```lua
function Reload.onBeforeReload(callback: Reload.beforeReloadCallback)
```

 Register callbacks before reloading
## optional

```lua
(Reload.Optional)?
```

## recycle

```lua
function Reload.recycle(callback: fun(trash: fun(obj: <R2>):<R2>):<R1>?)
  -> <R1>
```

Execute the callback function immediately, and thereafter whenever overloading occurs，
The callback is executed again。
## reload

```lua
function Reload.reload(optional?: Reload.Optional)
```

 overload
## setDefaultOptional

```lua
function Reload.setDefaultOptional(optional?: Reload.Optional)
```

 Set default overload options
## validMap

```lua
table<string, any>
```


# Reload.Optional

## filter

```lua
fun(name: string, reload: Reload):boolean
```

Filter function
## list

```lua
string[]
```

List of modules to overload

# Reload.afterReloadCallback


```lua
fun(reload: Reload, hasReloaded: boolean)
```


# Reload.beforeReloadCallback


```lua
fun(reload: Reload, willReload: boolean)
```


