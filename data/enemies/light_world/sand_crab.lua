local enemy = ...

local behavior = require("enemies/library/towards_hero")

local properties = {
  sprite = "enemies/" .. enemy:get_breed(),
  life = 2,
  damage = 2,
  normal_speed = 64,
  faster_speed = 64,
}

behavior:create(enemy, properties)
