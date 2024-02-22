local map = ...
local game = map:get_game()

local cannonball_manager = require("scripts/maps/cannonball_manager")
cannonball_manager:create_cannons(map, "cannon_small_")
cannonball_manager:create_big_cannons(map, "cannon_big_")

local door_manager = require("scripts/maps/door_manager")
door_manager:manage_map(map)
local chest_manager = require("scripts/maps/chest_manager")
chest_manager:manage_map(map)
local separator_manager = require("scripts/maps/separator_manager")
separator_manager:manage_map(map)

function map:on_started()

  map:set_doors_open("auto_door_2_back")
  map:set_doors_open("auto_door_3_back")

  --Grande Clé obtenue
  if game:get_value("eastern_big_key") then map:set_entities_enabled("wall_switch_bk_",false) auto_chest_big_key:set_enabled(true) end
end

function sensor_close_auto_door_2_back:on_activated()
  self:set_enabled(false)
  map:close_doors("auto_door_2_back")
end

function sensor_close_auto_door_3_back:on_activated()
  self:set_enabled(false)
  map:close_doors("auto_door_3_back")
end

for enemy in map:get_entities("enemy_switch_bk_") do
  function enemy:on_dead()
    if map:get_entities_count("enemy_switch_bk_") == 0 then
      map:set_entities_enabled("wall_switch_bk_",false)
    end
  end
end