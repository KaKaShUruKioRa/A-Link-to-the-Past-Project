local map = ...
local game = map:get_game()

local door_manager = require("scripts/maps/door_manager")
door_manager:manage_map(map)
local chest_manager = require("scripts/maps/chest_manager")
chest_manager:manage_map(map)
local separator_manager = require("scripts/maps/separator_manager")
separator_manager:manage_map(map)

local init_evil_tiles = sol.main.load_file("scripts/maps/evil_tiles")
init_evil_tiles(map)

function map:on_started(destination)


  -- Dalles piégées
  map:set_entities_enabled("evil_tile_", false)
end

--DALLES PIEGEES
for sensor in map:get_entities("evil_tiles_sensor") do
  function sensor:on_activated()
    map:set_entities_enabled("evil_tiles_sensor",false)
    if evil_tile_enemy_1 ~= nil then
      sol.timer.start(2000, function()
        map:start_evil_tiles()
      end)
    end
  end
end