----------------------------------
--
-- Undestructible destructible map entity, behaving the same way than build-in destructible except it bounces on obstacle reached instead of breaking.
-- A hit may happen when the entity reaches an obstacle or when the carriable sprite overlaps another entity sprite while the throw is running.
-- An entity can only be hit once in a throw, however the throw will still bonk on obstacles entites without triggering the hit behavior if already triggered.
-- 
-- Methods : carriable:throw(direction)
--
-- Events :  carriable:on_carrying()
--           carriable:on_thrown(direction)
--           carriable:on_bounce(num_bounce)
--           carriable:on_finish_throw()
--           carriable:on_hit(entity)
--           entity:on_hit_by_carriable(carriable)
--
-- Usage : 
-- local my_entity = ...
-- local carriable_behavior = require("entities/lib/carriable")
-- carriable_behavior.apply(my_entity, { --[[ Custom properties --]] } )
--
----------------------------------

local carriable_behavior = {}
local carrying_state = require("scripts/states/carrying.lua")

local default_properties = {

  bounce_distances = {80, 16, 4}, -- Distances for each bounce.
  bounce_durations = {400, 160, 70}, -- Duration for each bounce.
  bounce_heights = {nil, 4, 2}, -- Heights for each bounce. Nil means sprite position.
  bounce_sound = nil, -- Default id of the bouncing sound. Nil means no sound.
  respawn_delay = nil, -- Time before respawn when removed by bad grounds. Nil means no respawn.
  slowdown_ratio = 0.5, -- Speed and distance decrease ratio at each obstacle hit.
  is_bounding_box_collision_sensitive = true, -- Trigger a hit on bounding box collision.
  is_sprite_collision_sensitive = true, -- Trigger a hit on sprite collision.
  is_offensive = true -- True if the carriable has the offensive behavior on thrown, such as hitting enemies or crystals.
}

-- Returns true if there is at least one obstacle in given entities.
local function is_obstacle_in(entities)
  for _, entity in pairs(entities) do
    -- Workaround: No fucking way to get traversable entities, hardcode ones that will have a triggered behavior or have the on_hit_by_carriable event defined...
    local type = entity:get_type()
    if (type == "enemy" and entity:get_attack_consequence("thrown_item") ~= "ignored") or type == "crystal" or entity.on_hit_by_carriable then
      return true
    end
  end
  return false
end

-- Return the value if not nil, else return default.
local function get_existing(value, default)

  if value ~= nil then
    return value
  end
  return default
end

function carriable_behavior.apply(carriable, properties)

  local game = carriable:get_game()
  local map = carriable:get_map()
  local hero = map:get_hero()
  local sprite = carriable:get_sprite()
  local shadow = nil

  -- Add a shadow below the carriable, as an sub entity to not conflict with a possible collision test from outside.
  if not shadow then
    local x, y, layer = carriable:get_position()
    shadow = map:create_custom_entity({
      direction = 0,
      x = x,
      y = y,
      layer = layer,
      width = 0,
      height = 0,
      sprite = "entities/shadow"
    })
    shadow:set_weight(-1)
    shadow:set_traversable_by(true)
    shadow:set_drawn_in_y_order(false) -- Display the shadow as a flat entity.
    shadow:bring_to_back()

    -- Make the shadow not visible on lifted and carried.
    carriable:register_event("on_interaction", function(carriable)
      shadow:set_visible(false)
    end)
    carriable:register_event("on_thrown", function(carriable, direction)
      shadow:set_visible(true)
    end)

    -- Propagate a few carriable events to the shadow.
    carriable:register_event("on_position_changed", function(carriable, x, y, layer)
      shadow:set_position(x, y, layer)
    end)
    carriable:register_event("on_removed", function(carriable)
      if shadow:exists() then
        shadow:remove()
      end
    end)
    carriable:register_event("on_enabled", function(carriable)
      shadow:set_enabled()
    end)
    carriable:register_event("on_disabled", function(carriable)
      shadow:set_enabled(false)
    end)
    carriable:register_event("set_visible", function(carriable, visible)
      shadow:set_visible(visible)
    end)
  end

  -- Function to set the main sprite animation if it exists.
  local function set_animation_if_exists(animation)
    if sprite:has_animation(animation) and sprite:get_animation(animation) ~= animation then
      sprite:set_animation(animation)
    end
  end

  -- Function to call hit events, the entity parameter may be nil.
  local function call_hit_events(entity)
    if entity and entity.on_hit_by_carriable then
      entity:on_hit_by_carriable(carriable)
    end
    if carriable.on_hit then
      carriable:on_hit(entity)
    end
  end

  -- Throwing method, define behavior for the thrown carriable.
  carriable:register_event("throw", function(carriable, direction)

    -- Properties.
    local bounce_distances = properties.bounce_distances or default_properties.bounce_distances
    local bounce_durations = properties.bounce_durations or default_properties.bounce_durations
    local bounce_heights = properties.bounce_heights or default_properties.bounce_heights
    local bounce_sound = properties.bounce_sound or default_properties.bounce_sound
    local respawn_delay = properties.respawn_delay or default_properties.respawn_delay
    local slowdown_ratio = properties.slowdown_ratio or default_properties.slowdown_ratio
    local is_bounding_box_collision_sensitive = get_existing(properties.is_bounding_box_collision_sensitive, default_properties.is_bounding_box_collision_sensitive)
    local is_sprite_collision_sensitive = get_existing(properties.is_sprite_collision_sensitive, default_properties.is_sprite_collision_sensitive)
    local is_offensive = get_existing(properties.is_offensive, default_properties.is_offensive)

    -- Initialize throwing state.
    local num_bounces = #bounce_distances
    local current_bounce = 1
    local current_instant = 0
    local is_bounce_movement_starting = true -- True when the carriable is not moving, but about to.
    local dx, dy = math.cos(direction * math.pi / 2), -math.sin(direction * math.pi / 2)
    local _, hero_height = map:get_entity("hero"):get_size()
    local unhittable_entities = {}

    carriable:set_direction(direction)
    carriable:bring_to_back() -- Workaround : Ensure the created destructible is under a possible invisible entity such as lights, to let it liftable again after thrown.
    sprite:set_xy(0, -hero_height - 6)
    set_animation_if_exists("thrown")

    -- Callback function for bad ground bounce.
    -- Remove the carriable and respawn it after a delay if the property is set.
    local function on_bad_ground_bounce()
      local initial_properties = {
        name = carriable:get_name(), model = carriable:get_model(), properties = carriable:get_properties(),
        x = carriable.respawn_position.x, y = carriable.respawn_position.y, layer = carriable.respawn_position.layer, 
        direction = carriable:get_direction(), sprite = sprite:get_animation_set(),
        width = 16, height = 16}
      carriable:remove()
      if respawn_delay then
        sol.timer.start(map, respawn_delay, function()
          map:create_custom_entity(initial_properties)
        end)
      end
    end

    -- Return true if the entity is not already hit during this throw.
    local function is_hittable(entity)
      for _, unhittable_entity in pairs(unhittable_entities) do
        if unhittable_entity == entity then
          return false
        end
      end
      return true
    end

    -- Simulate the movement that hasn't been commited and return a table with bounding box overlapping entities.
    -- Workaround function to know what is obstacle entities reached during movement:on_obstacle_reached()
    local function get_overlapping_entities_on_obstacle_reached(movement)
      local overlapping_entities = {}
      local speed = movement:get_speed()
      local angle = movement:get_angle()
      local movement_x = speed / 100 * math.cos(angle)
      local movement_y = speed / 100 * math.sin(angle)
      local x, y, width, height = carriable:get_max_bounding_box()
      for entity in map:get_entities_in_rectangle(x + movement_x, y + movement_y, width, height) do
        if entity ~= carriable and is_hittable(entity) then
          table.insert(overlapping_entities, entity)
        end
      end
      return overlapping_entities
    end

    -- Returns entites the have a sprite or bounding box collision with the carriable.
    local function get_overlapping_entities()
      local overlapping_entities = {}
      for entity in map:get_entities_in_region(carriable) do
        local is_bounding_box_collision = is_bounding_box_collision_sensitive and carriable:overlaps(entity)
        local is_sprite_collision = is_sprite_collision_sensitive and carriable:overlaps(entity, "sprite")
        if entity ~= carriable and is_hittable(entity) and (is_bounding_box_collision or is_sprite_collision) then
          table.insert(overlapping_entities, entity)
        end
      end
      return overlapping_entities
    end

    -- Reverse throwing direction and slow down all bounces including the current movement.
    local function reverse_direction(slowdown_ratio)
      local movement = carriable:get_movement()
      direction = (direction + 2) % 4
      if movement then 
        local slowed_distances = {} -- New table to not override default properties.
        movement:set_angle(movement:get_angle() + math.pi)
        movement:set_max_distance(movement:get_max_distance() * slowdown_ratio)
        movement:set_speed(movement:get_speed() * slowdown_ratio)
        for _, distance in ipairs(bounce_distances) do
          table.insert(slowed_distances, math.floor(distance * slowdown_ratio))
        end
        bounce_distances = slowed_distances
      end
    end

    -- Trigger hit entities behavior.
    local function hit(entities)
      for _, entity in pairs(entities) do
        if entity and entity:is_enabled() then
          table.insert(unhittable_entities, entity) -- Avoid the entity being hit twice a throw.

          if is_offensive then
            if entity:get_type() == "enemy" then
              entity:receive_attack_consequence("thrown_item", entity:get_attack_consequence("thrown_item"))
            elseif entity:get_type() == "crystal" then
              map:set_crystal_state(not map:get_crystal_state())
            end
          end

          call_hit_events(entity)
        end
      end
    end

    -- Function called when the carriable has fallen.
    local function finish_bounce()
      carriable:stop_movement()
      carriable:set_follow_streams(false) -- true
      set_animation_if_exists("stopped")
      if carriable.on_finish_throw then
        carriable:on_finish_throw() -- Call event
      end
    end

    -- Function to bounce when carriable is thrown.
    local function bounce()

      -- Finish bouncing if we have already done them all.
      if current_bounce > num_bounces then 
        finish_bounce()    
        return
      end  

      -- Initialize parameters for the bounce.
      local _, sy = sprite:get_xy()
      local t = current_instant
      local dist = bounce_distances[current_bounce]
      local dur = bounce_durations[current_bounce] 
      local h = bounce_heights[current_bounce] or -sy
      local speed = 1000 * dist / dur
      
      -- Function to compute height for each fall (bounce).
      local function current_height()
        local progress = t / dur
        if current_bounce == 1 then
          return 2 * h * (progress ^ 2 - progress) - (h * (1.0 - progress))
        end
        return 4 * h * (progress ^ 2 - progress)
      end

      -- Start this bounce movement if the previous one ended normally or if the carriable is still moving.
      if is_bounce_movement_starting or carriable:get_movement() then
        local movement = sol.movement.create("straight")
        movement:set_angle(direction * math.pi / 2)
        movement:set_speed(speed)
        movement:set_max_distance(dist)
        movement:set_smooth(false)
        function movement:on_finished()
          is_bounce_movement_starting = true -- The movement ended without being stopped by an obstacle or from another script.
        end
        -- Hit on obstacle reached or sprite collision.
        function movement:on_obstacle_reached()
          local entities = get_overlapping_entities_on_obstacle_reached(movement)
          reverse_direction(slowdown_ratio)
          if #entities > 0 then
            hit(entities)
          else 
            call_hit_events(nil) -- Call hit events even if the obstacle is not an entity.
          end
        end
        function movement:on_position_changed(x, y, layer)
          local entities = get_overlapping_entities()
          if #entities > 0 then
            if is_offensive and is_obstacle_in(entities) then -- Only reverse the move if at least one entity is an obstacle.
              reverse_direction(slowdown_ratio)
              hit(entities)
            end
          end
        end
        carriable:set_follow_streams(false)
        is_bounce_movement_starting = false
        movement:start(carriable)
      end

      -- Start shifting height of the carriable at each instant for current bounce.
      local refreshing_time = 5 -- Time between computations of each position.
      sol.timer.start(carriable, refreshing_time, function()
        t = t + refreshing_time
        current_instant = t
        -- Update shift of sprite.
        if t <= dur then 
          sprite:set_xy(0, current_height())
        -- Stop the timer. Start next bounce or finish bounces. 
        else -- The carriable hits the ground.
          sol.audio.play_sound(bounce_sound)
          --map:ground_collision(carriable, bounce_sound, on_bad_ground_bounce)
          -- Check if the carriable still exists.
          if carriable:exists() then
            if carriable.on_bounce then
              carriable:on_bounce(current_bounce) -- Call event
            end
            current_bounce = current_bounce + 1
            current_instant = 0
            bounce() -- Start next bounce.
          end
          return false
        end
        return true
      end)
    end

    if carriable.on_thrown then
      carriable:on_thrown() -- Call event
    end

    -- Start the first bounce if the carriable is not immediately removed from outside.
    if carriable:exists() then
      bounce()
    end
  end)

  -- Apply default properties before a possible on_created event is called.
  local x, y, layer = carriable:get_position()
  carriable.respawn_position = {x = x, y = y, layer = layer}
  carriable:set_follow_streams(false) -- true
  carriable:set_drawn_in_y_order()
  carriable:set_weight(0)
  carriable:bring_to_back() -- Workaround : Ensure the created destructible is under a possible invisible entity such as lights, to let it liftable.
  set_animation_if_exists("stopped")

  carriable:set_traversable_by(true)
  carriable:set_can_traverse_ground("deep_water", true)
  carriable:set_can_traverse_ground("grass", true)
  carriable:set_can_traverse_ground("hole", true)
  carriable:set_can_traverse_ground("lava", true)
  carriable:set_can_traverse_ground("low_wall", true)
  carriable:set_can_traverse_ground("prickles", true)
  carriable:set_can_traverse_ground("shallow_water", true)
  carriable:set_can_traverse(true) -- No way to get traversable entities later, make them all traversable.

  -- Start a custom lifting on interaction to not destroy the carriable and keep events registered outside the entity script alive.
  carriable:register_event("on_interaction", function(carriable)
    if game:get_ability("lift") >= carriable:get_weight() and carriable:get_weight() ~= -1 then
      carrying_state.start(hero, carriable, sprite)
      if carriable.on_carrying then
        carriable:on_carrying() -- Call event
      end
    end
  end)
end

return carriable_behavior