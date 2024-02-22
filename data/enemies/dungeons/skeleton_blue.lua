local enemy = ...
local game = enemy:get_game()
local hero = enemy:get_map():get_hero()

local jumping_speed = 80
local jumping_height = 16
local jumping_duration = 600

require("enemies/library/common_actions").learn(enemy)

--Skeleton blue

function enemy:on_created()
  enemy:set_life(2)
  enemy:set_damage(2)
  enemy:set_hookshot_reaction(2)
  enemy:set_attack_consequence("boomerang",1)
  enemy:set_attack_consequence("thrown_item",2)
end

local sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())

-- The enemy was stopped for some reason and should restart.
function enemy:on_restarted()

  local m = sol.movement.create("straight")
  local direction4 = math.random(4) - 1
  enemy:set_exhausted(false)
  m:set_speed(0)
  m:start(self)
  self:go(direction4)
  self:check_hero()
end

-- An obstacle is reached: stop for a while, looking to a next direction.
function enemy:on_obstacle_reached(movement)

  -- Look to the left or to the right.
  local animation = sprite:get_animation()
  if animation == "walking" then
    self:look_left_or_right()
  end
end

-- The movement is finished: stop for a while, looking to a next direction.
function enemy:on_movement_finished(movement)
  -- Same thing as when an obstacle is reached.
  self:on_obstacle_reached(movement)
end

-- Makes the enemy walk towards a direction.
function enemy:go(direction4)

  -- Set the sprite.
  sprite:set_animation("walking")
  sprite:set_direction(direction4)

  -- Set the movement.
  local m = self:get_movement()
  local max_distance = 40 + math.random(120)
  m:set_max_distance(max_distance)
  m:set_smooth(true)
  m:set_speed(40)
  m:set_angle(direction4 * math.pi / 2)
end

-- Makes the enemy look to its left or to its right (random choice).
function enemy:look_left_or_right()

  local direction = sprite:get_direction()
  if math.random(2) == 1 then
    sprite:set_animation("stopped_watching_left")
    sol.timer.start(enemy, 500, function()
      enemy:go((direction + 1) % 4)
    end)
  else
    sprite:set_animation("stopped_watching_right")
    sol.timer.start(enemy, 500, function()
      enemy:go((direction + 3) % 4)
    end)
  end
end

-- Event triggered when the enemy is close enough to the hero.
function enemy:start_attacking()

  -- Start jumping away from the hero.
  local hero_x, hero_y, _ = hero:get_position()
  local enemy_x, enemy_y, _ = enemy:get_position()
  local angle = math.atan2(hero_y - enemy_y, enemy_x - hero_x)
  enemy:start_jumping(jumping_duration, jumping_height, angle, jumping_speed)
  sol.audio.play_sound("throw")
  sprite:set_animation("jumping")
  enemy.is_exhausted = true
end

-- Start walking again when the attack finished.
enemy:register_event("on_jump_finished", function(enemy)
  enemy:restart()
end)

-- Make the enemy able to attack or not.
function enemy:set_exhausted(exhausted)
  enemy.is_exhausted = exhausted
end

-- Start attacking when the hero is near enough and an attack is pressed, even if not assigned to an item.
function enemy:check_hero()
  local _, _, layer = enemy:get_position()
  local _, _, hero_layer = hero:get_position()
  local near_hero =
      layer == hero_layer
      and enemy:get_distance(hero) < 64
      and enemy:is_in_same_region(hero)
  if enemy:is_enabled() and not enemy.is_exhausted then
    if near_hero and hero:get_animation() == "sword" then
      enemy:start_attacking()
    end
  end
  sol.timer.start(self, 100, function() self:check_hero() end)
end

-- Set exhausted on hurt.
function enemy:on_hurt()
  enemy:set_exhausted(true)
end