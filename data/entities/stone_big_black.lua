-- Lua script of custom entity big_stone_white.
-- This script is executed every time a custom entity with this model is created.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local entity = ...
local game = entity:get_game()
local map = entity:get_map()
local hero = map:get_hero()

-- Event called when the custom entity is initialized.
function entity:on_created()
  entity:set_traversable_by(false)
  entity:set_drawn_in_y_order(true)
  entity:set_weight(2)
end

function entity:on_interaction()
end