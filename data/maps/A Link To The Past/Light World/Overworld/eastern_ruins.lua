-- Lua script of map Non_Playable Zone/great_swamp_npz.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started(destination)
  -- You can initialize the movement and sprites of various
  -- map entities here.  
  if destination == dest_dungeon_eastern_ruins_0 then
      if game:get_value("demo_part_2_dialog_ok") then return end
      if game:get_value("get_pendant_of_courage") then
      local dialog_box = game:get_dialog_box()
        dialog_box:set_style("empty")
        game:start_dialog("demo.part_two",function() dialog_box:set_style("box") game:set_value("demo_part_2_dialog_ok",true) end)
  end
end

end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end
