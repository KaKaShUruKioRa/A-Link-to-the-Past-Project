-- Script of the Lantern.
local item = ...

local behavior = require("items/inventory/library/magic_item")

local properties = {magic_needed = 4,
  sound_on_success = "magic_powder",
  savegame_variable = "possession_magic_powder_rod",
  hero_animation = "magic_powder",
  sound_on_fail = "wrong",
  animation_delay = 300,
  do_magic = function()

    -- Spreads some powder on the map.
    local map = item:get_map()
    local hero = map:get_hero()
    local direction = hero:get_direction()

    local dx, dy
    if direction == 0 then
      dx, dy = 18, -4
    elseif direction == 1 then
      dx, dy = 0, -24
    elseif direction == 2 then
      dx, dy = -20, -4
    else
      dx, dy = 0, 16
    end

    local x, y, layer = hero:get_position()
    map:create_custom_entity{
      model = "powder",
      x = x + dx,
      y = y + dy,
      layer = layer,
      width = 16,
      height = 16,
      direction = 0,
    }
  end
}

behavior:create(item, properties)
