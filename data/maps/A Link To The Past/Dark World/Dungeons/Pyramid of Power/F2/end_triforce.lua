-- Lua script of map A Link to the Past/Dark World/Dungeons/Pyramid of Power/F2/end.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()
  triforce_flotting()
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()
  local hero_sprite = hero:get_sprite()
  mov = sol.movement.create("target")
  mov:set_speed(44)
  mov:set_target(link_start_pos)
  hero_sprite:set_animation("walking")
  mov:start(hero, function()
    sol.audio.play_music("triforce")
    local dialog_box = game:get_dialog_box()
    dialog_box:set_style("empty")
    game:start_dialog("end.triforce", function()
      triforce_to_static()
      mov = sol.movement.create("target")
      mov:set_speed(22)
      mov:set_target(link_last_pos)
      hero_sprite:set_animation("walking")
      mov:start(hero, function()
        hero:set_direction(3)
        hero_sprite:set_animation("brandish")
        sol.timer.start(2000, function()
          game:start_dialog("demo.end",function() 
            dialog_box:set_style("box")
            game:set_value("end_credits", true)
            game:set_value("free_mode", false)
            sol.timer.start(1000, function() hero:teleport("A Link to the Past/Light World/Overworld/hyrule_castle", "dest_end_credits") end)
          end)
        end)
      end)
    end)
  end)  
end

-- Triforce end scene flotting 
function triforce_flotting()
  local triforce_sprite = triforce:get_sprite()
  triforce_sprite:set_ignore_suspend()
  triforce_sprite:set_animation("introduction", function()
    triforce_sprite:set_animation("flotting")
  end)
end

-- Triforce end scene to_static 
function triforce_to_static()
  local triforce_sprite = triforce:get_sprite()
  triforce_sprite:set_animation("to_static", function()
    triforce_sprite:set_animation("static")
  end)
end