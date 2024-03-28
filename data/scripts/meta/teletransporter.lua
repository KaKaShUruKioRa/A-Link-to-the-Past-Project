local teletransporter_meta=sol.main.get_metatable("teletransporter")

require("scripts/maps/light_manager.lua")
dark_on = false

teletransporter_meta:register_event("on_activated", function(teletransporter)
  local game = teletransporter:get_game()
  local hero = game:get_hero()
  local map = game:get_map()
  local name = teletransporter:get_name()
  local ground=hero:get_ground_below()
  game:set_value("tp_destination", teletransporter:get_destination_name())
  game:set_value("tp_ground", ground) --save last ground for the ceiling drop manager

  -- Dark Rooms Transitions
  if name == nil then return end
  if name:match("^tp_to_dark_") then
    sol.timer.start(game,650,function()
      dark_on = true
      map:set_light(0)
    end)
  end
  if name:match("^tp_to_light_") then
    sol.timer.start(game,650,function()
      dark_on = false
      map:set_light(1)
    end)
  end

end)