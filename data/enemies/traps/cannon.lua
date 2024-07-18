local enemy = ...
local map = enemy:get_map()
local game = map:get_game()
local hero = map:get_hero()
local sprite

function enemy:on_created()

  enemy:set_life(1)
  enemy:set_damage(2)
  enemy:set_size(16, 16)
  enemy:set_origin(8, 13)
  enemy:set_can_hurt_hero_running(true)
  enemy:set_invincible()
  enemy:set_attack_consequence("sword", "protected")
  enemy:set_attack_consequence("thrown_item", "protected")
  enemy:set_attack_consequence("arrow", "protected")
  enemy:set_attack_consequence("hookshot", "protected")
  enemy:set_attack_consequence("boomerang", "protected")
  sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())

end

function enemy:on_restarted()

  local direction4 = sprite:get_direction()
  local m = sol.movement.create("path")
  m:set_path{direction4 * 2}
  m:set_speed(72)
  m:set_loop(true)
  m:start(enemy)

  enemy:get_sprite():set_animation(enemy:get_property("direction_look"))

  sol.timer.start(enemy, math.random(500,800), function() 
    if enemy:is_in_same_region(hero) then
      sol.audio.play_sound("cannonball") 
      local x, y, layer = enemy:get_position()
      if enemy:get_sprite():get_animation() == "0" then x = x + 8
      elseif enemy:get_sprite():get_animation() == "1" then y = y - 8
      elseif enemy:get_sprite():get_animation() == "2" then x = x - 8
      elseif enemy:get_sprite():get_animation() == "3" then y = y + 8 end
      local effect = enemy:get_map():create_custom_entity({
        direction = 0,
        x = x,
        y = y,
        layer = layer,
        width = 16,
        height = 16,
        sprite = "entities/cannon_smoke",
      })
      effect:set_drawn_in_y_order(true)
      enemy:get_map():create_enemy({
        breed = "traps/cannon_projectile",
        x = x,
        y = y,
        layer = layer - 1,
        direction = enemy:get_property("direction_look")
      })
    end
    return true
  end)
end

function enemy:on_obstacle_reached()

  local direction4 = sprite:get_direction()
  sprite:set_direction((direction4 + 2) % 4)

  enemy:restart()
end