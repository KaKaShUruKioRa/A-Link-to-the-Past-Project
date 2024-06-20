local map = ...
local game = map:get_game()

local door_manager = require("scripts/maps/door_manager")
door_manager:manage_map(map)
local chest_manager = require("scripts/maps/chest_manager")
chest_manager:manage_map(map)
local separator_manager = require("scripts/maps/separator_manager")
separator_manager:manage_map(map)

function map:on_started(destination)
  curtain_1:set_cut_method("pixel")
  curtain_2:set_cut_method("pixel")
  curtain_3:set_cut_method("pixel")
  curtain_4:set_cut_method("pixel")
  curtain_5:set_cut_method("pixel")
  curtain_6:set_cut_method("pixel")
  if destination == secret_passage then
    if game:get_value("follower_zelda_on") then
        zelda_follower:set_enabled(true)
        zelda_follower:set_position(hero:get_position())
    end
  end
  if game:get_value("hyrule_castle_altar_pushed") then
    sensor_push_altar:set_enabled(false)
    sensor_push_altar_end:set_enabled(false)
    map:set_entities_enabled("altar_opened",true)
    altar_closed:set_enabled(false)
    altar:set_position(776,32)
  end
  if game:get_value("follower_zelda_on") then
    sensor_zelda_dialog:set_enabled(true)
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

  if game:get_value("zelda_rescued_dialog_2") then sensor_zelda_dialog:set_enabled(false) end
end

function sensor_push_altar:on_activated_repeat()
  local x, y = altar:get_position()
  local xs, ys = sensor_push_altar:get_position()
  if game:get_value("zelda_rescued") and game:get_value("get_lamp") then
    if (hero:get_sprite():get_animation() == "walking_with_shield" or hero:get_sprite():get_animation() == "walking") and hero:get_sprite():get_direction() == 0 then
      sol.timer.start(100,function()
        altar:set_position(x + 1, y)
        sensor_push_altar:set_position(xs + 1, ys)
      end)
    end
  end
end

function sensor_push_altar_end:on_activated()
  self:set_enabled(false)
  sensor_push_altar:set_enabled(false)
  map:set_entities_enabled("altar_opened",true)
  altar_closed:set_enabled(false)
  game:set_value("hyrule_castle_altar_pushed",true)
end

function sensor_zelda_dialog:on_activated()
  self:set_enabled(false)
  game:start_dialog("escape.zelda_following_2")
  game:set_value("zelda_rescued_dialog_2",true)
end