-- Lua script of map Archived/A Link to the Past/Light World/Non Playable Zone/Dungeons/Tower of Hera/F6/.
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

--GESTION DE LUMIERE DANS LA PIECE ET NIVEAUX D'OBSCURITE
require("scripts/maps/light_manager.lua")
local dark = sol.surface.create(320,240)
dark:set_opacity(150)
dark:fill_color({0, 0, 0})
for torch in map:get_entities("timed_torch_") do
  function torch:on_lit() 
    local opacity = dark:get_opacity()
    dark:set_opacity(opacity - 50)
    sol.timer.start(10000,function() 
      local opacity2 = dark:get_opacity()
      dark:set_opacity(opacity2 + 50) 
    end)
  end
end
map:register_event("on_draw", function(map, dst_surface)
  if dark_on then dark:draw(dst_surface) end
end)
-- Event called at initialization time, as soon as this map is loaded.
function map:on_started(destination)
  --Pièce dans le noir en arrivant
    dark_on = true
    map:set_light(0)
end

function map:on_finished()
  dark_on = false
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end
