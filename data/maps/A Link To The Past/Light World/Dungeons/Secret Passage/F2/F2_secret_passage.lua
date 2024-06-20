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

function map:on_started(destination)

  if destination == secret_passage then
    map:set_doors_open("auto_door_1")
    if game:get_value("follower_zelda_on") then
        zelda_follower:set_enabled(true)
        zelda_follower:set_position(hero:get_position())
    end
  else sensor_falling_auto_door_1_n_open:set_enabled(false) end

  dark_on = true
  map:set_light(0)

  if game:get_value("follower_zelda_on") then
    sol.timer.start(map,1600,function()
      zelda_follower:set_enabled(true)
      zelda_follower:set_position(hero:get_position())
    end)
  end
  
end

function map:on_finished()
  dark_on = false
end

--EXCEPTION : PORTE AUTOMATIQUE ENTRÉE PASSAGE
function sensor_falling_auto_door_1_n_open:on_activated()
  self:set_enabled(false)
  sol.timer.start(game,10,function()
    map:close_doors("auto_door_1")
  end)
end