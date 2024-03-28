-- Bone projectile, mainly used by the red skeleton enemy.

local enemy = ...
local projectile_behavior = require("enemies/generic_projectile")

-- Global variables
local sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())

-- Start going to the hero.
function enemy:go()
  enemy:straight_go(angle, 96)
end

-- Initialization.
enemy:register_event("on_created", function(enemy)

  projectile_behavior.apply(enemy, sprite)
  enemy:set_life(1)
  enemy:set_size(16, 16)
  enemy:set_origin(8, 8)
  enemy:set_damage(2)
  enemy:set_obstacle_behavior("flying")
  enemy:set_can_hurt_hero_running(true)
  enemy:set_minimum_shield_needed(1)
  enemy:set_invincible()
end)

-- Restart settings.
enemy:register_event("on_restarted", function(enemy)
  sprite:set_animation("walking")
  enemy:go()
end)
