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
    for entity in map:get_entities("green_soldier_hyrule_castle_") do
      entity:set_enabled()
    end
    for entity in map:get_entities("blue_soldier_hyrule_castle_") do
      entity:set_enabled()
    end
    for entity in map:get_entities("red_soldier_hyrule_castle_") do
      entity:set_enabled()
    end
    for entity in map:get_entities("spear_knight_hyrule_castle_") do
      entity:set_enabled()
    end
    for entity in map:get_entities("bomb_knight_hyrule_castle_") do
      entity:set_enabled()
    end   
    sol.audio.play_music("overworld")

  end
    
  -- End of the Game : End Credits
  if game:get_value("end_credits") and not game:get_value("free_mode") then 
    sol.timer.start(800, function() hero:freeze() end)
    hero:get_sprite("shield"):set_opacity(0)
    for entity in map:get_entities_by_type("enemy") do
      entity:set_enabled(false)
    end
    map:set_entities_enabled("npc_end_credits_", true)
    sol.audio.play_music("credits")
    sol.timer.start(6000, function()
      hero:get_sprite("shield"):set_opacity(255)
      hero:unfreeze()
    end)
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

function map:on_finished()
  if game:get_value("end_credits") then
    game:set_value("free_mode", true)
  end
end

function map:on_draw()
  if game:get_value("end_credits") and not game:get_value("free_mode") then
  tp_warp_hyrule_castle_0:set_enabled(false)
     the_end = sol.text_surface.create({
     ["text"] = "The End",
     ["horizontal_alignment "] = "left",
     ["vertical_alignment"] = "bottom",
     ["color"] = {251, 210, 168}, 
     ["font"] = "alttp",})
     surface_cam = map:get_camera():get_surface()
     the_end:set_scale(2, 2)
      the_end:draw(surface_cam, 8 , 204)
  end
end