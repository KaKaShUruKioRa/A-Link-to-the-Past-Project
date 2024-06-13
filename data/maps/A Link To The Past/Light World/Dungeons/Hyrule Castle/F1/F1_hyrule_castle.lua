local map = ...
local game = map:get_game()

local door_manager = require("scripts/maps/door_manager")
door_manager:manage_map(map)
local chest_manager = require("scripts/maps/chest_manager")
chest_manager:manage_map(map)
local separator_manager = require("scripts/maps/separator_manager")
separator_manager:manage_map(map)

function map:on_started(destination)
  if destination == entrance_left or destination == entrance_right or destination == entrance_main then
    if game:get_value("follower_zelda_on") then
        zelda_follower:set_enabled(true)
        zelda_follower:set_position(hero:get_position())
    end
  end
  if game:get_value("follower_zelda_on") then
    sensor_zelda_dialog:set_enabled(true)
    sensor_zelda_dialog_2:set_enabled(true)
    sol.timer.start(map,1600,function()
      zelda_follower:set_enabled(true)
      zelda_follower:set_position(hero:get_position())
    end)
  end
  if not game:get_value("intro_done") then
    sol.audio.play_sound("rain_in",true)
    sol.timer.start(map,5000,function()
      sol.audio.play_sound("rain_in",true)
      return true
    end):set_suspended_with_map(false)
  end

  if game:get_value("zelda_rescued_dialog_1") then sensor_zelda_dialog:set_enabled(false) end
end

function sensor_zelda_dialog:on_activated()
  map:set_entities_enabled("sensor_zelda_dialog",false)
  game:start_dialog("escape.zelda_following_1")
  game:set_value("zelda_rescued_dialog_1",true)
end
function sensor_zelda_dialog_2:on_activated()
  map:set_entities_enabled("sensor_zelda_dialog",false)
  game:start_dialog("escape.zelda_following_1")
  game:set_value("zelda_rescued_dialog_1",true)
end