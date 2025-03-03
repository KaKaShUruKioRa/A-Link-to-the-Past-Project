local enemy = ...

-- Armos: a statue that sleeps until the hero gets close.

local behavior = require("enemies/library/waiting_for_hero")

local properties = {
  sprite = "enemies/" .. enemy:get_breed(),
  life = 4,
  damage = 2,
  normal_speed = 56,
  faster_speed = 56,
  waking_distance = 80,
}

behavior:create(enemy, properties)
enemy:set_attacking_collision_mode("overlapping")
enemy:set_attack_consequence("thrown_item",4)