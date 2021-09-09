local item = ...
local game = item:get_game()
  
function item:on_started()
  item:set_savegame_variable("possession_magic_mirror")
  item:set_assignable(true)
end

function item:on_using()
  local hero = game:get_hero()
  if game:get_dungeon() then
    -- Teleport.
    sol.audio.play_sound("warp")
    hero:teleport(game:get_starting_location())
  else
    sol.audio.play_sound("wrong")
  end
  item:set_finished()
end

