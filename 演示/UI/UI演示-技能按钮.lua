--LDBG:event 'wait'

--Initialization interface
local function init_ui()
    local main = clicli.ui.get_ui(clicli.player(1), 'panel_1')

    --Just create a picture and look at it
    local image = main:create_child('picture')
    image:set_pos(100, main:get_height() / 2)
    image:set_image(106330)

    --Create a skill button component
    local skill_btn = main:create_child('Skill button')
    skill_btn:set_pos(500, main:get_height() / 2)

    --Hide the two child controls that are blocked
    skill_btn:get_child('skill_consume_mask_img'):set_visible(false)
    skill_btn:get_child('skill_disable_img'):set_visible(false)

    --Modify skill picture
    local skill_image = skill_btn:get_child('skill_icon_img')
    assert(skill_image)
    skill_image:set_image(106728)
end

clicli.game:event('Game - initialization', function ()
    init_ui()
end)
