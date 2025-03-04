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
  if game:get_value("boss_moldorm_F6_ganon_tower_0") then
    sensor_boss_0:set_enabled(false)
    sensor_boss_1:set_enabled(false)
    bloc_F6_ganon_tower_0:set_enabled(true)
  end
  -- You can initialize the movement and sprites of various
  -- map entities here.
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

function sensor_boss_0:on_activated()
  sensor_boss_0:set_enabled(false)
  sensor_boss_1:set_enabled(false)
  boss_moldorm_F6_ganon_tower_0:set_enabled(true)
end

function sensor_boss_1:on_activated()
  sensor_boss_0:set_enabled(false)
  sensor_boss_1:set_enabled(false)
  boss_moldorm_F6_ganon_tower_0:set_enabled(true)
end

if boss_moldorm_F6_ganon_tower_0 then
  function boss_moldorm_F6_ganon_tower_0:on_dead()
    bloc_F6_ganon_tower_0:set_enabled(true)
    sol.audio.play_sound("chest_appears")
  end
end