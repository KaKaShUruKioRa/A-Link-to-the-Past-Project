--Cannonball

local enemy = ...

function enemy:on_created()

  self:set_life(1)
  self:set_invincible()
  self:set_optimization_distance(0)  -- This is done manually by the map.
  self:set_damage(2)
  self:create_sprite("enemies/" .. enemy:get_breed())
  self:set_size(16, 16)
  self:set_origin(8, 13)
  self:set_obstacle_behavior("flying")
  self:set_can_hurt_hero_running(true)
  self:set_invincible()
end

function enemy:on_restarted()

  local movement = sol.movement.create("straight")

  function movement:on_obstacle_reached()
    enemy:remove()
  end

  local direction4 = enemy:get_sprite():get_direction()
  local angle = direction4 * math.pi / 2
  movement:set_speed(72)
  movement:set_angle(angle)

  -- Distance for a standard room.
  local max_distance = 196
  movement:set_max_distance(max_distance)

  movement:start(self, function()
    enemy:get_sprite():set_animation("destroy", function()
      enemy:remove()
    end)
  end)

  -- debug TODO
  movement:set_ignore_obstacles(false)
end