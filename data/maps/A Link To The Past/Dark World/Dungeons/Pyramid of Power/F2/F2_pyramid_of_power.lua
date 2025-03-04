-- Lua script of map Archived/A Link to the Past/Light World/Non Playable Zone/Dungeons/Tower of Hera/F6/.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

local door_manager = require("scripts/maps/door_manager")
door_manager:manage_map(map)
local chest_manager = require("scripts/maps/chest_manager")
chest_manager:manage_map(map)
local separator_manager = require("scripts/maps/separator_manager")
separator_manager:manage_map(map)

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()
  local ground=game:get_value("tp_ground")
  if ground=="hole" then
    hero:set_visible(false)
  else
    hero:set_visible()
  end

  if game:get_value("boss_ganon") then 
    sol.audio.stop_music()
    npc_ganon:set_enabled(false)
    sensor_boss:set_enabled(false)
    map:set_entities_enabled("dynamic_tile_ground_", false)
    map:set_entities_enabled("dynamic_tile_end_", true)
    map:set_entities_enabled("tp_hole_", true) 
    tp_hole_F2_pyramid_of_power_1:set_enabled(false)
  end
end

function map:on_finished()
  game:set_value("half_life_boss_ganon", false)
end

--BOSS : Activation Ganon
function sensor_boss:on_activated()
  self:set_enabled(false)
  hero:freeze()
  
  sol.timer.start(1300, function()
    game:start_dialog("enemy.ganon.introduction", function()
      sol.timer.start(map,200,function()
        sol.audio.play_music("ganon_battle")
        npc_ganon:set_enabled(false)
        boss_ganon:set_enabled(true)
        hero:unfreeze()
        boss_ganon:set_enabled(true)
      end)
    end)
  end)
end

--BOSS : Mort Ganon
function boss_ganon:on_dead()
  game:set_life(game:get_max_life()) 
  sol.audio.play_music("victory")
  hero:start_victory(function()
    game:set_value("boss_ganon", true)
    for dynamic_tile_end in map:get_entities("dynamic_tile_end_") do
      dynamic_tile_end:set_enabled(true)
    end
    tp_hole_F2_pyramid_of_power_1:set_enabled(false)
    hero:unfreeze()
  end)
end

function boss_ganon:on_movement_started()
  if boss_ganon:get_life() < 50 and not game:get_value("half_life_boss_ganon") then
    game:set_value("half_life_boss_ganon", true)
    local timer_to_hole = 1000
    for dynamic_tile_ground in map:get_entities("dynamic_tile_ground_") do
      sol.timer.start(timer_to_hole, function()
        sol.audio.play_sound("quake", function() sol.audio.play_sound("stone") end)
        dynamic_tile_ground:set_enabled(false)
      end)
        timer_to_hole = timer_to_hole + 2000
    end
    timer_to_hole = 1000
    local i = 0
    for tp_hole in map:get_entities("tp_hole_") do
      if i < 3 then
        i = i + 1
      else
        timer_to_hole = timer_to_hole + 2000
      end          
      sol.timer.start(timer_to_hole, function()
        tp_hole:set_enabled(true)
      end)
    end
  end
end
