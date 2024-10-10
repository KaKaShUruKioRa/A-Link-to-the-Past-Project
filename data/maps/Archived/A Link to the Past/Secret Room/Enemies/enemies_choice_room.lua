-- Lua script of map Archived/A Link to the Past/Secret Room/Boss/boss_choice_room.
local map = ...
local game = map:get_game()
local initial_tileset = map:get_tileset()

function map:on_started()

  for sensor in map:get_entities_by_type("sensor") do
    local name = sensor:get_name()
    function sensor:on_activated()
      for entity in map:get_entities("spawn_enemy") do
        if entity:get_type() == "custom_entity" then
          local x, y, layer = entity:get_position()
          local breed = entity:get_property("name")
          local parts = {}
          for part in string.gmatch(breed, "/(.*)") do
            table.insert(parts, part)
          end
          local entity_name = parts[#parts]
          if entity_name == name then
            for enemies in map:get_entities_by_type("enemy") do
              if enemies:get_breed() == breed then
                enemies:remove()
              end
            end
            map:create_enemy({breed = breed, layer = layer, x = x, y = y, direction = 1, name = entity_name})
          end
        end
      end
    end
  end
  for other in map:get_entities_by_type("door") do
    other:set_open(true)
  end

  for other in map:get_entities_by_type("npc") do
    if other:get_sprite():get_animation_set("npc/octopus") then
      function other:on_interaction()
        initial_tileset = ("dungeon/"..other:get_name())
        map:set_tileset(initial_tileset)
      end
    end
  end
 
end

function map:on_opening_transition_finished()
  
end

function moldorm_enter:on_activated()
  map:set_tileset("dungeon/pink")
end

function moldorm_out:on_activated()
  map:set_tileset(initial_tileset)
end