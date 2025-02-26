-- Lua script of map A Link to the Past/Light World/Houses/sanctuary.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()    
  if game:get_value("zelda_called_for_help") and game:get_value("get_master_sword") then
    zelda:set_enabled(false)
    priest:set_enabled(false)
    if not game:get_value("priest_dead") then
      npc_priest_dying:set_enabled(true)
    end
  end
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

function npc_priest_dying:on_interaction()
  game:start_dialog("npc.priest.dying",function() 
    sol.timer.start(300, function() sol.audio.play_sound("warp") end)
    npc_priest_dying:get_sprite():fade_out(80, function() 
      npc_priest_dying:set_enabled(false) 
      game:set_value("priest_dead",true)     
    end)
  end)
end