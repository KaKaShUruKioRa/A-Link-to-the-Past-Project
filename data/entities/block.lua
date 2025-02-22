-- Lua script of custom entity block.

local custom_block = ...
local game = custom_block:get_game()
local map = custom_block:get_map()

function custom_block:on_created()
  custom_block.cooldown_number = 20
  custom_block.on_cooldown = false

  custom_block:set_traversable_by("wall", false)
  custom_block:set_traversable_by("hero", false)
  custom_block:set_traversable_by("enemy", false)
  custom_block:set_traversable_by("npc", false)
  custom_block:set_traversable_by("block", false)
  custom_block:set_traversable_by("bomb", false)
  custom_block:set_traversable_by("arrow", false)
  custom_block:set_traversable_by("hookshot", false)
  custom_block:set_traversable_by("boomerang", false)
  custom_block:set_traversable_by("custom_entity", false)
  custom_block:set_drawn_in_y_order(true)
end

function custom_block:is_hookable()
  return true
end

-- Avoid loudy simultaneous sounds of Monster.
function custom_block:sound_play(sound_id)
  local map = custom_block:get_map()
  local hero = map:get_hero()
  if custom_block:get_distance(hero) < 500 and custom_block:is_in_same_region(hero) then
    if not map.block_sound_cooldown then
      if sol.main.resource_exists("sound", sound_id) then
        sol.audio.play_sound(sound_id)
      else
        print(sound_id .. " not exist.")
      end
      map.block_sound_cooldown = true
      sol.timer.start(map, 500, function()
        map.block_sound_cooldown = nil
      end)
    end
  end
end

function custom_block:check_if_on_switch(is_stopped)
  for switch in map:get_entities_by_type("switch") do
    if custom_block:overlaps(switch, "overlapping") then
      if not switch:is_locked() then
        if is_stopped then
          switch:set_activated(true)
          if switch.on_activated ~= nil then
            switch:on_activated()
          end
        else
          switch:set_activated(false)
          if switch.on_inactivated ~= nil then
            switch:on_inactivated()
          end
        end
      end
    end
  end
end

function custom_block:on_moving()

end

function custom_block:on_moved()

end

function custom_block:recall_collision(entity, other)
  if entity.on_cooldown then return end
  if other:get_type() == "hero" then
    -- check if hero is facing block
    local direction = other:get_direction4_to(entity)
    if direction == other:get_direction() then
      -- check if the hero pushes or pulls the block
      if other:get_state() == "pushing" or other:get_state() == "pulling" then
        -- reverse if the hero pulls the block otherwise change nothing
        if other:get_state() == "pulling" then direction = (direction+2)%4 end
        -- calculates the direction where the object and hero will move
        local move_x, move_y = 1, 0
        if direction == 1 then move_x, move_y = 0, -1
        elseif direction == 2 then move_x, move_y = -1, 0
        elseif direction == 3 then move_x, move_y = 0, 1
        end
        -- check if the block is not going towards an obstacle
        if not entity:test_obstacles(move_x, move_y) then
          -- check if the hero is not going towards an obstacle behind him
          if other:get_state() == "pulling" and other:test_obstacles(move_x, move_y) then
            return
          end
          entity:on_moving()
          entity:check_if_on_switch(false)
          -- set the block and hero positions
          local x_other, y_other, layer_other = other:get_position()
          other:set_position(x_other+move_x, y_other+move_y, layer_other)
          local x_entity, y_entity, layer_entity = entity:get_position()
          entity:set_position(x_entity+move_x, y_entity+move_y, layer_entity)
          -- check if the hero, by pushing the block, does not start to cross an obstacle for himself. If so, cancel the previous set position
          if other:get_state() == "pushing" and other:test_obstacles() then
            other:set_position(x_other, y_other, layer_other)
            entity:set_position(x_entity, y_entity, layer_entity)
            entity:check_if_on_switch(true)
            return
          end
          -- check if the block is not in an invisible wall that does not allow the crossing of blocks, if it is the case, cancel the previous set position
          for other_entity in map:get_entities_by_type("wall") do
            if other_entity:get_property("stops_blocks") ~= nil and other_entity:get_property("stops_blocks") == "true" then
              if entity:overlaps(other_entity, "overlapping") then
                other:set_position(x_other, y_other, layer_other)
                entity:set_position(x_entity, y_entity, layer_entity)
                entity:check_if_on_switch(true)
                return
              end
            end
          end
          -- the block and hero have passed all checks, set_positions can be kept, the block and hero have moved, the cooldown can be started.
          entity.on_cooldown = true
          entity:sound_play("hero_pushes")
          sol.timer.start(entity, entity.cooldown_number, function()
            entity:on_moved()
            entity.on_cooldown = false
            entity:check_if_on_switch(true)
          end)
        end
      end
    end
  end
end

custom_block:add_collision_test("touching", function(entity, other)
  custom_block:recall_collision(entity, other)
end)