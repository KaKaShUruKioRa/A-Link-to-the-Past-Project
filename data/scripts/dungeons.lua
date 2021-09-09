-- Defines the dungeon information of a game.

-- Usage:
-- require("scripts/dungeons")

require("scripts/multi_events")

local dungeons_info = require("scripts/dungeons_info.lua")

local function initialize_dungeon_features(game)

  if game.get_dungeon ~= nil then
    -- Already done.
    return
  end

  -- Returns the name of the current dungeon if any, or nil.
  function game:get_dungeon_name()

    local dungeon = game:get_map():get_id();
    -- Find the dungeon in dungeon_info
    for name,value in pairs(dungeons_info) do 
      for _, map in ipairs(dungeons_info[name].maps) do
        if map == dungeon then
          return name
        end
      end
    end
    
    return nil;
  end

  -- Returns the current dungeon if any, or nil.
  function game:get_dungeon()

    local name = game:get_dungeon_name()
    return dungeons_info[name]
  end

  function game:is_dungeon_finished(dungeon_name)
    return game:get_value(dungeon_name .. "_finished")
  end

  function game:set_dungeon_finished(dungeon_name, finished)
    if finished == nil then
      finished = true
    end
    game:set_value(dungeon_name .. "_finished", finished)
  end

  function game:has_dungeon_map(dungeon_name)

    dungeon_name = dungeon_name or game:get_dungeon_name()
    return game:get_value(dungeon_name .. "_map")
  end

  function game:has_dungeon_compass(dungeon_name)

    dungeon_name = dungeon_name or game:get_dungeon_name()
    return game:get_value(dungeon_name .. "_compass")
  end

  function game:has_dungeon_big_key(dungeon_name)

    dungeon_name = dungeon_name or game:get_dungeon_name()
    return game:get_value(dungeon_name .. "_big_key")
  end

  function game:has_dungeon_boss_key(dungeon_name)

    dungeon_name = dungeon_name or game:get_dungeon_name()
    return game:get_value(dungeon_name .. "_boss_key")
  end

  -- Returns the name of the boolean variable that stores the exploration
  -- of dungeon room, or nil.
  function game:get_explored_dungeon_room_variable(dungeon_name, floor, room)

    dungeon_name = dungeon_name or game:get_dungeon_name()
    room = room or 1

    if floor == nil then
      if game:get_map() ~= nil then
        floor = game:get_map():get_floor()
      else
        floor = 0
      end
    end

    local room_name
    if floor >= 0 then
      room_name = tostring(floor + 1) .. "f_" .. room
    else
      room_name = math.abs(floor) .. "b_" .. room
    end

    return dungeon_name .. "_explored_" .. room_name
  end

  -- Returns whether a dungeon room has been explored.
  function game:has_explored_dungeon_room(dungeon_name, floor, room)

    return self:get_value(
      self:get_explored_dungeon_room_variable(dungeon_name, floor, room)
    )
  end

  -- Changes the exploration state of a dungeon room.
  function game:set_explored_dungeon_room(dungeon_name, floor, room, explored)

    if explored == nil then
      explored = true
    end

    self:set_value(
      self:get_explored_dungeon_room_variable(dungeon_name, floor, room),
      explored
    )
  end

  -- Small key's features
  
  -- Returns whether a small key counter exists on the current map.
  function game:are_small_keys_enabled()
    return self:get_small_keys_savegame_variable() ~= nil
  end

  -- Returns the name of the integer variable that stores the number
  -- of small keys for the current map, or nil.
  function game:get_small_keys_savegame_variable()

    local map = self:get_map()

    if map ~= nil then
      -- Does the map explicitly define a small key counter?
      if map.small_keys_savegame_variable ~= nil then
        return map.small_keys_savegame_variable
      end

      -- Are we in a dungeon?
      local dungeon_name = self:get_dungeon_name()
      if dungeon_name ~= nil then
        return dungeon_name .. "_small_keys"
      end
    end

    -- No small keys on this map.
    return nil
  end

  -- Returns whether the player has at least one small key.
  -- Raises an error is small keys are not enabled in the current map.
  function game:has_small_key()

    return self:get_num_small_keys() > 0
  end

  -- Returns the number of small keys of the player.
  -- Raises an error is small keys are not enabled in the current map.
  function game:get_num_small_keys()

    if not self:are_small_keys_enabled() then
      error("Small keys are not enabled in the current map", 2)
    end

    local savegame_variable = self:get_small_keys_savegame_variable()
    return self:get_value(savegame_variable) or 0
  end

  -- Adds a small key to the player.
  -- Raises an error is small keys are not enabled in the current map.
  function game:add_small_key()

    if not self:are_small_keys_enabled() then
      error("Small keys are not enabled in the current map")
    end

    local savegame_variable = self:get_small_keys_savegame_variable()
    self:set_value(savegame_variable, self:get_num_small_keys() + 1)
  end

  -- Removes a small key to the player.
  -- Raises an error is small keys are not enabled in the current map
  -- or if the player has no small keys.
  function game:remove_small_key()

    if not self:has_small_key() then
      error("The player has no small key")
    end

    local savegame_variable = self:get_small_keys_savegame_variable()
    self:set_value(savegame_variable, self:get_num_small_keys() - 1)
  end

end

-- Set up dungeon features on any game that starts.
local game_meta = sol.main.get_metatable("game")
game_meta:register_event("on_started", initialize_dungeon_features)

return true
