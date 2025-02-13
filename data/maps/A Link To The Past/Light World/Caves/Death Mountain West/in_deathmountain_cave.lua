-- Lua script of map A Link To The Past/Light World/Caves/lost_wood_cave - Copie (5).
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

local door_manager = require("scripts/maps/door_manager")
door_manager:manage_map(map)
local chest_manager = require("scripts/maps/chest_manager")
chest_manager:manage_map(map)
local separator_manager = require("scripts/maps/separator_manager")
separator_manager:manage_map(map)

--GESTION DE LUMIERE DANS LA PIECE
require("scripts/maps/light_manager.lua")
local dark = sol.surface.create(320,240)
dark:set_opacity(150)
dark:fill_color({0, 0, 0})
map:register_event("on_draw", function(map, dst_surface)
  if dark_on then dark:draw(dst_surface) end
end)

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()
  dark_on = true
  map:set_light(0)
  
  if not game:has_item("inventory/magic_mirror") then
    grandpa_follower:set_enabled(false)
  end
end

function grandpa_start_dialog()
  if grandpa_follower:is_enabled() then
    self:set_enabled(false)
    grandpa_dialog_first_meeting_0:set_enabled(false)
    grandpa_dialog_warning_hole:set_enabled(false)
    grandpa_dialog_pot_heart:set_enabled(false)
    grandpa_dialog_turn_right:set_enabled(false)
    game:start_dialog("npc.grandpa.first_meeting")
    game:start_dialog("npc.grandpa.warning_hole")
    game:start_dialog("npc.grandpa.pot_heart")
    game:start_dialog("npc.grandpa.pot_heart")
  end 
end

function sensor_grandpa_follower:on_activated()
  if not game:has_item("inventory/magic_mirror") then
    grandpa_follower:set_enabled(true)
    grandpa_follower:set_position(hero:get_position())
  end
end

function grandpa_dialog_first_meeting_0:on_activated()
  if grandpa_follower:is_enabled() then
    self:set_enabled(false)
    game:start_dialog("npc.grandpa.first_meeting")
  end
end

function grandpa_dialog_warning_hole:on_activated()
  if grandpa_follower:is_enabled() then
    self:set_enabled(false)
    game:start_dialog("npc.grandpa.warning_hole")
  end
end

function grandpa_dialog_pot_heart:on_activated() 
  if grandpa_follower:is_enabled() then
    self:set_enabled(false)
    game:start_dialog("npc.grandpa.pot_heart")
  end
end

function grandpa_dialog_turn_right:on_activated()
  if grandpa_follower:is_enabled() then
    self:set_enabled(false)
    game:start_dialog("npc.grandpa.turn_right")
  end
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end