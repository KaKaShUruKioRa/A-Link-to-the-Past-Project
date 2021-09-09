-- The Book of Mudora is an item doing nothing
-- You can check the possession of this item in order
-- to display a translation for hylian text

local item = ...
local game = item:get_game()

-- Event called when the game is initialized.
function item:on_started()
  self:set_savegame_variable("possession_book_of_mudora")
  self:set_assignable(false)
end