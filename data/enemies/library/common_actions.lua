----------------------------------
--
-- Add some basic and common methods/events to an enemy.
-- There is no passive behavior without an explicit start when learning this to an enemy.
--
-- Methods : enemy:is_near(entity, triggering_distance, [sprite])
--           enemy:is_aligned(entity, thickness, [sprite])
--           enemy:is_leashed_by(entity)
--           enemy:is_sprite_contained(sprite, x, y, width, height)
--           enemy:get_angle_from_sprite(sprite, entity)
--           enemy:get_central_symmetry_position(x, y)
--
--           enemy:start_straight_walking(angle, speed, [distance, [on_stopped_callback]])
--           enemy:start_target_walking(entity, speed)
--           enemy:start_jumping(duration, height, [angle, speed, [on_finished_callback]])
--           enemy:start_flying(take_off_duration, height, [on_finished_callback])
--           enemy:stop_flying(landing_duration, [on_finished_callback])
--           enemy:start_attracting(entity, speed, [moving_condition_callback])
--           enemy:stop_attracting()
--           enemy:start_welding(entity, [x_offset, [y_offset]])
--           enemy:start_leashed_by(entity, maximum_distance)
--           enemy:stop_leashed_by(entity)
--           enemy:start_pushed_back(entity, [speed, [duration, [on_finished_callback]]])
--           enemy:start_pushing_back(entity, [speed, [duration, [on_finished_callback]]])
--
--           enemy:start_shadow([sprite_name, [animation_set_id]])
--           enemy:start_brief_effect(sprite_name, [animation_set_id, [x_offset, [y_offset, [maximum_duration, [on_finished_callback]]]]])
--           enemy:steal_item(item_name, [variant, [only_if_assigned, [drop_when_dead]]])
--
-- Events:   enemy:on_jump_finished()
--           enemy:on_flying_took_off()
--           enemy:on_flying_landed()
--
-- Usage : 
-- local my_enemy = ...
-- local common_actions = require("enemies/lib/common_actions")
-- common_actions.learn(my_enemy)
--
----------------------------------

local common_actions = {}

function common_actions.learn(enemy)

  local game = enemy:get_game()
  local map = enemy:get_map()
  local hero = map:get_hero()
  local trigonometric_functions = {math.cos, math.sin}
  local circle = 2.0 * math.pi
  local quarter = 0.5 * math.pi
  local eighth = 0.25 * math.pi

  local attracting_timers = {}
  local leashing_timers = {}
  local shadow = nil
  
  -- Return true if the entity is closer to the enemy than triggering_distance
  function enemy:is_near(entity, triggering_distance, sprite)

    local entity_layer = entity:get_layer()
    local x, y, layer = enemy:get_position()
    local x_offset, y_offset = 0, 0
    if sprite then
      x_offset, y_offset = sprite:get_xy()
    end

    return entity:get_distance(x + x_offset, y + y_offset) < triggering_distance 
      and (layer == entity_layer or enemy:has_layer_independent_collisions())
  end

  -- Return true if the entity is on the same row or column than the entity.
  function enemy:is_aligned(entity, thickness, sprite)

    local half_thickness = thickness * 0.5
    local entity_x, entity_y, entity_layer = entity:get_position()
    local x, y, layer = enemy:get_position()
    local x_offset, y_offset = 0, 0
    if sprite then
      x_offset, y_offset = sprite:get_xy()
    end

    return (math.abs(entity_x - x - x_offset) < half_thickness or math.abs(entity_y - y - y_offset) < half_thickness) and layer == entity_layer
  end

  -- Return true if the enemy is currently leashed by the entity.
  function enemy:is_leashed_by(entity)
    return leashing_timers[entity] ~= nil
  end

  -- Return true if the sprite is fully inside the given rectangle.
  function enemy:is_sprite_contained(sprite, x, y, width, height)

    local enemy_x, enemy_y, _ = enemy:get_position()
    local sprite_x, sprite_y = sprite:get_xy()
    local sprite_width, sprite_height = sprite:get_size()
    local origin_x, origin_y = sprite:get_origin()
    local sprite_absolute_x = sprite_x - origin_x + enemy_x
    local sprite_absolute_y = sprite_y - origin_y + enemy_y

    return sprite_absolute_x >= x and sprite_absolute_x + sprite_width <= x + width 
        and sprite_absolute_y >= y and sprite_absolute_y + sprite_height <= y + height 
  end

  -- Return the angle from the enemy sprite to given entity.
  function enemy:get_angle_from_sprite(sprite, entity)

    local x, y, _ = enemy:get_position()
    local sprite_x, sprite_y = sprite:get_xy()
    local entity_x, entity_y, _ = entity:get_position()

    return math.atan2(y - entity_y + sprite_y, entity_x - x - sprite_x)
  end

  -- Return the central symmetry position over the given point.
  function enemy:get_central_symmetry_position(x, y)

    local enemy_x, enemy_y, _ = enemy:get_position()
    return 2.0 * x - enemy_x, 2.0 * y - enemy_y
  end

  -- Return the normal angle of close obstacles as a multiple of pi/4, or nil if none.
  function enemy:get_obstacles_normal_angle(angle)

    local collisions = {
      [0] = enemy:test_obstacles( 1,  0),
      [1] = enemy:test_obstacles( 1, -1),
      [2] = enemy:test_obstacles( 0, -1),
      [3] = enemy:test_obstacles(-1, -1),
      [4] = enemy:test_obstacles(-1,  0),
      [5] = enemy:test_obstacles(-1,  1),
      [6] = enemy:test_obstacles( 0,  1),
      [7] = enemy:test_obstacles( 1,  1)
    }

    -- Return the normal angle for the given direction8 if there is an obstacle on the direction, and not on the two surrounding ones if direction is a diagonal.
    local function check_normal_angle(direction8)
      return collisions[direction8] and (direction8 % 2 == 0 or not collisions[(direction8 - 1) % 8] and not collisions[(direction8 + 1) % 8])
    end

    -- Check for obstacles on each direction8 and return the normal angle if it is the correct one.
    for direction8 = 0, 7 do
      if math.cos(angle - direction8 * eighth) > math.cos(quarter) and check_normal_angle(direction8) then
        return (direction8 * eighth + math.pi) % circle
      end
    end
  end

  -- Return the angle after bouncing against close obstacles towards the given angle, or nil if no obstacles.
  function enemy:get_obstacles_bounce_angle(angle)

    local normal_angle = enemy:get_obstacles_normal_angle(angle)
    return (2.0 * normal_angle - angle + math.pi) % circle
  end

  -- Make the enemy straight move.
  function enemy:start_straight_walking(angle, speed, distance, on_stopped_callback)

    local movement = sol.movement.create("straight")
    movement:set_speed(speed)
    movement:set_max_distance(distance or 0)
    movement:set_angle(angle)
    movement:set_smooth(true)
    movement:start(self)

    -- Consider the current move as stopped if finished or stuck.
    function movement:on_finished()
      if on_stopped_callback then
        on_stopped_callback()
      end
    end
    function movement:on_obstacle_reached()
      movement:stop()
      if on_stopped_callback then
        on_stopped_callback()
      end
    end

    -- Update the enemy sprites.
    for _, sprite in enemy:get_sprites() do
      if sprite:has_animation("walking") then
        sprite:set_animation("walking")
      end
      sprite:set_direction(movement:get_direction4())
    end

    return movement
  end

  -- Make the enemy move to the entity.
  function enemy:start_target_walking(entity, speed)

    local movement = sol.movement.create("target")
    movement:set_speed(speed)
    movement:set_target(entity)
    movement:start(enemy)

    -- Update enemy sprites.
    local direction = movement:get_direction4()
    for _, sprite in enemy:get_sprites() do
      if sprite:has_animation("walking") then
        sprite:set_animation("walking")
      end
      sprite:set_direction(direction)
    end
    function movement:on_position_changed()
      if movement:get_direction4() ~= direction then
        direction = movement:get_direction4()
        for _, sprite in enemy:get_sprites() do
          sprite:set_direction(direction)
        end
      end
    end

    return movement
  end

  -- Make the enemy start jumping.
  function enemy:start_jumping(duration, height, angle, speed, on_finished_callback)

    -- Update the sprite vertical offset at each frame.
    local elapsed_time = 0

    local function update_sprite_height()
      if elapsed_time < duration then
        for _, sprite in enemy:get_sprites() do
          sprite:set_xy(0, -math.sqrt(math.sin(elapsed_time / duration * math.pi)) * height)
        end
        sol.timer.start(enemy, 10, function()
          if game:is_suspended() then
            return 10
          end
          if enemy:exists() and enemy:is_enabled() then
            elapsed_time = elapsed_time + 10
            update_sprite_height()
          end
        end)
      else
        for _, sprite in enemy:get_sprites() do
          sprite:set_xy(0, 0)
        end

        -- Call events once jump finished.
        if on_finished_callback then
          on_finished_callback()
        end
        if enemy.on_jump_finished then
          enemy:on_jump_finished()
        end
      end
    end
    update_sprite_height()

    -- Move the enemy on-floor if requested.
    if angle then
      local movement = sol.movement.create("straight")
      movement:set_speed(speed)
      movement:set_angle(angle)
      movement:set_max_distance(speed * duration * 0.001)
      movement:set_smooth(false)
      movement:start(enemy)
    
      return movement
    end
  end

  -- Make the enemy start flying.
  function enemy:start_flying(take_off_duration, height, on_finished_callback)

    -- Make enemy sprites start elevating.
    local event_called = false
    for _, sprite in enemy:get_sprites() do
      local movement = sol.movement.create("straight")
      movement:set_speed(height * 1000 / take_off_duration)
      movement:set_max_distance(height)
      movement:set_angle(math.pi * 0.5)
      movement:set_ignore_obstacles(true)
      movement:start(sprite)

      -- Call events once take off finished.
      if not event_called then
        event_called = true
        function movement:on_finished()
          if on_finished_callback then
            on_finished_callback()
          end
          if enemy.on_flying_took_off then
            enemy:on_flying_took_off()
          end
        end
      end
    end
  end

  -- Make the enemy stop flying.
  function enemy:stop_flying(landing_duration, on_finished_callback)

    -- Make the enemy sprites start landing.
    local event_called = false
    for _, sprite in enemy:get_sprites() do
      local _, height = sprite:get_xy()
      height = math.abs(height)

      local movement = sol.movement.create("straight")
      movement:set_speed(height * 1000 / landing_duration)
      movement:set_max_distance(height)
      movement:set_angle(-math.pi * 0.5)
      movement:set_ignore_obstacles(true)
      movement:start(sprite)

      -- Call events once landed finished.
      if not event_called then
        event_called = true
        function movement:on_finished()
          if on_finished_callback then
            on_finished_callback()
          end
          if enemy.on_flying_landed then
            enemy:on_flying_landed()
          end
        end
      end
    end
  end

  -- Start attracting the given entity, negative speed possible.
  function enemy:start_attracting(entity, speed, moving_condition_callback)

    local move_ratio = speed > 0 and 1 or -1
    attracting_timers[entity] = {}

    local function attract_on_axis(axis)

      local entity_position = {entity:get_position()}
      local enemy_position = {enemy:get_position()}
      local angle = math.atan2(entity_position[2] - enemy_position[2], enemy_position[1] - entity_position[1])
      
      local axis_move = {0, 0}
      local axis_move_delay = 10 -- Default timer delay if no move

      if not moving_condition_callback or moving_condition_callback() then

        -- Always move pixel by pixel.
        axis_move[axis] = math.max(-1, math.min(1, enemy_position[axis] - entity_position[axis])) * move_ratio
        if axis_move[axis] ~= 0 then

          -- Schedule the next move on this axis depending on the remaining distance and the speed value, avoiding too high and low timers.
          axis_move_delay = 1000.0 / math.max(1, math.min(100, math.abs(speed * trigonometric_functions[axis](angle))))

          -- Move the entity.
          if not entity:test_obstacles(axis_move[1], axis_move[2]) then
            entity:set_position(entity_position[1] + axis_move[1], entity_position[2] + axis_move[2], entity_position[3])
          end
        end
      end

      -- Start the next move timer.
      attracting_timers[entity][axis] = sol.timer.start(enemy, axis_move_delay, function()
        if game:is_suspended() then
          return 10
        end
        if enemy:exists() and enemy:is_enabled() then
          attract_on_axis(axis)
        end
      end)
    end

    attract_on_axis(1)
    attract_on_axis(2)
  end

  -- Stop looped timers related to the attractions.
  function enemy:stop_attracting()

    for _, timers in pairs(attracting_timers) do
      if timers then
        for i = 1, 2 do
          if timers[i] then
            timers[i]:stop()
          end
        end
      end
    end
  end

  -- Make the entity welded to the enemy at the given offset position, and propagate main events and methods.
  function enemy:start_welding(entity, x_offset, y_offset)

    enemy:register_event("on_position_changed", function(enemy, x, y, layer)
      entity:set_position(x + (x_offset or 0), y + (y_offset or 0))
    end)
    enemy:register_event("on_removed", function(enemy)
      entity:remove()
    end)
    enemy:register_event("on_enabled", function(enemy)
      entity:set_enabled()
    end)
    enemy:register_event("on_disabled", function(enemy)
      entity:set_enabled(false)
    end)
    enemy:register_event("on_dying", function(enemy)
      sol.timer.start(entity, 300, function() -- No event when the enemy became invisible, hardcode a timer.
        entity:set_enabled(false)
      end)
    end)
    enemy:register_event("set_visible", function(enemy, visible)
      entity:set_visible(visible)
    end)
  end

  -- Set a maximum distance between the enemy and an entity, else replace the enemy near it.
  function enemy:start_leashed_by(entity, maximum_distance)

    leashing_timers[entity] = nil

    local function leashing(entity, maximum_distance)

      if enemy:get_distance(entity) > maximum_distance then
        local enemy_x, enemy_y, layer = enemy:get_position()
        local hero_x, hero_y, _ = hero:get_position()
        local vX = enemy_x - hero_x;
        local vY = enemy_y - hero_y;
        local magV = math.sqrt(vX * vX + vY * vY);
        local x = hero_x + vX / magV * maximum_distance;
        local y = hero_y + vY / magV * maximum_distance;

        -- Move the entity.
        if not enemy:test_obstacles(x - enemy_x, y - enemy_y) then
          enemy:set_position(x, y, layer)
        end
      end

      leashing_timers[entity] = sol.timer.start(enemy, 10, function()
        if game:is_suspended() then
          return 10
        end
        if enemy:exists() and enemy:is_enabled() then
          leashing(entity, maximum_distance)
        end
      end)
    end
    leashing(entity, maximum_distance)
  end

  -- Stop the leashing attraction on the given entity
  function enemy:stop_leashed_by(entity)
    if leashing_timers[entity] then
      leashing_timers[entity]:stop()
      leashing_timers[entity] = nil
    end
  end

  -- Start pushing back the enemy.
  function enemy:start_pushed_back(entity, speed, duration, on_finished_callback)

    local movement = sol.movement.create("straight")
    movement:set_speed(speed or 100)
    movement:set_angle(entity:get_angle(enemy))
    movement:set_smooth(false)
    movement:start(enemy)

    sol.timer.start(enemy, duration or 150, function()
      movement:stop()
      if on_finished_callback then
        on_finished_callback()
      end
    end)
  end

  -- Start pushing the entity back, not using the built-in movement to not stop a possible running movement.
  function enemy:start_pushing_back(entity, speed, duration, sprite, entity_sprite, on_finished_callback)

    speed = speed or 150
    duration = duration or 100
    sprite = sprite or enemy:get_sprite()
    entity_sprite = entity_sprite or entity:get_sprite()

    -- Take the enemy and entity sprite positions as reference for the angle instead of the global enemy and entity positions.
    local enemy_x, enemy_y = enemy:get_position()
    local offset_x, offset_y = sprite:get_xy()
    local entity_x, entity_y = entity:get_position()
    local entity_offset_x, entity_offset_y = entity_sprite:get_xy()
    enemy_x = enemy_x + offset_x
    enemy_y = enemy_y + offset_y
    entity_x = entity_x + entity_offset_x
    entity_y = entity_y + entity_offset_y

    local angle = math.atan2(enemy_y - entity_y, entity_x - enemy_x)
    local step_axis = {math.max(-1, math.min(1, entity_x - enemy_x)), math.max(-1, math.min(1, entity_y - enemy_y))}

    local function attract_on_axis(axis)

      -- Clean the timer if the entity was removed from outside.
      if not entity:exists() then
        return
      end
      
      local axis_move = {0, 0}
      local axis_move_delay = 10 -- Default timer delay if no move
      entity_x, entity_y = entity:get_position()

      -- Always move pixel by pixel.
      axis_move[axis] = step_axis[axis]
      if axis_move[axis] ~= 0 then

        -- Schedule the next move on this axis depending on the remaining distance and the speed value, avoiding too high and low timers.
        axis_move_delay = 1000.0 / math.max(1, math.min(1000, math.abs(speed * trigonometric_functions[axis](angle))))

        -- Move the entity.
        if not entity:test_obstacles(axis_move[1], axis_move[2]) then
          entity:set_position(entity_x + axis_move[1], entity_y + axis_move[2])
        end
      end

      return axis_move_delay
    end

    -- Start the pixel move schedule.
    local timers = {}
    for i = 1, 2 do
      local initial_delay = attract_on_axis(i)
      if initial_delay then
        timers[i] = sol.timer.start(entity, initial_delay, function()
          return attract_on_axis(i)
        end)
      end
    end

    -- Schedule the end of the push.
    sol.timer.start(entity, duration, function()
      for i = 1, 2 do
        if timers[i] then
          timers[i]:stop()
        end
      end
      if on_finished_callback then
        on_finished_callback()
      end
    end)
  end

  -- Add a shadow below the enemy.
  function enemy:start_shadow(sprite_name, animation_set_id)

    if not shadow then
      local enemy_x, enemy_y, enemy_layer = enemy:get_position()
      shadow = map:create_custom_entity({
        direction = 0,
        x = enemy_x,
        y = enemy_y,
        layer = enemy_layer,
        width = 16,
        height = 16,
        sprite = sprite_name or "entities/shadows/shadow"
      })
      enemy:start_welding(shadow)

      if animation_set_id then
        shadow:get_sprite():set_animation(animation_set_id)
      end
      shadow:set_traversable_by(true)
      --TODO Always display the shadow on the lowest possible layer
    end
    return shadow
  end

  -- Start a standalone sprite animation on the enemy position, that will be removed once finished or maximum_duration reached if given.
  function enemy:start_brief_effect(sprite_name, animation_set_id, x_offset, y_offset, maximum_duration, on_finished_callback)

    local x, y, layer = enemy:get_position()
    local entity = map:create_custom_entity({
        sprite = sprite_name,
        x = x + (x_offset or 0),
        y = y + (y_offset or 0),
        layer = layer,
        width = 80,
        height = 32,
        direction = 0
    })

    -- Remove the entity once animation finished or max_duration reached.
    local function on_finished()
      if on_finished_callback then
        on_finished_callback()
      end
      entity:remove()
    end
    local sprite = entity:get_sprite()
    sprite:set_animation(animation_set_id, function()
      on_finished()
    end)
    if maximum_duration then
      sol.timer.start(entity, maximum_duration, function()
        on_finished()
      end)
    end
  end

  -- Steal an item and drop it when died, possibly conditionned on the variant and the assignation to a slot.
  function enemy:steal_item(item_name, variant, only_if_assigned, drop_when_dead)

    if game:has_item(item_name) then
      local item = game:get_item(item_name)
      local is_stealable = not only_if_assigned or (game:get_item_assigned(1) == item and 1) or (game:get_item_assigned(2) == item and 2)

      if (not variant or item:get_variant() == variant) and is_stealable then 
        if drop_when_dead then
          enemy:set_treasure(item_name, item:get_variant()) -- TODO savegame variable
        end
        item:set_variant(0)
        if item_slot then
          game:set_item_assigned(item_slot, nil)
        end
      end
    end
  end
end

return common_actions