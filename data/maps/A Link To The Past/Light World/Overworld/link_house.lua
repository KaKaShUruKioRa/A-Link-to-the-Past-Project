local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

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
      end)
      return true
    end)
  else
    sol.audio.play_music("overworld")
  end

  if not game:get_value("get_sword_1") then
    sol.timer.start(map,30000,function()
      local dialog_box = game:get_dialog_box()
      dialog_box:set_style("empty")
      game:start_dialog("escape.zelda_backseat",function() dialog_box:set_style("box") end)
    end)
  end
  
end