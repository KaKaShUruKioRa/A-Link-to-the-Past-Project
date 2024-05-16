--Electric barrier keeping the Castle Tower. Only the Master Sword can remove it.

local enemy = ...
local game = enemy:get_game()
local map = enemy:get_map()
local hero = map:get_hero()
local sprite

-- Event called when the enemy is initialized.
function enemy:on_created()

  -- Initialize the properties of your enemy here,
  -- like the sprite, the life and the damage.
  sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_invincible()
  enemy:set_life(1)
  enemy:set_damage(4)
  enemy:set_pushed_back_when_hurt(false)
  enemy:set_attack_consequence("sword", "custom")
end

-- Restart settings.
function enemy:on_restarted()

  -- Initialize the properties of your enemy here,
  -- like the sprite, the life and the damage.
  sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_invincible()
  enemy:set_life(1)
  enemy:set_damage(8)
  enemy:set_pushed_back_when_hurt(false)
  enemy:set_attack_consequence("sword", "custom")
end

function enemy:on_custom_attack_received(attack, sprite)
  if attack == "sword" then
    if game:get_value("get_master_sword") then enemy:remove_life(1) 
    else
      enemy:get_game():remove_life(3)
      hero:start_hurt(1)
      hero:freeze()
      hero:set_animation("electrocuted")
      sol.audio.play_sound("hero_hurt")
      sol.timer.start(1000, function () hero:unfreeze() end)
    end
  end
end

function enemy:on_attacking_hero(hero)
	enemy:get_game():remove_life(3)
  hero:start_hurt(enemy, 1)
  hero:freeze()
	hero:set_animation("electrocuted")
  sol.audio.play_sound("hero_hurt")
  sol.timer.start(1000, function () hero:unfreeze() end)
end

function enemy:on_dead()
  game:get_map():get_entity("electric_barrier_wall"):set_enabled(false)
end