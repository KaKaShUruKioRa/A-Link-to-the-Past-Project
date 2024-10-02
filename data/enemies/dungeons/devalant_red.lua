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
  enemy:set_life(2)
  enemy:set_damage(2)
  enemy:set_property("is_major","true")
  enemy:set_attacking_collision_mode("center")
  enemy:set_pushed_back_when_hurt(false)

  enemy:set_attack_consequence("sword","custom")

  if self:get_treasure() == nil then self:set_treasure("prize_packs/2") end
end

function enemy:shoot()
  local i = 0
  sol.timer.start(enemy, 500,function()
    i = i + 1
    sol.audio.play_sound("zora")
    enemy:create_enemy({
      breed = "others/fireball_red_small",
      layer = layer
    })
    if i == 3 then
      i = 0
      sol.timer.start(enemy, 500, function()
        enemy:disappear()
      end)
    else return true end
  end) 
end

function enemy:on_restarted()
  enemy:set_visible(true)
  enemy:set_can_attack(true)
  enemy:appearing()
end

function enemy:disappear()
  sprite:set_animation("disappearing",function()
    enemy:set_visible(false)
    enemy:set_can_attack(false)
  end)
end

function enemy:appearing()
  sprite:set_animation("appearing", function()
    sprite:set_animation("normal")
    enemy:shoot()
  end)
end

function enemy:on_custom_attack_received()
  sprite:set_animation("hurt")
  sol.audio.play_sound("enemy_hurt")
  sol.timer.start(enemy, 400, function() enemy:remove_life(1) sprite:set_animation("normal") end)
end