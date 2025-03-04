-- Lua script of map A Link to the Past/Dark World/Dungeons/Ganon Tower/F7/F7_ganon_tower.
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

local agah_death_pos_x, agah_death_pos_y

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()
  npc_agahnim:get_sprite():set_direction(6)
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

--BOSS : Activation Agahnim 2
function sensor_boss:on_activated()
    self:set_enabled(false)
    hero:freeze()
    sol.timer.start(map,200,function()
      sol.audio.play_music("boss")
      hero:unfreeze()
      local m = sol.movement.create("straight")
      m:set_max_distance(16)
      m:set_angle(math.pi / 2)
      m:start(map:get_camera())

      boss_agahnim_F7_ganon_tower_0:set_enabled(true)
    end)
end

--BOSS : Activation Agahnim 2
function sensor_boss:on_activated()
  self:set_enabled(false)
  hero:freeze()
  
  game:start_dialog("enemy.agahnim2.introduction", function()
    sol.timer.start(map,200,function()
      sol.audio.play_music("boss")
      hero:unfreeze()
      local m = sol.movement.create("straight")
      m:set_max_distance(16)
      m:set_angle(math.pi / 2)
      m:start(map:get_camera())
      npc_agahnim:set_enabled(false)
      boss_agahnim_F7_ganon_tower_0:set_enabled(true)
    end)
  end)
end

local previous_on_dying = boss_agahnim_F7_ganon_tower_0.on_dying
function boss_agahnim_F7_ganon_tower_0:on_dying()
  agah_death_pos_x, agah_death_pos_y = boss_agahnim_F7_ganon_tower_0:get_position()

 if previous_on_dying then 
   previous_on_dying()
 end
end

--BOSS : Mort Agahnim 2, sur la Pyramide de Puissance pour l'affrontement Final
function boss_agahnim_F7_ganon_tower_0:on_dead()
  sol.audio.play_music("ganon_appears")
  hero:freeze()
  local npc_ganon = map:create_npc({ 
  ["name"] = "npc_ganon", 
  ["layer"] = 1,
  ["x"] = 0,
  ["y"] = 0, 
  ["direction"] = 0,
  ["subtype"] = 1,
  ["sprite"] = "enemies/bosses/ganon" })

  local mov_npc_ganon = sol.movement.create("straight")
  mov_npc_ganon:set_speed(12)
  mov_npc_ganon:set_angle(math.pi / 2)
  mov_npc_ganon:set_max_distance(48)
  mov_npc_ganon:set_ignore_obstacles(true)

  npc_ganon:set_position(agah_death_pos_x, agah_death_pos_y)
  npc_ganon:set_layer(1)
  npc_ganon:set_enabled(true)

  local appears = true
  local ganon_sprite = npc_ganon:get_sprite()
  ganon_sprite:set_opacity(125)

  local function on_frame_changed()
    if appears then
      ganon_sprite:set_direction(3)
    end
  end
  --TODO : trouvez une meilleurs façon de force Ganon à regarder le Bas
  ganon_sprite.on_frame_changed = on_frame_changed

  mov_npc_ganon:start(npc_ganon, function()
    mov_npc_ganon = sol.movement.create("random")
    mov_npc_ganon:set_speed(48)
    mov_npc_ganon:set_max_distance(48)
    mov_npc_ganon:set_ignore_obstacles(true)

    npc_ganon:remove_sprite()
    npc_ganon:create_sprite("enemies/others/fire_bat")
    ganon_sprite:set_opacity(255)
    
    -- Bat Sound 
    local i = 0
    sol.timer.start(700, function() 
      i = i + 1

      if i >= 8 then
        return false
      elseif i%4 > 0 then
        sol.audio.play_sound("sword3")
        return true
      elseif i%4 == 0 then 
        sol.audio.play_sound("sword4")
        return true
      end
    end)

    mov_npc_ganon:start(npc_ganon)

    sol.timer.start(4000, function()
      mov_npc_ganon = sol.movement.create("straight")
      mov_npc_ganon:set_speed(80)
      mov_npc_ganon:set_angle(math.pi / 1.5)
      mov_npc_ganon:set_max_distance(256)

      local function mov_obstacle_reach()
        mov_npc_ganon:stop()
        npc_ganon:set_enabled(false)
        hero:unfreeze()
        sol.audio.play_sound("ocarina")
        sol.timer.start(3000, function()
          game:set_value("boss_agahnim_F7_ganon_tower_0", true)
          hero:teleport("A Link to the Past/Dark World/Overworld/D4_pyramid", "dest_init_D4_pyramid_0", "fade")
        end)
      end
      mov_npc_ganon.on_obstacle_reached = mov_obstacle_reach

      mov_npc_ganon:start(npc_ganon)
    end)
  end)
end
