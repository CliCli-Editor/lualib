--Player
---@class Player
---@field handle py.Role
---@field id integer
---@overload fun(py_player?: py.Role): self
---@overload fun(id: py.RoleID | integer): self
local M = Class 'Player'

M.type = 'player'

---@class Player: Storage
Extends('Player', 'Storage')
---@class Player: CustomEvent
Extends('Player', 'CustomEvent')
---@class Player: CoreObjectEvent
Extends('Player', 'CoreObjectEvent')
---@class Player: KV
Extends('Player', 'KV')

---@package
---@param key py.RoleID
---@return Player?
M.ref_manager = New 'Ref' ('Player', function (key)
    local py_player = GameAPI.get_role_by_role_id(key)
    if not py_player then
        return nil
    end
    assert(type(py_player) == 'userdata', '参数类型错误:' .. tostring(py_player))
    return New 'Player' (py_player)
end)

---@param py_player py.Role
---@return self
function M:__init(py_player)
    self.handle = py_player
    self.id     = py_player:get_role_id_num() or 0
    return self
end

function M:__tostring()
    return string.format('{player|%s|%d}'
        , self:get_name()
        , self.id
    )
end

---转换玩家ID为玩家
---@param id integer 玩家ID
---@return Player player 玩家
function M:__alloc(id)
    return M.get_by_id(id)
end

function M:__encode()
    return self.id
end

function M:__decode(id)
    return M.get_by_id(id)
end

---转换玩家ID为玩家
---@param id integer 玩家ID
---@return Player player 玩家
function M.get_by_id(id)
    local player = M.ref_manager:get(id)
    return player
end

--Get the Player based on a string, which is via 'tostring(Player)'
--Or using the 'Convert any variable to string' in ECA.
---@param str string
---@return Player?
function M.get_by_string(str)
    local id = str:match('^{player|.+|(%d+)}$')
            or str:match('<Camp.-%(%d+%),id%((%d+)%)')
            or str:match('^Player:(%d+)')
    if not id then
        return nil
    end
    return M.get_by_id(tonumber(id)--[[@as integer]])
end

clicli.py_converter.register_type_alias('py.Role', 'Player')
clicli.py_converter.register_py_to_lua('py.RoleID', M.get_by_id)

---@param py_player py.Role
---@return Player
function M.get_by_handle(py_player)
    if type(py_player) ~= 'userdata' then
        error('参数类型错误:' .. tostring(py_player))
    end
    ---@cast py_player py.Role
    local id = py_player:get_role_id_num() or 0
    return M.get_by_id(id)
end

clicli.py_converter.register_py_to_lua('py.Role', M.get_by_handle)
clicli.py_converter.register_lua_to_py('py.Role', function (lua_value)
    return lua_value.handle
end)

--Local players, be aware that this may cause out-of-sync!
---@private
M.LOCAL_PLAYER = M.get_by_handle(GameAPI.get_client_role())

function M:get_camp()
    return self.handle:api_get_camp()
end

---布尔型玩家存档数据
---@deprecated
---@param index  integer 存档key
---@return boolean bool_value 布尔型玩家存档数据
function M:get_save_data_bool_value(index)
    return self.handle:get_save_data_bool_value(index) or false
end

---玩家是否中途加入
---@return boolean is_middle_join 是否中途加入
function M:is_middle_join()
    return self.handle:is_middle_join() or false
end

---玩家间是否是敌对关系
---@param player Player 玩家
---@return boolean is_enemy 是否是敌对关系
function M:is_enemy(player)
    return self.handle:players_is_enemy(player.handle) or false
end

---设置名字
---@param name string 名字
function M:set_name(name)
    self.handle:set_role_name(name)
end

---设置队伍ID
---@param id py.Camp
function M:set_team(id)
    self.handle:api_set_camp(id)
end

---设置属性值
---@param key clicli.Const.PlayerAttr | string 属性名
---@param value number 值
function M:set(key, value)
    key = clicli.const.PlayerAttr[key] or key
    ---@cast key py.RoleResKey
    self.handle:set_role_res(key, Fix32(value))
end

---增加属性值
---@param key clicli.Const.PlayerAttr | string 属性名
---@param value number 值
function M:add(key, value)
    key = clicli.const.PlayerAttr[key] or key
    ---@cast key py.RoleResKey
    self.handle:change_role_res(key, Fix32(value))
end

---获取玩家属性
---@param key clicli.Const.PlayerAttr | string # Attribute name
---@return number role_res 玩家属性
function M:get(key)
    key = clicli.const.PlayerAttr[key] or key
    ---@cast key py.RoleResKey
    return clicli.helper.tonumber(self.handle:get_role_res(key)) or 0.0
end

---获取玩家属性
---@param key clicli.Const.PlayerAttr | string # Attribute name
---@return number role_res 玩家属性
function M:get_attr(key)
    key = clicli.const.PlayerAttr[key] or key
    ---@cast key py.RoleResKey
    return clicli.helper.tonumber(self.handle:get_role_res(key)) or 0.0
end

---设置经验获得率
---@param rate number 经验获得率
function M:set_exp_rate(rate)
    self.handle:set_role_exp_rate(rate)
end

---设置敌对关系
---@param player Player 玩家
---@param is_hostile boolean 是否敌视
function M:set_hostility(player, is_hostile)
    self.handle:set_role_hostility(player.handle, is_hostile)
end

---设置群体寻路严格模式
---@param is_strict boolean 是否严格
function M:set_strict_group_navigation(is_strict)
    self.handle:set_group_navigate_mode(is_strict)
end

---选中单位/单位组
---@param unit_or_group Unit|UnitGroup 单位/单位组
function M:select_unit(unit_or_group)
    self.handle:role_select_unit(unit_or_group.handle)
end

---设置跟随距离
---@param distance number 距离
function M:set_follow_distance(distance)
    self.handle:api_set_follow_distance(Fix32(distance))
end

---为玩家开/关鼠标点选
---@param is_enable boolean 是否开鼠标点选
function M:set_mouse_click_selection(is_enable)
    self.handle:set_role_mouse_left_click(is_enable)
end

---为玩家开/关鼠标框选
---@param is_enable boolean 是否开鼠标框选
function M:set_mouse_drag_selection(is_enable)
    self.handle:set_role_mouse_move_select(is_enable)
end

---为玩家开/关鼠标滚轮
---@param is_enable boolean 是否开鼠标滚轮
function M:set_mouse_wheel(is_enable)
    self.handle:set_role_mouse_wheel(is_enable)
end

---玩家基础操作快捷键是否被占用
--TODO: Function key lua layer indicates that processing is required
---@param key py.NormalKey 键名
---@param assist_key py.RecordKey 辅助键名
---@return boolean is_conf 是否被占用
function M:is_operation_key_occupied(key,assist_key)
    return self.handle:api_is_conf_of_editable_game_func(key, assist_key) or false
end

---设置玩家的基础操作快捷键（过滤掉禁止设置的） 
--TODO:operation Indicates the operation mode on the lua layer to be sorted. Method Name English to be confirmed
---@param operation py.EditableGameFunc 可编辑操作
---@param key py.NormalKey 功能按键
---@param assist_key py.RecordKey 辅助按键
function M:set_operation_key(operation, key, assist_key)
    self.handle:api_set_role_editable_game_func(operation, key, assist_key)
end

---设置玩家的基础操作开关（包含所有基础操作）
--TODO:operation Indicates the operation mode on the lua layer to be sorted. Method Name English to be confirmed
---@param operation py.AllGameFunc 可编辑操作
---@param is_enable boolean 是否开
function M:set_all_operation_key(operation, is_enable)
    self.handle:api_set_role_all_game_func_enable(operation, is_enable)
end

---获取玩家响应键盘按键的基础操作（过滤掉禁止设置的）
---@param key py.NormalKey 键名
---@param assist_key py.RecordKey 键盘按键
---@return py.EditableGameFunc shortcut 基础操作
function M:get_operation_key(key, assist_key)
    return self.handle:api_get_editable_game_func_of_shortcut(key, assist_key) or 0
end

---设置科技等级
---@param tech_type py.TechKey 科技等级
---@param level integer 等级
function M:set_tech_level(tech_type, level)
    self.handle:api_set_tech_level(tech_type, level)
end

---增加科技等级
---@param tech_type py.TechKey 科技等级
---@param level integer 等级
function M:add_tech_level(tech_type, level)
    self.handle:api_change_tech_level(tech_type, level)
end

---对玩家开放视野
---@param target_player Player 玩家
---@param share boolean
function M:share_vision_with_player(target_player, share)
    if share then
        self.handle:share_source_player_vision_to_target(target_player.handle)
    else
        self.handle:close_source_player_vision_to_target(target_player.handle)
    end
end

---获取单位的视野
---@param unit Unit 单位
---@param share boolean
function M:share_vision_of_unit(unit, share)
    if share then
        self.handle:share_source_unit_vision_to_target(unit.handle)
    else
        self.handle:close_source_unit_vision_to_target(unit.handle)
    end
end

---上传存档
function M:upload_save_data()
    self.handle:upload_save_data()
end

---增加全局存档
---@param key string 键
---@param value integer 值
function M:add_global_save_data(key, value)
    self.handle:add_global_map_archive_data(key, value)
end

---消耗玩家平台道具
---@param count integer 个数
---@param item_id py.StoreKey 平台道具id
function M:use_store_item(count, item_id)
    self.handle:api_use_store_item(count, item_id)
end

---请求购买平台道具
---@param id py.StoreKey 平台道具id
function M:open_platform_shop(id)
    GameAPI.open_platform_shop(self.handle, id)
end

---玩家是否可以看到某个位置
---@param point Point 点
---@return boolean visible 点对于玩家可见
function M:is_visible(point)
    ---@diagnostic disable-next-line: param-type-mismatch
    return self.handle:is_point_visible_to_player(point.handle) and true or false
end

---某个位置是否处于玩家的迷雾中
---@param point Point 点
---@return boolean is_point_in_fog 点在迷雾中
function M:is_in_fog(point)
    ---@diagnostic disable-next-line: param-type-mismatch
    return self.handle:is_point_in_fog(point.handle) or false
end

---某个位置是否处于玩家的黑色阴影中
---@param point Point 点
---@return boolean is_point_in_shadow 点在黑色阴影中
function M:is_in_shadow(point)
    ---@diagnostic disable-next-line: param-type-mismatch
    return self.handle:is_point_in_shadow(point.handle) or false
end

---获取玩家ID
---@return integer role_id_num 玩家ID
function M:get_id()
    return self.id
end

---获取玩家颜色
---@return string HEX颜色
function M:get_color()
    return self.handle:api_get_role_color() or ''
end

---获取玩家游戏状态
---@see clicli.Const.RoleStatus
---@return clicli.Const.RoleStatus role_status 玩家游戏状态
function M:get_state()
    return self.handle:get_role_status() or 2
end

---获取玩家控制者类型
---@return clicli.Const.RoleType role_type 玩家控制者类型
function M:get_controller()
    if not self._cotroller then
        ---@private
        self._cotroller = self.handle:get_role_type() or 0
    end
    return self._cotroller
end

---获取玩家名字
---@return string role_name 玩家名字
function M:get_name()
    return self.handle:get_role_name() or ''
end

---获取经验获得率
---@return number exp_rate 经验获得率
function M:get_exp_rate()
    return clicli.helper.tonumber(self.handle:get_role_exp_rate()) or 0.0
end

---获取队伍ID
---@return integer camp_id 队伍ID
function M:get_team_id()
    return self.handle:get_camp_id_num() or 0
end

---表格型玩家存档数据
---@deprecated
---@param key integer 存档key
---@return table? table_value 表格型玩家存档数据
function M:get_save_data_table(key)
    return self.handle:get_save_data_table_value(key)
end

---字符串型玩家存档数据
---@deprecated
---@param key integer 存档key
---@return string str_value 字符串玩家存档数据
function M:get_save_data_string(key)
    return self.handle:get_save_data_str_value(key) or ''
end

---实数型存档数据
---@deprecated
---@param key integer 存档key
---@return number int_value 实数型存档数据
function M:get_save_data_float(key)
    return clicli.helper.tonumber(self.handle:get_save_data_fixed_value(key)) or 0.0
end

---获取整数型存档数据
---@deprecated
---@param key integer 存档key
---@return integer int_value 整数型存档数据
function M:get_save_data_int(key)
    return self.handle:get_save_data_int_value(key) or 0
end

---获取整数存档玩家排名
---@param key integer 存档key
---@return integer rank_num 整数存档玩家排名
function M:get_rank_num(key)
    return self.handle:get_player_archive_rank_num(key) or 0
end

---获取科技等级
---@param tech_id py.TechKey 科技id
---@return integer tech_level 科技等级
function M:get_tech_level(tech_id)
    return self.handle:api_get_tech_level(tech_id) or 0
end

---@private
---@type string
M._platform_icon = nil

---获取玩家平台头像
---@return string icon 平台头像
function M:get_platform_icon()
    if not self._platform_icon then
        local suc, res = pcall(GameAPI.get_role_platform_icon, self.handle)
        if suc then
            self._platform_icon = res --[[@as string]]
        else
            self._platform_icon = ''
        end
    end
    return self._platform_icon
end

---获取玩家平台头像下载地址
---@return string icon_url 平台头像下载地址
function M:get_platform_icon_url()
    ---@diagnostic disable-next-line: undefined-field
    local get_url = GameAPI.get_role_platform_url
    if not get_url then
        return ''
    end
    local url = get_url(self.handle) --[[@as string]]
    return url or ''
end

--Gets the player's platform unique ID
---@return integer plat_aid 平台唯一ID
function M:get_platform_id()
    return math.tointeger(GameAPI.get_player_plat_aid(self.handle)) or 0
end

--Get the player's platform level for this map
---@return integer
function M:get_map_level()
    return self.handle:get_role_plat_map_level() or 0
end

--Get the player's platform rank in the local chart
---@return integer
function M:get_map_level_rank()
    return self.handle:api_get_map_level_rank() or 0
end

--Gets the player's accumulated game count on the local graph
function M:get_played_times()
    return self.handle:api_get_played_times() or 0
end

--Get achievement points for the player's current map
function M:get_achieve_point()
    return self.handle:api_get_role_achieve_point() or 0
end

--Determines whether the specified achievement is unlocked
---@param id string
---@return boolean
function M:is_achieve_unlock(id)
    return self.handle:api_get_role_achieve_unlock(id) or false
end

---玩家平台道具数量
---@param id py.StoreKey 平台道具id
---@return integer store_item_cnt 平台道具数量
function M:get_store_item_number(id)
    return self.handle:get_store_item_cnt(id) or 0
end

---玩家平台道具到期时间戳
---@param id py.StoreKey 平台道具id
---@return integer store_item_end_time 平台道具到期时间戳
function M:get_store_item_end_time(id)
    return self.handle:get_store_item_expired_time(id) or 0
end

---获取玩家平台等级
---@return integer map_level 平台等级
function M:get_platform_level()
    return self.handle:get_role_plat_map_level() or 0
end

---玩家在玩家组中
---@param player_group PlayerGroup 玩家组
---@return boolean is_in_group 玩家在玩家组中
function M:is_in_group(player_group)
    return GlobalAPI.judge_role_in_group(self.handle, player_group.handle)
end

---属于某玩家的所有单位
---@return UnitGroup unit_group 单位组
function M:get_all_units()
    local py_unit_group = self.handle:get_all_unit_id()
    if not py_unit_group then
        return clicli.unit_group.create()
    end
    return clicli.unit_group.get_by_handle(py_unit_group)
end

---创建单位
---@param unit_id py.UnitKey 单位类型
---@param point? Point 单位
---@param facing? number 朝向
---@return Unit
function M:create_unit(unit_id, point, facing)
    local unit = clicli.unit.create_unit(self, unit_id, point or clicli.point(0.0, 0.0), facing or 0.0)
    return unit
end

---强制踢出
---@param reason string 踢出原因
function M:kick(reason)
    GameAPI.role_force_quit(self.handle, reason)
end

---设置玩家属性图标
---@param key py.RoleResKey 属性名
---@param id py.Texture 图标id
function clicli.set_res_icon(key, id)
    GameAPI.change_role_res_icon_with_icon(key, id)
end

---获取玩家平台外观模型
---@return py.ModelKey model 模型id
function M:get_platform_model()
    return GameAPI.get_role_platform_model(self.handle)
end

--Gets the point of the mouse in the game.
--You must first set 'clicli.config.sync.mouse = true'.
---@return Point point 点
function M:get_mouse_pos()
    if not clicli.config.sync.mouse then
        error('必须先设置 `clicli.config.sync.mouse = true`')
    end
    local py_point = GameAPI.get_player_pointing_pos(self.handle)
    -- TODO 见问题2
    ---@diagnostic disable-next-line: param-type-mismatch
    return clicli.point.get_by_handle(py_point)
end

---获取玩家鼠标屏幕坐标X的占比。
--You must first set 'clicli.config.sync.mouse = true'.
---@return number x_per X的占比
function M:get_mouse_ui_x_percent()
    if not clicli.config.sync.mouse then
        error('必须先设置 `clicli.config.sync.mouse = true`')
    end
    return clicli.helper.tonumber(GameAPI.get_role_ui_x_per(self.handle)) or 0.0
end

---获取玩家鼠标屏幕坐标y的占比。
--You must first set 'clicli.config.sync.mouse = true'.
---@return number y_per Y的占比
function M:get_mouse_ui_y_percent()
    if not clicli.config.sync.mouse then
        error('必须先设置 `clicli.config.sync.mouse = true`')
    end
    return clicli.helper.tonumber(GameAPI.get_role_ui_y_per(self.handle)) or 0.0
end

---获取鼠标在屏幕上的X坐标
---@return number pos_x X坐标
function M:get_mouse_pos_x()
    return GameAPI.get_player_ui_pos_x(self.handle)
end

---获取鼠标在屏幕上的y坐标
---@return number pos_y Y坐标
function M:get_mouse_pos_y()
    return GameAPI.get_player_ui_pos_y(self.handle)
end

---玩家的按键是否被按下
---@param key clicli.Const.KeyboardKey | clicli.Const.MouseKey | integer 按键
---@return boolean 是否被按下
function M:is_key_pressed(key)
    if not clicli.config.sync.key then
        error('必须先设置 `clicli.config.sync.key = true`')
    end
    key =  clicli.const.KeyboardKey[key]
        or clicli.const.MouseKey[key]
        or key
    return GameAPI.player_key_is_pressed(self.handle, key)
end

---获取玩家唯一名称
---@return string name 属性名称
function M:get_platform_name()
    return self.handle:get_role__unique_name() or ''
end

---获取玩家加密UUID
---@return string
function M:get_platform_uuid()
    ---@diagnostic disable-next-line: return-type-mismatch
    return self.handle:get_encry_uuid()
end

---向玩家发送提示
---@param msg string 消息
---@param localize? boolean 是否支持语言环境
function M:display_info(msg, localize)
    GameAPI.show_msg_to_role(self.handle, msg, localize)
end

---获取玩家属性的货币图标
---@param key py.RoleResKey 属性名
---@return integer icon 图标id
function M.get_res_icon(key)
    return GameAPI.get_role_res_icon(key)
end

---获取玩家属性名称
---@param key py.RoleResKey 属性名
---@return string name 属性名称
function M.get_res_name(key)
    return GameAPI.get_role_res_name(key)
end

--Set filter
---@param value integer 滤镜
function M:set_color_grading(value)
    GameAPI.set_role_color_grading(self.handle, value)
end

---显示/隐藏玩家地表纹理
---@param is_visible boolean 显示/隐藏
function M:set_local_terrain_visible(is_visible)
    GameAPI.set_local_terrain_visible(self.handle, is_visible)
end

---@param player Player 玩家
---@param is_enable boolean 开关
---设置暗角开关
function M.enable_vignetting(player, is_enable)
    player.handle:set_role_vignetting_enable(is_enable)
end

---设置暗角大小
---@param size number 大小
function M:set_vignetting_size(size)
    self.handle:set_role_vignetting_size(size)
end

---设置暗角呼吸周期
---@param circle_time number 呼吸周期
function M:set_role_vignetting_breath_rate(circle_time)
    self.handle:set_role_vignetting_breath_rate(circle_time)
end

---设置暗角变化幅度
---@param range number 幅度
function M:set_vignetting_change_range(range)
    self.handle:set_role_vignetting_change_range(range)
end

---设置暗角颜色
---@param red number 颜色r
---@param green number 颜色g
---@param blue number 颜色b
---@param time number 过渡时间
function M:set_vignetting_color(red, green, blue, time)
    self.handle:set_role_vignetting_color(red, green, blue, time)
end

--Quit the game
function M:exit_game()
    GameAPI.exit_game(self.handle)
end

--Get local players, be aware that this may cause out-of-sync!
--Warning: If you are not sure what this function is doing, do not use it!
--
--> Obsolete: use 'clicli.player.with_local' instead
---@deprecated
---@return Player
function M.get_local()
    return M.LOCAL_PLAYER
end

--Gets attribute names for all player attributes
---@param only_coin boolean # Only gets player attributes for currency types
---@return py.RoleResKey[]
function M.get_res_keys(only_coin)
    local py_list = GameAPI.iter_role_res(only_coin)
    return clicli.helper.unpack_list(py_list)
end

--Displays a text message to the player
---@param message string # message
---@param localize? boolean # Whether locale is supported
function M:display_message(message, localize)
    GameAPI.show_msg_to_role(self.handle, message, localize or false)
end

--Upload the buried data
---@param key string
---@param cnt integer
function M:upload_tracking_data(key, cnt)
    GameAPI.api_upload_user_tracking_data(self.handle, key, cnt)
end

---获取玩家在社区的互动数据
---@param community_type clicli.Const.PlatFormRoleCommunityType
---@return integer
function M:get_community_value(community_type)
    return self.handle:api_get_community_value(clicli.const.PlatFormRoleCommunityType[community_type] or community_type) or 0
end

---获取玩家当前地图的签到天数
---@param sign_type? clicli.Const.SignInDaysType
---@return integer
function M:get_sign_in_days(sign_type)
    return self.handle:api_get_sign_in_days_of_platform(clicli.const.SignInDaysType[sign_type] or sign_type or 0) or 0
end

---玩家是否收藏当前地图
---@return boolean
function M:is_bookmark_current_map()
    return self.handle:api_is_bookmark_current_map() or false
end

---请求执行随机池掉落
---执行完毕后调用回调函数，返回的参数如下：
---* `code`: 结果代码
---  + `0`: 成功
---  + `1`: 不满足触发间隔
---  + `2`: 不满足每日限制
---  + `999`: 服务器无法连接，必须在平台上才能测试
---* `result`: 结果表，`key` 表示影响的存档编号，`value` 表示改变的值
---@param id integer # Number of the random pool
---@param callback fun(code: 0|1|2|999, result: { [integer]: integer }) # Callback function after execution
function M:request_random_pool(id, callback)
    local response = {}
    GameAPI.lua_request_server_random_pool_result(self.handle, id, function ()
        local code = response['__random_pool_ret_code']
        local result = clicli.helper.dict_to_table(response['__random_pool_result_dict'])
        xpcall(callback, log.error, code, result)
    end, response)
end

---请求使用商城道具
---执行完毕后调用回调函数，通知是否成功
---@param count integer # Quantity used
---@param item_id py.StoreKey # Shop item id
---@param callback fun(suc: boolean) # Callback function after execution
function M:request_use_item(count, item_id, callback)
    GameAPI.lua_request_server_role_use_item(self.handle, count, item_id, function (_, suc)
        callback(suc)
    end, {})
end

---请求购买商城货币
---@param goods_id string
---@param callback? fun(suc: boolean, sn?: string, error_code?: integer)
function M:request_buy_mall_coin(goods_id, callback)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_buy_mall_coin(self.handle, goods_id, function (context)
        if callback then
            local error_code = context['__error_code']
            if error_code then
                xpcall(callback, log.error, false, nil, error_code)
                return
            end
            -- 订单号
            local sn = context['__str1']
            local status = context['__int1']
            xpcall(callback, log.error, status == 0, sn, status)
        end
    end, {})
end

---@class MallGoodsInfo
---@field is_exist boolean # Existence or not
---@field effective_time integer # Effective time
---@field expiration_time integer # Expiration time
---@field left_token integer # Quantity of surplus money

---获取某个玩家的商城物品信息
---@param goods_id string
---@param callback fun(info: MallGoodsInfo)
function M:request_mall_goods_info(goods_id, callback)
    ---@diagnostic disable-next-line: param-type-mismatch
    GameAPI.lua_request_server_mall_goods_info(self.handle, tostring(goods_id), function (context)
        xpcall(callback, log.error, {
            is_exist = context['__bool1'],
            effective_time = context['__mall_goods_effective_time'],
            expiration_time = context['__mall_goods_expiration_time'],
            left_token = context['__float1']
        })
    end, {})
end

---请求购买商城道具
---@param count integer # quantity
---@param goods_id integer # Shop item id
---@param callback? fun(suc: boolean, error_code: integer) # Callback function after execution
function M:request_mall_purchase_goods(count, goods_id, callback)
    ---@diagnostic disable-next-line: undefined-field, param-type-mismatch
    GameAPI.lua_request_server_mall_purchase_goods(self.handle, count, goods_id, function (context)
        if callback then
            local error_code = context['__error_code']
            xpcall(callback, log.error, error_code == 0, error_code)
        end
    end, {})
end

---请求生成随机数
---@param group_id integer # id of a random read-only archive group
---@param key string # The key of a random number
---@param callback fun(value: integer) # Callback function after execution
function M:request_random_number(group_id, key, callback)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_generate_random_number(self.handle, key, group_id, function (context)
        local result = context['__random_number_err_code']
        xpcall(callback, log.error, result)
    end, {})
end

---请求玩家的开放存档数据
---@param callback fun(archive: any) # Callback function after execution
function M:request_open_archive(callback)
    ---@diagnostic disable-next-line: undefined-field
    GameAPI.lua_request_role_open_archive(self.handle, function (context)
        xpcall(callback, log.error, context['__role_open_archive'])
    end, {})
end

---更新存档排行榜
---@param save_index integer # Archive field
function M:update_save_rank(save_index)
    self.handle:update_player_save_rank(save_index)
end

return M
