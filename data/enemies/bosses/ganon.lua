-- Ganon: final boss.

local enemy = ...
local game = enemy:get_game()

function enemy:on_created()
  local dialog_interlude_read = false
  enemy:set_life(100)
  enemy:set_damage(20)
  enemy:set_hurt_style("boss")
  enemy:create_sprite("enemies/" .. enemy:get_breed())
  enemy:set_pushed_back_when_hurt(false)
  enemy:set_size(16, 16)
  enemy:set_origin(8, 13)

  enemy:set_attack_consequence("sword", "protected")
  enemy:set_attack_consequence("arrow", "custom")
end

function enemy:on_restarted()

    enemy:set_can_attack(true)

    local movement = sol.movement.create("target")
    movement:set_speed(48)
    movement:start(enemy)

    enemy:set_attack_consequence("sword", "protected")
    enemy:set_attack_consequence("arrow", "custom")
end

function enemy:on_custom_attack_received(attack, sprite) 
  
  if attack == "arrow" and not enemy:is_immobilized() then
    if game:get_item("inventory/bow"):get_variant() > 1 then
      sol.audio.play_sound("boss_hurt")
      enemy:stop_movement()
      enemy:set_can_attack(false)
      enemy:get_sprite():set_animation("immobilized")
      enemy:set_attack_consequence("arrow", "protected")
      enemy:set_attack_consequence("sword", "custom")
      sol.timer.start(3500, function() enemy:restart() end)
    end
  end
  
  if attack == "sword" and enemy:get_sprite():get_animation() == "immobilized" then     
    sol.audio.play_sound("boss_hurt")
    enemy:get_sprite():set_animation("hurt")
    enemy:remove_life(4*math.max(1, game:get_ability("sword")-1))

    if enemy:get_life() <= (100 / 2) and not dialog_interlude_read then
      game:start_dialog("enemy.ganon.interlude", function()
        dialog_interlude_read = true
      end)
    end
    
    sol.timer.start(1500, function() enemy:restart() end)
  end
end