-- Script of the Fire rod.
local item = ...

local behavior = require("items/inventory/library/magic_item")

local properties = {
  magic_needed = 4,
  sound_on_success = "lantern",
  savegame_variable = "possession_fire_rod",
  hero_animation = "rod",
  sound_on_fail = "wrong",
  animation_sprite = "hero/fire_rod",
  animation_delay = 300,
  do_magic = function()

    -- Shoots some fire on the map.
    local map = item:get_map()
    local hero = map:get_hero()
    local direction = hero:get_direction()

    local x, y, layer = hero:get_center_position()
    local fire = map:create_custom_entity({
      model = "fire",
      x = x,
      y = y + 3,
      layer = layer,
      width = 8,
      height = 8,
      direction = direction,
    })

    local fire_sprite = fire:get_sprite()
    fire_sprite:set_animation("flying")

    local angle = direction * math.pi / 2
    local movement = sol.movement.create("straight")
    movement:set_speed(192)
    movement:set_angle(angle)
    movement:set_smooth(false)
    movement:start(fire)
  end
}

behavior:create(item, properties)


-- Initialize the metatable of appropriate entities to work with the fire.
local function initialize_meta()

  -- Add Lua fire properties to enemies.
  local enemy_meta = sol.main.get_metatable("enemy")
  if enemy_meta.get_fire_reaction ~= nil then
    -- Already done.
    return
  end

  enemy_meta.fire_reaction = 3  -- 3 life points by default.
  enemy_meta.fire_reaction_sprite = {}
  function enemy_meta:get_fire_reaction(sprite)

    if sprite ~= nil and self.fire_reaction_sprite[sprite] ~= nil then
      return self.fire_reaction_sprite[sprite]
    end
    return self.fire_reaction
  end

  function enemy_meta:set_fire_reaction(reaction, sprite)

    self.fire_reaction = reaction
  end

  function enemy_meta:set_fire_reaction_sprite(sprite, reaction)

    self.fire_reaction_sprite[sprite] = reaction
  end

  -- Change the default enemy:set_invincible() to also
  -- take into account the fire.
  local previous_set_invincible = enemy_meta.set_invincible
  function enemy_meta:set_invincible()
    previous_set_invincible(self)
    self:set_fire_reaction("ignored")
  end
  local previous_set_invincible_sprite = enemy_meta.set_invincible_sprite
  function enemy_meta:set_invincible_sprite(sprite)
    previous_set_invincible_sprite(self, sprite)
    self:set_fire_reaction_sprite(sprite, "ignored")
  end

end
initialize_meta()
