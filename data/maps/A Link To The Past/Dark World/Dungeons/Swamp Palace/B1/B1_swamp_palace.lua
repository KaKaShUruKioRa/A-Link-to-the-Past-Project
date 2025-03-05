-- Lua script of map Archived/A Link to the Past/Light World/Non Playable Zone/Dungeons/Tower of Hera/F6/.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

local door_manager = require("scripts/maps/door_manager")
door_manager:manage_map(map)
local chest_manager = require("scripts/maps/chest_manager")
chest_manager:manage_map(map)
local separator_manager = require("scripts/maps/separator_manager")
separator_manager:manage_map(map)

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()
  --Réceptacle obtenu : Pendentif apparait et pas Boss
  if game:get_value("heart_container_swamp_palace") then
    local x, y = key_item_spot:get_position()
      map:create_pickable{
        treasure_name = "quest/crystal_2",
        treasure_variant = 1,
        treasure_savegame_variable = "get_crystal_2",
        x = x,
        y = y,
        layer = 1
      }
  end
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

function map:on_obtained_treasure(treasure_item, treasure_variant, treasure_savegame_variable)
  if treasure_item == game:get_item("consumables/heart_container") then
    sol.timer.start(map,1000,function()

      local x, y, layer = key_item_spot:get_position()
      local key_item_entity = map:create_custom_entity({
          name = "falling_key_item",
          sprite = "entities/items",
          x = x,
          y = y - 144,
          width = 16,
          height = 16,
          layer = layer + 1,
          direction = 0
        })
      key_item_entity:get_sprite():set_animation("quest/crystal_2")
      key_item_entity:get_sprite():set_direction(0)

      shadow:set_enabled(true)
      sol.timer.start(map,500,function()
        shadow:get_sprite():set_animation("big")
      end)

      local m = sol.movement.create("straight")
      m:set_max_distance(144)
      m:set_ignore_obstacles(true)
      m:set_speed(144)
      m:set_angle(3 * math.pi / 2)
      sol.audio.play_sound("savequit")
      m:start(key_item_entity,function()
        key_item_entity:set_enabled(false)
        local x, y = key_item_spot:get_position()
          map:create_pickable{
            treasure_name = "quest/crystal_2",
            treasure_variant = 1,
            treasure_savegame_variable = "get_crystal_2",
            x = x,
            y = y,
            layer = 1
          }
      end)      
    end)
  end
end