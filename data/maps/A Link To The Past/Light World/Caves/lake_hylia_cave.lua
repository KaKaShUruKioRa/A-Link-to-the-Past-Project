-- Lua script of map A Link to the Past/Light World/Caves/lake_hylia_cave.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

  -- You can initialize the movement and sprites of various
  -- map entities here.
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

function green_thief_lake_hylia_cave_0:on_interaction()
  game:start_dialog("npc.thief.it_s_a_secret", function ()
    if not game:get_value("secret_rupee_lake_hylia_cave_0") then
      hero:start_treasure("consumables/rupee", 6, "secret_rupee_lake_hylia_cave_0")
    end
  end)
end
 