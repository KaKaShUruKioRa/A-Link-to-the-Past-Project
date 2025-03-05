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
  if game:get_value("boss_lanmolas_F4_ganon_tower_0") and game:get_value("boss_lanmolas_F4_ganon_tower_1") and game:get_value("boss_lanmolas_F4_ganon_tower_2") then
    disabled_locked_door(false)    
    sensor_boss:set_enabled(false)
  end
  -- You can initialize the movement and sprites of various
  -- map entities here.
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

function sensor_boss:on_activated()
  sensor_boss:set_enabled(false)
  boss_lanmolas_F4_ganon_tower_0:set_enabled(true)
  boss_lanmolas_F4_ganon_tower_1:set_enabled(true)
  boss_lanmolas_F4_ganon_tower_2:set_enabled(true)
end

if boss_lanmolas_F4_ganon_tower_0 then
  function boss_lanmolas_F4_ganon_tower_0:on_dead()
    if game:get_value("boss_lanmolas_F4_ganon_tower_1") and game:get_value("boss_lanmolas_F4_ganon_tower_2") then
      disabled_locked_door(true)  
    end
  end
end

if boss_lanmolas_F4_ganon_tower_1 then
  function boss_lanmolas_F4_ganon_tower_1:on_dead()
    if game:get_value("boss_lanmolas_F4_ganon_tower_0") and game:get_value("boss_lanmolas_F4_ganon_tower_2") then
      disabled_locked_door(true)  
    end
  end
end
if boss_lanmolas_F4_ganon_tower_1 then
  function boss_lanmolas_F4_ganon_tower_2:on_dead()
    if game:get_value("boss_lanmolas_F4_ganon_tower_0") and game:get_value("boss_lanmolas_F4_ganon_tower_1") then
      disabled_locked_door(true)  
    end
  end
end

function disabled_locked_door(sound)  
  if sound == true then
    sol.audio.play_sound("door_open")
  end
  auto_door_1_back_1:set_enabled(false)
  auto_door_1_back_2:set_enabled(false)
  sensor_falling_auto_door_1_s_open:set_enabled(false)
  sensor_falling_auto_door_1_e_open:set_enabled(false)
  sensor_boss:set_enabled(false)
end