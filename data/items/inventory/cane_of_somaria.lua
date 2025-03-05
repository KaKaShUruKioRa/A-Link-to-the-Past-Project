-- Script of the Cane of Somaria.
local item = ...

local magic_needed = 4
local sound_on_success = "lantern"
local savegame_variable = "possession_somaria_cane"
local hero_animation = "rod"
local sound_on_fail = "wrong"
local sound_block_spawn = "cane"
local sound_block_destroy = "cane"
local animation_sprite = "hero/cane_of_somaria"
local block_bounce_sound = "bomb"
local animation_delay = 300

local game = item:get_game()

function item:on_created()
  if savegame_variable then
    item:set_savegame_variable(savegame_variable)
  end
  item:set_assignable(true)
end

function item:on_using()

  local map = item:get_map()
  local hero = map:get_hero()

  if sol.main.resource_exists("sprite", animation_sprite) then
    animation_sprite = animation_sprite
  else
    animation_sprite = "hero/fire_rod"
  end
  -- Give the hero the animation of using the item
  local custom_entity = nil
  if hero_animation then
    hero:set_animation(hero_animation)
  end
  local x, y, layer = hero:get_position()
  local custom_entity = map:create_custom_entity({
    x = x,
    y = y,
    layer = layer,
    width = 16,
    height = 16,
    direction = hero:get_direction(),
    sprite = animation_sprite,
  })

  -- Do magic if there is enough magic.
  if game:get_magic() >= magic_needed or map:get_entity("somaria_block") ~= nil then
    sol.audio.play_sound(sound_on_success)

    -- Shoots some fire on the map.
    local direction = hero:get_direction()

    local x, y, layer = hero:get_center_position()

    local function create_fire_projectile(map, direction, x, y, layer, variant)
      local fire = map:create_custom_entity({
        model = "fire",
        x = x,
        y = y + 3,
        layer = layer,
        width = 8,
        height = 8,
        direction = variant,
      })
      function fire:lengthdir_x(angle_radian, distance)
        local dx = math.cos(angle_radian)*distance
        return dx
      end

      function fire:lengthdir_y(angle_radian, distance)
        local dy = math.sin(angle_radian)*distance
        return dy
      end
      function fire:on_obstacle_reached(movement)
        sol.audio.play_sound(sound_on_success)
        local x, y, layer = fire:get_position()
        local angle = movement:get_angle()
        x, y = x+fire:lengthdir_x(angle, 8), y-fire:lengthdir_y(angle, 8)
        fire:get_map():create_custom_entity{
          model = "fire",
          x = x,
          y = y,
          layer = layer,
          width = 16,
          height = 16,
          direction = fire:get_direction(),
        }
        fire:remove()
      end

      local fire_sprite = fire:get_sprite()
      fire_sprite:set_animation("flying")
      fire_sprite:set_rotation((math.pi/2)*direction)
      fire_sprite:set_xy(0,-5)

      local angle = direction * math.pi / 2
      local movement = sol.movement.create("straight")
      movement:set_speed(192)
      movement:set_angle(angle)
      movement:set_smooth(false)
      movement:start(fire)
    end

    if map:get_entity("somaria_block") ~= nil then
      if map:get_entity("somaria_block"):get_sprite():get_animation() == "block" then
        map:get_entity("somaria_block"):get_sprite():set_animation("destroy", function()
          local block = map:get_entity("somaria_block")
          x, y, layer = block:get_position()
          for switch in map:get_entities_by_type("switch") do
            if block:overlaps(switch, "overlapping") then
              if not switch:is_locked() then
                switch:set_activated(false)
                if switch.on_inactivated ~= nil then
                  switch:on_inactivated()
                end
              end
            end
          end
          block:remove()
          create_fire_projectile(map, 0, x, y, layer, 0)
          create_fire_projectile(map, 1, x, y, layer, 0)
          create_fire_projectile(map, 2, x, y, layer, 0)
          create_fire_projectile(map, 3, x, y, layer, 0)
        end)
      end
    else
      game:remove_magic(magic_needed)
      local i = 0
      sol.timer.start(hero, 50, function()
        sol.audio.play_sound(sound_block_spawn)
        local x_spawn, y_spawn = x+16, y
        if direction == 1 then x_spawn, y_spawn = x, y-16
        elseif direction == 2 then x_spawn, y_spawn = x-16, y
        elseif direction == 3 then x_spawn, y_spawn = x, y+16
        end
        local block = map:create_custom_entity({
          name = "somaria_block",
          model = "block",
          x = x_spawn,
          y = y_spawn + 5,
          layer = layer,
          width = 16,
          height = 16,
          direction = 0,
          sprite = "entities/block_somaria",
        })
        function block:is_hookable()
          return false
        end
        block:register_event("on_interaction", function(block)
          for switch in map:get_entities_by_type("switch") do
            if block:overlaps(switch, "overlapping") then
              if not switch:is_locked() then
                switch:set_activated(false)
                if switch.on_inactivated ~= nil then
                  switch:on_inactivated()
                end
              end
            end
          end
        end)
        local carriable_behavior = require("entities/lib/carriable")
        carriable_behavior.apply(block, {bounce_sound = block_bounce_sound, is_offensive = false})
        function block:on_finish_throw()
          for switch in map:get_entities_by_type("switch") do
            if block:overlaps(switch, "overlapping") then
              if not switch:is_locked() then
                switch:set_activated(true)
                if switch.on_activated ~= nil then
                  switch:on_activated()
                end
              end
            end
          end
        end
        if hero:test_obstacles(0, 0) then
          map:get_entity("somaria_block"):remove()
          create_fire_projectile(map, direction, x, y, layer, 0)
        end
      end)
    end
  elseif sound_on_fail then
    sol.audio.play_sound(sound_on_fail)
  end

  if custom_entity then
    -- Make sure that the magic item stays on the hero.
    -- Even if he is using this item, he can move
    -- because of holes or ice.
    sol.timer.start(custom_entity, 10, function()
      custom_entity:set_position(hero:get_position())
      return true
    end)
  end

  -- Remove the magic item and restore control after a delay.
  if hero_animation or custom_entity then
    sol.timer.start(hero, animation_delay, function()
      if custom_entity then
        custom_entity:remove()
      end
      item:set_finished()
    end)
  else
    item:set_finished()
  end
end

-- Initialize the metatable of appropriate entities to work with the fire.
local function initialize_meta()

  -- Add Lua fire properties to enemies.
  local enemy_meta = sol.main.get_metatable("enemy")
  if enemy_meta.get_fire_reaction ~= nil then
    -- Already done.
    return
  end

  enemy_meta.fire_reaction = 3  -- 3 life points by default.
  enemy_meta.fire_reaction_sprite = {}
  function enemy_meta:get_fire_reaction(sprite)

    if sprite ~= nil and self.fire_reaction_sprite[sprite] ~= nil then
      return self.fire_reaction_sprite[sprite]
    end
    return self.fire_reaction
  end

  function enemy_meta:set_fire_reaction(reaction, sprite)

    self.fire_reaction = reaction
  end

  function enemy_meta:set_fire_reaction_sprite(sprite, reaction)

    self.fire_reaction_sprite[sprite] = reaction
  end

  -- Change the default enemy:set_invincible() to also
  -- take into account the fire.
  local previous_set_invincible = enemy_meta.set_invincible
  function enemy_meta:set_invincible()
    previous_set_invincible(self)
    self:set_fire_reaction("ignored")
  end
  local previous_set_invincible_sprite = enemy_meta.set_invincible_sprite
  function enemy_meta:set_invincible_sprite(sprite)
    previous_set_invincible_sprite(self, sprite)
    self:set_fire_reaction_sprite(sprite, "ignored")
  end

end
initialize_meta()

item.is_magic = true
-- Check if the hero obtains a magic item to give the magic meter
local item_meta = sol.main.get_metatable("item")
item_meta:register_event("on_obtained", function(item)
  local magic_meter = item:get_game():get_item("equipment/magic_meter")
  if item.is_magic and not magic_meter:has_variant() then
    magic_meter:set_variant(1)
  end
end)