--Spear Knight Projectile.

local enemy = ...
local speed = 96

function enemy:on_created()
  enemy:set_invincible()
  enemy:set_life(1)
  enemy:create_sprite("enemies/soldiers/spear_knight_weapon")
  enemy:set_damage(2)
  enemy:set_size(8, 8)
  enemy:set_origin(4, 4)
  enemy:set_obstacle_behavior("flying")
  enemy:set_minimum_shield_needed(1)
  enemy:set_attacking_collision_mode("overlapping")
end

function enemy:on_obstacle_reached()
  sol.audio.play_sound("sword_tapping")
  enemy:remove()
end

function enemy:on_restarted()
  sol.timer.start(enemy, 10000, function()
    enemy:remove()
  end)
end

function enemy:set_speed(new_speed)
  speed = new_speed
end

function enemy:go(direction4)
  local angle = direction4 * math.pi / 2
  local movement = sol.movement.create("straight")
  movement:set_speed(speed)
  movement:set_angle(angle)
  movement:set_smooth(false)
  movement:start(enemy)
  enemy:get_sprite():set_direction(direction4)
end