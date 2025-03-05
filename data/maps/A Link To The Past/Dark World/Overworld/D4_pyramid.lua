local map = ...
local game = map:get_game()

function map:on_started()

  if not game:get_value("dark_world_discovered") and game:get_value("boss_agahnim_F7_hyrule_castle_tower_0") then
      local dialog_box = game:get_dialog_box()
      dialog_box:set_style("empty")
      game:start_dialog("npc.sahasrahla.dark_world", 
        function() dialog_box:set_style("box") 
        game:set_value("dark_world_discovered", true)
       end)
  end
  
  if game:get_value("boss_agahnim_F7_ganon_tower_0") then
    if not game:get_value("ganon_crashed_pyramid") then
      sol.audio.play_sound("bat_crash")
      game:set_value("ganon_crashed_pyramid", true)
    end

    for ganon_hole in map:get_entities("ganon_hole_") do
      ganon_hole:set_enabled()   
    end
      tp_dungeon_D4_pyramid_0:set_enabled()
  end

  if game:get_value("boss_vitreous_0") then
    for bombable_tile in map:get_entities("dynamic_tile_bombable_") do
      bombable_tile:set_enabled(false)   
    end
  end

end

