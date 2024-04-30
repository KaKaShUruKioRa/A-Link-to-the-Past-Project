-- Lua script of map A Link To The Past/Light World/House/link_house.
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

function chest_lantern:on_opened()
  if game:get_value("get_lamp") then
    hero:start_treasure("consumables/rupee",2,"after_lamp_rupees_HOUSE")
  else
    hero:start_treasure("inventory/lantern",1,"get_lamp")
  end
end