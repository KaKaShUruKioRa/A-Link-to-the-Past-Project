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

  if game:get_value("follower_zelda_on") then
      zelda_follower:set_enabled(true)
      zelda_follower:set_position(hero:get_position())
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