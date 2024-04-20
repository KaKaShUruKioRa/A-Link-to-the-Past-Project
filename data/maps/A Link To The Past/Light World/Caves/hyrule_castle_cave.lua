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
local torch_on = 0
for torch in map:get_entities("timed_torch_") do
  function torch:on_lit()
    torch_on = torch_on + 1
    local opacity = dark:get_opacity()
    dark:set_opacity(math.max(opacity - 50,0))
    sol.timer.start(10000,function()
      torch_on = torch_on - 1
      if torch_on <= 3 then
        local opacity2 = dark:get_opacity()
        dark:set_opacity(math.min(opacity2 + 50,255)) 
      end
    end)
  end
end
map:register_event("on_draw", function(map, dst_surface)
  dark:draw(dst_surface)
end)

function map:on_started()
  
end