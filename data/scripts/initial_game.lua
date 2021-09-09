-- This script initializes game values for a new savegame file.
-- You should modify the initialize_new_savegame() function below
-- to set values like the initial life and equipment
-- as well as the starting location.
--
-- Usage:
-- local initial_game = require("scripts/initial_game")
-- initial_game:initialize_new_savegame(game)

local initial_game = {}

-- Sets initial values to a new savegame file.
function initial_game:initialize_new_savegame(game)

  -- You can modify this function to set the initial life and equipment
  -- and the starting location.
  game:set_starting_location("A Link To The Past/Light World/Overworld/overworld_light", "starting_destination")

  -- game:set_starting_location("Non_Playable Zone/desert_of_mystery_npz", "start_dest")
  -- game:set_starting_location("A Link To The Past/Light World/Overworld/Zone/desert_of_mystery", "start_dest")

  -- game:set_starting_location("A Link To The Past/Light World/Overworld/Zone/turtle_rock", "start_dest")
  -- game:set_starting_location("Non_Playable Zone/turtle_rock", "start_dest")
  -- game:set_starting_location("test_map/dungeon_entrance", "starting_destination")

  game:set_max_life(6)
  game:set_life(game:get_max_life())
  game:set_max_money(100)
  game:set_ability("lift", 0)
  game:set_ability("sword", 1)
  game:get_item("equipment/tunic"):set_variant(1)
  game:get_item("equipment/piece_of_heart_counter"):set_variant(1)
  
  -- default command binding
  game:set_value("keyboard_save", "escape")
end

return initial_game
