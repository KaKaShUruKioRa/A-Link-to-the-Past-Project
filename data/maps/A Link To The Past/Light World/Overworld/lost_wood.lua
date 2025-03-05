-- Lua script of map A Link to the Past/Light World/Overworld/Zone/lost_wood.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()  
  if game:get_value("get_master_sword") then
    for mist in map:get_entities("mist_lost_wood_") do
      mist:set_enabled(false)
    end
    if not game:get_value("zelda_called_for_help") then
      sensor_zelda_call_for_help:set_enabled(true)
    end
      light_lost_wood_0:set_enabled(true)
  else
    sol.audio.play_music("lost_woods")
  end
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

function sensor_zelda_call_for_help:on_activated()
  if game:get_value("get_master_sword") and not game:get_value("zelda_called_for_help") then
    local dialog_box = game:get_dialog_box()
    dialog_box:set_style("empty")
    game:start_dialog("npc.zelda.call_for_help", function() dialog_box:set_style("box") game:set_value("zelda_called_for_help",true) end)
  end
end