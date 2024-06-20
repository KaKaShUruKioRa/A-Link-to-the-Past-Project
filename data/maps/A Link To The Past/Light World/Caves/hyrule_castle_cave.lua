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
  local ground=game:get_value("tp_ground")
  if ground=="hole" then
    hero:set_visible(false)
  else
    hero:set_visible()
  end
  if not game:get_value("intro_done") then
    map:set_entities_enabled("intro_",true)
    sol.audio.play_music("beginning")
  else
    sol.audio.play_music("cave")
  end
  if game:get_value("get_sword_1") then
    sensor_uncle_death:set_enabled(false)
    uncle:set_enabled(false)
  end

  if game:get_value("follower_zelda_on") then
    zelda_follower:set_enabled(true)
    zelda_follower:set_position(hero:get_position())
  end
end

function sensor_uncle_death:on_activated()
  self:set_enabled(false)
  game:start_dialog("escape.uncle_dead",function()
    uncle:get_sprite():set_direction(0)
    hero:start_treasure("equipment/sword",1,"get_sword_1",function()
      game:set_ability("shield",1)
      game:get_item("equipment/shield"):set_variant(1)
    end)
  end)
end

function chest_lantern:on_opened()
  if game:get_value("get_lamp") then
    hero:start_treasure("consumables/rupee",2,"after_lamp_rupees_castleCAVE")
  else
    hero:start_treasure("inventory/lantern",1,"get_lamp")
  end
end