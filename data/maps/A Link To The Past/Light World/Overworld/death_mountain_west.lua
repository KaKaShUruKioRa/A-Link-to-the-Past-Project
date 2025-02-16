-- Lua script of map Non_Playable Zone/death_mountain_west.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local hero = map:get_hero()

local grandpa = map:create_npc({ 
  ["name"] = "grandpa", 
  ["layer"] = 0,
  ["x"] = 0,
  ["y"] = 0, 
  ["direction"] = 0,
  ["subtype"] = 1,
  ["sprite"] = "npc/lost_old_man" })

local bunny_link = sol.state.create("bunny_link")

function bunny_transformation()
  -- ! Bunny Transformation !
  if not game:has_item("equipment/moon_pearl") then  
  
    sol.audio.play_music("rabbit")
      
    bunny_link:set_can_control_direction(true)
    bunny_link:set_can_control_movement(true)
    bunny_link:set_can_interact(true)
    bunny_link:set_can_use_sword(false) 
    bunny_link:set_can_use_shield(false)
    bunny_link:set_can_grab(false)
    bunny_link:set_can_use_item(false)
    bunny_link:set_can_use_item("inventory/magic_mirror", true)
    bunny_link:set_can_push(false)
    
    game:set_ability("shield", 0)
    game:set_ability("lift", 0)
    
    hero:start_state(bunny_link)
    
    hero:set_tunic_sprite_id("hero/bunny")
  end
end

local function change_world(to_dark)
  -- Faire Disparaitre/Apparaitre les TP/warps Accessible en Priorité au changement de Monde(Dark/Light)
  warp_death_mountain_west_0:set_enabled(not to_dark)  
  tp_cave_death_mountain_west_0:set_enabled(not to_dark)

    --Transformation du Lapin en Héro et du Monde en Light World (Désactivation Shaders) 
  if to_dark == false then
    map:set_tileset("out/outside_lightworld_main")
    sol.audio.play_music("overworld")    

    hero:set_tunic_sprite_id("hero/tunic1")

    sol.video.set_shader(nil)
    --Transformation du Héro en Lapin et du Monde en Dark World (Sombre Shaders) 
  else 
    map:set_tileset("out/outside_darkworld_main")
    sol.audio.play_music("rabbit")

    bunny_transformation()

    shader_to_dark = sol.shader.create("fr_to_normal_colors")
    sol.video.set_shader(shader_to_dark)
  end
  
  -- Faire Disparaitre/Apparaitre les PNJs au changement de Monde(Dark/Light)
  pink_ball_death_moutain_west_0:set_enabled(to_dark)
  cursed_bully_death_moutain_west_0:set_enabled(to_dark)
  -- Faire Disparaitre/Apparaitre le Quart de Coeur dans le Dark World
  if not game:get_value("piece_of_heart_mountain_west_0") then
    piece_of_heart_mountain_west_0:set_enabled(not to_dark)
  end
  -- Faire Disparaitre/Apparaitre les Monstres dans le Dark World 
  for entity_on_screen in map:get_entities_by_type("enemy") do
    if entity_on_screen:get_distance(hero) < 64 then
      entity_on_screen:set_enabled(false)
    else
      entity_on_screen:set_enabled(not to_dark)
    end
  end
  -- Faire Disparaitre/Apparaitre des Murs au changement de Monde(Dark/Light)
  -- Faire Apparaitre/Disparaitre des Murret au changement de Monde(Dark/Light)
  for dynamic_tile in map:get_entities_by_type("dynamic_tile") do
      if dynamic_tile:get_name() ~= nil then
        dynamic_tile:set_enabled(to_dark)
      elseif dynamic_tile:get_name() == nil then
        dynamic_tile:set_enabled(not to_dark)    
      end
  end
  -- Gardez, toujours visible ces tiles dynamiques
  for dynamic_tile in map:get_entities("dynamic_tile_ground_dark_world_") do
    dynamic_tile:set_enabled(true)    
  end
  --Faire Disparaitre/Apparaitre les Jumpers au changement de Monde(Dark/Light)
  for jumper in map:get_entities_by_type("jumper") do
    jumper:set_enabled(not to_dark)
  end
end

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()  
  if not game:has_item("inventory/magic_mirror") then
    grandpa_follower:set_enabled(true)
    grandpa_follower:set_position(hero:get_position())
  end
end

function grandpa_dialog_arrived:on_activated()
  if grandpa_follower:is_enabled() then
    self:set_enabled(false)
    game:start_dialog("npc.grandpa.arrived", function() 
      hero:start_treasure("inventory/magic_mirror", 1, "possession_magic_mirror", function()
        hero:freeze()

        local mov_grandpa_go_at_home = sol.movement.create("target")

        mov_grandpa_go_at_home:set_target(dest_house_death_mountain_west_0)
        mov_grandpa_go_at_home:set_speed(33)
        mov_grandpa_go_at_home:set_ignore_obstacles(true)
        
        grandpa:set_position(grandpa_follower:get_position())

        --Remplace le Follower par un NPC pour qu'il puisse reach sa target
        grandpa_follower:remove()        

        mov_grandpa_go_at_home:start(grandpa, function()
          grandpa:remove()
          hero:unfreeze()
        end)
      end)
    end)
  end
end

function warp_death_mountain_west_0:on_activated()
  warp_death_mountain_west_0:set_enabled(false)
  sol.audio.play_sound("world_warp")
  hero:teleport(game:get_map():get_id(), "_same", "fade")
end

function npc_ether_stele_death_mountain_west_0:on_interaction()
  if game:has_item("equipment/book_of_mudora") then
    game:start_dialog("uncrypted.ether_stele")
  else
    game:start_dialog("crypted.ether_stele")
  end  
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished(destination)
  --Si à la fin d'une transistion, on est dans le Light World, on transoforme la Map en Light World 
  if destination == nil then
    local pos_hero_x = hero:get_position() 
    if map:get_tileset() == "out/outside_darkworld_main" then
      --Si on est dans un Mur (Représanté par les Sensor Mirror_warp_protect*) On retourne dans le Dark World    
      change_world(false)

      for sensor_mirror_warp_protect in map:get_entities("sensor_mirror_warp_protect_") do
        if sensor_mirror_warp_protect:overlaps(hero) then
          sol.audio.play_sound("world_warp")
          hero:teleport(game:get_map():get_id(), "_same", "fade")
        end
      end

    --Si à la fin d'une Transistion, on est dans le Dark World, on transoforme la Map en Dark World
    elseif map:get_tileset() == "out/outside_lightworld_main" and pos_hero_x < 944  then 
      change_world(true)

    end
  end
end

function map:on_finished()  
  sol.video.set_shader(nil)
end

function cursed_bully_death_moutain_west_0:on_interaction()
  if not game:has_item("equipment/moon_pearl") then  
    game:start_dialog("npc.cursed_bully.meeting")
  else
    game:start_dialog("npc.cursed_bully.moon_pearl")
  end
end

function pink_ball_death_moutain_west_0:on_interaction()
  if not game:has_item("equipment/moon_pearl") then  
    game:start_dialog("npc.pink_ball.meeting")
  else
    game:start_dialog("npc.pink_ball.moon_pearl")
  end
end

--Bunny State Freeze l'animation du Héro, donc...
function bunny_link:on_movement_changed(movement)
  if hero:get_movement():get_speed() > 0 then
    hero:set_animation("walking")
  else
    hero:set_animation("stopped")
  end
end

--Bunny State ne permet pas les interaction malgrès que ce soit activé... donc
function bunny_link:on_command_pressed(command)
  if command == "action" then
    if hero:get_facing_entity() ~= nil then
        local npc = hero:get_facing_entity()
      if npc:get_type() == "npc" and hero:get_distance(npc) < 32 then
        npc:get_sprite():set_direction(npc:get_direction4_to(hero))
        if npc:get_name() == "pink_ball_death_moutain_west_0"then
          hero:freeze() 
          if not game:has_item("equipment/moon_pearl") then 
            game:start_dialog("npc.pink_ball.meeting", function()
              hero:start_state(bunny_link) end)
          end
        elseif npc:get_name() == "cursed_bully_death_moutain_west_0" then 
          hero:freeze() 
          if not game:has_item("equipment/moon_pearl") then 
            game:start_dialog("npc.cursed_bully.meeting", function()
              hero:start_state(bunny_link) end)
          end
        end
      end
    end
  end
end