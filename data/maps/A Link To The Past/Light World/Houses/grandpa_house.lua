-- Lua script of map A Link to the Past/Light World/Houses/grandpa_house.
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

function heal_hero()
  game:set_life(game:get_max_life())
end

function grandpa:on_interaction()
  if game:has_item("equipment/moon_pearl") then
    game:start_dialog("npc.grandpa.moon_perl", function() 
      heal_hero()
    end)
  else
    game:start_dialog("npc.grandpa.at_home", function() 
      heal_hero()
    end)
  end
end