----------------------------------
--
-- Ballchain Soldier.
--
-- Soldier enemy holding a spiked cannonball at the end of a chain.
-- Slowly moves to the hero, and throw the cannonball to the hero once close enough.
-- 
--
-- Methods : enemy:start_walking()
--           enemy:start_attacking()
--
----------------------------------

-- Global variables
local enemy = ...
require("enemies/library/common_actions").learn(enemy)

local game = enemy:get_game()
local map = enemy:get_map()
local hero = map:get_hero()
local sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())
local quarter = math.pi * 0.5
local flail
local is_attacking = false

-- Configuration variables
local right_hand_offset_x = 4
local right_hand_offset_y = -19
local throwed_chain_origin_offset_x = 0
local throwed_chain_origin_offset_y = 0
local walking_speed = 8
local attack_triggering_distance = 64
local aiming_minimum_duration = 1000
local throwed_ball_speed = 180

-- Start the enemy movement.
function enemy:start_walking()

  local movement = enemy:start_target_walking(hero, walking_speed)

  function movement:on_position_changed()
    if enemy:is_near(hero, attack_triggering_distance) then
      enemy:start_attacking()
    end
  end

  sprite:set_animation("walking")
end

-- Make the enemy aim then throw its ball.
function enemy:start_attacking()

  -- The flail doesn't restart on hurt and finish its possble running move, make sure only one attack is triggered at the same time.
  if is_attacking then
    return
  end
  is_attacking = true
  --enemy:stop_movement()
  --sprite:set_animation("aiming")
  local i = 0
  sol.timer.start(enemy, 300, function() sol.audio.play_sound("ball_and_chain") i = i + 1 return i < 4 end)
  flail:start_aiming(hero, aiming_minimum_duration, function()

    --sprite:set_animation("throwing")
    sol.audio.play_sound("ball_and_chain")
    flail:set_chain_origin_offset(throwed_chain_origin_offset_x, throwed_chain_origin_offset_y)
    flail:start_throwing_out(hero, throwed_ball_speed, function()

      --sprite:set_animation("aiming")
      flail:set_chain_origin_offset(0, 0)
      flail:start_pulling_in(throwed_ball_speed, function()
        is_attacking = false
        enemy:restart()
      end)
    end)
  end)
end

-- Initialization.
enemy:register_event("on_created", function(enemy)

  enemy:set_life(8)
  enemy:set_size(16, 16)
  enemy:set_origin(8, 13)
  enemy:set_attack_consequence("boomerang","immobilized")
  enemy:set_attack_consequence("thrown_item",4)
  enemy:set_pushed_back_when_hurt(false)
  if enemy:get_treasure() == nil then enemy:set_treasure("prize_packs/2") end

  -- Create the flail.
  flail = enemy:create_enemy({
    name = (enemy:get_name() or enemy:get_breed()) .. "_flail",
    breed = "soldiers/chain_and_ball",
    direction = 1,
    x = right_hand_offset_x,
    y = right_hand_offset_y,
    layer = enemy:get_layer() + 1
  })
  enemy:start_welding(flail, right_hand_offset_x, right_hand_offset_y, 1)
end)

-- Make flail disappear when the enemy became invisible on dying.
enemy:register_event("on_dying", function(enemy)
  flail:set_enabled(false)
end)

-- Restart settings.
enemy:register_event("on_restarted", function(enemy)

  -- States.
  flail:set_chain_origin_offset(0, 0)
  enemy:set_can_attack(true)
  enemy:set_damage(4)
  if not is_attacking then
    enemy:start_walking()
  else
    sprite:set_animation(flail:get_state() == "throwing" and "throwing" or "aiming")
  end
end)

function enemy:on_movement_changed(movement)

  local direction4 = movement:get_direction4()
  local sprite = self:get_sprite()
  sprite:set_direction(direction4)
end