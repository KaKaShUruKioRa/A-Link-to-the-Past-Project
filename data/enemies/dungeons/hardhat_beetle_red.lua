local enemy = ...

local movement = sol.movement.create("target")
local max_speed = 48
local min_speed = 0
local speed = min_speed
local speed_change = false

enemy:set_attack_consequence("thrown_item",4)
-- Blue Hardhat Beetle.

function enemy:on_created()

  enemy:set_life(8)
  enemy:set_damage(8)
  enemy:set_attack_consequence("thrown_item",4)
  enemy:set_attack_consequence("boomerang","protected")
  enemy:create_sprite("enemies/" .. enemy:get_breed())
  if self:get_treasure() == nil then self:set_treasure("prize_packs/2") end
  enemy:set_push_hero_on_sword(true)
end

local function go_hero()

  local sprite = enemy:get_sprite()
  sprite:set_animation("walking")
  movement:set_speed(min_speed)
  movement:start(enemy)
end

function movement:on_changed()
  if(speed < max_speed and not speed_change) then
    speed_change = true -- Pour éviter plusieurs modifications simultanées
    sol.timer.start(enemy, 1500/(max_speed - min_speed), function() -- Temps d'accélération fixé à 1500ms
      speed = speed + 1      
      movement:set_speed(speed)
      movement:start(enemy)
      return speed < max_speed
    end)
  end

end

function enemy:on_restarted()

  local map = enemy:get_map()
  local hero = map:get_hero()
  speed = min_speed
  speed_change = false
  go_hero()

end