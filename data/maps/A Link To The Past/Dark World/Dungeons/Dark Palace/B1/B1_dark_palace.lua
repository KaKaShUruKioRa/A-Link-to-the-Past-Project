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
  if not game:get_value("heart_container_dark_palace") and game:get_value("treasure_hammer_F1_dark_palace_0") then
      boss_helmasaur_king_0:set_enabled()
  else 
    boss_helmasaur_king_0:set_enabled(false)
  end
end

function dest_warp_B1_dark_palace_0:on_activated()
  if not game:get_value("heart_container_dark_palace") and game:get_value("treasure_hammer_F1_dark_palace_0") then
    boss_helmasaur_king_0:set_enabled()
  else 
    boss_helmasaur_king_0:set_enabled(false)
  end
end
-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end
