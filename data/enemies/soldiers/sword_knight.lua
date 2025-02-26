local enemy = ...

local behavior = require("enemies/library/soldier")

local properties = {
  main_sprite = "enemies/" .. enemy:get_breed(),
  sword_sprite = "enemies/" .. enemy:get_breed() .. "_weapon",
  life = 3,
  damage = 2,
  normal_speed = 48,
  faster_speed = 56,
  waking_distance = 192
}

behavior:create(enemy, properties)
