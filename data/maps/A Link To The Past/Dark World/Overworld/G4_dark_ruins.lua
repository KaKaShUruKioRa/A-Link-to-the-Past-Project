-- Lua script of map Non_Playable Zone/great_swamp_npz.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

local jumping = false
local npc_kiki = map:create_npc({ 
  ["name"] = "npc_kiki", 
  ["layer"] = 1,
  ["x"] = 0,
  ["y"] = 0, 
  ["direction"] = 0,
  ["subtype"] = 1,
  ["sprite"] = "npc/monkey" })

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()
  if game:get_value("palace_of_darkness_opened") then
    map:set_entities_enabled("dynamic_tile_open_dungeon_", true)
    map:remove_entities("sensor_")
    dynamic_tile_switch_kiki_0:remove()
  end
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

function sensor_kiki_follower:on_activated()
  map:set_entities_enabled("sensor_", true)
  self:set_enabled(false)
  npc_kiki_follower:set_enabled(true)
  npc_kiki_follower:set_position(hero:get_position())
end

function sensor_kiki_trigger:on_activated()
  kiki_opening_question()
end

function sensor_kiki_cost_0:on_activated()
  kiki_folowing_question()
end

function sensor_kiki_cost_1:on_activated()
  kiki_folowing_question()
end

function sensor_no_entry:on_activated()
  if npc_kiki_follower:is_enabled() then
    game:start_dialog("npc.kiki.no_entry")
    wall_no_entry_0:set_enabled(true) 
  else 
    wall_no_entry_0:set_enabled(false) 
  end
end

function kiki_folowing_question() 
  if npc_kiki_follower:is_enabled() then
    game:start_dialog("npc.kiki.following_question",function(answer)
      if answer == 2 and game:get_money() >= 10 then
        game:start_dialog("npc.kiki.following_yes")
        game:remove_money(10)
        map:set_entities_enabled("sensor_kiki_cost_", false)
      else
        game:start_dialog("npc.kiki.following_no", function()
          kiki_run_away()
        end)
      end
    end)
  end
end

function kiki_opening_question() 
  if npc_kiki_follower:is_enabled() then
    game:start_dialog("npc.kiki.opening_question",function(answer)
      if answer == 2 and game:get_money() >= 100 then
        sensor_kiki_trigger:set_enabled(false)
        kiki_open_door()
      elseif answer == 2 and game:get_money() < 100 then
        game:start_dialog("npc.kiki.opening_no", function()
        kiki_run_away()
        end)
      else
        game:start_dialog("npc.kiki.opening_no", function()
          kiki_run_away()
        end)
      end
    end)
  end
end

function kiki_open_door()
  game:start_dialog("npc.kiki.opening_yes", function()
    hero:freeze()
    game:remove_money(100)
    local mov_kiki_to_trigger = sol.movement.create("target")

    mov_kiki_to_trigger:set_target(kiki_last_pos_3)
    mov_kiki_to_trigger:set_speed(33)
    mov_kiki_to_trigger:set_ignore_obstacles(true)
    
    npc_kiki:set_position(npc_kiki_follower:get_position())
    npc_kiki:set_layer(1)
    npc_kiki:set_enabled(true)
    jumping = false

    -- Modif event de on_direction_changed : s'assure que Kiki saute pendant le mouvement
    local function on_frame_changed()
      if jumping == 1 then
        npc_kiki:get_sprite():set_animation("jumping")
      elseif jumping == 2 then
        npc_kiki:get_sprite():set_direction(3)
        npc_kiki:get_sprite():set_animation("jumping")
      end
    end
    --TODO : trouvez une meilleurs façon d'animé le saut du singe
    npc_kiki:get_sprite().on_frame_changed = on_frame_changed

    --Remplace le Follower par un NPC pour qu'il puisse reach sa target
    npc_kiki_follower:set_enabled(false)

    mov_kiki_to_trigger:start(npc_kiki, function()
      jumping = 1
      sol.audio.play_sound("jump")
      mov_kiki_to_trigger:set_target(kiki_last_pos_2)

      mov_kiki_to_trigger:start(npc_kiki, function()
        jumping = 2
        sol.audio.play_sound("jump")
        mov_kiki_to_trigger:set_target(kiki_last_pos_1)

        mov_kiki_to_trigger:start(npc_kiki, function()
          jumping = false

          mov_kiki_to_trigger:set_target(kiki_last_pos_0)

          mov_kiki_to_trigger:start(npc_kiki, function()
            jumping = 1            
            mov_kiki_to_trigger:stop()
            npc_kiki:get_sprite():set_animation("jumping")
            npc_kiki:get_sprite():set_direction(0)
            sol.audio.play_sound("jump")

            -- Opening Palace Sound & Dynamic Tiles
            local i = 0
            sol.timer.start(500, function() 
              i = i + 1
              
              if i == 1 then
                jumping = false
                npc_kiki:get_sprite():set_animation("stopped")
                npc_kiki:get_sprite():set_direction(3)
                dynamic_tile_switch_kiki_0:set_enabled(false)
                sol.audio.play_sound("switch")
                return true
              elseif i < 5 then 
                sol.audio.play_sound("explosion")
                return true
              else
                map:set_entities_enabled("dynamic_tile_open_dungeon_", true)
                game:set_value("palace_of_darkness_opened", true)
                hero:unfreeze()
                return false
              end
            end)

          end)
        end)
      end)
    end)
  end)
end

function kiki_run_away()
  local mov_kiki_to_trigger = sol.movement.create("target")

  mov_kiki_to_trigger:set_target(sensor_kiki_follower)
  mov_kiki_to_trigger:set_speed(96)
  mov_kiki_to_trigger:set_ignore_obstacles(true)
  
  npc_kiki:set_position(npc_kiki_follower:get_position())
  npc_kiki:set_layer(1)
  npc_kiki:set_enabled(true)
  
  --Remplace le Follower par un NPC pour qu'il puisse reach sa target
  npc_kiki_follower:set_enabled(false)
  
  npc_kiki:get_sprite():set_animation("jumping")
  mov_kiki_to_trigger:start(npc_kiki, function()
    npc_kiki:set_enabled(false)

    sensor_kiki_follower:set_enabled(true)
    end)  
end

local function hurted()
   kiki_run_away()
end

hero.on_hurt = hurted
