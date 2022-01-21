-- Lua script of map Non_Playable Zone/entrance_lost_wood_npz.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()
warp_entrance_lost_wood_0:set_enabled(true)
  -- You can initialize the movement and sprites of various
  -- map entities here.
end

function stone_white_entrance_lost_wood_0:on_lifting(hero, stone_white_entrance_lost_wood_0)
  warp_entrance_lost_wood_0:set_enabled(true)
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end
