--Suppose you have a UI called "Blood Bar" in the scene UI

clicli.game:event('Unit - Create', function (trg, data)
    --After creating any unit, bind a scene UI to that unit
    local scene_ui = clicli.scene_ui.create_scene_ui_at_player_unit_socket('Blood bar', clicli.player(1), data.unit, 'head')
    --After the unit is removed, remove the scene UI
    data.unit:bindGC(scene_ui)
end)
