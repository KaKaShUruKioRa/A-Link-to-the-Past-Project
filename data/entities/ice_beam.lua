-- An ice beam that can unlight torches and freeze water.
local ice_beam = ...
local sprites = {}
local ice_path_sprite

local enemies_touched = {}

function ice_beam:on_created()

  ice_beam:set_size(8, 8)
  ice_beam:set_origin(4, 5)
  for i = 0, 2 do
    sprites[#sprites + 1] = ice_beam:create_sprite("entities/ice_beam")
  end
end

-- Traversable rules.
ice_beam:set_can_traverse("crystal", true)
ice_beam:set_can_traverse("crystal_block", true)
ice_beam:set_can_traverse("hero", true)
ice_beam:set_can_traverse("jumper", true)
ice_beam:set_can_traverse("stairs", false)
ice_beam:set_can_traverse("stream", true)
ice_beam:set_can_traverse("switch", true)
ice_beam:set_can_traverse("teletransporter", true)
ice_beam:set_can_traverse_ground("deep_water", true)
ice_beam:set_can_traverse_ground("shallow_water", true)
ice_beam:set_can_traverse_ground("hole", true)
ice_beam:set_can_traverse_ground("lava", true)
ice_beam:set_can_traverse_ground("prickles", true)
ice_beam:set_can_traverse_ground("low_wall", true)
ice_beam.apply_cliffs = true

-- Hurt enemies.
ice_beam:add_collision_test("sprite", function(ice_beam, entity)

  if entity:get_type() == "enemy" then
    local enemy = entity
    if enemies_touched[enemy] then
      -- If protected we don't want to play the sound repeatedly.
      return
    end
    enemies_touched[enemy] = true
    local reaction = enemy:get_ice_reaction(enemy_sprite)
    enemy:receive_attack_consequence("ice", reaction)

    sol.timer.start(ice_beam, 200, function()
      ice_beam:remove()
    end)
  end
end)

function ice_beam:go(angle)

  local movement = sol.movement.create("straight")
  movement:set_speed(192)
  movement:set_angle(angle)
  movement:set_max_distance(320)
  movement:set_smooth(false)

  -- Compute the coordinate offset of each sprite.
  local x = math.cos(angle) * 16
  local y = -math.sin(angle) * 16
  sprites[1]:set_xy(2 * x, 2 * y)
  sprites[2]:set_xy(x, y)
  sprites[3]:set_xy(0, 0)

  -- TODO : Rework the animation
  sprites[1]:set_animation("1")
  sprites[2]:set_animation("2")
  sprites[3]:set_animation("3")

  movement:start(ice_beam)
end

function ice_beam:on_obstacle_reached()
  ice_beam:remove()
end

function ice_beam:on_movement_finished()
  ice_beam:remove()
end

function ice_beam:on_position_changed()

  if sprites[1] == nil then
    -- Not initialized yet.
    return
  end
end
