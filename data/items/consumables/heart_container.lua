local item = ...

function item:on_created()

  self:set_sound_when_picked(nil)
  self:set_sound_when_brandished("heart_container")
end

function item:on_obtained(variant, savegame_variable)

  local game = self:get_game()
  game:add_max_life(4)
  game:add_life(4)
end

