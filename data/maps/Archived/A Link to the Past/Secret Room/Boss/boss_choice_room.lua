-- Lua script of map Archived/A Link to the Past/Secret Room/Boss/boss_choice_room.
local map = ...
local game = map:get_game()
local initial_tileset = map:get_tileset()

function map:on_started()

  for other in map:get_entities_by_type("sensor") do
    local name = other:get_name()
    function other:on_activated()
      for other in map:get_entities(name) do
        if other:get_type() == "enemy" then
          sol.audio.play_music("boss")
          other:set_enabled()
          function other:on_dead()
            local the_door = map:get_entity(name.."_door")
            the_door:open()
          end
        end
        if other:get_type() == "door" then
          other:close()
        end
      end
      other:remove()
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