local item = ...

local behavior = require("items/inventory/library/magic_item")

local properties = {
  magic_needed = 4,
  sound_on_success = "ice",
  savegame_variable = "possession_ice_rod",
  hero_animation = "rod",
  sound_on_fail = "wrong",
  animation_sprite = "hero/ice_rod",
  animation_delay = 300,
  do_magic = function()

    -- Shoots some ice on the map.
    local map = item:get_map()
    local hero = map:get_hero()
    local direction = hero:get_direction()

    local x, y, layer = hero:get_position()
    if hero:get_direction() == 3 then
      y = y - 5
    end
    local ice_beam = map:create_custom_entity({
      model = "ice_beam",
      x = x,
      y = y,
      layer = layer,
      width = 16,
      height = 16,
      direction = direction,
    })

    local angle = direction * math.pi / 2
    ice_beam:go(angle)
  end
}

behavior:create(item, properties)


-- Initialize the metatable of appropriate entities to work with the ice beam.
local function initialize_meta()

  -- Add Lua ice beam properties to enemies.
  local enemy_meta = sol.main.get_metatable("enemy")
  if enemy_meta.get_ice_reaction ~= nil then
    -- Already done.
    return
  end

  enemy_meta.ice_reaction = 3  -- 3 life points by default.
  enemy_meta.ice_reaction_sprite = {}
  function enemy_meta:get_ice_reaction(sprite)

    if sprite ~= nil and self.ice_reaction_sprite[sprite] ~= nil then
      return self.ice_reaction_sprite[sprite]
    end
    return self.ice_reaction
  end

  function enemy_meta:set_ice_reaction(reaction, sprite)

    self.ice_reaction = reaction
  end

  function enemy_meta:set_ice_reaction_sprite(sprite, reaction)

    self.ice_reaction_sprite[sprite] = reaction
  end

  -- Change the default enemy:set_invincible() to also
  -- take into account the ice.
  local previous_set_invincible = enemy_meta.set_invincible
  function enemy_meta:set_invincible()
    previous_set_invincible(self)
    self:set_ice_reaction("ignored")
  end
  local previous_set_invincible_sprite = enemy_meta.set_invincible_sprite
  function enemy_meta:set_invincible_sprite(sprite)
    previous_set_invincible_sprite(self, sprite)
    self:set_ice_reaction_sprite(sprite, "ignored")
  end

end
initialize_meta()
