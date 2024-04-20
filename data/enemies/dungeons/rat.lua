local enemy = ...

--Rat

enemy:set_life(1)
enemy:set_damage(2)
if enemy:get_treasure() == nil then enemy:set_treasure("prize_packs/2") end

local sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())

-- The enemy was stopped for some reason and should restart.
function enemy:on_restarted()
   local m = sol.movement.create("straight")
   m:start(self)
   self:go()
end

-- An obstacle is reached: try a new direction
function enemy:on_obstacle_reached()
    self:go()
end

-- Stop for a while, then keep going or change direction
function enemy:on_movement_finished()
  sprite:set_animation("rat")
  local hero = self:get_map():get_hero()
  if self:is_in_same_region(hero) then
    sol.audio.play_sound("rat")
  end
  sol.timer.start(self, math.random(1000,2000), function() 
    self:go()
  end)
end

-- Makes the rat walk towards a direction.
function enemy:go()

    -- Set the sprite.
    sprite:set_animation("walking")
    local direction = sprite:get_direction()
 
    local directions = { ((direction + 3) % 4), ((direction + 1) % 4), ((direction) % 4) }
    local direction4 = directions[math.random(3)]

    sprite:set_direction(direction4)
  
    -- Set the movement.
    local m = self:get_movement()
    local max_distance = 72 + math.random(128)
    m:set_speed(72)
    m:set_max_distance(max_distance)
    m:set_angle(direction4 * math.pi / 2)
end
