local item = ...
local game = item:get_game()

-- Event called when the game is initialized.
function item:on_started()
  self:set_savegame_variable("possession_ocarina")
  self:set_assignable(true)
end

-- Event called when the hero is using this item.
function item:on_using()
  -- TODO : Import and play the right song
  sol.audio.play_sound("picked_small_key")
  
  -- Here you can code the effect of the ocarina
  item:set_finished()
end