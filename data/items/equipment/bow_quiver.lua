-- The Quiver is an item fixing the max amount of arrow
-- We do not merge the quiver and the bow for ergonomy purpose (it's different items in the menu)
-- <!> Obtaining the bow automatically give the base quiver

local item = ...
local game = item:get_game()

function item:on_created()
  item:set_savegame_variable("possession_quiver")
  item:set_amount_savegame_variable("amount_arrows")
  item:set_assignable(false)
end

function item:on_started()
  self:on_variant_changed(self:get_variant())
end

function item:on_obtaining(variant, savegame_variable)
  -- The quiver is obtained filled
  item:set_amount(item:get_max_amount())
end

-- Increase the capacity of arrow depending on the variant of the quiver
-- and unlock arrows
function item:on_variant_changed(variant)
  local bow = game:get_item("inventory/bow")
  local arrows = game:get_item("consumables/arrow_refill")
  if variant == 0 then
    item:set_max_amount(0)
    arrows:set_obtainable(false)
  else
    -- Determine the max amount of arrows
    local max_amounts = {30, 50, 70}
    local max_amount = max_amounts[variant]

    -- Unlock arrow and set max amount
    item:set_max_amount(max_amount)
    arrows:set_obtainable(true)
  end
end