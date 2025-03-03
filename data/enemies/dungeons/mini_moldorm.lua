-- Lua script of enemy mini_moldorm.
-- This script is executed every time an enemy with this model is created.

-- Global variables
local enemy = ...
local common_actions = require("enemies/library/common_actions")
require("scripts/multi_events")

local game = enemy:get_game()
local map = enemy:get_map()
local hero = map:get_hero()
local head_sprite, body_sprite, tail_sprite
local last_positions, frame_count
local walking_movement = nil
local eighth = math.pi * 0.25
local quarter = math.pi * 0.5

-- Configuration variables
local walking_speed = 96
local walking_angle = 0.05
local body_frame_lag = 11
local tail_frame_lag = 20
local keeping_angle_maximum_duration = 1000

local highest_frame_lag = tail_frame_lag + 1 -- Avoid too much values in the last_positions table

-- Start the enemy movement.
function enemy:start_walking()

  walking_movement = sol.movement.create("straight")
  walking_movement:set_speed(walking_speed)
  walking_movement:set_angle(math.random(4) * quarter)
  walking_movement:set_smooth(false)
  walking_movement:start(self)

  -- Inverse the angle on obstacle reached.
  function walking_movement:on_obstacle_reached()
    walking_movement:set_angle(walking_movement:get_angle() + math.pi)
  end

  -- Slightly change the angle when walking.
  function walking_movement:on_position_changed()
    local angle = walking_movement:get_angle() % (2.0 * math.pi)
    if walking_movement == enemy:get_movement() then
      walking_movement:set_angle(angle + walking_angle)
    end
  end

  -- Regularly and randomly change the angle.
  sol.timer.start(enemy, keeping_angle_maximum_duration, function()
    if math.random(2) == 1 then
      walking_angle = 0 - walking_angle
    end
    return true
  end)
end

-- Update head, body and tails sprite on position changed whatever the movement is.
enemy:register_event("on_position_changed", function(enemy)

  if not last_positions then
    return
  end

  -- Save current position
  local x, y, _ = enemy:get_position()
  last_positions[frame_count] = {x = x, y = y}

  -- Set the head sprite direction.
  local angle = (enemy:get_movement():get_angle() + eighth / 4.0) % (2.0 * math.pi)
  local direction8 = math.floor(angle / eighth)
  if head_sprite:get_direction() ~= direction8 then
    head_sprite:set_direction(direction8)
  end

  -- Replace part sprites on a previous position.
  local function replace_part_sprite(sprite, frame_lag)
    local previous_position = last_positions[(frame_count - frame_lag) % highest_frame_lag] or last_positions[0]
    sprite:set_xy(previous_position.x - x, previous_position.y - y)
  end
  replace_part_sprite(body_sprite, body_frame_lag)
  replace_part_sprite(tail_sprite, tail_frame_lag)

  frame_count = (frame_count + 1) % highest_frame_lag
end)

-- Initialization.
enemy:register_event("on_created", function(enemy)

  common_actions.learn(enemy, sprite)
  enemy:set_life(2)
  enemy:set_damage(4)
  enemy:set_size(16, 16)
  enemy:set_origin(8, 8)
  enemy:set_hookshot_reaction(6)
  enemy:set_attack_consequence("boomerang","protected")
  enemy:set_attack_consequence("thrown_item",4)

  if enemy:get_treasure() == nil then enemy:set_treasure("prize_packs/2") end
  
  -- Create sprites.
  head_sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())
  body_sprite = enemy:create_sprite("enemies/" .. enemy:get_breed() .. "_body")
  tail_sprite = enemy:create_sprite("enemies/" .. enemy:get_breed() .. "_tail")
  enemy:bring_sprite_to_back(body_sprite)
  enemy:bring_sprite_to_back(tail_sprite)
end)

-- Restart settings.
enemy:register_event("on_restarted", function(enemy)

  -- States.
  last_positions = {}
  frame_count = 0
  enemy:start_walking()
end)
