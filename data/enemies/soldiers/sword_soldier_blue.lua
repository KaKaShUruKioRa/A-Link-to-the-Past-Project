local enemy = ...

local behavior = require("enemies/library/soldier")

local properties = {
  main_sprite = "enemies/" .. enemy:get_breed(),
  sword_sprite = "enemies/" .. enemy:get_breed() .. "_weapon",
  life = 3,
  damage = 2,
  play_hero_seen_sound = true,
  normal_speed = 32,
  faster_speed = 48,
}

behavior:create(enemy, properties)
