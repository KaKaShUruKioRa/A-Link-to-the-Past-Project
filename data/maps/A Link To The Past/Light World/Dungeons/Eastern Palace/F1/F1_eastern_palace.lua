local map = ...
local game = map:get_game()

local cannonball_manager = require("scripts/maps/cannonball_manager")
cannonball_manager:create_cannons(map, "cannon_small_", 1000, 5)
cannonball_manager:create_cannons(map, "cannon_big_", 5000, nil, "traps/cannonball_big")

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
  --Pièce dans le noir en arrivant
  if destination == stair_n then
    dark_on = true
    map:set_light(0)
  end
  --Grande Clé obtenue
  if game:get_value("eastern_big_key") then map:set_entities_enabled("wall_switch_bk_",false) auto_chest_big_key:set_enabled(true) end
end

function map:on_finished()
  dark_on = false
end

--EXCEPTION : PORTE AUTOMATIQUE MAIS AUSSI TRANSITION VERS PIÈCE SOMBRE
function tp_to_dark_3:on_activated()
  map:open_doors("auto_door_3")
  sol.timer.start(game,650,function()
    dark_on = true
    map:set_light(0)
  end)
end
function sensor_falling_auto_door_3_s_open:on_activated()
  sol.timer.start(game,10,function()
      hero:freeze()
      hero:set_animation("walking")
      hero:set_direction(3)
      local movement = sol.movement.create("straight")
      movement:set_speed(88)
      local angle = 3 * math.pi / 2
      movement:set_angle(angle)
      movement:set_max_distance(48) 
      movement:start(hero, function() map:close_doors("auto_door_3") hero:unfreeze() end)
  end)
end

for enemy in map:get_entities("enemy_switch_bk_") do
  function enemy:on_dead()
    if map:get_entities_count("enemy_switch_bk_") == 0 then
      map:set_entities_enabled("wall_switch_bk_",false)
    end
  end
end

function sensor_skeleton_spawn:on_activated()
  self:set_enabled(false)
  sol.timer.start(map,1000,function()
    local i = 0
    sol.timer.start(map,550,function()
      i = i + 1
      sol.audio.play_sound("cape")
      map:get_entity("smoke_"..i):set_enabled(true)
      sol.timer.start(map,200,function()
        map:get_entity("auto_enemy_auto_door_7_"..i):set_enabled(true)
      end)
      return i < 4
    end)
  end)
end