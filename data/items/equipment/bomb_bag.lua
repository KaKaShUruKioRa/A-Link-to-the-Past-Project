-- The Bomb Bag is an item fixing the max amount of bombs
-- We do not merge the bomb bag and the bombs for ergonomy purpose (it's different items in the menu)


local item = ...
local game = item:get_game()

function item:on_created()
  item:set_savegame_variable("possession_bomb_bag")
  item:set_amount_savegame_variable("amount_bombs")
  item:set_assignable(false)
end

function item:on_started()
  self:on_variant_changed(self:get_variant())
end

function item:on_obtaining(variant, savegame_variable)
  -- The bomb bag is obtained filled
  item:set_amount(item:get_max_amount())
  game:get_item("inventory/bombs"):set_variant(1)
end

-- Increase the capacity of bombs depending on the variant of the bong bag
-- and unlock bong bag
function item:on_variant_changed(variant)
  local bombs = game:get_item("inventory/bombs")
  local pickable_bombs = game:get_item("consumables/bomb_refill")
  if variant == 0 then
    item:set_max_amount(0)
    pickable_bombs:set_obtainable(false)
  else
    -- Determine the max amount of bombs
    local max_amounts = {10, 30, 50}
    local max_amount = max_amounts[variant]

    -- Unlock bombs and set max amount
    item:set_max_amount(max_amount)
    pickable_bombs:set_obtainable(true)
  end
end