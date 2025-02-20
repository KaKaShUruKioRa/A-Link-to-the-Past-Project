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
dark:set_opacity(50)
dark:fill_color({0, 0, 0})
map:register_event("on_draw", function(map, dst_surface)
  dark:draw(dst_surface)
end)

function map:on_started(destination)
  --Pièce dans le noir en arrivant
  dark_on = true
  map:set_light(0)
end

function map:on_finished()
  dark_on = false
end