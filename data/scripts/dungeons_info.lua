-- Define the existing dungeons and their floors for the minimap menu.
local dungeons_info = {
  ["eastern_palace"] = {
    floor_width = 1920,
    floor_height = 1200,
    lowest_floor = 0,
    highest_floor = 1,
    maps = {
      "A Link To The Past/Light World/Dungeons/Eastern Palace/F1/F1_eastern_palace","A Link To The Past/Light World/Dungeons/Eastern Palace/F2/F2_eastern_palace",
    },
    boss = {
      floor = 1,
      savegame_variable = "dungeon_1_boss",
      x = 960,
      y = 480 + 224,
    },
  },
}

return dungeons_info