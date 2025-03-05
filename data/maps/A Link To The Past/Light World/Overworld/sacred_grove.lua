-- Lua script of map A Link to the Past/Light World/Overworld/sacred grove.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()
  excalibur:set_drawn_in_y_order()
  excalibur:bring_to_front()
  if not game:get_item("equipment/sword"):has_variant(2) then
      excalibur_sprite = excalibur:create_sprite("entities/excalibur")
      excalibur_sprite:set_animation("walking")
   else      
    excalibur:set_enabled(false)
    for mist in map:get_entities("mist_sacred_grove_") do
      mist:set_enabled(false)
    end
  end
  
  -- You can initialize the movement and sprites of various
  -- map entities here.
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

function excalibur:on_interaction()
  if game:has_item("quest/pendant_of_courage") and game:has_item("quest/pendant_of_power") and game:has_item("quest/pendant_of_wisdom") then
    hero:freeze()
    sol.audio.play_music("excalibur")
    excalibur:set_enabled(false)    

    hero:start_treasure("equipment/sword", 2, "get_master_sword", function()
      for mist in map:get_entities("mist_sacred_grove_") do
          mist:set_enabled(false)
      end
      game:start_dialog("npc.sahasrahla.master_sword", function()
        sol.audio.play_music("overworld")
        hero:unfreeze()
      end)
    end)
  end
end

function crypted_stone_sacred_grove_0:on_interaction()
  if game:has_item("equipment/book_of_mudora") then
    game:start_dialog("uncrypted.grove_stone")
  else
    game:start_dialog("crypted.grove_stone")
  end  
end