-- Lua script of map A Link to the Past/Light World/Houses/sahasrahla_hideout.
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

-- Dialogues Sahasrahla
  function sahasrahla:on_interaction()
  -- On a les bottes, dirige vers la suite
  if game:get_value("possession_pegasus_boots") then 
      game:start_dialog("demo.sahasrahla.hint_repeat")
  -- On a trouvé le Pendentif, donne les bottes et dirige vers la suite
  elseif game:get_value("get_pendant_of_courage") then
    game:start_dialog("npc.sahasrahla.first_meeting", function()
      game:start_dialog("npc.sahasrahla.give_courage_pendent",function()
        hero:start_treasure("equipment/pegasus_shoes", 1, "get_pegasus_shoes", function()
        game:start_dialog("demo.sahasrahla.hint_dungeon2_and_3") 
      end)
    end)
  end)
  -- Défaut: dirige vers Eastern Palace
  else 
    game:start_dialog("npc.sahasrahla.first_meeting", function()
      game:start_dialog("npc.sahasrahla.first_meeting_question", function()
        game:start_dialog("npc.sahasrahla.first_meeting_answer")
      end)
    end)
  end
end
