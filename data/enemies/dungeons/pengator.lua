local enemy = ...

local behavior = require("enemies/library/towards_hero")

local properties = {
  sprite = "enemies/" .. enemy:get_breed(),
  life = 9,
  damage = 6,
  normal_speed = 48,
  faster_speed = 48,
}

behavior:create(enemy, properties)
