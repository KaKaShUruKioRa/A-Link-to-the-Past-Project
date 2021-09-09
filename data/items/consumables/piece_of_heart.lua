local item = ...
local game = item:get_game()

function item:on_created()
  item:set_assignable(false)
end

function item:on_obtaining(variant, savegame_variable)
  local piece_of_heart_counter = game:get_item("equipment/piece_of_heart_counter")
  piece_of_heart_counter:set_variant(piece_of_heart_counter:get_variant() + 1)
end