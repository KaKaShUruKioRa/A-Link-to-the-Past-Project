local item = ...
local game = item:get_game()

function item:on_created()
  self:set_can_disappear(true)
  self:set_brandish_when_picked(false)
end

function item:on_started()
  -- Disable pickable bomb if the player has no bomb bag
  -- We cannot do this from on_created() because we don't know if the bomb bag
  -- is already created there.
  item:set_obtainable(game:has_item("equipment/bomb_bag"))
end

function item:on_obtaining(variant, savegame_variable)
  -- Increasing the amount of bombs depending on the variant of picked item
  local amounts = {1, 3, 8}
  local amount = amounts[variant]
  if amount == nil then
    error("Invalid variant '" .. variant .. "' for item 'bomb'")
  else
    game:get_item("equipment/bomb_bag"):add_amount(amount)
  end
end

