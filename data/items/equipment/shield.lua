local item = ...
local game = item:get_game()

function item:on_created()
  item:set_savegame_variable("possession_shield")
end

function item:on_variant_changed(variant)
  game:set_ability("shield", variant)
end