local item = ...
local game = item:get_game()

function item:on_created()
  self:set_can_disappear(true)
  self:set_brandish_when_picked(false)
end

function item:on_started()
  -- Disable pickable arrow if the player has no quiver
  -- We cannot do this from on_created() because we don't know if the quiver
  -- is already created there.
  item:set_obtainable(game:has_item("equipment/bow_quiver"))
end

function item:on_obtaining(variant, savegame_variable)
  -- Increasing the amount of arrows depending on the variant of picked item
  local amounts = {1, 5, 10}
  local amount = amounts[variant]
  if amount == nil then
    error("Invalid variant '" .. variant .. "' for item 'bomb'")
  else
    game:get_item("equipment/bow_quiver"):add_amount(amount)
  end
end

