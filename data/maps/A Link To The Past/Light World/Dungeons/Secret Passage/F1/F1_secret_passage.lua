local map = ...
local game = map:get_game()

local door_manager = require("scripts/maps/door_manager")
door_manager:manage_map(map)
local chest_manager = require("scripts/maps/chest_manager")
chest_manager:manage_map(map)
local separator_manager = require("scripts/maps/separator_manager")
separator_manager:manage_map(map)

local altar_pushed = false

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

  if destination == sanctuary then sol.audio.play_music("sanctuary") end

  if destination == stair_e or destination == stair_w then
    map:set_tileset("dungeon/blue")
    dark_on = true
    map:set_light(0)
  end
  
end

function map:on_finished()
  dark_on = false
end

function auto_separator_5:on_activated(direction4)
  if direction4 == 3 then
    local i = 0
    sol.audio.play_music("sanctuary")
    if not altar_pushed then
      hero:freeze()
      local m = sol.movement.create("straight")
      m:set_angle(3 * math.pi / 2)
      m:set_max_distance(48)
      m:set_ignore_obstacles(true)
      m:start(hero,function()
        sol.timer.start(map,100,function()
          local x, y = altar:get_position()
          altar:set_position(x + 1, y)
          i = i + 1
          if i >= 32 then
            altar_opened:set_enabled(true)
            altar_closed:set_enabled(false)

--TODO : FIN DE L'ESCAPE ET ZELDA QUI SE MET A COTÉ DU CURÉ
            game:set_value("intro_done",true)

            altar_pushed = true
            hero:unfreeze()

          else return true end
        end)
      end)
    end
  else sol.audio.play_music("castle") end
end