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

  if game:get_value("follower_zelda_on") then
    sensor_zelda_dialog:set_enabled(true)
    sensor_zelda_dialog_2:set_enabled(true)
    sol.timer.start(map,1600,function()
      zelda_follower:set_enabled(true)
      zelda_follower:set_position(hero:get_position())
      zelda:set_enabled(false)
    end)
  end

  if game:get_value("zelda_rescued_dialog_4") then sensor_zelda_dialog:set_enabled(false) end
  if game:get_value("zelda_rescued_dialog_5") then sensor_zelda_dialog_2:set_enabled(false) end
  
end

function map:on_finished()
  dark_on = false
end

function sensor_zelda_dialog:on_activated()
  self:set_enabled(false)
  game:start_dialog("escape.zelda_following_4")
  game:set_value("zelda_rescued_dialog_4",true)
end
function sensor_zelda_dialog_2:on_activated()
  self:set_enabled(false)
  game:start_dialog("escape.zelda_following_5")
  game:set_value("zelda_rescued_dialog_5",true)
end

local function priest_question()
  game:start_dialog("escape.end_3",function(answer)
    if answer == 2 then
      zelda:get_sprite():set_direction(3)
      priest:get_sprite():set_direction(3)
      game:set_value("intro_done",true)
      altar_pushed = true
      hero:unfreeze()
    else priest_question()
    end
  end)
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
            if not game:get_value("intro_done") then
              game:set_value("follower_zelda_on",false)
              zelda_follower:set_enabled(false)
              zelda_2:set_enabled(true)
              priest:get_sprite():set_direction(1)
              game:start_dialog("escape.end_1",function()
                local m = sol.movement.create("path")
                m:set_path{6,6,6,6,6,6,0,0,6,6,6}
                m:set_speed(48)
                m:set_ignore_obstacles(true)
                m:start(zelda_2,function()
                  zelda:set_enabled(true)
                  zelda_2:set_enabled(false)
                  zelda:get_sprite():set_direction(1)
                  game:start_dialog("escape.end_2",function()
                    sol.timer.start(map, 100, function()
                      priest_question()
                    end)
                  end)
                end)
              end)
            else
              altar_pushed = true
              hero:unfreeze()
            end
          else return true end
        end)
      end)
    end
  else sol.audio.play_music("castle") end
end

function map:on_update()

  -- npc turn toward hero
  local x, y = priest:get_position()
  local turn_toward = sol.movement.create("target")
  turn_toward:set_target(hero, -x, -y)
  turn_toward:set_speed(0)
  priest:get_sprite():set_direction(turn_toward:get_direction4())
  turn_toward:start(priest)

  local x, y = zelda:get_position()
  local turn_toward = sol.movement.create("target")
  turn_toward:set_target(hero, -x, -y)
  turn_toward:set_speed(0)
  zelda:get_sprite():set_direction(turn_toward:get_direction4())
  turn_toward:start(zelda)

end