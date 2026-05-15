--[[
    UI Basic class entry

    The loading order is very important：
    1. EventBus   → Event bus (the most basic, no dependencies.）
    2. BasePanel  → Panel base class
    3. BaseView   → View base class (optional nested component)）
    4. BaseTips   → Hint base class (Special explicit and implicit logic）
]]

require 'clicli.ui_framework.base.EventBus'
require 'clicli.ui_framework.base.BasePanel'
require 'clicli.ui_framework.base.BaseView'
require 'clicli.ui_framework.base.BaseTips'

--Definition of loading constants
require 'clicli.ui_framework.UIConst'
