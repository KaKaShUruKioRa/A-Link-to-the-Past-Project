local enemy = ...

local behavior = require("enemies/library/soldier")

local properties = {
  main_sprite = "enemies/" .. enemy:get_breed(),
  sword_sprite = "enemies/" .. enemy:get_breed() .. "_weapon",
  life = 4,
  damage = 4,
  play_hero_seen_sound = true,
  normal_speed = 48,
  faster_speed = 56,
}

behavior:create(enemy, properties)
