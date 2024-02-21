local map = ...
local game = map:get_game()

local cannonball_manager = require("maps/lib/cannonball_manager")
cannonball_manager:create_cannons(map, "cannon_")

local door_manager = require("maps/lib/door_manager")
door_manager:manage_map(map)
local chest_manager = require("maps/lib/chest_manager")
chest_manager:manage_map(map)
local separator_manager = require("maps/lib/separator_manager")
separator_manager:manage_map(map)

function map:on_started()

  map:set_doors_open("auto_door_2_back")
end

function sensor_close_auto_door_2_back:on_activated()
  self:set_enabled(false)
  map:close_doors("auto_door_2_back")
end