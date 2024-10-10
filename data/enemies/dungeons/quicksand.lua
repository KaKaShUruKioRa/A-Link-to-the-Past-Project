local enemy = ...
local game = enemy:get_game()
local map = enemy:get_map()
local hero = map:get_hero()
local sprite
local movement
local name = enemy:get_name()

local timer
local enemy_appear = false

function enemy:on_created()

  sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_invincible()
  enemy:set_property("is_major","true")
  enemy:set_can_attack(false)
  enemy:set_drawn_in_y_order(false)
end

function enemy:on_restarted()

  if not enemy_appear then
    self:set_visible(false)
    self:check_hero()
  end
end

function enemy:disappear()
  map:set_entities_enabled(name.."_flux", false)
  map:set_entities_enabled(name.."_devalant", false)
  sprite:set_animation("disappearing",function()
    self:set_visible(false)
    sol.timer.start(enemy,2000,function() enemy_appear = false enemy:restart() end)
  end)
end

function enemy:appearing()
  enemy_appear = true
  self:set_visible(true)
  sprite:set_animation("appearing",function()
    map:set_entities_enabled(name.."_flux", true)
    map:set_entities_enabled(name.."_devalant", true)
    sprite:set_animation("normal")

    sol.timer.start(enemy,5000,function() enemy:disappear() end)
  end)
end

function enemy:check_hero()
  local hero = self:get_map():get_entity("hero")
  local _, _, layer = self:get_position()
  local _, _, hero_layer = hero:get_position()
  local near_hero = layer == hero_layer
    and self:get_distance(hero) <= 48

  if near_hero and not enemy_appear then
    timer:stop()
    timer = nil
    enemy:appearing()
  end

  timer = sol.timer.start(self, 200, function() self:check_hero() end)
end