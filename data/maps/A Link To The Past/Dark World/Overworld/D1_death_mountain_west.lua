-- Lua script of map Non_Playable Zone/death_mountain_west.
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

function npc_cursed_bully_D1_death_moutain_west_0:on_interaction()
  if not game:has_item("equipment/moon_pearl") then  
    game:start_dialog("npc.cursed_bully.meeting")
  else
    game:start_dialog("npc.cursed_bully.moon_pearl")
  end
end

function npc_pink_ball_D1_death_moutain_west_0:on_interaction()
  if not game:has_item("equipment/moon_pearl") then  
    game:start_dialog("npc.pink_ball.meeting")
  else
    game:start_dialog("npc.pink_ball.moon_pearl")
  end
end