local map = ...
local game = map:get_game()

function map:on_started()
  if heroic_mode_enabled_for_this_savegame or game:get_value("heroic_mode") then
    map:set_entities_enabled("ganon_hole",false)
    map:set_entities_enabled("heroic_ganon_hole",true)
  end
end