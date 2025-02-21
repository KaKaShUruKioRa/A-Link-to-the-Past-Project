local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()
  -- Supprime le mur si la barrière électrique a été détruitre par l'Epee de Légende
  if game:get_value("electric_barrier_destroyed") then
    electric_barrier_wall:set_enabled(false)
  end

  if game:get_value("boss_agahnim_F7_hyrule_castle_tower_0") or game:get_value("hyrule_castle_tower_boss") then
    tp_warp_hyrule_castle_0:set_enabled(true)
  end

  if not game:get_value("intro_done") then
    red_spear_soldier_hyrule_castle_0:set_enabled(false)
    map:set_entities_enabled("intro_",true)
    sol.audio.play_music("beginning")
    sol.audio.play_sound("rain_out",true)
    sol.timer.start(map,5000,function()
      sol.audio.play_sound("rain_out",true)
      map:set_entities_enabled("intro_bg_dark",false)
      sol.timer.start(map, 80, function()
        map:set_entities_enabled("intro_bg_dark",true)
        sol.audio.play_sound("quake")
      end):set_suspended_with_map(false)
      return true
    end):set_suspended_with_map(false)
  else
    for entity in map:get_entities("blue_soldier_hyrule_castle_") do
      entity:set_enabled()
    end
    for entity in map:get_entities("red_soldier_hyrule_castle_") do
      entity:set_enabled()
    end
    for entity in map:get_entities("green_soldier_hyrule_castle_") do
      entity:set_enabled()
    end
    for entity in map:get_entities("red_spear_soldier_hyrule_castle_") do
      entity:set_enabled()
    end

    sol.audio.play_music("overworld")
    
  end

  if game:get_value("follower_zelda_on") then
      zelda_follower:set_enabled(true)
      zelda_follower:set_position(hero:get_position())
  end

  if not game:get_value("get_sword_1") then
    sol.timer.start(map,math.random(20000,29999),function()
      local dialog_box = game:get_dialog_box()
      dialog_box:set_style("empty")
      game:start_dialog("escape.zelda_backseat",function() dialog_box:set_style("box") end)
    end)
  end
  
end

function bush_secret:on_lifting()
  sol.audio.play_sound("secret")
  bush_secret_ground:set_enabled(false)
end
function bush_secret:on_cut()
  sol.audio.play_sound("secret")
  bush_secret_ground:set_enabled(false)
end