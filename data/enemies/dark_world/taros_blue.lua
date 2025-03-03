local enemy = ...

local behavior = require("enemies/library/soldier")

local properties = {
  main_sprite = "enemies/" .. enemy:get_breed(),
  sword_sprite = "enemies/" .. enemy:get_breed() .. "_weapon",
  life = 9,
  damage = 8,
  play_hero_seen_sound = true,
  normal_speed = 32,
  faster_speed = 32,
}

behavior:create(enemy, properties)
