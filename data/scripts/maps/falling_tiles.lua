-- This script enables falling tiles on the map passed as parameter.

local map = ...

-- Starts the fall of tiles
-- (this function can be called when the hero enters the room of falling tiles).
function map:start_falling_tiles()

  local total = map:get_entities_count("falling_tile_entity")
  local next_index = 1  -- Index of the next falling tile to spawn.
  local spawn_delay = 350  -- Delay between two falling tiles.

  map:set_entities_enabled("falling_tile_entity", false)
  map:set_entities_enabled("falling_tile_after", false)

  -- Spawns a tile and schedules the next one.
  local function repeat_spawn()

    map:get_entity("falling_tile_entity_" .. next_index):set_enabled(true)
    map:get_entity("falling_tile_after_" .. next_index):set_enabled(true)
    next_index = next_index + 1
    sol.audio.play_sound("bow")
    if next_index <= total then
      sol.timer.start(spawn_delay, repeat_spawn)
    end
  end

  repeat_spawn()
end