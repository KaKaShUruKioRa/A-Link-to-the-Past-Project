local enemy = ...
local behavior = require("enemies/library/soldier")

local children = {}

local properties = {
  main_sprite = "enemies/" .. enemy:get_breed(),
  sword_sprite = "enemies/" .. enemy:get_breed() .. "_weapon",
  life = 6,
  damage = 4,
  normal_speed = 32,
  faster_speed = 48,
  can_shoot = true
}

behavior:create(enemy, properties)

local function throw_spear()

  local sprite = enemy:get_sprite()
  local x, y, layer = enemy:get_position()
  local direction = sprite:get_direction()

  -- Where to start the fire from.
  local dxy = {
    {  8, -0 },
    {  0, -0 },
    { -8, -0 },
    {  0, -0 },
  }
  spear_sprite = enemy:get_sprite(sword_sprite)
  spear_sprite:set_opacity(0)
  enemy:set_attack_consequence_sprite(spear_sprite, "sword", "ignored")
  
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
    enemy:go_hero()
  end)
end

function enemy:on_restarted()

  local map = enemy:get_map()
  local hero = map:get_hero()

  enemy:go_hero()

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
          spear_sprite = enemy:get_sprite(sword_sprite)
          spear_sprite:set_opacity(255)
          enemy:set_attack_consequence_sprite(spear_sprite, "sword", "custom")
          can_shoot = true
        end)
      end
    end
    return true  -- Repeat the timer.
  end)
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


