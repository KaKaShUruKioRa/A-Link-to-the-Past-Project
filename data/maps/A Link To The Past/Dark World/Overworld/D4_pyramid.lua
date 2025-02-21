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
    ganon_hole_0:set_enabled()
    ganon_hole_1:set_enabled()
    ganon_hole_2:set_enabled()
    ganon_hole_3:set_enabled()
    ganon_hole_4:set_enabled()
    ganon_hole_5:set_enabled()
    ganon_hole_6:set_enabled()
    ganon_hole_7:set_enabled()
    ganon_hole_8:set_enabled()
    tp_dungeon_D4_pyramid_0:set_enabled()
  end

  if game:get_value("boss_vitreous_0") then
      dynamic_tile_bombable_D4_pyramid_0:set_enabled(false)
      dynamic_tile_bombable_D4_pyramid_1:set_enabled(false)
      dynamic_tile_bombable_D4_pyramid_2:set_enabled(false)
      dynamic_tile_bombable_D4_pyramid_3:set_enabled(false)
  end

end

