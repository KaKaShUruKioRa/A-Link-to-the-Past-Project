-- Lua script of enemy eyegore.

local enemy = ...
local game = enemy:get_game()
local map = enemy:get_map()
local hero = map:get_hero()
local sprite = {}
local movement
local direction = 3
local state = 0
local step = 0
local x, y = enemy:get_position()

function enemy:set_vulnerable() end

function enemy:on_created()
  enemy:set_can_attack(false)
  enemy:set_invincible()
  self:set_attack_consequence("sword", "protected")
  self:set_attack_consequence("thrown_item", "protected")
  self:set_attack_consequence("explosion", "protected")
  self:set_attack_consequence("boomerang", "protected")
  self:set_attack_consequence("arrow", "protected")
  sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_life(8)
  enemy:set_damage(2)

  function enemy:set_vulnerable(boolean)
    if boolean then
      enemy:set_attack_consequence("arrow", 4)
    else
      enemy:set_invincible()
      self:set_attack_consequence("sword", "protected")
      self:set_attack_consequence("thrown_item", "protected")
      self:set_attack_consequence("explosion", "protected")
      self:set_attack_consequence("boomerang", "protected")
      self:set_attack_consequence("arrow", "protected")
    end
  end

  if self:get_treasure() == nil then self:set_treasure("prize_packs/5") end
  sprite:set_animation("immobilized")
  enemy:set_attacking_collision_mode("overlapping")
end

function enemy:on_restarted()
  x, y = enemy:get_position()
  if not enemy:is_in_same_region(hero) then step = 0 end
  if state == 0 then -- wait hero
    enemy:set_can_attack(false)
    sprite:set_animation("immobilized")
    if (sol.main.get_distance(x, y, hero:get_position()) < 64)
    and enemy:is_in_same_region(hero) then
      sprite:set_animation("awakening")
        sol.timer.start(enemy, 1200, function()
          state = 1
          enemy:set_vulnerable(true)
          enemy:set_can_attack(true)
          step = 20
          sprite:set_animation("walking")
          enemy:restart()
        end)
    else
      sol.timer.start(enemy, 200, function()
        enemy:restart()
      end)
    end
  elseif state == 1 then -- target hero
    step = step-1
    if step <= 0 then
      state = 2
      enemy:restart()
    else
      direction = (math.ceil((math.abs((sol.main.get_angle(x, y, hero:get_position()))*(180/math.pi))-45)/90))%4
      movement = sol.movement.create("path")
      movement:set_path{direction*2}
      movement:set_speed(48)
      function movement:on_obstacle_reached()
        enemy:restart()
      end
      movement:start(enemy, function()
        enemy:restart()
      end)
      sprite:set_direction(direction)
    end
  elseif state == 2 then -- close eyes
    enemy:set_can_attack(false)
    enemy:set_vulnerable(false)
    sprite:set_direction(3)
    sprite:set_animation("sleeping", function()
      state = 0
      sprite:set_animation("immobilized")
      enemy:restart()
    end)
  end
end