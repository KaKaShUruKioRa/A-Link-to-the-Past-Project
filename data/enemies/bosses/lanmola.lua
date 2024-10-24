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
local underground_delay = 0
local flight_duration = 0
local projectiles_random_direction = 0
local on_hurted = 0

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
    sprite[i]:set_opacity(0)
  end
  enemy:set_life(16)
  enemy:set_damage(1)
  enemy:set_hurt_style("boss")
  enemy:set_push_hero_on_sword(true)
  enemy:set_pushed_back_when_hurt(false)
  enemy:set_can_attack(false)

  enemy:set_invincible()
  enemy:set_attack_consequence_sprite(sprite[8], "sword", "ignored")
  enemy:set_attack_consequence_sprite(sprite[8], "thrown_item", "ignored")
  enemy:set_attack_consequence_sprite(sprite[8], "explosion", "ignored")
  enemy:set_attack_consequence_sprite(sprite[8], "arrow", "ignored")
  enemy:set_attack_consequence_sprite(sprite[8], "boomerang", "ignored")
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

local children = {}

local function shoot()
  
  sol.audio.play_sound("stone")
  local lanmola_count = 0
  for entity in map:get_entities_by_type("enemy") do
    if(entity:get_breed() == "bosses/lanmola") then    
      lanmola_count = lanmola_count + 1
    end
  end
  if(lanmola_count == 1) then
    for i = 0, 7 do
      local stone = enemy:create_enemy({
        breed = "others/octorok_stone",
        x = 0,
        y = 0,
      })
      children[#children + 1] = stone
      stone:get_sprite():set_opacity(0)
      stone:create_sprite("enemies/" .. enemy:get_breed(), "lanmola_projo")
      stone:get_sprite("lanmola_projo"):set_animation("projectile_1")
      stone:go(i/2)
    end
  else
    projectiles_random_direction = math.random(0,1)
    for i = 0, 3 do
      local stone = enemy:create_enemy({
        breed = "others/octorok_stone",
        x = 0,
        y = 0,
      })
      children[#children + 1] = stone
      stone:get_sprite():set_opacity(0)
      stone:create_sprite("enemies/" .. enemy:get_breed(), "lanmola_projo")
      stone:get_sprite("lanmola_projo"):set_animation("projectile_1")
      stone:go(i + projectiles_random_direction/2)
    end
  end
end




function enemy:on_update()
  local x_backup, y_backup = x, y

  x_et, y_et = enemy:get_position()
  frame = frame+1

  if on_hurted < -1 then

    if sprite[8]:get_animation() == "head" then
      for i = 1, 8 do
        local animation_to_set
        if i == 8 then
          animation_to_set = "hurt"
        elseif i == 1 then
          animation_to_set = "tail_hurt"
        else
          animation_to_set = "body_hurt"
        end
        sprite[i]:set_animation(animation_to_set)
      end
    end
    if on_hurted == -5000 then
      enemy:set_life(0)
    end
    on_hurted = on_hurted+1
    if on_hurted <= -4900 then
      frame = 0
      state = -10
      return
    end

  elseif on_hurted < 0 then
    on_hurted = 0
    if sprite[8]:get_animation() == "hurt" then

      for i = 1, 8 do
        local animation_to_set
        if i == 8 then
          animation_to_set = "head"
        elseif i == 1 then
          animation_to_set = "tail"
        else
          animation_to_set = "body"
        end
        sprite[i]:set_animation(animation_to_set)
      end
    end
  end

  if (state == 1) then
    if frame >= 200 then
      sprite[0]:set_animation("shadow")
      frame = 0
      z = 0
      state = 2
      for i = 1, 7 do
        sprite[i]:set_xy(0, 0)
      end
      shoot()
    end
    return
  end

  if (state == 2) then
    x = x+(math.cos(angle_calcul)*(speed))
    y = y-(math.sin(angle_calcul)*(speed))
    if (frame%10) == 0 then
      for i = 1, 7 do
        local x_2, y_2 = sprite[i]:get_xy()
        local x_3, y_3 = sprite[i+1]:get_xy()
        if y_2 > 0 then
          sprite[i]:set_opacity(0)
        else
          sprite[i]:set_opacity(255)
          sprite[i]:set_xy(x_3+((x_backup-x)*8), y_3)

          local x_s, y_s =  sprite[i]:get_size()
          local x_o, y_o =  sprite[i]:get_origin()

          if ((hero:overlaps((x+x_2)-(x_o), (y+y_2)-(y_o), x_s, y_s)) and ((state == 2) or (state == 4)) and sprite[i]:get_opacity()) then
            if (not hero:is_invincible()) then
              hero:start_hurt(enemy, enemy:get_damage())
            end
          end

        end
      end
    end
    z_jump = z_jump-z_gravity
    z = z-z_jump
    sprite[8]:set_xy(0, z)
    if z > 0 then
      x = x_backup
      y = y_backup
      if sprite[0]:get_animation() == "shadow" then
        sprite[0]:set_animation("emerging")
      end
      sprite[8]:set_opacity(0)
      enemy:set_attack_consequence_sprite(sprite[8], "sword", "ignored")
      enemy:set_attack_consequence_sprite(sprite[8], "thrown_item", "ignored")
      enemy:set_attack_consequence_sprite(sprite[8], "explosion", "ignored")
      enemy:set_attack_consequence_sprite(sprite[8], "arrow", "ignored")
      enemy:set_attack_consequence_sprite(sprite[8], "boomerang", "ignored")
    else
      sprite[8]:set_opacity(255)
      if sprite[0]:get_animation() == "emerging" then
        sprite[0]:set_animation("shadow")
      end
      enemy:set_attack_consequence_sprite(sprite[8], "sword", "custom")
      enemy:set_attack_consequence_sprite(sprite[8], "thrown_item", "custom")
      enemy:set_attack_consequence_sprite(sprite[8], "explosion", "custom")
      enemy:set_attack_consequence_sprite(sprite[8], "arrow", "custom")
      enemy:set_attack_consequence_sprite(sprite[8], "boomerang", "custom")
    end
    if not enemy:test_obstacles(x-x_et, y-y_et) then
      enemy:set_position(x, y, layer)
    else
      x, y = x_backup, y_backup
    end
    sprite[1]:set_direction( math.abs(((angle_calcul*(180/math.pi))/20)%16) )
    sprite[8]:set_direction( math.abs(((angle_calcul*(180/math.pi))/20)%16) )
    if frame > 300 then
      sprite[0]:set_opacity(0)
      frame = 0
      z_jump = 0
      z = 0
      angle_calcul = math.rad(math.random(0, 360))
      state = 0
    end
    return
  end

  if (state == 0) then
    if (frame < 2) then
      underground_delay = math.random(150, 300)
    end
    x = x+(math.cos(math.random(0,360))*(speed*32))
    y = y-(math.sin(math.random(0,360))*(speed*32))
    if frame >= underground_delay then
      local angle_colision = true
      local frame_count = 0
      while angle_colision and frame_count < 300 do
        angle_colision = false
        frame_count = frame_count + 1
        z_jump = math.random(30, 50)/100
        flight_duration = z_jump/z_gravity
        angle_calcul = math.rad(math.random(0, 360))
        for f = 0, 3 * flight_duration do
          if(enemy:test_obstacles(math.cos(angle_calcul) * speed * f, (- math.sin(angle_calcul)) * speed * f)) then
            angle_colision = true
          end
        end     
      end
      frame = 0
      z = 0
      state = 1
      sprite[0]:set_animation("emerging")
      sprite[0]:set_opacity(255)
      for i = 1, 7 do
        sprite[i]:set_xy(0, 0)
      end
    end
    if not enemy:test_obstacles(x-x_et, y-y_et) then
      enemy:set_position(x, y, layer)
    else
      x, y = x_backup, y_backup
    end
    return
  end

end

function enemy:on_custom_attack_received(attack, sprite)
  if (state == 2 and on_hurted == 0) then

    if (attack == "sword") then
      if enemy:get_life()-( 2*math.max(1, game:get_ability("sword")-1) ) <= 0 then
        enemy:set_life(1)
        on_hurted = -5000
        sol.audio.play_sound(list_lanmola_sound[3])
      else
        sol.audio.play_sound(list_lanmola_sound[2])
        enemy:remove_life(2*math.max(1, game:get_ability("sword")-1))
        on_hurted = -75
      end
    end

    if (attack == "thrown_item") or (attack == "explosion") then
      if enemy:get_life()-4 <= 0 then
        enemy:set_life(1)
        on_hurted = -5000
        sol.audio.play_sound(list_lanmola_sound[3])
      else
        sol.audio.play_sound(list_lanmola_sound[2])
        enemy:remove_life(4)
        on_hurted = -75
      end
    end

    if attack == "arrow" then
      if enemy:get_life()-( 4+((game:get_value("possession_bow")-1)*200) ) <= 0 then
        enemy:set_life(1)
        on_hurted = -5000
        sol.audio.play_sound(list_lanmola_sound[3])
      else
        sol.audio.play_sound(list_lanmola_sound[2])
        enemy:remove_life(4+((game:get_value("possession_bow")-1)*200))
        on_hurted = -75
      end
    end

  end
end

function enemy:on_post_draw(camera)
  local temp_x, temp_y = enemy:get_position()
  local camera_surface = camera:get_surface()
  if (state == 2) and (sprite[0]:get_animation() == "shadow") and (frame <= 50) then
    local x_d_1, y_d_1 = camera:get_position()
    local img_frame = ((math.floor(frame/20))%3)

    sprite[0]:set_animation("particule")
    sprite[0]:set_frame(img_frame)

    sprite[0]:draw(camera_surface, temp_x-x_d_1-(frame/10), temp_y-y_d_1)
    sprite[0]:set_scale(-1, 1)
    sprite[0]:draw(camera_surface, temp_x-x_d_1+(frame/10), temp_y-y_d_1)
    sprite[0]:set_scale(1, 1)

    sprite[0]:set_animation("shadow")

  end
  if (state == 2) and (z > 0) then
    local x_d_1, y_d_1 = camera:get_position()
    local img_frame = ((math.floor(frame/20))%3)
    sprite[0]:set_opacity(255)

    sprite[0]:set_animation("particule")
    sprite[0]:set_frame(img_frame)

    sprite[0]:draw(camera_surface, temp_x-x_d_1-(frame/30), temp_y-y_d_1)
    sprite[0]:set_scale(-1, 1)
    sprite[0]:draw(camera_surface, temp_x-x_d_1+(frame/30), temp_y-y_d_1)
    sprite[0]:set_scale(1, 1)

    sprite[0]:set_opacity(0)

  end
end