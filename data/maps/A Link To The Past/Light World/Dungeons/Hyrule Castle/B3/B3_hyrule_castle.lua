-- Lua script of map Archived/A Link to the Past/Light World/Non Playable Zone/Dungeons/Tower of Hera/F6/.
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
  if game:get_value("zelda_rescued") then
    zelda:set_enabled(false)
  end
end

function zelda:on_interaction()
  sol.audio.play_music("zelda")
  game:start_dialog("NoBigKey",function()
    game:set_value("zelda_rescued",true)
    sol.audio.play_music("castle")
  end)
end

function chest_lantern:on_opened()
  if game:get_value("get_lamp") then
    hero:start_treasure("consumables/rupee",2,"after_lamp_rupees_castleB3")
  else
    hero:start_treasure("inventory/lantern",1,"get_lamp")
  end
end