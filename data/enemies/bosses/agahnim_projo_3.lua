-- Lua script of enemy bosses/agahnim_projo_3.
-- 16 cases to down
local enemy = ...
local game = enemy:get_game()
local map = enemy:get_map()
local hero = map:get_hero()
local sprites = {}
local cases_spr = {}
local cases_x = {}
local x, y, layer = enemy:get_position()
local hero_x, hero_y, hero_layer = hero:get_position()

function enemy:on_created()
  enemy:set_invincible()
  sprite = enemy:get_sprite()
  for i = 0, 7 do
    sprites[i] = sol.sprite.create("enemies/" .. enemy:get_breed())
    sprites[i]:set_direction(i)
  end
  for i = 1, 17 do
    cases_spr[i] = -1
    cases_x[i] = 0
  end
  enemy:set_life(1)
  enemy:set_damage(8)
  enemy:set_attacking_collision_mode("overlapping")
end

function enemy:on_restarted()
  local i = 2
  cases_spr[1] = math.random(0, 7)
  sol.timer.start(enemy, 20, function()
    local previous_x = cases_x[i-1]
    cases_spr[i] = math.random(0, 7)
    local id_calcul = cases_spr[i-1]
    if id_calcul == 0 then
      cases_x[i] = previous_x-8
    elseif id_calcul == 1 then
      cases_x[i] = previous_x-8
    elseif id_calcul == 2 then
      cases_x[i] = previous_x+8
    elseif id_calcul == 3 then
      cases_x[i] = previous_x-8
    elseif id_calcul == 4 then
      cases_x[i] = previous_x+8
    elseif id_calcul == 5 then
      cases_x[i] = previous_x+8
    elseif id_calcul == 6 then
      cases_x[i] = previous_x-4
    elseif id_calcul == 7 then
      cases_x[i] = previous_x+4
    end
    i = i+1
    if i < 17 then
      return true
    else
      sol.timer.start(enemy, 400, function()
        i = 1
        sol.timer.start(enemy, 20, function()
          cases_spr[i] = -1
          i = i+1
          if i < 17 then
            return true
          else
            enemy:remove()
          end
        end)
      end)
    end
  end)
end

function enemy:on_update()
  x, y, layer = enemy:get_position()
  if hero:get_layer() == layer and not (hero:is_invincible() or hero:is_blinking()) then
    for i = 1, 17 do
      if cases_spr[i] >= 0 and hero:overlaps(x+cases_x[i], y+(i*8)) then
        hero:start_hurt(x, y, enemy:get_damage())
      end
    end
  end
end

function enemy:on_post_draw(camera)
  local random_value = tostring(math.random(0,5))
  for i = 0, 7 do
    sprites[i]:set_animation(random_value)
  end
  local camera_surface = camera:get_surface()
  local cam_x, cam_y = camera:get_position()
  for i = 1, 17 do
    local sprite_id = cases_spr[i]
    if sprite_id >= 0 then
      sprites[sprite_id]:draw(camera_surface, x-cam_x+cases_x[i], y-cam_y+(i*8))
    end
  end
end