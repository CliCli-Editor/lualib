--[[
    UI Basic class entry

    The loading order is very important：
    1. EventBus   → Event bus (the most basic, no dependencies.）
    2. BasePanel  → Panel base class
    3. BaseView   → View base class (optional nested component)）
    4. BaseTips   → Hint base class (Special explicit and implicit logic）
]]

include 'clicli.ui_framework.base.EventBus'
include 'clicli.ui_framework.base.BasePanel'
include 'clicli.ui_framework.base.BaseView'
include 'clicli.ui_framework.base.BaseTips'

--Definition of loading constants
include 'clicli.ui_framework.UIConst'