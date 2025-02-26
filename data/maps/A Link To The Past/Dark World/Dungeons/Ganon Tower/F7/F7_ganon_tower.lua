-- Lua script of map A Link to the Past/Dark World/Dungeons/Ganon Tower/F7/F7_ganon_tower.
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
  npc_agahnim:get_sprite():set_direction(6)
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

--BOSS : Activation Agahnim 1
function sensor_boss:on_activated()
    self:set_enabled(false)
    hero:freeze()
    sol.timer.start(map,200,function()
      sol.audio.play_music("boss")
      hero:unfreeze()
      local m = sol.movement.create("straight")
      m:set_max_distance(16)
      m:set_angle(math.pi / 2)
      m:start(map:get_camera())

      boss_agahnim_F7_hyrule_castle_tower_0:set_enabled(true)
    end)
end

--BOSS : Activation Agahnim 2
function sensor_boss:on_activated()
  self:set_enabled(false)
  hero:freeze()
  
  game:start_dialog("enemy.agahnim2.introduction", function()
    sol.timer.start(map,200,function()
      sol.audio.play_music("boss")
      hero:unfreeze()
      local m = sol.movement.create("straight")
      m:set_max_distance(16)
      m:set_angle(math.pi / 2)
      m:start(map:get_camera())
      npc_agahnim:set_enabled(false)
      boss_agahnim_F7_ganon_tower_0:set_enabled(true)
    end)
  end)
end

--BOSS : Mort Agahnim 2, sur la Pyramide de Puissance pour l'affrontement Final
function boss_agahnim_F7_ganon_tower_0:on_dying()  
  sol.audio.stop_music()     
  sol.timer.start(6000, function ()
    sol.audio.play_sound("ocarina")
    sol.timer.start(2000, function ()
      hero:teleport("A Link to the Past/Dark World/Overworld/D4_pyramid", "dest_init_D4_pyramid_0", "fade")
      game:set_value("boss_agahnim_F7_ganon_tower_0", true)
      hero:unfreeze() 
    end)
  end)
end
