-- Define the existing dungeons and their floors for the minimap menu.
local dungeons_info = {
  ["hyrule_castle"] = {
    floor_width = 1920,
    floor_height = 1200,
    lowest_floor = 0,
    highest_floor = 1,
    maps = {
      "A Link To The Past/Light World/Dungeons/Hyrule Castle/F1/F1_hyrule_castle","A Link To The Past/Light World/Dungeons/Hyrule Castle/F2/F2_hyrule_castle", "A Link To The Past/Light World/Dungeons/Hyrule Castle/B1/B1_hyrule_castle", "A Link To The Past/Light World/Dungeons/Hyrule Castle/B2/B2_hyrule_castle", "A Link To The Past/Light World/Dungeons/Hyrule Castle/B3/B3_hyrule_castle"
    },
    boss = {
      floor = 1,
      savegame_variable = "hyrule_castle_boss",
      x = 960,
      y = 480 + 224,
    },
  },
  ["hyrule_castle_secret_passage"] = {
    floor_width = 1920,
    floor_height = 1200,
    lowest_floor = 0,
    highest_floor = 1,
    maps = {
      "A Link To The Past/Light World/Dungeons/Secret Passage/F2/F2_secret_passage","A Link To The Past/Light World/Dungeons/Secret Passage/F1/F1_secret_passage", "A Link To The Past/Light World/Dungeons/Secret Passage/B1/B1_secret_passage"
    },
    boss = {
      floor = 1,
      savegame_variable = "hyrule_castle_secret_passage_boss",
      x = 960,
      y = 480 + 224,
    },
  },
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
      savegame_variable = "eastern_boss",
      x = 960,
      y = 480 + 224,
    },
  },
}

return dungeons_info