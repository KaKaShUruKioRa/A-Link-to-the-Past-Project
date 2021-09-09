-- Script of the Lantern.
local item = ...

local behavior = require("items/inventory/library/magic_item")

local properties = {
  magic_needed = 2,
  sound_on_success = "lantern",
  sound_on_fail = "wrong",
  savegame_variable = "possession_lantern",
  do_magic = function()

    -- Creates some fire on the map.
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
      model = "fire",
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

