------------------------------
--
-- Custom carrying state that keep the entity alive when lifted, and then also events not registered from the entity script.
--
-- Start a lifting animation and the carrying state when it finished.
-- The carried entity must implement a entity:throw(direction) method.
--
-- Usage : 
-- local carrying_state = require("scripts/states/carrying.lua")
-- carrying_state.start(hero, carriable, carriable_sprite)
--
------------------------------

local carrying_state = {}

-- Start lifting.
function carrying_state.start(hero, carriable, carriable_sprite) -- Pass the carriable sprite to ensure it is the main one and not the back one.

  sol.audio.play_sound("lift")
  local game = carriable:get_game()
  local map = carriable:get_map()

  -- Function to set the main sprite animation if it exists.
  local function set_animation_if_exists(animation)
    if carriable_sprite:has_animation(animation) and carriable_sprite:get_animation(animation) ~= animation then
      carriable_sprite:set_animation(animation)
    end
  end

  -- Initialize.
  local x, y, layer = hero:get_position()
  adjust_direction = {
    [0] = function () x = x + 16 end,
    function () y = y - 16 end,
    function () x = x - 16 end,
    function () y = y + 16 end,
  }
  adjust_direction[hero:get_direction()]()
  carriable:set_position(x, y, layer + 1) -- Move on the superior layer to fix display issues with multi-layer objects on the map.
  hero:freeze()

  -- Lifting movement.
  local movement = carriable:get_movement()
  local lifting_trajectories = {
    [0] = {{0, 0}, {0, 0}, {-3, -6}, {-5, -6},  {-5, -4}},
    {{0, 0}, {0, 0}, {0, -1}, {0, -1}, {0, 0}},
    {{0, 0}, {0, 0}, {3, -6},  {5, -6}, {5, -4}},
    {{0, 0}, {0, 0}, {0, -10}, {0, -12}, {0, 0}}}
  if movement then
    movement:stop()
  end
  movement = sol.movement.create("pixel")
  movement:set_trajectory(lifting_trajectories[hero:get_direction()])
  movement:set_ignore_obstacles(true)
  movement:set_delay(100)
  movement:start(carriable_sprite)

  -- Start a custom carrying state when the lifting animation finished.
  hero:set_animation("lifting", function()

    local carrying_state = sol.state.create()
    carrying_state:set_can_interact(false)
    carrying_state:set_can_grab(false)
    carrying_state:set_can_push(false)

    -- Initilize carrying object and animations.
    function carrying_state:on_started()
      if game:is_command_pressed("right") or game:is_command_pressed("left") or game:is_command_pressed("up") or game:is_command_pressed("down") then
        hero:set_animation("carrying_walking")
        set_animation_if_exists("walking")
      else
        hero:set_animation("carrying_stopped")
        set_animation_if_exists("stopped")
      end
      carriable:set_direction(0)
      carriable_sprite:set_xy(0, -18)
    end

    -- Make carriable follow hero moves.
    function carrying_state:on_update()
      if hero:get_map() == carriable:get_map() then
        local x, y, layer = hero:get_position()
        carriable:set_position(x, y, layer + 1) -- Move on the superior layer to fix display issues with multi-layer objects on the map.
      end
    end

    -- Throw the carriable when the state finished, whatever the reason is.
    function carrying_state:on_finished()
      if hero:get_map() == carriable:get_map() then
        sol.audio.play_sound("throw")
        local x, y, layer = hero:get_position()
        carriable:set_position(x, y, layer)
        carriable:throw(hero:get_direction())
      end
    end

    function carrying_state:on_command_pressed(command)
      -- Throw the carriable on action command pressed.
      if command == "action"  then
        hero:unfreeze() -- Stop the carrying state.
      end
      -- Start walking animations on direction command pressed.
      if command == "right" or command == "left" or command == "up" or command == "down" then
        hero:set_animation("carrying_walking")
        set_animation_if_exists("walking")
      end
    end

    -- Start stopped animations if no direction command is pressed.
    function carrying_state:on_command_released(command)
      if not game:is_command_pressed("right") and not game:is_command_pressed("left") and not game:is_command_pressed("up") and not game:is_command_pressed("down") then
        hero:set_animation("carrying_stopped")
        set_animation_if_exists("stopped")
      end
      -- Workaround : Resynchronize carriable and hero sprites on direction command released. -- TODO check for sprite:synchronize()
      if command == "right" or command == "left" or command == "up" or command == "down" then
        carriable_sprite:set_frame(0)
        hero:get_sprite():set_frame(0)
      end
    end
    hero:start_state(carrying_state)
  end)
 
--  RAZDARAC AJOUT
--  function map:on_finished()
--    hero:unfreeze()
--  end
-- RAZDARAC FIN
end

return carrying_state
