-- Lua script of map Non_Playable Zone/sanctuary_npz.
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
  if game:get_value("demo_part_1_dialog_ok") then
    sensor_demo_part_one_ended:set_enabled(false)
  end
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

-- Event : Démo Partie 1 Terminée
function sensor_demo_part_one_ended:on_activated()
  self:set_enabled(false)
      local dialog_box = game:get_dialog_box()
      dialog_box:set_style("empty")
      game:start_dialog("demo.part_one",function() dialog_box:set_style("box") game:set_value("demo_part_1_dialog_ok",true) end)
end