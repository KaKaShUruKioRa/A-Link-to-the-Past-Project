local map = ...
local game = map:get_game()

local cannonball_manager = require("scripts/maps/cannonball_manager")
cannonball_manager:create_cannons(map, "cannon_small_", 400)

local door_manager = require("scripts/maps/door_manager")
door_manager:manage_map(map)
local chest_manager = require("scripts/maps/chest_manager")
chest_manager:manage_map(map)
local separator_manager = require("scripts/maps/separator_manager")
separator_manager:manage_map(map)

function map:on_started()
  --Pendentif obtenue : Boss ne revient pas
  if game:get_value("get_pendant_of_courage") then
    map:set_entities_enabled("armosknight_",false)
    boss:set_enabled(false)
    sensor_boss:set_enabled(false)
    sensor_falling_auto_door_6_n_open:set_enabled(false)
    map:set_doors_open("auto_door_6")
  end
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
      key_item_entity:get_sprite():set_animation("quest/pendant_of_courage")
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
      m:start(key_item_entity,function()
        key_item_entity:set_enabled(false)
        local x, y = key_item_spot:get_position()
          map:create_pickable{
            treasure_name = "quest/pendant_of_courage",
            treasure_variant = 1,
            treasure_savegame_variable = "get_pendant_of_courage",
            x = x,
            y = y,
            layer = 1
          }
      end)      
    end)
  end
end