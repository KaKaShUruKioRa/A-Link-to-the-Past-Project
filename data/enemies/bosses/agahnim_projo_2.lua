-- Lua script of enemy bosses/agahnim_projo_2.
local enemy = ...
local map = enemy:get_map()
local sprite

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
  sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_invincible()
  enemy:set_life(1)
  enemy:set_damage(4)
  enemy:set_size(16, 16)
  enemy:set_origin(8, 8)
  enemy:set_obstacle_behavior("flying")
  enemy:set_attack_consequence("sword", "custom")
  enemy:set_can_hurt_hero_running(true)
  enemy:set_attacking_collision_mode("overlapping")
end

function enemy:on_restarted()
  local hero_x, hero_y = map:get_hero():get_center_position()
  local angle = enemy:get_angle(hero_x, hero_y)
  enemy:go(angle)
  sprite:set_direction(0)
end

function enemy:go(angle)
  local movement = sol.movement.create("straight")
  movement:set_speed(140)
  movement:set_angle(angle)
  movement:set_smooth(false)
  movement:start(enemy)
end

function enemy:on_obstacle_reached()
  enemy:explode()
end

function enemy:explode()
  if sprite:get_direction() == 0 then
    enemy:sound_play("boss_fireball")
    for i = 0, 5 do
      local name = "aga_projo_2"..tostring(i)
      if enemy:get_name() ~= nil then
        name = enemy:get_name().."_small_"..tostring(i)
      end
      local projo = enemy:create_enemy({
        name = name,
        breed = enemy:get_breed(),
      })
      projo:set_invincible()
      projo:set_damage(2)
      projo:set_size(8, 8)
      projo:set_origin(4, 4)
      projo:go( (((math.pi*2)/6)*i)-(math.pi/6) )
      projo:get_sprite():set_direction(1)
      sol.timer.start(projo, 90, function()
        local x, y, layer = projo:get_position()
        local particule = projo:get_map():create_custom_entity({
          layer = layer,
          x = x,
          y = y,
          direction = 1,
          width = 8,
          height = 8,
          sprite = "enemies/" .. enemy:get_breed(),
        })
        local sprite_particule = particule:get_sprite()
        sprite_particule:set_animation(sprite_particule:get_animation(), function()
          particule:remove()
        end)
        sol.timer.start(particule, 90, function()
          if particule:get_direction() < 3 then
            particule:set_direction(particule:get_direction()+1)
            return true
          else
            particule:remove()
          end
        end)
        return true
      end)
    end
  end
  enemy:remove()
end

function enemy:on_custom_attack_received(attack, sprite)
  if attack == "sword" then
    enemy:explode()
  end
end