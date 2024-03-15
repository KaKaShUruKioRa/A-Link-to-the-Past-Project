local map = ...
local game = map:get_game()

local cannonball_manager = require("scripts/maps/cannonball_manager")
cannonball_manager:create_cannons(map, "cannon_small_", 1000, 5)
cannonball_manager:create_cannons(map, "cannon_big_", 5000, nil, "traps/cannonball_big")

local door_manager = require("scripts/maps/door_manager")
door_manager:manage_map(map)
local chest_manager = require("scripts/maps/chest_manager")
chest_manager:manage_map(map)
local separator_manager = require("scripts/maps/separator_manager")
separator_manager:manage_map(map)

function map:on_started()
  --Grande Clé obtenue
  if game:get_value("eastern_big_key") then map:set_entities_enabled("wall_switch_bk_",false) auto_chest_big_key:set_enabled(true) end
end

for enemy in map:get_entities("enemy_switch_bk_") do
  function enemy:on_dead()
    if map:get_entities_count("enemy_switch_bk_") == 0 then
      map:set_entities_enabled("wall_switch_bk_",false)
    end
  end
end

function sensor_skeleton_spawn:on_activated()
  self:set_enabled(false)
  sol.timer.start(map,1000,function()
    local i = 0
    sol.timer.start(map,550,function()
      i = i + 1
      sol.audio.play_sound("cape")
      map:get_entity("smoke_"..i):set_enabled(true)
      sol.timer.start(map,200,function()
        map:get_entity("auto_enemy_auto_door_7_"..i):set_enabled(true)
      end)
      return i < 4
    end)
  end)
end