----------------------------------
--
-- Ballchain Soldier's Flail.
--
-- Weapon of the ballchain soldier.
--
-- Methods : enemy:get_state()
--           enemy:set_chain_origin_offset(x, y)
--           enemy:start_orbitting(angle)
--           enemy:start_aiming(entity, minimum_duration, on_finished_callback)
--           enemy:start_throwing_out(on_finished_callback)
--           enemy:start_pulling_in(on_finished_callback)
--
----------------------------------

-- Variables
local enemy = ...
require("enemies/library/common_actions").learn(enemy)

local game = enemy:get_game()
local map = enemy:get_map()
local hero = map:get_hero()
local ball_sprite
local chain_sprites = {}
local eighth = math.pi * 0.25
local quarter = math.pi * 0.5
local circle = math.pi * 2.0
local orbit_rotation_step, orbit_timer
local chain_origin_offset_x, chain_origin_offset_y
local state = "orbitting"

-- Configuration variables
local orbit_initial_angle = 5 * eighth
local orbit_rotation_speed = 1.5 * circle
local orbit_attacking_rotation_speed = 3 * circle
local orbit_radius = 12
local chain_maximum_length = 80

-- Update chain display depending on ball offset position.
local function update_chain()

  local x, y = ball_sprite:get_xy()
  for i = 1, 3 do
    chain_sprites[i]:set_xy((x - chain_origin_offset_x) / 4.0 * i + chain_origin_offset_x, (y - chain_origin_offset_y) / 4.0 * i + chain_origin_offset_y)
  end
end

-- Set the ball and chain sprites position during its orbit depending on angle.
local function set_orbit_position(angle)

  local x = math.cos(angle) * orbit_radius
  local y = -math.sin(angle) * orbit_radius

  ball_sprite:set_xy(x, y)
  update_chain()
end

-- Get the enemy state.
function enemy:get_state()

  return state
end

-- Set an offset to the chain origin.
function enemy:set_chain_origin_offset(x, y)

  chain_origin_offset_x = x
  chain_origin_offset_y = y
end

-- Make the ball start orbitting around its origin, anti clockwise.
function enemy:start_orbitting(angle)

  state = "orbitting"
  orbit_rotation_step = orbit_rotation_speed / 100.0

  set_orbit_position(angle)
  orbit_timer = sol.timer.start(enemy, 10, function()
    angle = (angle - orbit_rotation_step) % circle
    set_orbit_position(angle)
    return true
  end)
end

-- Make the ball start orbitting faster then call the on_finished() callback when the orbit angle is a quarter less than the angle to the entity.
function enemy:start_aiming(entity, minimum_duration, on_finished_callback)

  state = "aiming"
  orbit_rotation_step = orbit_attacking_rotation_speed / 100.0
  sol.timer.start(enemy, minimum_duration, function()

    local x, y = enemy:get_position()
    local remaining_angle = (sol.main.get_angle(0, 0, ball_sprite:get_xy()) - enemy:get_angle(entity:get_position()) - quarter) % circle

    sol.timer.start(enemy, remaining_angle / orbit_attacking_rotation_speed * 1000, function()
      orbit_timer:stop()
      if on_finished_callback then
        on_finished_callback()
      end
    end)
  end)
end

-- Make the ball be throwed to the entity.
function enemy:start_throwing_out(entity, ball_speed, on_finished_callback)

  local x, y, _ = enemy:get_position()
  local offset_x, offset_y = ball_sprite:get_xy()
  local entity_x, entity_y, _ = entity:get_position()
  local angle = sol.main.get_angle(x + offset_x, y + offset_y, entity_x, entity_y)
  state = "throwing"

  local movement = sol.movement.create("straight")
  movement:set_speed(ball_speed)
  movement:set_max_distance(chain_maximum_length)
  movement:set_angle(angle)
  movement:set_ignore_obstacles()
  movement:set_smooth(false)
  movement:start(ball_sprite)
  
  function movement:on_finished()
    if on_finished_callback then
      on_finished_callback()
    end
  end

  function movement:on_position_changed()
    update_chain()
  end
end

-- Make the ball be pulled to the enemy origin then start orbitting again.
function enemy:start_pulling_in(ball_speed, on_finished_callback)

  local angle = sol.main.get_angle(0, 0, ball_sprite:get_xy()) - quarter + orbit_rotation_step
  local target_x = math.cos(angle) * orbit_radius
  local target_y = -math.sin(angle) * orbit_radius
  state = "pulling"

  local movement = sol.movement.create("target")
  movement:set_speed(ball_speed)
  movement:set_target(target_x, target_y)
  movement:set_ignore_obstacles()
  movement:set_smooth(false)
  movement:start(ball_sprite)

  -- Start orbitting again once take back.
  function movement:on_finished()
    enemy:start_orbitting(angle)
    if on_finished_callback then
      on_finished_callback()
    end
  end

  function movement:on_position_changed()
    update_chain()
  end
end

-- Initialization.
enemy:register_event("on_created", function(enemy)

  enemy:set_size(16, 16)
  enemy:set_origin(8, 13)

  for i = 3, 1, -1 do
    chain_sprites[i] = enemy:create_sprite("enemies/soldiers/chain")
  end
  ball_sprite = enemy:create_sprite("enemies/soldiers/ball")
end)

-- Restart settings.
enemy:register_event("on_restarted", function(enemy)

  enemy:set_invincible(true)
  enemy:set_damage(4)
  enemy:set_layer_independent_collisions(true)

  chain_origin_offset_x = 0
  chain_origin_offset_y = 0
  enemy:start_orbitting(orbit_initial_angle)
end)