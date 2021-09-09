-- This item displays the number of piece of hearts obtained in the menu.
-- It is given to the hero at the begining of the game and shouldn't be deleted.
-- Its variant gives the number of piece of heart minus 1

local item = ...
local game = item:get_game()

-- Event called when the game is initialized.
function item:on_started()
  item:set_savegame_variable("possession_piece_of_heart_counter")
  item:set_assignable(false)
end

function item:on_variant_changed(variant)
  if (variant >= 5) then
    local game = self:get_game()
    game:add_max_life(2)
    game:set_life(game:get_max_life())
    
    item:set_variant(1)
  end
end