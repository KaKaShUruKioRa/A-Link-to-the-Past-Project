-- Converts maps that are using the old huge outside tileset
-- to now be using the rearranged equivalent that is splitted into 3 tilesets
-- whose size is now lower than 2048x2048.

local map_files = {...}

local function get_pattern_mapping()
  
  local pattern_to_tileset = {}
  
  -- Check that the new tileset files exist, otherwise show an error.
  local tileset_path = "../data/tilesets/"
  local tileset_ids = {
    "out/outside_main",
    "out/outside_buildings",
    "out/outside_special",
  }
  
  -- Traverse the new tileset files and associate to each pattern the tileset id.
  for _, tileset_id in ipairs(tileset_ids) do
    local file = io.open(tileset_path .. tileset_id .. ".dat")
    if file == nil then
      error("Cannot open tileset file: " .. file_path)
    end
    local content = file:read("*a")
    for pattern in content:gmatch("tile_pattern{\n  id = \"([a-zA-Z0-9._-]+)\",\n") do
      if pattern_to_tileset[pattern] ~= nil then
        error("Pattern is duplicated in two tilesets: " .. pattern)
      end
      pattern_to_tileset[pattern] = tileset_id
    end
  end

  return pattern_to_tileset
end

local function convert_map(pattern_to_tileset, map_file_path)

  print("Converting map " .. map_file_path)

  local file = io.open(map_file_path)
  if file == nil then
    error("Cannot open map file for reading: " .. map_file_path)
  end
  local content = file:read("*a")

  -- Set the main tileset of the map.
  -- Do nothing if the main tileset is not the old one.
  local obsolete_tileset_id = "out/outside"
  local main_tileset_id = "out/outside_main"
  local occurences
  content, occurences = content:gsub(
    "\n  tileset = \"" .. obsolete_tileset_id .. "\",\n",
    "\n  tileset = \"" .. main_tileset_id .. "\",\n",
    1)
  if occurences == 0 then
    print("  The tileset of this map is not the obsolete one, skipping.")
    return
  end

  -- For each tile or dynamic tile that does not specify a tileset,
  -- determine the new tileset.
  -- Set this tileset except if it is the main one of the map.
  local count = 0
  content = content:gsub("(tile{[^}]+\n  pattern = \")([a-zA-Z0-9._-]+)(\"[^}]+})", function(before, pattern_id, after)
      local explicit_tileset_id = after:match("\n  tileset = \"([a-zA-Z0-9._-%/]+)\",\n")
      if explicit_tileset_id ~= nil then
        if explicit_tileset_id == obsolete_tileset_id then
          -- Not implemented. If this happens, we need to update this script (or to manually update the map file).
          error("Unsupported operation: tile with pattern " .. pattern_id .. " explicitly refers to the obsolete tileset")
        end
        return  -- Don't change anything if a specific tileset is already set.
      end
      
      local new_tileset_id = pattern_to_tileset[pattern_id]
      if new_tileset_id == nil then
        error("Cannot find pattern in any of the new tilesets: " .. pattern_id)
      end
      if new_tileset_id == main_tileset_id then
        return nil  -- Nothing to change for this one.
      else
        count = count + 1
        return before .. pattern_id .. "\",\n  tileset = \"" .. new_tileset_id .. after
      end
    end
  )
  print("  Done, " .. count .. " tiles updated")
  
  -- Save the file.
  file:close()
  file = io.open(map_file_path, "w")
  if file == nil then
    error("Cannot open map file for writing: " .. map_file_path)
  end
  file:write(content)
  file:close()
end

if #map_files == 0 then
  print("Usage: lua update_maps_to_rearranged_outside_tilesets.lua quest_path map_file_1.dat ...")
  os.exit(1)
end

local pattern_to_tileset = get_pattern_mapping()

for _, map_file in ipairs(map_files) do
  convert_map(pattern_to_tileset, map_file)
end
