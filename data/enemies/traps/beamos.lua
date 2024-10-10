-- Lua script of enemy beamos.
-- This script is executed every time an enemy with this model is created.

-- Global variables.
local enemy = ...
local map = enemy:get_map()
local hero = map:get_hero()

local sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())
local beamos_direction
local angle_per_frame = 2 * math.pi / sprite:get_num_frames()

-- Configuration variables.
local triggering_angle = angle_per_frame * 1.5
local start_shooting_delay = 300
local pause_duration = 300
local is_exhausted_duration = 600
local create_shooting_delay = 500
local start_shooting = false
local laser_direction

-- Properties
function enemy:on_created()

  enemy:set_size(16, 16)
  self:set_invincible()
  self:set_damage(4)
  enemy:set_property("is_major","true")
  self.is_exhausted = false -- True after a shoot and before a delay.
  sol.timer.start(500, function()
    start_shooting = true
  end)
end
  
-- Function to start firing.
function enemy:start_firing()

  

  -- Blink.
  sprite:set_paused(true)
  beamos_direction = sprite:get_frame()
  sprite:set_animation("blink")
  sprite:set_direction(beamos_direction)
  if beamos_direction < 4 then enemy.is_exhausted = true  end
  sol.audio.play_sound("zora")


  -- Start the laser after some time.
  sol.timer.start(enemy, start_shooting_delay, function()

    self.is_exhausted = true 

    -- Create laser projectile.
    local x, y, layer = enemy:get_position()
    map:create_enemy({
      breed =  "traps/beamos_laser",
      x = x,
      y = y - 13,
      layer = layer,
      direction = laser_direction,
      name = laser_direction
    })
    sol.audio.play_sound("lightning")

    -- Unpause animation after some time.
    sol.timer.start(enemy, pause_duration, function()
      sprite:set_paused(false)
      sprite:set_animation("walking")
      sprite:set_frame(beamos_direction)

      -- Allow to shoot again after a delay.
      sol.timer.start(enemy, is_exhausted_duration, function()
        self.is_exhausted = false 
      end)
    end)
  end)
end

-- Check if the beamos is facing the hero at each frame change, then stop and shoot.
function sprite:on_frame_changed(animation, frame)

  if (not enemy.is_exhausted) and start_shooting then
    local x, y, _ = enemy:get_position()
    local hero_x, hero_y, _ = hero:get_position()
    local enemy_angle = frame * angle_per_frame - math.pi * 0.5 -- Frame 0 of the sprite faces the south.
    local hero_angle = math.atan2(y - hero_y, hero_x - x)

    if math.abs(enemy_angle - hero_angle) % (math.pi * 2.0) <= triggering_angle then
      if enemy:is_in_same_region(hero) and enemy:get_distance(hero) <= 256 then 
        laser_direction = hero_angle
        enemy:start_firing() 
      end
    end
  end
end