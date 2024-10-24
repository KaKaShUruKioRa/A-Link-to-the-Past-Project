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

  --Pendentif obtenu : Boss ne revient pas
  if game:get_value("get_pendant_of_power") then
    sensor_boss:set_enabled(false)
    sensor_falling_auto_door_6_n_open:set_enabled(false)
    map:set_doors_open("auto_door_6")
  end
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

--BOSS : ACTIVATION LAMNOLAS, MORT ET RÉCUPÉRATION PENDENTIF

function sensor_boss:on_activated()
    self:set_enabled(false)
    hero:freeze()
    sol.timer.start(map,200,function()
      sol.audio.play_music("boss")
      hero:unfreeze()
      local m = sol.movement.create("straight")
      m:set_max_distance(16)
      m:set_angle(math.pi / 2)
      m:start(map:get_camera())
    end)
end

for enemy in map:get_entities("lamnola_") do
  function enemy:on_dead()
    local x, y, layer = enemy:get_position()
    if not map:has_entities("lamnola_") then
      map:create_pickable{
        treasure_name = "consumables/heart_container",
        treasure_variant = 1,
        x = x,
        y = y,
        layer = layer
      }
    end
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
      key_item_entity:get_sprite():set_animation("quest/pendant_of_power")
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
            treasure_name = "quest/pendant_of_power",
            treasure_variant = 1,
            treasure_savegame_variable = "get_pendant_of_power",
            x = x,
            y = y,
            layer = 1
          }
      end)      
    end)
  end
end