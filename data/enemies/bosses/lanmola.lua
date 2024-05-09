-- Lua script of enemy bosses/lanmola.

local enemy = ...
local game = enemy:get_game()
local map = enemy:get_map()
local hero = map:get_hero()
local sprite = {}
local z = 0
local z_jump = 0.5
local z_gravity = 0.005
local speed = 0.4
local state = 0
local frame = 0
local angle_calcul = math.rad(math.random(0, 360))

local x, y, layer = enemy:get_position()

-- State 0 = dans le sol, deplacement rapide random, et choix de direction aleatoire
-- State 1 = emergance du sol, puis projection de projectile
-- State 2 = hors du sol

local list_lanmola_sound = {}
list_lanmola_sound[0] = "enemy_awake"
list_lanmola_sound[1] = "bomb"
list_lanmola_sound[2] = "boss_hurt"
list_lanmola_sound[3] = "boss_killed"
list_lanmola_sound[4] = "jump"
list_lanmola_sound[5] = "explosion"

function enemy:on_created()
  for i = 0, 8 do
    sprite[i] = enemy:create_sprite("enemies/" .. enemy:get_breed())
  end
  enemy:set_life(8)
  enemy:set_damage(1)
  enemy:set_hurt_style("boss")
  enemy:set_pushed_back_when_hurt(false)

  enemy:set_invincible()
  for i = 1, 8 do
    enemy:set_attack_consequence_sprite(sprite[i], "sword", "protected")
    enemy:set_attack_consequence_sprite(sprite[i], "thrown_item", "protected")
    enemy:set_attack_consequence_sprite(sprite[i], "explosion", "protected")
    enemy:set_attack_consequence_sprite(sprite[i], "arrow", "protected")
    enemy:set_attack_consequence_sprite(sprite[i], "boomerang", "protected")
  end
end

function enemy:on_restarted()
  for i = 0, 8 do
    local animation_to_set
    if i == 8 then
      animation_to_set = "head"
    elseif i == 1 then
      animation_to_set = "tail"
    elseif i == 0 then
      animation_to_set = "shadow"
    else
      animation_to_set = "body"
    end
    sprite[i]:set_animation(animation_to_set)
  end
end

function enemy:on_update()
  sprite[1]:set_direction((angle_calcul*(180/math.pi))%16)
  sprite[8]:set_direction((angle_calcul*(180/math.pi))%16)

  x_et, y_et = enemy:get_position()
  frame = frame+1

  if (state == 0) then
    x = x+(math.cos(angle_calcul)*(speed))
    y = y-(math.sin(angle_calcul)*(speed))
    if (frame%10) == 0 then
      for i = 1, 7 do
        local x_2, y_2 = sprite[i+1]:get_xy()
        sprite[i]:set_xy(x_2+((x_et-x)*8), y_2)
      end
    end
    z_jump = z_jump-z_gravity
    z = z-z_jump
    sprite[8]:set_xy(0, z)
  end
  if frame >= 200 then
    frame = 0
    z_jump = 0.5
    z = 0
    angle_calcul = math.rad(math.random(0, 360))
  end

  if not enemy:test_obstacles(x-x_et, y-y_et) then
    enemy:set_position(x, y, layer)
  else
    x, y = x_et, y_et
  end
end

function enemy:on_custom_attack_received(attack, sprite)
  if (state == 1) then

    if (attack == "sword") then
      if enemy:get_life()-( 4*math.max(1, game:get_ability("sword")-1) ) <= 0 then
        sol.audio.play_sound(list_lanmola_sound[3])
        enemy:set_life(1)
        on_hurted = -250
        enemy:change_state(1)
      else
        sol.audio.play_sound(list_lanmola_sound[2])
        enemy:remove_life(4*math.max(1, game:get_ability("sword")-1))
        on_hurted = -75
        enemy:change_state(5)
      end
    end

    if (attack == "thrown_item") or (attack == "explosion") then
      if enemy:get_life()-4 <= 0 then
        sol.audio.play_sound(list_lanmola_sound[3])
        enemy:set_life(1)
        on_hurted = -250
        enemy:change_state(1)
      else
        sol.audio.play_sound(list_lanmola_sound[2])
        enemy:remove_life(4)
        on_hurted = -75
        enemy:change_state(5)
      end
    end

    if attack == "boomerang" then
      if enemy:get_life()-1 <= 0 then
        sol.audio.play_sound(list_lanmola_sound[3])
        enemy:set_life(1)
        on_hurted = -250
        enemy:change_state(1)
      else
        sol.audio.play_sound(list_lanmola_sound[2])
        enemy:remove_life(1)
        on_hurted = -75
        enemy:change_state(5)
      end
    end

    if attack == "arrow" then
      if enemy:get_life()-( 16+((game:get_value("possession_bow")-1)*200) ) <= 0 then
        sol.audio.play_sound(list_lanmola_sound[3])
        enemy:set_life(1)
        on_hurted = -250
        enemy:change_state(1)
      else
        sol.audio.play_sound(list_lanmola_sound[2])
        enemy:remove_life(16+((game:get_value("possession_bow")-1)*200))
        on_hurted = -75
        enemy:change_state(5)
      end
    end

  end
end
