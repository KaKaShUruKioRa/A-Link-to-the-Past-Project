-- Initialize map features specific to this quest.

require("scripts/multi_events")

local map_meta = sol.main.get_metatable("map")

local ceiling_drop_manager = require("scripts/ceiling_drop_manager")
for _, entity_type in pairs({"hero"}) do
  ceiling_drop_manager:create(entity_type)
end

map_meta:register_event("on_opening_transition_finished",function(map)
  local game = map:get_game()

  --Effet de chute
  local hero = game:get_hero()
  local ground=game:get_value("tp_ground")
  if ground=="hole" then
    hero:set_invincible()
    hero:set_visible(false)
    hero:fall_from_ceiling(240, nil, function()
        sol.audio.play_sound("hero_lands")
        game:set_value("tp_ground","traversable")
        hero:set_invincible(false)
    end)
  end
end)

return true