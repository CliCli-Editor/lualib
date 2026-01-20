---@class UI
---@field player Player
---@field handle string
---@overload fun(player: Player, ui_name: string): self
local M = Class 'UI'

M.type = 'ui'

---@param player Player
---@param handle string
---@return self
function M:__init(player, handle)
    self.player = player
    self.handle = handle
    self.name   = GameAPI.get_ui_comp_name(player.handle, handle)
    return self
end

function M:__del()
    if self:is_removed() then
        return
    end
    local parent_ui = self:get_parent()
    if parent_ui ~= nil then
        parent_ui:remove_get_child_cache(self.name)
    end
    local player = self.player
    if player._ui_cache then
        player._ui_cache[self.handle] = nil
    end
    GameAPI.del_ui_comp(player.handle, self.handle)
end

function M:__tostring()
    return string.format('{UI|%s|%s} @ %s'
        , self.name
        , self.handle
        , self.player
    )
end

function M:__eq(other)
    return IsInstanceOf(other, 'UI')
        and self.handle == other.handle
end

---@private
M.map = {}

M.comp_id = clicli.proxy.new({}, {
    cache = true,
    anyGetter = function (self, raw, key, config, custom)
        if not GameAPI.get_prefab_ins_id_by_name then
            return key
        end
        local id = GameAPI.get_prefab_ins_id_by_name(key)
        if id == '' or id == nil then
            return key
        else
            return id
        end
    end
})

---@class Player
---@field package _ui_cache table<string, UI>

---Obtain the interface instance of the lua layer from the interface instance of the py layer
---@param player Player
---@param handle string
---@return UI
function M.get_by_handle(player, handle)
    if not player._ui_cache then
        assert(type(player.handle) == 'userdata', 'player.handle is not a userdata?')
        player._ui_cache = setmetatable({}, {
            __mode = 'v',
            __index = function (t, k)
                if not k then
                    return nil
                end
                local ui = New 'UI' (player, k)
                t[k] = ui
                return ui
            end
        })
    end
    local ui = player._ui_cache[handle]
    return ui
end

--Create interface controls
---@param player Player
---@param parent_ui UI ui control
---@ param comp_type clicli. Const. UIComponentType UI controls
---@return UI Returns the lua layer skill instance initialized at the lua layer
function M.create_ui(player, parent_ui, comp_type)
    local py_ui = GameAPI.create_ui_comp(player.handle, parent_ui.handle, clicli.const.UIComponentType[comp_type] or 7)
    return clicli.ui.get_by_handle(player, py_ui)
end

---@param player Player
---@param ui_path string ui object path. Starting from the artboard level 1, the parent node and child node use. link
---@return UI
function M.get_ui(player, ui_path)
    local py_ui = GameAPI.get_comp_by_absolute_path(player.handle, ui_path)
    if not py_ui then
        error(string.format('UI %s does not exist. Note that the UI placed in the interface editor will not be retrieved until after the game initialization event.', ui_path))
    end
    return clicli.ui.get_by_handle(player, py_ui)
end

---@ param comp_type clicli. Const. UIComponentType UI controls
---@return UI Returns the lua layer skill instance initialized at the lua layer
function M:create_child(comp_type)
    return M.create_ui(self.player, self, comp_type)
end

--Create interface event
---@param event clicli.Const.UIEvent Indicates the interface event type
---@param name string Event name
---@param data? Serialization. SupportTypes custom data, in the event by ` data ` field acquisition
---@return string
function M:add_event(event, name, data)
    return GameAPI.create_ui_comp_event_ex_ex(self.handle, clicli.const.UIEventMap[event] or event, name, clicli.dump.encode(data))
end

---@private
M._added_fast_events = {}

--Create quick interface events
---@param event clicli.Const.UIEvent Indicates the interface event type
---@param callback fun(trg: Trigger)
---@return Trigger
function M:add_fast_event(event, callback)
    local id = string.format('$fast_event:%s@%s'
        , event
        , self.handle
    )
    if not M._added_fast_events[id] then
        GameAPI.create_ui_comp_event_ex_ex(self.handle, clicli.const.UIEventMap[event] or event, id, '')
        M._added_fast_events[id] = true
    end
    return self.player:event("Interface - Message", id, callback)
end

--Creating a local interface event
--The callback function is called immediately after the event is triggered and is not synchronized with other players.
--
--> Warning: The callback function is executed on the local player is client, take care to avoid the problem of asynchronism.
---@param event clicli.Const.UIEvent # Interface event type
---@param callback fun(local_player: Player) # Callback function
function M:add_local_event(event, callback)
    assert(clicli.const.UIEventMap[event], 'Invalid event type')
    GameAPI.bind_local_listener(self.handle, clicli.const.UIEventMap[event], function ()
        clicli.player.with_local(function (local_player)
            xpcall(callback, log.error, local_player)
        end)
    end)
end

--Sets the position relative to the parent. This parameter is not recommended because there are bugs in the engine layer. You are advised to manually calculate the location assignment.
---@param direction clicli.Const.UIRelativeParentPosType
---@param offset number # Relative to the parent position
---@return UI
function M:set_relative_parent_pos(direction, offset)
    GameAPI.set_ui_comp_adapt_option(self.player.handle, self.handle, clicli.const.UIRelativeParentPosType[direction], offset)
    return self
end

--Triggers UI events for the player
---@param event_name string
function M:send_event(event_name)
    GameAPI.trigger_ui_event(self.player.handle, self.handle, event_name)
end

--Set UI control visibility
---@param visible boolean Show/hide
---@return self
function M:set_visible(visible)
    GameAPI.set_ui_comp_visible(self.player.handle, visible, self.handle)
    return self
end

---@private
M._image_version = 0

---Set picture
---@param img py.Texture | string Image id
---@return self
function M:set_image(img)
    self._image_version = self._image_version + 1
    ---@diagnostic disable-next-line: param-type-mismatch
    GameAPI.set_ui_comp_image_with_icon(self.player.handle, self.handle, img)
    return self
end

---Set images from the network
---@param url string Image url
---@param aid? string The unique id of the image, which is extracted from the url if not specified. If the aid image already exists locally, the local image is directly used. The file name must be available to the operating system.
---@return self
function M:set_image_url(url, aid)
    local version = self._image_version + 1
    self._image_version = version
    if not aid then
        aid = (url:match('.+/(.+)$') or ''):gsub('%.[^%.]+$', '') or ''
    end
    clicli.game.download_platform_icon(url, aid, function (real_path)
        if version ~= self._image_version then
            return
        end
        --It must be delayed for a short time, otherwise multiple images are set at the same time
        --The Settings of several images failed
        clicli.ltimer.wait(0.1, function ()
            if version ~= self._image_version then
                return
            end
            self:set_image(real_path)
        end)
    end)
    return self
end

--Set picture color
---@param r number Red
---@param g number Green
---@param b number Blue
---@param a number of transparency
---@return self
function M:set_image_color(r, g, b, a)
    GameAPI.set_ui_image_color(self.player.handle, self.handle, r, g, b, a)
    return self
end

--Set image Color (hex)
---@param color string hex
---@param a number of transparency
---@return self
function M:set_image_color_hex(color, a)
    GameAPI.set_ui_image_color_hex(self.player.handle, self.handle, color, a)
    return self
end

--Set text
---@param str string text
---@return self
function M:set_text(str)
    GameAPI.set_ui_comp_text(self.player.handle, self.handle, str)
    return self
end


--Set control transparency
---@param value number Transparency
---@return self
function M:set_alpha(value)
    GameAPI.set_ui_comp_opacity(self.player.handle, self.handle, value)
    return self
end

--Play UI transparency animation
---@param start_alpha number # Start alpha
---@param end_alpha number # End alpha
---@param duration number # duration
---@param ease_type? clicli.Const.EaseType # Curve type
---@return self
function M:set_anim_opacity(start_alpha, end_alpha, duration, ease_type)
    GameAPI.set_ui_comp_anim_opacity(self.player.handle, self.handle, start_alpha, end_alpha, duration, ease_type)
    return self
end

--Sets whether the control can be dragged
---@param isdrag boolean Specifies whether to drag
---@return self
function M:set_is_draggable(isdrag)
    GameAPI.set_ui_comp_drag(self.player.handle, self.handle, isdrag)
    return self
end


--Sets whether the control blocks operations
---@param intercepts boolean Specifies whether to intercept an operation
---@return self
function M:set_intercepts_operations(intercepts)
    GameAPI.set_ui_comp_swallow(self.player.handle, self.handle, intercepts)
    return self
end


--Set control depth
---@param deep integer Indicates the depth
---@return self
function M:set_z_order(deep)
    GameAPI.set_ui_comp_z_order(self.player.handle, self.handle, deep)
    return self
end


--The maximum value of the progress bar is set
---@param progress number Indicates the maximum number of progress bars
---@return self
function M:set_max_progress_bar_value(progress)
    GameAPI.set_progress_bar_max_value(self.player.handle, self.handle, progress)
    return self
end


--Set the current value of the progress bar
---@param progress number Current value of the progress bar
---@param time number? Gradient time
---@return self
function M:set_current_progress_bar_value(progress, time)
    GameAPI.set_progress_bar_current_value(self.player.handle, self.handle, progress, time or 0)
    return self
end


--Enable/disable button
---@param enable boolean Enable/Disable button
---@return self
function M:set_button_enable(enable)
    GameAPI.set_ui_comp_enable(self.player.handle, self.handle, enable)
    return self
end


--Set control size
---@param width number Width
---@param height number Height
---@return self
function M:set_ui_size(width, height)
    GameAPI.set_ui_comp_size(self.player.handle, self.handle, width, height)
    return self
end

--Set control 9 grid
---@param x_left integer # x
---@param x_right integer # y
---@param y_top integer # width
---@param y_bottom integer # height
---@return self
function M:set_ui_9(x_left, x_right, y_top, y_bottom)
    GameAPI.set_ui_comp_cap_insets(self.player.handle, self.handle, x_left, x_right, y_top, y_bottom)
    return self
end

--Set controls. 9 Grid enabled
---@param switch boolean # Enable/disable
---@return self
function M:set_ui_9_enable(switch)
    GameAPI.set_ui_comp_scale_9_enable(self.player.handle, self.handle, switch)
    return self
end

--Set the text font size
---@param size integer Specifies the font size
---@return self
function M:set_font_size(size)
    GameAPI.set_ui_comp_font_size(self.player.handle, self.handle, size)
    return self
end

--Let the input field get focus
---@return self
function M:set_input_field_focus()
    GameAPI.set_input_field_focus(self.player.handle, self.handle)
    return self
end

--Make the input field lose focus
---@return self
function M:set_input_field_not_focus()
    GameAPI.set_input_field_not_focus(self.player.handle, self.handle)
    return self
end

--Set the list view percentage
---@param percent number # percent
function M:set_list_view_percent(percent)
    GameAPI.set_list_view_percent(self.player.handle, self.handle, percent)
end

--Bind a skill object to a control
---@param skill? Ability skill object
---@return self
function M:set_skill_on_ui_comp(skill)
    local handle = skill and skill.handle or nil
    ---@diagnostic disable-next-line: param-type-mismatch
    GameAPI.set_skill_on_ui_comp(self.player.handle, handle, self.handle)
    return self
end

--Binding skill
---@param ability? Ability skill object
---@return self
function M:bind_ability(ability)
    return self:set_skill_on_ui_comp(ability)
end

--Bind units to the Magic Effects Display bar component
---@param unit Unit Unit
---@return self
function M:set_buff_on_ui(unit)
    GameAPI.set_buff_on_ui_comp(self.player.handle, unit.handle, self.handle)
    return self
end


--Bind item objects to item components
---@param item Item Object
---@return self
function M:set_item_on_ui(item)
    GameAPI.set_item_on_ui_comp(self.player.handle, item.handle, self.handle)
    return self
end

--Set the default game interface switch
---@param player Player
---@param visible boolean Game interface switch
function M.set_prefab_ui_visible(player,visible)
    GameAPI.set_prefab_ui_visible(player.handle, visible)
end


--Sets the model of the model control
---@param modelid py.ModelKey Model id
---@return self
function M:set_ui_model_id(modelid)
    ---@diagnostic disable-next-line: missing-parameter
    GameAPI.set_ui_model_id(self.player.handle, self.handle, modelid)
    return self
end

--Sets the unit of the UI model control
---@param model_unit Unit
---@param clone_effect? boolean # Inheritance effect
---@param clone_attach? boolean # Inherit the mount model
---@param clone_material? boolean # Inherited material change
function M:set_ui_model_unit(model_unit, clone_effect, clone_attach, clone_material)
    GameAPI.set_ui_model_unit(self.player.handle, self.handle, model_unit.handle, clone_effect, clone_attach, clone_material)
end

--Change the minimap picture
---@param player Player
---@param img py.Texture Image id
function M.change_mini_map_img(player,img)
    GameAPI.change_mini_map_img_with_icon(player.handle, img)
end

--Set the minimap display area
---@param player Player
---@param rect_area Area Indicates a rectangular area
function M.set_minimap_show_area(player, rect_area)
    GameAPI.set_min_map_show_area(player.handle, rect_area.handle --[[@as py.RecArea]])
end

--Sets the item component binding unit
---@param unit Unit
---@param field clicli.Const.SlotType Indicates the slot type of a backpack
---@param index integer Specifies the lattice position
---@return self
function M:set_ui_unit_slot(unit, field, index)
    GameAPI.set_ui_comp_unit_slot(self.player.handle, self.handle, unit.handle, field, index)
    return self
end

--Set button shortcut keys
---@param key integer Specifies the shortcut key
---@return self
function M:set_button_shortcut(key)
    GameAPI.set_btn_short_cut(self.player.handle, self.handle, key)
    return self
end

--Set button combination shortcut keys
---@param key integer Specifies the secondary key
---@return self
function M:set_btn_meta_key(key)
    GameAPI.set_btn_func_short_cut(self.player.handle, self.handle, key)
    return self
end

--Set the text of the button in different states
---@ param status clicli. Const. UIButtonStatus state
---@param text string Indicates the text
---@return self
function M:set_btn_status_string(status, text)
    GameAPI.set_ui_btn_status_string(self.player.handle, self.handle, status, text)
    return self
end

--Set buttons in different states of the picture
---@ param status clicli. Const. UIButtonStatus state
---@param img integer Image id
---@return self
function M:set_btn_status_image(status, img)
    GameAPI.set_ui_btn_status_image(self.player.handle, self.handle, status, img)
    return self
end

--Set the smart casting shortcut key
---@param key integer Specifies the shortcut key
---@return self
function M:set_skill_btn_smart_cast_key(key)
    GameAPI.set_skill_btn_smart_cast_key(self.player.handle, self.handle, key)
    return self
end


--Set smart spell combination shortcut keys
---@param key integer Specifies the secondary key
---@return self
function M:set_skill_btn_func_meta_key(key)
    GameAPI.set_skill_btn_func_smart_cast_key(self.player.handle, self.handle, key)
    return self
end


--Play/Stop Skill button activation effect
---@param isopen boolean Play/Stop skill button activation effect
---@return self
function M:set_skill_btn_action_effect(isopen)
    GameAPI.set_skill_btn_action_effect(self.player.handle, self.handle, isopen)
    return self
end


---Set text color
---@param r number # Red (0-255)
---@param g number # Green (0-255)
---@param b number # Blue (0-255)
---@param a? number # Opacity (0-255)
---@return self
function M:set_text_color(r, g, b, a)
    GameAPI.set_ui_comp_font_color(self.player.handle, self.handle, r, g, b, a or 255)
    return self
end

---Set text color (HEX)
---@param color string # For example, ffcc00
---@param a? number # Opacity: 0 is completely transparent and 100 is completely opaque
---@return self
function M:set_text_color_hex(color, a)
    GameAPI.set_ui_comp_font_color_hex(self.player.handle, self.handle, color, a or 100)
    return self
end


--Sets the lens view of the model control
---@param fov number Field of view
---@return self
function M:change_showroom_fov(fov)
    GameAPI.change_showroom_fov(self.player.handle, self.handle, fov)
    return self
end


--Sets the lens coordinates of the model control
---@param x number x axis
---@param y number y axis
---@param z number z axis
---@return self
function M:change_showroom_cposition(x,y,z)
    GameAPI.change_showroom_cposition(self.player.handle, self.handle, x, y, z)
    return self
end


--Set the lens rotation of the model control
---@param x number x axis
---@param y number y axis
---@param z number z axis
---@return self
function M:change_showroom_crotation(x,y,z)
    GameAPI.change_showroom_crotation(self.player.handle, self.handle, x, y, z)
    return self
end


--System message prompt
---@param player Player
---@param msg string Message
---@param time number Duration
---@param isSupportLanguage? boolean Specifies whether locale is supported
function M.display_message(player, msg, time, isSupportLanguage)
    GameAPI.show_tips_text(player.handle, msg, Fix32(time), isSupportLanguage)
end

--Set the background color of the interface model control
---@param r number Red
---@param g number Green
---@param b number Blue
---@param a number of transparency
---@return self
function M:set_show_room_background_color(r, g, b, a)
    GameAPI.set_show_room_background_color(self.player.handle, self.handle, r, g, b, a)
    return self
end

--Set the control to rotate relative to each other
---@param rot number Angle
---@return self
function M:set_widget_relative_rotation(rot)
    GameAPI.set_ui_comp_rotation(self.player.handle,self.handle, rot)
    return self
end


--Sets the absolute coordinates of the control
--> Same as UI:set_absolute_pos
---@param x number x axis
---@param y number y axis
---@return self
function M:set_widget_absolute_coordinates(x,y)
    GameAPI.set_ui_comp_world_pos(self.player.handle,self.handle, x, y)
    return self
end


--Sets the absolute rotation of the control
---@param rot number Angle
---@return self
function M:set_widget_absolute_rotation(rot)
    GameAPI.set_ui_comp_world_rotation(self.player.handle,self.handle, rot)
    return self
end


--Sets the absolute scaling of the control
---@param x number x axis
---@param y number y axis
---@return self
function M:set_widget_absolute_scale(x, y)
    GameAPI.set_ui_comp_world_scale(self.player.handle,self.handle, x, y)
    return self
end


--Set the relative scaling of controls
---@param x number x axis
---@param y number y axis
---@return self
function M:set_widget_relative_scale(x, y)
    GameAPI.set_ui_comp_scale(self.player.handle,self.handle, x, y)
    return self
end


--Set the minimap display mode
---@param player Player
---@param type integer Indicates the minimap display mode
function M.change_minimap_display_mode(player,type)
    GameAPI.change_mini_map_color_type(player.handle,type)
end


--Set the progress of the slider
---@param percent number The progress of the slider
---@return self
function M:set_slider_value(percent)
    GameAPI.set_slider_cur_percent(self.player.handle,self.handle, percent)
    return self
end

--Unbind control
---@return self
function M:unbind_widget()
    GameAPI.unbind_ui_comp(self.player.handle,self.handle)
    return self
end

--Traverse the child nodes of an interface control
--The name is too long, use 'get_childs' instead
---@return UI[]
function M:get_ui_comp_children()
    return self:get_childs()
end

--Traverse the child nodes of an interface control
---@return UI[]
function M:get_childs()
    local py_list = GameAPI.get_ui_comp_children(self.player.handle, self.handle)
    local uis = clicli.helper.unpack_list(py_list, function (py_object)
        return clicli.ui.get_by_handle(self.player, py_object)
    end)
    return uis
end

--Play timeline animation
---@param player Player
---@param anim string | clicli.Const.UIAnimKey Animation
---@param speed? number Playback speed
---@param mode? boolean | 'Keep' | 'regular' | 'reciprocating' | 'loop' play mode
---@param start? integer Start frame
---@param finish? integer End frame
function M.play_timeline_animation(player, anim, speed, mode, start, finish)
    local playMode
    if mode == true or mode == 'Loop' then
        playMode = 3
    elseif mode == 'hold' then
        playMode = 0
    elseif mode == 'routine' then
        playMode = 1
    elseif mode == 'Go back and forth' then
        playMode = 2
    end
    --TODO see question 7
    ---@diagnostic disable-next-line: redundant-parameter
    GameAPI.play_ui_comp_anim_new(
        player.handle,
    ---@diagnostic disable-next-line: param-type-mismatch
        clicli.const.UIAnimKey[anim] or anim,
        start,
        finish,
        speed,
        playMode
    )
end

--Play animation move
---@param start_x number # Start x
---@param start_y number # Start y
---@param end_x number # End x
---@param end_y number # End y
---@param duration number # duration
---@param ease_type? integer # Curve type
---@return UI
function M:set_anim_pos(start_x, start_y, end_x, end_y, duration, ease_type)
    GameAPI.set_ui_comp_anim_pos(self.player.handle, self.handle, start_x, start_y, end_x, end_y, duration, ease_type)
    return self
end

--Play the UI zoom animation
---@param start_x number # Start x
---@param start_y number # Start y
---@param end_x number # End x
---@param end_y number # End y
---@param duration number # duration
---@param ease_type? integer # Curve type
---@return self
function M:set_anim_scale(start_x, start_y, end_x, end_y, duration, ease_type)
    GameAPI.set_ui_comp_anim_scale(self.player.handle, self.handle, start_x, start_y, end_x, end_y, duration, ease_type)
    return self
end

--Sets the model control observation point
---@param x number x axis
---@param y number y axis
---@param z number z axis
---@return self
function M:set_ui_model_focus_pos(x, y, z)
    GameAPI.set_ui_model_focus_pos(self.player.handle, self.handle, x, y, z)
    return self
end

--Bind unit properties to the properties of the player interface control
--> Use 'UI:bind_unit_attr' instead
---@deprecated
---@param uiAttr string Interface control property
---@param attr string Unit attribute
---@param accuracy integer Decimal accuracy
---@return self
function M:bind_player_attribute(uiAttr, attr, accuracy)
    GameAPI.set_ui_comp_bind_attr(self.player.handle, self.handle, uiAttr, attr, accuracy)
    return self
end

--Bind unit properties to the properties of the player interface control
---@param uiAttr clicli.Const.UIAttr interface control properties
---@param attr_name clicli.Const.UnitAttr Unit attribute
---@param accuracy? integer Specifies the decimal precision. The default value is 0
---@return self
function M:bind_unit_attr(uiAttr, attr_name, accuracy)
    GameAPI.set_ui_comp_bind_attr(self.player.handle, self.handle, clicli.const.UIAttr[uiAttr], clicli.const.UnitAttr[attr_name] or attr_name, accuracy or 0)
    return self
end

--Bind player properties to the properties of the player interface control
---@param uiAttr clicli.Const.UIAttr interface control properties
---@param player Player # Player
---@param attr_or_var clicli.Const.PlayerAttr # Player attribute key
---@param accuracy? integer Specifies the decimal precision. The default value is 0
---@return self
function M:bind_player_prop(uiAttr, player, attr_or_var, accuracy)
    GameAPI.set_ui_comp_bind_player_prop(self.player.handle, self.handle, clicli.const.UIAttr[uiAttr] or uiAttr, player.handle, clicli.const.PlayerAttr[attr_or_var] or attr_or_var, accuracy or 0)
    return self
end

--Bind global variables to properties of player interface controls
---@param uiAttr clicli.Const.UIAttr | string Interface control property
---@param globalVar string Global attribute
---@param accuracy? integer decimal precision
---@return self
function M:bind_global_variable(uiAttr, globalVar, accuracy)
    GameAPI.set_ui_comp_bind_var(self.player.handle, self.handle, clicli.const.UIAttr[uiAttr] or uiAttr, globalVar, accuracy or 0)
    return self
end

---Format the text, such as' %.2f 'to keep two decimals
---@param format_str string
function M:set_text_format(format_str)
    GameAPI.set_ui_comp_bind_format(self.player.handle, self.handle, format_str)
end

--Unbind interface control properties
---@param uiAttr string Interface control property
---@return self
function M:unbind(uiAttr)
    GameAPI.ui_comp_unbind(self.player.handle, self.handle, uiAttr)
    return self
end

--Interface control properties bind to specified units
---@param unit Unit Unit
---@return self
function M:bind_unit(unit)
    GameAPI.ui_comp_bind_unit(self.player.handle, self.handle, unit.handle)
    return self
end

--Set Disable images (image type)
---@param img integer Image id
---@return self
function M:set_disable_image_type(img)
    GameAPI.set_ui_comp_disabled_image(self.player.handle, self.handle, img)
    return self
end

--Set floating image (image type)
---@param img integer Image id
---@return self
function M:set_hover_image_type(img)
    GameAPI.set_ui_comp_suspend_image(self.player.handle, self.handle, img)
    return self
end

--Settings Press Picture (Picture type)
---@param img integer Image id
---@return self
function M:set_press_image_type(img)
    GameAPI.set_ui_comp_press_image(self.player.handle, self.handle, img)
    return self
end

--Sets the alignment of the text
---@param h? clicli.Const.UIHAlignmentType # Horizontal alignment
---@param v? clicli.Const.UIVAlignmentType # Vertical alignment
---@return self
function M:set_text_alignment(h, v)
    if h then
        GameAPI.set_ui_comp_align(self.player.handle, self.handle, clicli.const.UIHAlignmentType[h])
    end
    if v then
        GameAPI.set_ui_comp_align(self.player.handle, self.handle, clicli.const.UIVAlignmentType[v])
    end
    return self
end

--Turn on drawing the unit path line
---@param player Player
---@param unit Unit Unit
function M.enable_drawing_unit_path(player, unit)
    GameAPI.enable_unit_path_drawing(player.handle, unit.handle)
end

--Turn off drawing unit path lines
---@param player Player
---@param unit Unit Unit
function M.disable_drawing_unit_path(player, unit)
    GameAPI.disable_unit_path_drawing(player.handle, unit.handle)
end

--Delete interface controls
function M:remove()
    Delete(self)
end

--Whether to be deleted
function M:is_removed()
    return not GameAPI.ui_comp_is_exist(self.handle)
end

--Bind skill cooldowns to attributes of player interface controls
---@param uiAttr string Interface control property
---@param skill Ability
---@param isSmooth? Whether boolean is smooth
---@param digits? integer Decimal places
---@return self
function M:bind_ability_cd(uiAttr, skill, isSmooth, digits)
    GameAPI.set_ui_comp_bind_ability_cd(self.player.handle, self.handle, uiAttr, skill.handle, isSmooth, digits)
    return self
end

--Bind the remaining time of the magic effect to the properties of the player interface control
---@param uiAttr string Interface control property
---@param buff Buff Magic effect
---@return self
function M:bind_buff_time(uiAttr, buff)
    GameAPI.set_ui_comp_bind_modifier_cd(self.player.handle, self.handle, uiAttr, buff.handle)
    return self
end

--Enable or disable the send chat function
---@param enable boolean Enables or disables the send chat function
---@return self
function M:enable_chat(enable)
    GameAPI.set_chat_send_enabled(self.player.handle, self.handle, enable)
    return self
end

--Show/hide the chat box
---@param enable boolean Shows/hides chat boxes
---@param player Player Target player
---@return self
function M:show_chat(player, enable)
    GameAPI.set_player_chat_show(self.player.handle, self.handle, player.handle,enable)
    return self
end

--Clear chat messages
---@return self
function M:clear_chat()
    GameAPI.clear_player_chat_panel(self.player.handle, self.handle)
    return self
end

--Send private chat messages
---@param player Player
---@param msg string Information
---@return self
function M:send_chat(player, msg)
    GameAPI.send_chat_to_role(self.player.handle, self.handle, player.handle, msg)
    return self
end

--Gets the current checked status of the check box
---@return boolean # Currently selected
function M:get_checkbox_selected()
    return GameAPI.get_checkbox_selected(self.player.handle, self.handle)
end

--Create floating text
--> Use 'UI.create_floating_text2' instead
---@deprecated
---@param point Point
---@ param text_type clicli. Const. HarmTextType jumps type
---@param str string text
---@param player_group? PlayerGroup Player group
---@param jump_word_track? integer Specifies the type of the hop trace
function M.create_floating_text(point, text_type, str, player_group, jump_word_track)
    --TODO see question 2
    ---@diagnostic disable-next-line: param-type-mismatch
    GameAPI.create_harm_text_ex(point.handle, clicli.const.HarmTextType[text_type] or text_type, str, (player_group or clicli.player_group.get_all_players()).handle, jump_word_track or 0)
end

--Create floating text
---@param point Point
---@ param text_type clicli. Const. FloatTextType | string | integer type
---@param str string text
---@param jump_word_track? Clicli. Const. FloatTextJumpType jumps track type, if not preach will use random trajectory
---@param player_group? PlayerGroup A visible group of players. Passing in 'nil' means that all players are visible
function M.create_floating_text2(point, text_type, str, jump_word_track, player_group)
    GameAPI.create_harm_text_ex(
        --TODO see question 2
        ---@diagnostic disable-next-line: param-type-mismatch
        point.handle,
        ---@diagnostic disable-next-line: param-type-mismatch
        clicli.const.FloatTextType[text_type] or text_type,
        str,
        (player_group or clicli.player_group.get_all_players()).handle,
        ---@diagnostic disable-next-line: param-type-mismatch
        clicli.const.FloatTextJumpType[jump_word_track] or jump_word_track or 0
    )
end

--Set window type
---@param player Player
---@param window_mode Game.WindowMode Window type
function M.set_window_mode(player, window_mode)
    GameAPI.set_window_type(player.handle, window_mode)
end

--Set image quality
---@param player Player
---@param quality string Image quality
function M.set_graphics_quality(player, quality)
    GameAPI.set_image_quality(player.handle, quality)
end

--Screen resolution
---@param player Player
---@param x number x axis
---@param y number y axis
function M.set_screen_resolution(player, x, y)
    GameAPI.set_screen_resolution(player.handle, x, y)
end

--Gets the X of the relative coordinate of the local control
---@return number x x relative coordinates
function M:get_relative_x()
    return clicli.helper.tonumber(GameAPI.get_ui_comp_pos_x(self.handle)) or 0.0
end

--Gets the Y of the relative coordinate of the local control
---@return number y y coordinates
function M:get_relative_y()
    return clicli.helper.tonumber(GameAPI.get_ui_comp_pos_y(self.handle)) or 0.0
end

--Gets the X of the absolute coordinate of the local control
---@return number x x Absolute coordinates
function M:get_absolute_x()
    return clicli.helper.tonumber(GameAPI.get_ui_comp_world_pos_x(self.handle)) or 0.0
end

--Gets the Y of the absolute coordinate of the local control
---@return number y y absolute coordinates
function M:get_absolute_y()
    return clicli.helper.tonumber(GameAPI.get_ui_comp_world_pos_y(self.handle)) or 0.0
end

--Gets local control relative rotation
---@return number rot Relative rotation
function M:get_relative_rotation()
    return clicli.helper.tonumber(GameAPI.get_ui_comp_rotation(self.handle)) or 0.0
end

--Gets the local control absolute rotation
---@return number rot Absolute rotation
function M:get_absolute_rotation()
    return clicli.helper.tonumber(GameAPI.get_ui_comp_world_rotation(self.handle)) or 0.0
end

--Gets X of the relative scaling of the local control
---@return number x x Relative scaling
function M:get_relative_scale_x()
    return clicli.helper.tonumber(GameAPI.get_ui_comp_scale_x(self.handle)) or 0.0
end

--Gets the relative scaling Y of the local control
---@return number y y Absolute scaling
function M:get_relative_scale_y()
    return clicli.helper.tonumber(GameAPI.get_ui_comp_scale_y(self.handle)) or 0.0
end

--Gets the absolute scaling X of the local control
---@return number x x Absolute scaling
function M:get_absolute_scale_x()
    return clicli.helper.tonumber(GameAPI.get_ui_comp_world_scale_x(self.handle)) or 0.0
end

--Gets the absolute scaling Y of the local control
---@return number y y Absolute scaling
function M:get_absolute_scale_y()
    return clicli.helper.tonumber(GameAPI.get_ui_comp_world_scale_y(self.handle)) or 0.0
end

--Set animation rotation
---@param start_rotation number # Start spinning
---@param end_rotation number # End rotation
---@param duration number # duration
---@param ease_type? integer # Curve type
function M:set_anim_rotate(start_rotation, end_rotation, duration, ease_type)
    GameAPI.set_ui_comp_anim_rotate(self.player.handle, self.handle, start_rotation, end_rotation, duration, ease_type)
end

--Convert the interface control to a string
---@return string str string
function M:to_string()
    return GlobalAPI.comp_to_str(self.handle)
end

--Gets the current value of the slider
---@return number slider_value Current value of the slider
function M:get_slider_current_value()
    return clicli.helper.tonumber(GameAPI.get_slider_cur_percent(self.handle)) or 0.0
end

--Gets the name of the interface control
---@return string uiname control name
function M:get_name()
    return GameAPI.get_ui_comp_name(self.player.handle, self.handle)
end

--Gets the child control with the specified name
---@param name string
---@return UI ui_comp ui control
function M:get_child(name)
    local py_ui
    if not clicli.config.cache.ui then
        py_ui = GameAPI.get_comp_by_path(self.player.handle, self.handle, name)
    else
        if not self._get_child_py_ui_cache then
            ---@private
            self._get_child_py_ui_cache = setmetatable({}, {
                __index = function(t, k)
                    local py_ui_ = GameAPI.get_comp_by_path(self.player.handle, self.handle, k)
                    t[k] = py_ui_
                    return py_ui_
                end
            })
        end
        py_ui = self._get_child_py_ui_cache[name]
    end
    if not py_ui or py_ui == '' then
        ---@diagnostic disable-next-line: return-type-mismatch
        return nil
    end
    return clicli.ui.get_by_handle(self.player, py_ui)
end

---@package
function M:remove_get_child_cache(name)
    if self._get_child_py_ui_cache then
        self._get_child_py_ui_cache[name] = nil
    end
end

--Get control width
---@return number width Control width
function M:get_width()
    return GameAPI.get_ui_comp_width(self.handle)
end

--Gain control height
---@return number height Height of the control
function M:get_height()
    return GameAPI.get_ui_comp_height(self.handle)
end

--Gets the true width of the control
--> Note: This result is not synchronized
---@return number width True width of the control
function M:get_real_width()
    if self.player:get_state() ~= 1 then
        return 0
    end
    local r = GameAPI.get_role_ui_comp_real_width(self.player.handle, self.handle)
    if type(r) == 'number' then
        return r
    else
        ---@cast r py.Fixed
        return clicli.helper.tonumber(r) or 0.0
    end
end

--Gets the control is true height
--> Note: This result is not synchronized
---@return number height The actual height of the control
function M:get_real_height()
    if self.player:get_state() ~= 1 then
        return 0
    end
    local r = GameAPI.get_role_ui_comp_real_height(self.player.handle, self.handle)
    if type(r) == 'number' then
        return r
    else
        ---@cast r py.Fixed
        return clicli.helper.tonumber(r) or 0.0
    end
end

--Gets the parent of the interface control
---@return UI? ui_comp ui control
function M:get_parent()
    local py_ui = GameAPI.get_ui_comp_parent(self.player.handle, self.handle)
    if not py_ui then
        return nil
    end
    return clicli.ui.get_by_handle(self.player, py_ui)
end

--Get the text of the player input box
---@return string msg Indicates the text content
function M:get_input_field_content()
    return GameAPI.get_input_field_content(self.player.handle, self.handle)
end

--Gain control visibility
---@return boolean ui_visible control visibility
function M:is_visible()
    return GameAPI.get_ui_comp_visible(self.player.handle, self.handle)
end

--Gain real visibility into the control
---@return boolean
function M:is_real_visible()
    ---@type UI?
    local tmp = self
    while tmp and tmp:is_visible() do
        tmp = tmp:get_parent()
    end
    return tmp == nil
end

---Sets the relative coordinates of the control
---@param x number x axis
---@param y number y axis
---@return self
function M:set_pos(x, y)
    GameAPI.set_ui_comp_pos_no_trans(self.player.handle, self.handle, x, y)
    return self
end

---Sets the absolute coordinates of the control
---@param x number x axis
---@param y number y axis
---@return self
function M:set_absolute_pos(x, y)
    GameAPI.set_ui_comp_world_pos(self.player.handle, self.handle, x, y)
    return self
end

---Set the anchor point of the interface control
---@param x number x axis
---@param y number y axis
---@return self
function M:set_anchor(x, y)
    GameAPI.set_ui_comp_anchor(self.player.handle, self.handle, x, y)
    return self
end

---Set up a chat channel
---@param switch boolean switch
---@return self
function M:set_nearby_micro_switch(switch)
    GameAPI.set_ui_comp_chat_channel(self.player.handle, self.handle, switch)
    return self
end

--Gets the screen landscape resolution
---@return integer horizontal_res Horizontal resolution
function M.get_screen_width()
    return GameAPI.get_screen_x_resolution()
end

--Gets the screen portrait resolution
---@return integer vertical_res Vertical resolution
function M.get_screen_height()
    return GameAPI.get_screen_y_resolution()
end

--Get window width
---@return integer
function M.get_window_width()
    return GameAPI.get_window_real_x_size()
end

--Get window height
---@return integer
function M.get_window_height()
    return GameAPI.get_window_real_y_size()
end

--Set controls to follow the mouse
---@param follow_mouse boolean
---@param offset_x? number # Offset X-axis
---@param offset_y? number # Offset Y-axis
---@return self
function M:set_follow_mouse(follow_mouse, offset_x, offset_y)
    GameAPI.set_ui_comp_follow_mouse(self.player.handle, self.handle, follow_mouse, offset_x or 0, offset_y or 0)
    return self
end

--Set mouse style
---@param player Player
---@param state clicli.Const.CursorState
---@param key py.CursorKey
---@return self
function M:set_cursor(player, state, key)
    player.handle:api_set_role_cursor(
        clicli.const.CursorState[state],
        key
    )
    return self
end

--Set the sequence frame picture
---@param image_id integer # Sequence frame picture ID
function M:set_sequence_image(image_id)
    GameAPI.set_ui_comp_sequence(self.player.handle, self.handle, image_id)
end

--Play sequence frame
---@param loop? boolean # Cyclic or not
---@param space? number # Interval frame number
---@param start_frame? integer # Start frame
---@param end_frame? integer # End frame
---@return self
function M:play_ui_sequence(loop, space, start_frame, end_frame)
    ---@diagnostic disable-next-line: param-type-mismatch
    GameAPI.play_ui_comp_sequence(self.player.handle, self.handle, loop or false, space or 0.1, start_frame or 0, end_frame or -1)
    return self
end

--Stop playing sequence frames
function M:stop_ui_sequence()
    GameAPI.stop_ui_comp_sequence(self.player.handle, self.handle)
end

---@enum(key) Item.UseOperation
local use_operation_map = {
    ['None'] = 0,
    ['LeftClick'] = 1,
    ['RightClick'] = 2,
    ['LeftClickAndDouble-click'] = 3,
}

--Set how to use items
---@param use_operation Item.UseOperation # Mode of operation
function M:set_equip_slot_use_operation(use_operation)
    GameAPI.set_equip_slot_use_operation(self.player.handle, self.handle, use_operation_map[use_operation] or 0)
end

---@enum(key) Item.DrapOperation
local drag_operation_map = {
    ['None'] = 0,
    ['LeftButton'] = 1,
    ['RightClick'] = 2,
}

--Set how to drag and drop items
---@param drag_operation Item.DrapOperation # Mode of operation
function M:set_equip_slot_drag_operation(drag_operation)
    GameAPI.set_equip_slot_drag_operation(self.player.handle, self.handle, drag_operation_map[drag_operation] or 0)
end

--Add the UI to the grid list
---@param child UI
---@param child_index? integer is the last one by default, and also the last one if the position is greater than the current maximum
function M:insert_ui_gridview_comp(child, child_index)
    ---@diagnostic disable-next-line: param-type-mismatch
    GameAPI.insert_ui_gridview_comp(self.player.handle, child.handle, self.handle, child_index)
end

--Set the grid list layout
---@param layout_type integer # Layout mode
function M:set_ui_gridview_type(layout_type)
    GameAPI.set_ui_gridview_type(self.player.handle, self.handle, layout_type)
end

--Set the number of rows in the grid list
---@param row_count integer # Line number
---@param column_count integer # Number of columns
function M:set_ui_gridview_count(row_count, column_count)
    GameAPI.set_ui_gridview_count(self.player.handle, self.handle, row_count, column_count)
end

--Sets the width and height of the grid list cells
---@param width number # wide
---@param height number # high
function M:set_ui_gridview_size(width, height)
    GameAPI.set_ui_gridview_size(self.player.handle, self.handle, width, height)
end

--Set the grid list margin
---@param top number # Up.
---@param bottom number # Under the
---@param left number # The left
---@param right number # right
function M:set_ui_gridview_margin(top, bottom, left, right)
    GameAPI.set_ui_gridview_margin(self.player.handle, self.handle, top, bottom, left, right)
end

--Set the grid list cell spacing
---@param row number # Line spacing (vertical)
---@param col number # Column spacing (horizontal)
function M:set_ui_gridview_space(row, col)
    GameAPI.set_ui_gridview_space(self.player.handle, self.handle, row, col)
end

--Set the grid list alignment
---@param align_type integer # Alignment mode
function M:set_ui_gridview_align(align_type)
    GameAPI.set_ui_gridview_align(self.player.handle, self.handle, align_type)
end

--Set the grid list to enable/disable scrolling
---@param enable boolean # Enable or not
function M:set_ui_gridview_scroll(enable)
    GameAPI.set_ui_gridview_scroll(self.player.handle, self.handle, enable)
end

--Set mesh list Enable/Disable size change with content
---@param enable boolean # Enable or not
function M:set_ui_gridview_size_adaptive(enable)
    GameAPI.set_ui_gridview_size_adaptive(self.player.handle, self.handle, enable)
end

--Set the percentage of horizontal/vertical jumps in the grid list
---@param direction integer # Horizontal/vertical
---@param ratio number # percent
function M:set_ui_gridview_bar_percent(direction, ratio)
    GameAPI.set_ui_gridview_bar_percent(self.player.handle, self.handle, direction, ratio)
end

--Sets the parent control of an interface control
---@param parent_uid string # Parent control uid
---@param keep_pos? boolean # Hold position
---@param keep_rotation? boolean # Hold rotation
---@param keep_scale? boolean # Hold scale
function M:set_ui_comp_parent(parent_uid, keep_pos, keep_rotation, keep_scale)
    local parent_ui = self:get_parent()
    if parent_ui ~= nil then
        parent_ui:remove_get_child_cache(self.name)
    end
    GameAPI.set_ui_comp_parent(self.player.handle, self.handle, parent_uid, keep_pos, keep_rotation, keep_scale)
end

--Clear the UI control picture
function M:clear_ui_comp_image()
    GameAPI.clear_ui_comp_image(self.player.handle, self.handle)
end

---Set the list to allow/disable scrolling
---@param enable boolean # Roll allowed or not
function M:set_scrollview_scroll(enable)
    GameAPI.set_ui_scrollview_scroll(self.player.handle, self.handle, enable)
end

--Effects controls play effects
---@param effect_id integer # Special effect id
---@param is_loop? boolean # Cyclic or not
function M:play_ui_effect(effect_id, is_loop)
    ---@diagnostic disable-next-line: param-type-mismatch
    GameAPI.set_ui_effect_id(self.player.handle, self.handle, effect_id, is_loop)
end

--Sets the background color of the effects control
---@param r number # R
---@param g number # G
---@param b number # B
---@param a number # A
function M:set_effect_background_color(r, g, b, a)
    GameAPI.set_ui_effect_background_color(self.player.handle, self.handle, r, g, b, a)
end

--Set the camera viewport of the effects control
---@param fov number # fov
function M:set_effect_camera_fov(fov)
    GameAPI.set_ui_effect_camera_fov(self.player.handle, self.handle, fov)
end

--Sets the lens coordinates of the effects control
---@param x number # x
---@param y number # y
---@param z number # z
function M:set_effect_camera_pos(x, y, z)
    GameAPI.set_ui_effect_camera_pos(self.player.handle, self.handle, x, y, z)
end

--Set the camera rotation of the effects control
---@param pitch number # pitch
---@param roll number # roll
---@param yaw number # yaw
function M:set_effect_camera_rotation(pitch, roll, yaw)
    GameAPI.set_ui_effect_camera_rotation(self.player.handle, self.handle, pitch, roll, yaw)
end

--Sets the lens mode of the model control
---@param camera_mod clicli.Const.UIEffectCameraMode # Lens mode
function M:set_effect_camera_mode(camera_mod)
    GameAPI.set_ui_effect_camera_mode(self.player.handle, self.handle, clicli.const.UIEffectCameraMode[camera_mod])
end

--Set the lens focus of the effects control
---@param x number # x
---@param y number # y
---@param z number # z
function M:set_effect_focus_pos(x, y, z)
    GameAPI.set_ui_effect_focus_pos(self.player.handle, self.handle, x, y, z)
end

--Sets the playback speed of the effects control
---@param play_speed number # Playback speed
function M:set_effect_play_speed(play_speed)
    GameAPI.set_ui_effect_play_speed(self.player.handle, self.handle, play_speed)
end

return M
