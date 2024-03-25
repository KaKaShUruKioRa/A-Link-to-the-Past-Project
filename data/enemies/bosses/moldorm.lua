----------------------------------
--
-- Moldorm.
--
-- Caterpillar enemy with three body parts and one tail that will follow the head move.
-- Moves in curved motion, and randomly change the direction of the curve.
-- Speed up the move if set_angry() or hurt.
--
-- Methods : enemy:start_walking()
--           enemy:set_angry()
--
----------------------------------

-- Global variables
local enemy = ...
--require("enemies/lib/common_actions").learn(enemy)

local game = enemy:get_game()
local map = enemy:get_map()
local hero = map:get_hero()
local sprites = {}
local head_sprite, tail_sprite
local last_positions, frame_count
local walking_movement
local is_angry

-- Configuration variables
local walking_speed = 88
local walking_angle = 0.035
local running_speed = 140
local tied_sprites_frame_lags = {20, 35, 50, 62}
local keeping_angle_duration = 1000
local angry_duration = 3000
local before_explosion_delay = 2000
local between_explosion_delay = 500

-- Constants
local highest_frame_lag = tied_sprites_frame_lags[#tied_sprites_frame_lags] + 1
local sixteenth = math.pi * 0.125
local eighth = math.pi * 0.25
local quarter = math.pi * 0.5
local circle = math.pi * 2.0

-- Return the normal angle of close obstacles as a multiple of pi/4, or nil if none.
function enemy:get_obstacles_normal_angle()

  local collisions = {
    [0] = enemy:test_obstacles(-1,  0),
    [1] = enemy:test_obstacles(-1,  1),
    [2] = enemy:test_obstacles( 0,  1),
    [3] = enemy:test_obstacles( 1,  1),
    [4] = enemy:test_obstacles( 1,  0),
    [5] = enemy:test_obstacles( 1, -1),
    [6] = enemy:test_obstacles( 0, -1),
    [7] = enemy:test_obstacles(-1, -1)
  }

  local function xor(a, b)
    return (a or b) and not (a and b)
  end

  -- Return the normal angle for this direction if collision on the direction or the two surrounding ones, and no obstacle in the two next or obstacle in both.
  local function check_normal_angle(direction8)
    return ((collisions[direction8] or collisions[(direction8 - 1) % 8] and collisions[(direction8 + 1) % 8]) 
        and not xor(collisions[(direction8 - 2) % 8], collisions[(direction8 + 2) % 8])
        and direction8 * eighth)
  end

  -- Check for obstacles on each direction8 and return the normal angle if it is the correct one.
  local normal_angle
  for direction8 = 0, 7 do
    normal_angle = normal_angle or check_normal_angle(direction8)
  end

  return normal_angle
end

-- Update head sprite direction, and tied sprites offset.
local function update_sprites()

  -- Save current position
  local x, y, _ = enemy:get_position()
  last_positions[frame_count] = {x = x, y = y}

  -- Set the head sprite direction.
  local direction8 = math.floor((enemy:get_movement():get_angle() + sixteenth) % circle / eighth)
  if head_sprite:get_direction() ~= direction8 then
    head_sprite:set_direction(direction8)
  end

  -- Replace part sprites on a previous position.
  local function replace_part_sprite(sprite, frame_lag)
    local previous_position = last_positions[(frame_count - frame_lag) % highest_frame_lag] or last_positions[0]
    sprite:set_xy(previous_position.x - x, previous_position.y - y)
  end
  for i = 1, 4 do
    replace_part_sprite(sprites[i + 1], tied_sprites_frame_lags[i])
  end

  frame_count = (frame_count + 1) % highest_frame_lag
end

-- Hurt or repulse the hero depending on touched sprite.
local function on_attack_received()

  -- Make sure to only trigger this event once by attack.
  enemy:set_invincible()

  -- Don't hurt and only repulse if the hero sword sprite doesn't collide with the tail sprite.
  if not enemy:overlaps(hero, "sprite", tail_sprite, hero:get_sprite("sword")) then
    enemy:start_pushing_back(hero, 200, 100, function()
      --TODO enemy:set_hero_weapons_reactions(on_attack_received, {jump_on = "ignored"})
    end)
    return
  end

  -- Custom die if only one more life point.
  if enemy:get_life() < 2 then

    -- Wait a few time, make tail then body sprites explode, wait a few time again and finally make the head explode and enemy die.
    enemy:start_death(function()
      for _, sprite in enemy:get_sprites() do
        if sprite:has_animation("hurt") then
          sprite:set_animation("hurt")
        end
      end

      local sorted_tied_sprites = {sprites[5], sprites[4], sprites[3], sprites[2]}
      sol.timer.start(enemy, 2000, function()
        enemy:start_sprite_explosions(sorted_tied_sprites, "entities/explosion_boss", 0, 0, function()
          sol.timer.start(enemy, 1000, function()
            local x, y = head_sprite:get_xy()
            enemy:start_brief_effect("entities/explosion_boss", nil, x, y)
            finish_death()
          end)
        end)
      end)
    end)
    return
  end

  -- Else hurt normally.
  enemy:hurt(1)
end

-- Start the enemy movement.
function enemy:start_walking()

  walking_movement = sol.movement.create("straight")
  walking_movement:set_speed(walking_speed)
  walking_movement:set_angle(math.random(4) * quarter)
  walking_movement:set_smooth(false)
  walking_movement:start(enemy)

  -- Take the obstacle normal as angle on obstacle reached.
  function walking_movement:on_obstacle_reached()
    walking_movement:set_angle(enemy:get_obstacles_normal_angle())
  end

  -- Regularly and randomly change the angle.
  sol.timer.start(enemy, keeping_angle_duration, function()
    if math.random(2) == 1 then
      walking_angle = 0 - walking_angle
    end
    return true
  end)

  -- Update walking angle, head sprite direction and tied sprites positions
  sol.timer.start(enemy, 10, function()
    walking_movement:set_angle((walking_movement:get_angle() + walking_angle) % circle)
    update_sprites()
    return walking_speed / walking_movement:get_speed() * 10 -- Schedule for each frame while walking and more while running, to keep the same curve and sprites distance.
  end)
end

-- Increase the enemy speed for some time.
function enemy:set_angry()

  is_angry = true
  walking_movement:set_speed(running_speed)
  sol.timer.start(enemy, angry_duration, function()
    is_angry = false
    walking_movement:set_speed(walking_speed)
  end)
end

-- Initialization.
enemy:register_event("on_created", function(enemy)

  enemy:set_life(12)
  enemy:set_size(24, 24)
  enemy:set_origin(12, 12)
  
  -- Create sprites in right z-order.
  sprites[5] = enemy:create_sprite("enemies/" .. enemy:get_breed() .. "/tail")
  for i = 3, 1, -1 do -- for i = 3 to 1 step -1
    sprites[i + 1] = enemy:create_sprite("enemies/" .. enemy:get_breed() .. "/body_" .. i)
    enemy:set_invincible_sprite(sprites[i + 1])
  end
  sprites[1] = enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_invincible_sprite(sprites[1])

  head_sprite = sprites[1]
  tail_sprite = sprites[5]
end)

-- Restart settings.
enemy:register_event("on_restarted", function(enemy)

  -- Behavior for each items.
 -- TODO enemy:set_hero_weapons_reactions(on_attack_received, {jump_on = "ignored"})

  -- States.
  last_positions = {}
  frame_count = 0
  is_angry = false
  enemy:set_can_attack(true)
  enemy:set_damage(2)
  enemy:start_walking()
  if enemy:get_life() < 4 then
    enemy:set_angry()
  end
end)
