-- Lua for enemies/bosses/agahnim.
-- "variant" property :
-- 2                 = Aga 2 (plus, et ca ajoute un clone)
-- 1                 = Aga Clone
--(0, other, or nil) = Aga 1
local enemy = ...
local hero = enemy:get_map():get_hero()
local attack = {}
function enemy:launch_attack() end
local spawn_x, spawn_y = enemy:get_position()
local variant = tonumber(enemy:get_property("variant"))
if variant == nil then variant = 0 end
local up_zone = tonumber(enemy:get_property("up_zone"))
local down_zone = tonumber(enemy:get_property("down_zone"))
local right_zone = tonumber(enemy:get_property("right_zone"))
local left_zone = tonumber(enemy:get_property("left_zone"))
local agahnim_room = false
if up_zone == nil and down_zone == nil and right_zone == nil and left_zone == nil then
  agahnim_room = true
else
  if up_zone == nil then up_zone = -3 end
  if down_zone == nil then down_zone = 12 end
  if right_zone == nil then right_zone = 8 end
  if left_zone == nil then left_zone = -8 end
end
local can_be_hurt = true
local projo_spr = sol.sprite.create("enemies/"..enemy:get_breed().."_projo_1")
projo_spr:set_opacity(0)
local projo_pos = {}
projo_pos[0] = {0, 0}
projo_pos[1] = {0, 0}
local direction = 7
local x, y, layer = enemy:get_position()
local general_opacity = 255

-- Avoid loudy simultaneous sounds of Monster.
function enemy:sound_play(sound_id)
  local map = enemy:get_map()
  local hero = map:get_hero()
  if enemy:get_distance(hero) < 500 and enemy:is_in_same_region(hero) then
    if not map.monster_recent_sound then
      if sol.main.resource_exists("sound", sound_id) then
        sol.audio.play_sound(sound_id)
      else
        print(sound_id .. " not exist.")
      end
      map.monster_recent_sound = true
      sol.timer.start(map, 250, function()
        map.monster_recent_sound = nil
      end)
    end
  end
end

function enemy:on_created()
  enemy:set_invincible()
  enemy:set_attack_consequence("sword", "protected")
  enemy:set_attack_consequence("boomerang", "protected")
  enemy:set_life(12)
  enemy:set_damage(4)
  enemy:set_hurt_style("boss")
  enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_pushed_back_when_hurt(false)
  enemy:set_push_hero_on_sword(true)
  enemy:set_size(16, 16)
  enemy:set_origin(8, 13)
  enemy:set_attacking_collision_mode("overlapping")

  attack[0] = function() -- Projectile
    local tp_x = 0
    local tp_y = 0
    if agahnim_room then
      tp_y = math.max(math.min(math.random(-6,15),12),-3)
      if tp_y < 0 then
        tp_x = math.max(math.min(math.random(-7,7),6),-6)
      else
        tp_x = math.max(math.min(math.random(-11,11),8),-8)
      end
    else
      tp_x = math.max(math.min(math.random(left_zone*1.5,right_zone*1.5),right_zone),left_zone)
      tp_y = math.max(math.min(math.random(up_zone*1.5,down_zone*1.5),down_zone),up_zone)
    end
    tp_x = spawn_x+(tp_x*8)
    tp_y = spawn_y+(tp_y*8)
    enemy:shadow_move(tp_x, tp_y, true, function()
      enemy:sound_play("boss_charge")
      enemy:launch_projectile(enemy:get_breed().."_projo_1", "boss_fireball", 1, 2000, true, function()
        enemy:restart()
      end)
    end)
  end
  attack[1] = function()  -- Four Sphere
    local tp_x = 0
    local tp_y = 0
    if agahnim_room then
      tp_y = math.max(math.min(math.random(-6,15),12),-3)
      if tp_y < 0 then
        tp_x = math.max(math.min(math.random(-7,7),6),-6)
      else
        tp_x = math.max(math.min(math.random(-11,11),8),-8)
      end
    else
      tp_x = math.max(math.min(math.random(left_zone*1.5,right_zone*1.5),right_zone),left_zone)
      tp_y = math.max(math.min(math.random(up_zone*1.5,down_zone*1.5),down_zone),up_zone)
    end
    tp_x = spawn_x+(tp_x*8)
    tp_y = spawn_y+(tp_y*8)
    enemy:shadow_move(tp_x, tp_y, true, function()
      enemy:sound_play("boss_charge")
      enemy:launch_projectile(enemy:get_breed().."_projo_2", "boss_fireball", 1, 2000, true, function()
        enemy:restart()
      end)
    end)
  end
  attack[2] = function()   -- Lightning
    enemy:shadow_move(spawn_x, spawn_y-16, false, function()
      enemy:get_sprite():set_direction(6)
      direction = 6
      enemy:sound_play("boss_charge")
      enemy:launch_projectile(enemy:get_breed().."_projo_3", "lightning", 4, 1000, false, function()
        enemy:restart()
      end)
    end)
  end

  if variant > 1 then -- Agahnim 2
    function enemy:launch_attack()
      if math.random(0, 1) == 0 then
        attack[0]()
      else
        attack[1]()
      end
    end
    -- Function called by the fireball when colliding.
    function enemy:receive_bounced_projectile(fireball)
      if can_be_hurt then
        fireball:remove()
        enemy:hurt(2)
      end
    end
    for i = 1, variant do
      local clone_aga = enemy:get_map():create_enemy({
        name = ("agahnim_"..tostring(enemy).."_clone_"..tostring(i)),
        breed = enemy:get_breed(),
        x = x,
        y = y,
        layer = layer,
        direction = 0,
        enabled_at_start = enemy:is_enabled(),
        properties = {
          {
            key = "variant",
            value = "1",
          },
          {
            key = "up_zone",
            value = tostring(up_zone),
          },
          {
            key = "down_zone",
            value = tostring(down_zone),
          },
          {
            key = "right_zone",
            value = tostring(right_zone),
          },
          {
            key = "left_zone",
            value = tostring(left_zone),
          },
        },
      })
      clone_aga:set_invincible()
      clone_aga:set_attack_consequence("sword", "ignored")
      clone_aga:set_attack_consequence("boomerang", "ignored")
      clone_aga:set_can_attack(false)
      clone_aga.is_clone = true
      clone_aga:set_position(x, y)
      clone_aga:shadow_move(x+64-(128*(i%2)), y+64, true, function()
        clone_aga:restart()
      end)
    end
  elseif variant == 1 then -- Agahnim Clone
    function enemy:launch_attack()
      attack[0]()
    end
    general_opacity = 125
    enemy:set_invincible()
    enemy:set_attack_consequence("sword", "ignored")
    enemy:set_attack_consequence("boomerang", "ignored")
    enemy:set_can_attack(false)
    enemy.is_clone = true
  else                     -- Agahnim 1
    local attack_choice = {}
    local number_cycle = 0
    attack_choice[0] = function() attack[0]() end
    attack_choice[1] = function() attack[math.random(0,1)]() end
    attack_choice[2] = function() attack[math.random(0,1)]() end
    attack_choice[3] = function() attack[math.random(0,1)]() end
    attack_choice[4] = function() attack[2]() end
    function enemy:launch_attack()
      attack_choice[number_cycle]()
      number_cycle = (number_cycle+1)%5
    end
    -- Function called by the fireball when colliding.
    function enemy:receive_bounced_projectile(fireball)
      if can_be_hurt then
        fireball:remove()
        enemy:hurt(2)
      end
    end
  end

end

function enemy:launch_projectile(projectile_breed, sound, number_projectile, wait_value, target_hero, callback)
  local i = 0
  if target_hero then
    direction = enemy:get_direction8_to(hero)
    enemy:get_sprite():set_direction(direction)
  end
  enemy:get_sprite():set_animation("shooting")
  projo_spr:set_direction(0)
  projo_spr:set_opacity(255)
  sol.timer.start(enemy, 300, function()
    i = i+1
    if target_hero then
      direction = enemy:get_direction8_to(hero)
      enemy:get_sprite():set_direction(direction)
    end
    if i < 5 then
      projo_spr:set_direction(i)
      return true
    end
    if sound ~= nil then
      enemy:sound_play(sound)
    end
    enemy:get_sprite():set_animation("walking")
    projo_spr:set_opacity(0)
    for i = 1, number_projectile do
      local projo = enemy:create_enemy({
        name = ("agahnim_"..tostring(enemy).."_projo"),
        breed = projectile_breed,
        y = -16,
      })
    end
    sol.timer.start(enemy, wait_value, function()
      if callback ~= nil then callback() end
    end)
  end)
end

function enemy:shadow_move_end(opacity, color, target_hero, callback)
  if target_hero then
    direction = enemy:get_direction8_to(hero)
    enemy:get_sprite():set_direction(direction)
  end
  enemy:get_sprite():set_animation("to_appear", function()
    enemy:get_sprite():set_animation("walking")
    sol.timer.start(enemy, 50, function()
      if color < 255 then
        opacity = math.min(opacity+25,general_opacity)
        color = math.min(color+25,255)
        enemy:get_sprite():set_color_modulation({color, color, color, opacity})
        return true
      end
      x, y, layer = enemy:get_position()
      can_be_hurt = true
      if enemy.is_clone == nil then
        enemy:set_attack_consequence("sword", "protected")
        enemy:set_attack_consequence("boomerang", "protected")
        enemy:set_can_attack(true)
      end
      if callback ~= nil then callback() end
    end)
  end)
end

function enemy:shadow_move(target_x, target_y, target_hero, callback)
  local opacity = 255
  local color = 255
  can_be_hurt = false
  if enemy.is_clone == nil then
    enemy:set_attack_consequence("sword", "ignored")
    enemy:set_attack_consequence("boomerang", "ignored")
    enemy:set_can_attack(false)
  end
  sol.timer.start(enemy, 50, function()
    if color > 0 then
      color = math.max(0,color-25)
      opacity = math.min(math.max(125,opacity-25), general_opacity)
      enemy:get_sprite():set_color_modulation({color, color, color, opacity})
      return true
    end
    enemy:get_sprite():set_animation("to_shadow", function()
      enemy:get_sprite():set_animation("shadow")
      local m = sol.movement.create("target")
      m:set_speed(32)
      m:set_target(target_x, target_y)
      m:set_ignore_obstacles(true)
      local add_speed = 32
      sol.timer.start(enemy, 80, function()
        add_speed = add_speed+32
        if enemy:get_sprite():get_animation() == "shadow" then
          m:set_speed(add_speed)
          m:start(enemy, function()
            m:stop()
            enemy:shadow_move_end(opacity, color, target_hero, callback)
          end)
          return true
        end
      end)
      m:start(enemy, function()
        m:stop()
        enemy:shadow_move_end(opacity, color, target_hero, callback)
      end)
    end)
  end)
end

function enemy:on_restarted()
  projo_spr:set_opacity(0)
  direction = enemy:get_direction8_to(hero)
  enemy:get_sprite():set_direction(direction)
  enemy:launch_attack()
end

function enemy:on_pre_draw(camera)
  local surface = camera:get_surface()
  if projo_spr:get_opacity() > 0 and (direction >= 1 and direction <= 3) then
    local x_d_1, y_d_1 = camera:get_position()
    local calcul = math.max(0, projo_spr:get_direction()-2)*6
    projo_spr:draw(surface, x-x_d_1+calcul-12, y-y_d_1-24)
    projo_spr:draw(surface, x-x_d_1-calcul+12, y-y_d_1-24)
  end
end

function enemy:on_post_draw(camera)
  local surface = camera:get_surface()
  if projo_spr:get_opacity() > 0 and (direction == 0 or direction >= 4) then
    local x_d_1, y_d_1 = camera:get_position()
    if direction == 0 then
      local calcul = math.max(0, projo_spr:get_direction()-2)*3
      projo_spr:draw(surface, x-x_d_1+10, y-y_d_1+calcul-20)
      projo_spr:draw(surface, x-x_d_1+10, y-y_d_1-calcul-8)
    elseif direction == 4 then
      local calcul = math.max(0, projo_spr:get_direction()-2)*3
      projo_spr:draw(surface, x-x_d_1-10, y-y_d_1+calcul-20)
      projo_spr:draw(surface, x-x_d_1-10, y-y_d_1-calcul-8)
    elseif direction == 5 then
      local calcul = math.max(0, projo_spr:get_direction()-2)*3
      projo_spr:draw(surface, x-x_d_1+calcul-16, y-y_d_1+calcul-22)
      projo_spr:draw(surface, x-x_d_1-calcul-4, y-y_d_1-calcul-10)
    elseif direction == 6 then
      local calcul = math.max(0, projo_spr:get_direction()-2)*6
      projo_spr:draw(surface, x-x_d_1+calcul-12, y-y_d_1-24)
      projo_spr:draw(surface, x-x_d_1-calcul+12, y-y_d_1-24)
    elseif direction == 7 then
      local calcul = math.max(0, projo_spr:get_direction()-2)*3
      projo_spr:draw(surface, x-x_d_1+calcul+4, y-y_d_1-calcul-10)
      projo_spr:draw(surface, x-x_d_1-calcul+16, y-y_d_1+calcul-22)
    end
  end
end

function enemy:on_enabled()
  enemy:get_map():set_entities_enabled("agahnim_"..tostring(enemy).."_clone", true)
  projo_spr:set_opacity(0)
end

function enemy:on_disabled()
  enemy:get_map():set_entities_enabled("agahnim_"..tostring(enemy).."_clone", false)
  projo_spr:set_opacity(0)
end

function enemy:on_dying()
  enemy:get_map():remove_entities("agahnim_"..tostring(enemy))
end

function enemy:on_dead()
  enemy:get_map():remove_entities("agahnim_"..tostring(enemy))
end