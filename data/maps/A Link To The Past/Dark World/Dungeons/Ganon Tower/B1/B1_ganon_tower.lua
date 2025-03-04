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
  if game:get_value("boss_armos_B1_ganon_tower_0") then
    disabled_locked_door(false)
    sensor_boss:set_enabled(false)
  end
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

function sensor_boss:on_activated()
  sensor_boss:set_enabled(false)
  boss_armos_B1_ganon_tower_0:set_enabled(true)
end

if boss_armos_B1_ganon_tower_0 then
  function boss_armos_B1_ganon_tower_0:on_dead()
    game:set_value("boss_armos_B1_ganon_tower_0", true)
    disabled_locked_door(true)
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
end