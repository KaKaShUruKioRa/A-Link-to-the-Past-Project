-- Lua script of map A Link to the Past/Light World/Caves/blacksmiths_cave.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()
  if game:get_value("get_demi_magic_meter") then
    npc_purple_mad_better_0:set_enabled(false)
  end
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

function npc_purple_mad_better_0:on_interaction()
  game:start_dialog("npc.purple_mad.before_demi_magic", function()
    hero:freeze()
    hero:get_sprite():set_animation("electrocuted")
    sol.audio.play_sound("ritual_shock")
    sol.timer.start(3000, function()
      hero:get_sprite():set_animation("stopped_with_shield")
      game:get_item("equipment/magic_meter"):set_variant(2)
      game:set_value("get_demi_magic_meter", true)
      game:start_dialog("npc.purple_mad.after_demi_magic", function()
        npc_purple_mad_better_0:set_enabled(false)
        sol.audio.play_sound("cane")
        hero:unfreeze()
      end)  
    end)
  end)
end