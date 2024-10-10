local enemy = ...
local going_hero = false
local timer
local timer_awakening = 500
local timer_asleep = 2000
local timer_following = 3000

--Eyegore green

function enemy:on_created()
  self:set_life(8)
  self:set_damage(2)
  self:create_sprite("enemies/" .. enemy:get_breed())
  self:set_hurt_style("monster")
  self:get_sprite():set_animation("immobilized")
  self:set_invincible(true)
  self:set_attack_consequence("sword", "protected")
  self:set_attack_consequence("thrown_item", "protected")
  self:set_attack_consequence("explosion", "protected")
  self:set_attack_consequence("boomerang", "protected")
  self:set_attack_consequence("arrow", "protected")
  if self:get_treasure() == nil then self:set_treasure("prize_packs/5") end
  --self:set_arrow_reaction("protected")
  --self:set_hookshot_reaction("protected")
  --self:set_fire_reaction("protected")
end

function enemy:on_obstacle_reached(movement)
  if not going_hero then
    self:sleep()
    self:check_hero()
  end
end

function enemy:on_restarted()
  if not going_hero then
    self:get_sprite():set_animation("immobilized")
    self:check_hero()
  else
    if enemy:is_in_same_region(enemy:get_map():get_hero()) then self:go_hero()
    else
      local m = sol.movement.create("target")
      m:set_speed(32)
      m:start(enemy)
      m:stop()
      enemy:set_attack_consequence("arrow", "protected")
      --enemy:set_arrow_reaction("protected")
      enemy:set_attack_consequence("sword", "protected")
      enemy:set_attack_consequence("thrown_item", "protected")
      enemy:set_attack_consequence("explosion", "protected")
      enemy:get_sprite():set_animation("immobilized")
      going_hero = false
      enemy:check_hero()
    end
  end
end

function enemy:check_hero()
  local hero = self:get_map():get_entity("hero")
  local _, _, layer = self:get_position()
  local _, _, hero_layer = hero:get_position()
  local near_hero = layer == hero_layer
    and self:get_distance(hero) <= 40

  if near_hero and not going_hero then
    timer:stop()
    timer = nil
    self:awakens()
  end
-- TODO #21 : Timing d'ouverture de l'oeil lié à la vérification de pressence du Héro... trop lent
  timer = sol.timer.start(self, timer_awakening, function() self:check_hero() end)
end

function enemy:sleep()
  self:set_attack_consequence("arrow", "protected")
  --self:set_arrow_reaction("protected")
  self:set_attack_consequence("sword", "protected")
  self:set_attack_consequence("thrown_item", "protected")
  self:set_attack_consequence("explosion", "protected")
  self:get_sprite():set_animation("sleeping",function()
    self:get_sprite():set_animation("immobilized")
  end)
  timer = sol.timer.start(self, timer_asleep, function() going_hero = false self:check_hero() end)
end

function enemy:awakens()
  self:get_sprite():set_animation("awakening",function() end)
  timer = sol.timer.start(self, timer_awakening, function() self:go_hero() end)  
end

function enemy:on_movement_changed(movement)

    local direction4 = movement:get_direction4()
    local sprite = self:get_sprite()
    sprite:set_direction(direction4)
    timer_following = timer_following - 25
end

function enemy:go_hero()
  self:set_attack_consequence("arrow", 8)
  --self:set_arrow_reaction(8)
  --self:set_hammer_reaction(8)
  --self:set_fire_reaction(4)
  self:set_attack_consequence("sword", 1)
  self:set_attack_consequence("thrown_item", 8)
  self:set_attack_consequence("explosion", 4)
  self:get_sprite():set_animation("walking")
  local m = sol.movement.create("target")
  m:set_speed(56)
  m:start(self)
  going_hero = true
  sol.timer.start(self,timer_following,function()
    timer_following = 3000  
    m:stop(self)
    self:sleep() 
  end)
end