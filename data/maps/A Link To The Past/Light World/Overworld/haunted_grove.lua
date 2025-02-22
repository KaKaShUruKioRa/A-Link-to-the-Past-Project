-- Lua script of map Non_Playable Zone/hunted_grove_npz.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

  if game:has_item("inventory/ocarina") then
    flute_boy:set_enabled(false)
  end

  if flute_boy:is_enabled() then
    music_tmp = sol.audio.get_music()
    sol.audio.stop_music()
    sol.audio.play_sound("ocarina_complet")
    sol.timer.start(12000, function() sol.audio.play_music(music_tmp) end)
  end

end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

function hero:on_state_changed(state)
  if state == "treasure" then 
      sol.timer.start(2000, function() 
      sol.audio.play_sound("warp") flute_boy:set_enabled(false) end)
  end
end