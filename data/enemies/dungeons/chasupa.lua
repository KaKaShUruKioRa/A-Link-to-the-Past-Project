-- Chasupa: a flying eye that sleeps until the hero gets close.

local chasupa = ...

local game = chasupa:get_game()
local map = chasupa:get_map()
local hero = map:get_hero()

local function lengthdir_x(angle_radian, distance)
  local dx = math.cos(angle_radian)*distance
  return dx
end

local function lengthdir_y(angle_radian, distance)
  local dy = math.sin(angle_radian)*distance
  return dy
end

local main_sprite
local speed
local enemy_variant
local enemy_timer = 0

local angle_point = 90

local function wave(a, b, c, d, time)
  local wave = (b - a) * 0.5
  if time == nil then time = sol.main.get_elapsed_time() end
  return a + wave + math.sin((((time * 0.001) + c * d) / c) * (math.pi * 2)) * wave
end

function chasupa:on_created()
  enemy_variant = chasupa:get_property("variant")
  if enemy_variant == nil then enemy_variant = 1 end
  if enemy_variant == "3" then
    main_sprite = chasupa:create_sprite("enemies/" .. chasupa:get_breed() .. enemy_variant)
    speed = 16
    chasupa:set_size(16, 16)
    chasupa:set_origin(8, 16)
    chasupa:set_life(4)
    chasupa:set_damage(2)
    chasupa:set_pushed_back_when_hurt(false)
  elseif enemy_variant == "2" then
    main_sprite = chasupa:create_sprite("enemies/" .. chasupa:get_breed() .. enemy_variant)
    speed = 64
    chasupa:set_size(8, 8)
    chasupa:set_origin(4, 8)
    chasupa:set_life(2)
    chasupa:set_damage(4)
    chasupa:set_pushed_back_when_hurt(true)
  else
    main_sprite = chasupa:create_sprite("enemies/" .. chasupa:get_breed())
    speed = 32
    chasupa:set_size(8, 8)
    chasupa:set_origin(4, 8)
    chasupa:set_life(1)
    chasupa:set_damage(1)
    chasupa:set_pushed_back_when_hurt(true)
  end
  chasupa:set_obstacle_behavior("flying")
  chasupa:set_attacking_collision_mode("sprite")
  chasupa:set_layer_independent_collisions(true)
end

function chasupa:on_update()
  if main_sprite:get_animation() == "walking" then
    enemy_timer = enemy_timer+((speed*1)/2)-( (1735)*(math.min(math.max(enemy_timer-(1735), 0), 1)) )
    angle_point = angle_point+1
    if angle_point > 359 then angle_point = angle_point-359 end
    main_sprite:set_xy(lengthdir_x(math.rad(angle_point), 16), wave(-8, 8, 1.8, 4, enemy_timer))
  end
end

function chasupa:on_restarted()
  if chasupa:get_distance(hero) < 48 and chasupa:is_in_same_region(hero) then
    main_sprite:set_xy(lengthdir_x(math.rad(angle_point), 16), wave(-8, 8, 1.8, 4, enemy_timer))
    chasupa:go_walk()
  else
    main_sprite:set_xy(lengthdir_x(math.rad(angle_point), 16), wave(-8, 8, 1.8, 4, enemy_timer))
    chasupa:stare()
  end
end

function chasupa:stare()
  main_sprite:set_animation("stopped")
  sol.timer.start(chasupa, 100, function()
    chasupa:restart()
  end)
end

function chasupa:go_walk()
  if not main_sprite:get_animation() == "walking" then main_sprite:set_animation("walking") end
  local x, y, layer = chasupa:get_position()
  local hero_x, hero_y, hero_layer = hero:get_position()
  local angle = sol.main.get_angle(x, y, hero_x, hero_y)
  local movement = sol.movement.create("straight")
  movement:set_angle(angle)
  movement:set_speed(speed)
  --movement:set_max_distance(32)
  movement:start(chasupa) --, function() chasupa:restart() end)
  sol.timer.start(chasupa, 100, function()
    movement:stop()
    chasupa:restart()
  end)
end

function chasupa:on_attacking_hero(hero, enemy_sprite)
  local x_center, y_center = chasupa:get_position()
  local x_local_pos, y_local_pos = main_sprite:get_xy()
  local x_origin, y_origin = chasupa:get_origin()
  local x_size, y_size = chasupa:get_size()
  if hero:overlaps(x_center+x_local_pos-x_origin, y_center+y_local_pos-y_origin, x_size, y_size) then
    hero:start_hurt(chasupa, chasupa:get_damage())
  end
end