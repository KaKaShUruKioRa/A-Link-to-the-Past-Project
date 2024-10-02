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

  --Mur repoussé
  if game:get_value("desert_palace_sliding_wall") then
    map:set_entities_enabled("sliding_wall",false)
    map:set_entities_enabled("after_slide",true)
    map:set_entities_enabled("before_slide",false)
    for torch in map:get_entities("wall_torch") do torch:set_lit(true) end
  end


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

--ALLUMER TORCHES POUR DEPLACER LE MUR
local lit_torch = 0
for torch in map:get_entities("wall_torch") do
  function torch:on_lit()
    lit_torch = lit_torch + 1
    if lit_torch == 4 then
      map:move_camera(592,554,256,function() 
        local sliding_wall_1_x, sliding_wall_1_y = map:get_entity("sliding_wall_1"):get_position()
        local sliding_wall_2_x, sliding_wall_2_y = map:get_entity("sliding_wall_2"):get_position()
        local sliding_wall_3_x, sliding_wall_3_y = map:get_entity("sliding_wall_3"):get_position()
        local sliding_wall_4_x, sliding_wall_4_y = map:get_entity("sliding_wall_4"):get_position()
        local i = 0
        local camera = map:get_camera()
        --local shake_config = {
        --  count = 310,
        --  amplitude = 2,
        --}
        --camera:shake(shake_config)
        sol.timer.start(map,70,function()
          sol.audio.play_sound("hero_pushes")
          i = i + 1
          sliding_wall_1_x = sliding_wall_1_x - 1
          sliding_wall_2_x = sliding_wall_2_x - 1
          sliding_wall_3_x = sliding_wall_3_x - 1
          sliding_wall_4_x = sliding_wall_4_x - 1
          sliding_wall_1:set_position(sliding_wall_1_x, sliding_wall_1_y)
          sliding_wall_2:set_position(sliding_wall_2_x, sliding_wall_2_y)
          sliding_wall_3:set_position(sliding_wall_3_x, sliding_wall_3_y)
          sliding_wall_4:set_position(sliding_wall_4_x, sliding_wall_4_y)
          if i < 64 then return true end
          sol.audio.play_sound("secret")
          map:set_entities_enabled("before_slide",false)
          map:set_entities_enabled("after_slide",true)
          game:set_value("desert_palace_sliding_wall",true)
        end)
      end,1000,5000)     
    end
  end
end