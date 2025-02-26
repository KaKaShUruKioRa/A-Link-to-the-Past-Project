-- Lua script of map Archived/A Link to the Past/Light World/Non Playable Zone/Dungeons/Tower of Hera/F6/.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

local door_manager = require("scripts/maps/door_manager")
door_manager:manage_map(map)
local chest_manager = require("scripts/maps/chest_manager")
chest_manager:manage_map(map)
local separator_manager = require("scripts/maps/separator_manager")
separator_manager:manage_map(map)

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()
  npc_agahnim:get_sprite():set_animation("move_hands")
  npc_agahnim:get_sprite():set_direction(6)

  if game:get_value("ritual_accomplished") then
    npc_agahnim:set_enabled(false)
    sensor_ritual:set_enabled(false)
    npc_zelda_sleeping:set_enabled(false)
  end

  if game:get_value("boss_agahnim_F7_hyrule_castle_tower_0") then
    boss_agahnim_F7_hyrule_castle_tower_0:set_enabled(false)
    sensor_boss:set_enabled(false)
  end
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

--RITUAL : Dialog Before & After Ritual + Animation
--Etape 1 : Le Premier Dialogue se lance
function sensor_ritual:on_activated()
  self:set_enabled(false)
  game:start_dialog("enemy.agahnim1.before_ritual", flotting_zelda)
end

--Etape 2 : Zelda flotte dans les airs et ce rapproche d'Agahnim
function flotting_zelda()
  hero:freeze()
  sol.audio.play_sound("boss_charge")

  local m = sol.movement.create("target")
  m:set_target(npc_agahnim)
  m:set_ignore_obstacles(true)
  m:set_speed(12)
  local m2 = sol.movement.create("target")
  m2:set_target(npc_agahnim)
  m2:set_ignore_obstacles(true)
  m2:set_speed(12)
  local m3 = sol.movement.create("target")
  m3:set_target(npc_zelda_sleeping)
  m3:set_ignore_obstacles(true)
  m3:set_speed(8)
  local m4 = sol.movement.create("target")
  m4:set_target(npc_zelda_sleeping)
  m4:set_ignore_obstacles(true)
  m4:set_speed(8)

  m:start(npc_zelda_sleeping, zelda_disapear)

  fx_fire_circle:set_enabled(true)
  m2:start(fx_fire_circle)
  fx_fire_ball_0:set_enabled(true)
  m3:start(fx_fire_ball_0)
  fx_fire_ball_1:set_enabled(true)
  m4:start(fx_fire_ball_1)
end

--Etape 3 : Zelda disparait, les FX associés également
function zelda_disapear()  
  sol.audio.play_sound("ritual_shock")
  fx_fire_circle:set_enabled(false)
  fx_fire_ball_0:set_enabled(false)
  fx_fire_ball_1:set_enabled(false)
  npc_zelda_sleeping:set_enabled(false)

  game:start_dialog("enemy.agahnim1.after_ritual", agahnim_back)
end

--Etape 4 : Agahnim recule et disparait derrière le rideau
function agahnim_back()  
  sol.audio.play_sound("agahnim_dash")
  local m = sol.movement.create("target")
  m:set_target(curtain_F7_hyrule_castle_tower_1)
  m:set_ignore_obstacles(true)
  m:set_speed(64)

  -- Modif event de on_direction_changed : s'assure que Agahnim reste face à Link
  local function on_dir_changed()
    npc_agahnim:get_sprite():set_direction(6)
  end

  npc_agahnim:get_sprite().on_direction_changed = on_dir_changed
  
  m:start(npc_agahnim, ritual_accomplished)
  
end

-- Etape 5 : Le rituel est accompli, tout est désactivé, le héro peut se balader dans la pièce
function ritual_accomplished()
  npc_agahnim:get_movement():stop()
  npc_agahnim:set_position(boss_agahnim_F7_hyrule_castle_tower_0:get_position())

  game:set_value("ritual_accomplished", true)
  hero:unfreeze()
end

--BOSS : Activation Agahnim 1
function sensor_boss:on_activated()
  self:set_enabled(false)
  hero:freeze()
  sol.timer.start(map,200,function()

    local m = sol.movement.create("straight")
    m:set_max_distance(16)
    m:set_angle(math.pi / 2)
    m:start(map:get_camera())

    game:start_dialog("enemy.agahnim1.introduction", function()      
      sol.audio.play_music("boss")
      npc_agahnim:set_enabled(false)
      boss_agahnim_F7_hyrule_castle_tower_0:set_enabled(true)
      hero:unfreeze()
    end)
  end)
end

--BOSS : Mort Agahnim 1, dialogue et téléportation dans le Dark World
function boss_agahnim_F7_hyrule_castle_tower_0:on_dying()

  game:start_dialog("enemy.agahnim1.defeated", function()
    sol.timer.start(2000, function () 
      hero:teleport("A Link to the Past/Dark World/Overworld/D4_pyramid", "dest_init_D4_pyramid_0", "fade")
      sol.audio.play_sound("world_warp")
      game:set_value("boss_agahnim_F7_hyrule_castle_tower_0", true)
      hero:unfreeze() 
    end)
  end)
end
