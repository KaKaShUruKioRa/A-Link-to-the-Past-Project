local enemy = ...

local children = {}

-- Moblin (simple soldier copy + spear knight)

enemy:set_life(3)
enemy:set_damage(2)
enemy:set_attack_consequence("thrown_item",4)
if enemy:get_treasure() == nil then enemy:set_treasure("prize_packs/1") end

local sprite = enemy:create_sprite("enemies/" .. enemy:get_breed())

local function throw_spear()

  local sprite = enemy:get_sprite()
  local x, y, layer = enemy:get_position()
  local direction = sprite:get_direction()

  -- Where to start the fire from.
  local dxy = {
    { 0, 16 }, --Droite (Axe Horizontal X, Axe Vertical Y)--Droite (Axe Horizontal X, Axe Vertical Y)
    { 16, 0 }, --Haut (Axe Horizontal X, Axe Vertical Y)
    { 0, 8 }, --Gauche (Axe Horizontal X, Axe Vertical Y)
    { -16, 0},  --Bas (Axe Horizontal X, Axe Vertical Y)
  }
  
  sprite:set_animation("aiming")
  enemy:stop_movement()
  sol.timer.start(enemy, 500, function()
    local spear = enemy:create_enemy({
     breed = "soldiers/spear_knight_projectile",
      x = dxy[direction + 1][1],
      y = dxy[direction + 1][2],
    })

    spear:go(direction)
    children[#children + 1] = spear

    local direction4 = math.random(4) - 1
    enemy:go(direction4)
  end)
end

-- The enemy was stopped for some reason and should restart.
function enemy:on_restarted()
  local map = enemy:get_map()
  local hero = map:get_hero()

  local m = sol.movement.create("straight")
  m:set_speed(0)
  m:start(self)
  local direction4 = math.random(4) - 1
  self:go(direction4)

  can_shoot = true

  sol.timer.start(enemy, 200, function()

    local hero_x, hero_y = hero:get_position()
    local x, y = enemy:get_center_position()

    if can_shoot then
      local aligned = (math.abs(hero_x - x) < 16 or math.abs(hero_y - y) < 16)
      if aligned and enemy:get_distance(hero) < 200 then
        throw_spear()
        can_shoot = false
        sol.timer.start(enemy, 2000, function()
          can_shoot = true
        end)
      end
    end
    return true  -- Repeat the timer.
  end)
end

-- An obstacle is reached: stop for a while, looking to a next direction.
function enemy:on_obstacle_reached(movement)

  -- Look to the left or to the right.
  local animation = sprite:get_animation()
  if animation == "walking" then
    self:look_left_or_right()
  end
end

-- The movement is finished: stop for a while, looking to a next direction.
function enemy:on_movement_finished(movement)
  -- Same thing as when an obstacle is reached.
  self:on_obstacle_reached(movement)
end

-- Makes the enemy walk towards a direction.
function enemy:go(direction4)
  -- Set the sprite.
  sprite:set_animation("walking")
  sprite:set_direction(direction4)

  -- Set the movement.
  if not self:get_movement() then
    sol.movement.create("straight"):start(self)
  end
  
  local m  = self:get_movement()
  local max_distance = 40 + math.random(120)
  m:set_max_distance(max_distance)
  m:set_smooth(true)
  m:set_speed(48)
  m:set_angle(direction4 * math.pi / 2)
end

-- Makes the enemy look to its left or to its right (random choice).
function enemy:look_left_or_right()

  local direction = sprite:get_direction()
  if math.random(2) == 1 then
    sol.timer.start(enemy, 500, function()
      enemy:go((direction + 1) % 4)
    end)
  else
    sol.timer.start(enemy, 500, function()
      enemy:go((direction + 3) % 4)
    end)
  end
end

local previous_on_removed = enemy.on_removed
function enemy:on_removed()

  if previous_on_removed then
    previous_on_removed(enemy)
  end

  for _, child in ipairs(children) do
    child:remove()
  end
end