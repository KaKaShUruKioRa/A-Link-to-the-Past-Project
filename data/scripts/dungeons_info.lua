-- Define the existing dungeons and their floors for the minimap menu.
local dungeons_info = {

  ["dungeon_of_terror"] = {
    floor_width = 1920,
    floor_height = 1200,
    lowest_floor = -2,
    highest_floor = 1,
    maps = {
      "test_map/dungeon_entrance",
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