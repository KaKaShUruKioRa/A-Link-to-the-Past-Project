local map = ...
local game = map:get_game()

local cannonball_manager = require("scripts/maps/cannonball_manager")
cannonball_manager:create_cannons(map, "cannon_small_", 1000, 5)

local door_manager = require("scripts/maps/door_manager")
door_manager:manage_map(map)
local chest_manager = require("scripts/maps/chest_manager")
chest_manager:manage_map(map)
local separator_manager = require("scripts/maps/separator_manager")
separator_manager:manage_map(map)

function map:on_started()

  map:set_doors_open("auto_door_2")
  map:set_doors_open("auto_door_3")
end

function sensor_close_auto_door_2:on_activated()
  map:set_entities_enabled("sensor_close_auto_door_2",false)
  map:close_doors("auto_door_2")
end

function sensor_close_auto_door_3:on_activated()
  map:set_entities_enabled("sensor_close_auto_door_3",false)
  map:close_doors("auto_door_3")
end