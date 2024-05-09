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
  if dark_on then dark:draw(dst_surface) end
end)

function map:on_started(destination)

  if destination == stair_w then
    dark_on = true
    map:set_light(0)
  end

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

function weak_door_1:on_opened() sol.audio.play_sound("secret") end
function weak_door_2:on_opened() sol.audio.play_sound("secret") end