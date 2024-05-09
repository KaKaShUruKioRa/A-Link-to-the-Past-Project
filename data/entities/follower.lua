-- Variable
local follower = ...
local game = follower:get_game()
local map = follower:get_map()
local sprite = follower:get_sprite()
local hero = game:get_hero()
local state = "following"
local movement

local hero_speed = hero:get_walking_speed()

-- Include scripts
require("scripts/multi_events")


local function follow_hero()

  movement = sol.movement.create("target")
  movement:set_speed(88)
  movement:set_ignore_obstacles(true)
  movement:start(follower)
  sprite:set_animation("walking")
  follower:set_state("following")

end

local function stop_walking()
  
  if follower:get_state() ~= "following" then
    return false
  end
  follower:stop_movement()
  movement = nil
  sprite:set_animation("stopped")
  follower:set_state("stopped")
    
end

-- Event called when the custom entity is initialized.
follower:register_event("on_created", function()
    
  follower:set_optimization_distance(0)
  follower:set_drawn_in_y_order(true)
  follower:set_traversable_by(true)
  follower:set_position(hero:get_position())
  follower:get_sprite():set_direction(hero:get_direction())
  follow_hero()

end)

follower:register_event("on_position_changed", function()

  if follower:get_state() == "following" and follower:is_very_close_to_hero() then
    stop_walking()
  end

end)

follower:register_event("on_movement_changed", function()

  local movement = follower:get_movement()
  if movement:get_speed() > 0 then
    sprite:set_direction(movement:get_direction4())
  end

end)

-- Get current follower state
function follower:get_state()

  return state
  
end

-- Set current follower state
-- following is default state
function follower:set_state(new_state)

  if new_state == nil then
    new_state = "following"
  end
  
  state = new_state
  
end

-- Check if follower is so closed to hero
function follower:is_very_close_to_hero()

  local distance = follower:get_distance(hero)
  return distance < 16
  
end

-- Launch timer on follower
sol.timer.start(follower, 10, function()


    if movement == nil and not follower:is_very_close_to_hero() then
      follow_hero()
    end


  if hero:get_state() == "stairs" then
    follower:set_position(hero:get_position())
    follower:set_drawn_in_y_order(false)

    sol.timer.start(500,function()
      if hero:get_state() == "stairs" then follower:set_visible(false) end
    end)
  elseif hero:get_state() == "jumping" then
    follower:set_position(hero:get_position())
  elseif hero:get_state() == "free" then
    follower:set_visible(true) follower:set_layer(hero:get_layer()) follower:set_drawn_in_y_order(true)
  end

  return true

end)