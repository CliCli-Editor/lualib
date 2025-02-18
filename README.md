# y3-lualib

This is the Lua development framework for Y3 Editor, designed to help the most pure Lua developers develop better maps。
This project hopes to jointly develop this framework with the majority of users, so we hope that you can actively put forward suggestions, including the framework design can also put forward their own ideas to discuss together。

# Quick start

## Automatic initialization
* Create a map using the CliCli editor，
* Install the extension in VSCode `sumneko.y3-helper`
* Select "CliCli-Helper" in the left sidebar and click "Initialize CliCli library.”

## Manual initialization
* Create a map using the CliCli editor and open the map directory (default is' < Map Project>/maps/EntryMap`）
* Then replace this project with the 'script/clicli' directory in the map
* You can double-click to run 'script/clicli/initial configuration.bat', it can help you configure the plugin environment and debugger
* Open the script folder with VSCode

> Note: If you are using the 1.0 editor, switch the branch of this project to `1.0`

# Domestic mirror image

If you have difficulty accessing Github, you can use the mirror repository：https://gitee.com/tsukiko/y3-lualib

Note: gitee only provides code images and does not support issues. If you want to submit an issue, please search other github mirror sites on your own。

# illustration

Start with the demoLua!

## screen

contain：
* Main control panel (Avatar, Stats, skills, Inventory, Blood bar, Store）
* Hold down the space or click the avatar to focus the lens on this unit

Enabling method：
* Add 'require "clicli.demo.UI" into Lua code"`
* In the editor click 'Menu Bar' -> 'Plugins' ->' Plugins Mall ', search for 'LuaLib', install 'LuaLib Example - Interface' (Art resources）

## Defense plan

contain：
* Simple 5 wave monster attack
* The hero dies or the monsters on the field fail after more than 30
* Victory when all monsters are destroyed

Enabling method：
* Add 'require "clicli.demo.Defense" into Lua code"`
* In the editor click 'Menu Bar' -> 'Plugins' ->' Plugins Mall ', search for 'LuaLib', install 'LuaLib Example - Defense Chart' (hero, skill, monster compilation data）

## Practice room

contain：
* The hero enters the central zone and spawns
* After the monster dies, it continues to spawn the next wave
* Heroes leave the central zone 5 seconds after monster hours

Enabling method：
* Add 'require "clicli.demo.Practice room" into Lua code"`
* In the editor, click 'Menu Bar' -> 'Plugins' ->' Plugins Mall ', search for 'LuaLib', install 'LuaLib Example - Training Room' (heroes, skills, monsters compilation data）

## Equipment synthesis and store purchase

contain：
* Configuration formula
* Pick up the items on the ground and synthesize according to the formula
* Purchase items in the store, automatically deduct the existing components and deduct the difference

Enabling method：
* Create maps using 'CliCli' objects (objects for demonstration purposes)）
* Add 'require "clicli.demo.craft" into Lua code"`
* In the editor, click 'Menu Bar' -> 'Plugins' ->' Plugins Mall ', search for 'LuaLib', install 'LuaLib Example - Interface' (to display the store）

# Q&A

### How does the framework's code relate to the "ECA to Lua" code？

The vast majority of interfaces will remain compatible, but many features have better implementations for pure Lua authors. For example, the action "add integer to one" in ECA generates a function call when "ECA to Lua", but this function is removed in this framework。
Triggers, events and other functions will also be different from ECA, using Lua language features to use a more convenient form of Lua development。

### I see a lot of functions are simple forwarding, whether you can call directlyCAPI？

Try not to call directly. Because there are currently plans to modify CAPI, calling CAPI directly could create compatibility issues in the future。

### ECAHow does ECA call Lua functions when co-developing with Lua？

ECAlua code can be executed directly, or you can refer to [This code](. demo/ECA call Lua function.lua) to register a binding function for ECA to call。

### Models and effects used in Lua cannot be displayed？

Our model resources are downloaded dynamically and you need to explicitly state which models you use. The way to declare is to create a new table in the form editor, and then fill in the model or effect resource ID you use. This table is not actually used in the game。

### Y3How does the Lua virtual machine differ from the official implementation? Can you use some insecure functions？

Y3For details, see [this document](./doc/Lua Virtual Machine.md)。

### How to use logs

log with 'log.info' (' log content ') in the code, and in development mode the log will be written to '.log/lua_player01.log 'in the script directory. When running on the platform, the log is written to 'custom/lua_player01.log' in the map directory. The last two digits of the file name represent your player ID in the game, and multiple log files are generated when the local multiple is opened. When running on the platform, the full log path is approximately '... / kkduizhan/Games/clicli/2.0 / game/LocalData/etc/maps / < encryption map>/custom/lua_player01.log` 。

If you just want to take a quick look at it, you can use 'print' and it will be displayed directly in the game. Don't forget to remove the map before uploading it `print` 。

# Additional debugging using VSCode

1. VSCodeSearch the Extension Marketplace to install plug-ins `sumneko.y3-helper`。
2. Click on the "CliCli-Helper" view in the left sidebar
3. Click "Start Game and attach debugger" in the view to start debugging (shortcut key：`Shift+F5`）

# Engineering structure

<pre>

📦 y3/
    ├── 📁 <span title="Demo Code "> Demo/</span>
    ├── 📁 <span title="Related implementation of game features">game/</span>
    │    ├── 📜 <span title="Define constants and enumerations">const.lua</span>
    │    ├── 📜 <span title="Interface to implement game functions">game.lua</span>
    │    ├── 📜 <span title="Some common glue functions">helper.lua</span>
    │    ├── 📜 <span title="Convert engine objects to Lua objects">py_converter.lua</span>
    │    ├── 📜 <span title="Bind the engine event system to the Lua event system">py_event_subscribe.lua</span>
    ├── 📂 <span title="Engine API metafile">meta/</span>
    ├── 📂 <span title="LuaObject implementation">object/</span>
    │    ├── 📁 <span title="An editable object in a catalog (as a category only)）">editable_object/</span>
    │    ├── 📁 <span title="Abstract objects that are only available at runtime (as categories only)）">runtime_object/</span>
    │    ├── 📁 <span title="Objects that can be placed in the scene (as categories only）">scene_object/</span>
    ├── 📂 <span title="Some general Lua tools">tools/</span>
    ├── 📂 <span title="Tools based on this game engine">tools/</span>
    ├── 📜 <span title="Debugger configuration">debugger.lua</span>
    └── 📜 <span title="Y3Library entry">init.lua</span>

</pre>

# contributor

![GitHub Contributors Image](https://contrib.rocks/image?repo=y3-editor/y3-lualib)
