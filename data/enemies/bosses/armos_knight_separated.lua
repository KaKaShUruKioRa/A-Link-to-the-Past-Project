-- Armos Knight boss.

local enemy = ...

local hero = enemy:get_map():get_hero()
local game = enemy:get_game()

local state = 0
-- 0 = nothing
-- 1 = dead
-- 2 = jump in place and move
-- 3 = awaken
-- 4 = red and jump to hero
-- 5 = hurted

local speed = 0.6

local list_armos_sound = {}
list_armos_sound[0] = "enemy_awake"
list_armos_sound[1] = "bomb"
list_armos_sound[2] = "boss_hurt"
list_armos_sound[3] = "boss_killed"
list_armos_sound[4] = "jump"
list_armos_sound[5] = "explosion"

local position_hero_on_hurt_x, position_hero_on_hurt_y = 0, 0
local jump_z_value_1 = 0
local jump_z_value_2 = 0
local frame = 0
local palet = 0
local on_hurted = 0
local sprite = {}
local x, y, layer
local x_target, y_target = 128, 128

-- Avoid loudy simultaneous sounds of Armos.
function enemy:sound_play(sound_id)
  local map = self:get_map()
  if self:get_distance(hero) < 500 and self:is_in_same_region(hero) then
    if not map.armos_recent_sound then
      sol.audio.play_sound(sound_id)
      map.armos_recent_sound = true
      sol.timer.start(map, 25, function()
        map.armos_recent_sound = nil
      end)
    end
  end
end

function enemy:on_created()
  enemy:set_life(48)
  enemy:set_damage(2)
  enemy:set_hurt_style("boss")
  for i = 0, 1 do
    sprite[i] = enemy:create_sprite("enemies/" .. enemy:get_breed())
  end
  enemy:set_hurt_style("boss")
  enemy:set_pushed_back_when_hurt(false)
  enemy:set_size(16, 16)
  enemy:set_origin(8, 13)
  enemy:set_can_attack(false)
  enemy:set_traversable(false)

  enemy:set_invincible()
  enemy:set_attack_consequence_sprite(sprite[1], "sword", "protected")
  enemy:set_attack_consequence_sprite(sprite[1], "thrown_item", "protected")
  enemy:set_attack_consequence_sprite(sprite[1], "explosion", "protected")
  enemy:set_attack_consequence_sprite(sprite[1], "arrow", "protected")
  enemy:set_attack_consequence_sprite(sprite[1], "boomerang", "protected")
end

function enemy:on_custom_attack_received(attack, sprite)
  if not (state == 1) then

    if (attack == "sword") then
      if enemy:get_life()-( 4*math.max(1, game:get_ability("sword")-1) ) <= 0 then
        sol.audio.play_sound(list_armos_sound[3])
        enemy:set_life(1)
        on_hurted = -250
        enemy:change_state(1)
      else
        sol.audio.play_sound(list_armos_sound[2])
        enemy:remove_life(4*math.max(1, game:get_ability("sword")-1))
        on_hurted = -75
        enemy:change_state(5)
      end
    end

    if (attack == "thrown_item") or (attack == "explosion") then
      if enemy:get_life()-4 <= 0 then
        sol.audio.play_sound(list_armos_sound[3])
        enemy:set_life(1)
        on_hurted = -250
        enemy:change_state(1)
      else
        sol.audio.play_sound(list_armos_sound[2])
        enemy:remove_life(4)
        on_hurted = -75
        enemy:change_state(5)
      end
    end

    if attack == "boomerang" then
      if enemy:get_life()-1 <= 0 then
        sol.audio.play_sound(list_armos_sound[3])
        enemy:set_life(1)
        on_hurted = -250
        enemy:change_state(1)
      else
        sol.audio.play_sound(list_armos_sound[2])
        enemy:remove_life(1)
        on_hurted = -75
        enemy:change_state(5)
      end
    end

    if attack == "arrow" then
      if enemy:get_life()-( 16+((game:get_value("possession_bow")-1)*200) ) <= 0 then
        sol.audio.play_sound(list_armos_sound[3])
        enemy:set_life(1)
        on_hurted = -250
        enemy:change_state(1)
      else
        sol.audio.play_sound(list_armos_sound[2])
        enemy:remove_life(16+((game:get_value("possession_bow")-1)*200))
        on_hurted = -75
        enemy:change_state(5)
      end
    end

  end
end

function enemy:change_palet(value)
  palet = value
end

function enemy:change_state(value)
  frame = 0
  state = value
end

function enemy:get_palet()
  return palet
end

function enemy:get_state()
  return state
end

function enemy:update_target(x_target_value, y_target_value)
  x_target, y_target = x_target_value, y_target_value
end

function enemy:on_restarted()
  x, y, layer = enemy:get_position()
  sprite[0]:set_animation("shadow")
  sprite[1]:set_animation(palet)
end

function enemy:on_update()
  if on_hurted < 0 then
    if palet == 0 then

      if math.ceil(on_hurted/3) % 8 == 0 then
        sprite[1]:set_animation(7)
      elseif math.ceil(on_hurted/3) % 8 == 1 then
        sprite[1]:set_animation(5)
      elseif math.ceil(on_hurted/3) % 8 == 2 then
        sprite[1]:set_animation(3)
      elseif math.ceil(on_hurted/3) % 8 == 3 then
        sprite[1]:set_animation(1)
      elseif math.ceil(on_hurted/3) % 8 == 4 then
        sprite[1]:set_animation(6)
      elseif math.ceil(on_hurted/3) % 8 == 5 then
        sprite[1]:set_animation(4)
      elseif math.ceil(on_hurted/3) % 8 == 6 then
        sprite[1]:set_animation(2)
      elseif math.ceil(on_hurted/3) % 8 == 7 then
        sprite[1]:set_animation(0)
      end

    elseif palet == 7 then

      if math.ceil(on_hurted/3) % 8 == 0 then
        sprite[1]:set_animation(0)
      elseif math.ceil(on_hurted/3) % 8 == 1 then
        sprite[1]:set_animation(2)
      elseif math.ceil(on_hurted/3) % 8 == 2 then
        sprite[1]:set_animation(4)
      elseif math.ceil(on_hurted/3) % 8 == 3 then
        sprite[1]:set_animation(6)
      elseif math.ceil(on_hurted/3) % 8 == 4 then
        sprite[1]:set_animation(1)
      elseif math.ceil(on_hurted/3) % 8 == 5 then
        sprite[1]:set_animation(3)
      elseif math.ceil(on_hurted/3) % 8 == 6 then
        sprite[1]:set_animation(5)
      elseif math.ceil(on_hurted/3) % 8 == 7 then
        sprite[1]:set_animation(7)
      end

    else
      sprite[1]:set_animation(math.floor(math.random(0, 7)))
    end
    on_hurted = on_hurted+1
  else
    sprite[1]:set_animation(palet)
  end
  if state == 1 then -- in dead
    frame = frame+1
    enemy:get_map():get_camera():get_surface():set_xy(0, 0)
  end
  if state == 2 then -- jump and move
    -- visual
    if jump_z_value_1 <= 0 then
      jump_z_value_1 = jump_z_value_1-jump_z_value_2
      jump_z_value_2 = jump_z_value_2-0.11
    elseif jump_z_value_1 > 0 then
      enemy:sound_play(list_armos_sound[1])
      jump_z_value_1 = 0
      jump_z_value_2 = 2.15
    end
    sprite[1]:set_xy(0,jump_z_value_1)

    -- AI
    local temp_angle = sol.main.get_angle(x, y, x_target, y_target)
    if not (x == x_target) then
      if (math.abs(x-x_target) < speed) then
        x = x_target
      else
        x = x+(math.cos(temp_angle)*speed)
      end
    end

    if not (y == y_target) then
      if (math.abs(y-y_target) < speed) then
        y = y_target
      else
        y = y-(math.sin(temp_angle)*speed)
      end
    end
    enemy:set_position(x, y, layer)

  elseif state == 3 then -- awaken
    if frame == 0 then
      enemy:sound_play(list_armos_sound[0])
    end
    frame = frame+1
    sprite[1]:set_xy( (math.ceil(frame/1.5)%3)-1, 0)
    if frame >= 150 then
      enemy:set_traversable(true)
      enemy:set_attack_consequence_sprite(sprite[1], "sword", "custom")
      enemy:set_attack_consequence_sprite(sprite[1], "thrown_item", "custom")
      enemy:set_attack_consequence_sprite(sprite[1], "explosion", "custom")
      enemy:set_attack_consequence_sprite(sprite[1], "arrow", "custom")
      enemy:set_attack_consequence_sprite(sprite[1], "boomerang", "custom")
      enemy:change_state(2)
    end
  elseif state == 5 then -- on pushed back by hurt
    jump_z_value_1 = 0
    if frame == 0 then
      position_hero_on_hurt_x, position_hero_on_hurt_y = hero:get_position()
    end
    frame = frame+1
    if not enemy:test_obstacles((math.cos(sol.main.get_angle(x, y, position_hero_on_hurt_x, position_hero_on_hurt_y))*(-speed*4)), (math.sin(sol.main.get_angle(x, y, position_hero_on_hurt_x, position_hero_on_hurt_y))*(-speed*4))) then
      x = x+(math.cos(sol.main.get_angle(x, y, position_hero_on_hurt_x, position_hero_on_hurt_y))*(-speed*4))
      y = y-(math.sin(sol.main.get_angle(x, y, position_hero_on_hurt_x, position_hero_on_hurt_y))*(-speed*4))
      enemy:set_position(x, y, layer)
    end

    if frame >= 15 then
      enemy:change_state(2)
    end
    
  elseif state == 4 then -- phase 2 red and jump to hero


    sprite[1]:set_xy(0,jump_z_value_1)
    if frame == 0 then
      enemy:sound_play(list_armos_sound[4])
      local x_temp, y_temp = hero:get_position()
      enemy:update_target(x_temp, y_temp)
      enemy:set_attack_consequence_sprite(sprite[1], "sword", "ignored")
    end

    if (frame >= 300) and (frame < 700) then
      frame = frame+1
      if (frame > 330) then
        if not (jump_z_value_1 >= 0) then
          jump_z_value_1 = math.min(0, jump_z_value_1+5)
        else
          enemy:set_attack_consequence_sprite(sprite[1], "sword", "custom")
          frame = 700
          enemy:sound_play(list_armos_sound[5])
        end
      end
    elseif (x == x_target) and (y == y_target) and (frame < 300) then
      frame = 300
    elseif not ((x == x_target) and (y == y_target)) then
      frame = frame+1
      local temp_angle = sol.main.get_angle(x, y, x_target, y_target)
      if not (x == x_target) then
        if (math.abs(x-x_target) < (speed*3)) then
          x = x_target
        else
          x = x+(math.cos(temp_angle)*(speed*3))
        end
      end

      if not (y == y_target) then
        if (math.abs(y-y_target) < (speed*3)) then
          y = y_target
        else
          y = y-(math.sin(temp_angle)*(speed*3))
        end
      end
      enemy:set_position(x, y, layer)
      jump_z_value_1 = jump_z_value_1-1
    else
      frame = frame+1
      enemy:get_map():get_camera():get_surface():set_xy(0, ((math.ceil(frame/2)%5)-2))
      if (frame > 730) then
        frame = 0
        enemy:get_map():get_camera():get_surface():set_xy(0, 0)
      end
    end

  elseif state == 0 then -- stopped
    frame = 0
  end
  if jump_z_value_1 < -8 then
    sprite[0]:set_scale( math.max(0.8, ((jump_z_value_1+60)/40)) , 1)
  else
    local x_s, y_s =  enemy:get_size()
    local x_o, y_o =  enemy:get_origin()
    if (hero:overlaps(x-(x_o), y-(y_o), x_s, y_s)) and ((state == 2) or (state == 4)) then
      if not hero:is_invincible() then
        hero:start_hurt(enemy, enemy:get_damage())
      end
    end
  end
  sprite[0]:set_scale( math.max(0.8, ((jump_z_value_1+60)/40)) , 1)
end

function enemy:on_post_draw(camera)
  local camera_surface = camera:get_surface()
  if state == 1 then
    sprite[1]:set_xy(0,-24)
    local x_d_1, y_d_1 = camera:get_position()
    if frame < 15 then
      sprite[1]:set_direction(1)
      sprite[1]:draw(camera_surface, x-x_d_1, y-y_d_1)
      sprite[1]:set_direction(2)
      sprite[1]:draw(camera_surface, x-x_d_1, y-y_d_1)
      sprite[1]:set_direction(3)
      sprite[1]:draw(camera_surface, x-x_d_1, y-y_d_1)
      sprite[1]:set_direction(4)
      sprite[1]:draw(camera_surface, x-x_d_1, y-y_d_1)
    elseif frame < 30 then
      sprite[1]:set_direction(5)
    elseif frame < 45 then
      sprite[1]:set_direction(6)
    elseif frame < 60 then
      sprite[1]:set_direction(7)
    elseif frame < 75 then
      sprite[1]:set_direction(8)
    elseif frame < 80 then
      enemy:remove()
    end
    if frame > 15 then
      sprite[1]:draw(camera_surface, x-x_d_1, y-y_d_1)
      sprite[1]:set_scale(-1, 1)
      sprite[1]:draw(camera_surface, x-x_d_1, y-y_d_1)
      sprite[1]:set_scale(-1, -1)
      sprite[1]:draw(camera_surface, x-x_d_1, y-y_d_1)
      sprite[1]:set_scale(1, -1)
      sprite[1]:draw(camera_surface, x-x_d_1, y-y_d_1)
      sprite[1]:set_scale(1, 1)
    end
  end
end