local cannonball_manager = {}

local i = 0

function cannonball_manager:create_cannons(map, prefix)

  -- Random cannonballs.
  local cannons = {}
  for cannon in map:get_entities(prefix) do
    if cannon:get_type() == "custom_entity" then
      cannons[#cannons + 1] = cannon
    end
  end
  if #cannons == 0 then
    return
  end
  sol.timer.start(map, 1000, function()

    local hero = map:get_entity("hero")
    if hero:is_in_same_region(cannons[1]) then
      i = i + 1
      if i == 5 then
        i = 0
      else
        local index = math.random(#cannons)
        local cannon = cannons[index]
        local x, y, layer = cannon:get_position()
        map:create_enemy{
          name = "cannonball",
          breed = "traps/cannonball",
          x = x,
          y = y,
          layer = layer,
          direction = cannon:get_direction(),
        }
        sol.audio.play_sound("cannonball")
      end
    else
      i = i + 1
      if i == 5 then i = 0 end
      map:remove_entities("cannonball")
    end

    return true  -- Repeat the timer.
  end)

end

function cannonball_manager:create_big_cannons(map, prefix)

  -- Random cannonballs.
  local cannons = {}
  for cannon in map:get_entities(prefix) do
    if cannon:get_type() == "custom_entity" then
      cannons[#cannons + 1] = cannon
    end
  end
  if #cannons == 0 then
    return
  end
  sol.timer.start(map, 5000, function()

    local hero = map:get_entity("hero")
    if hero:is_in_same_region(cannons[1]) then
      local index = math.random(#cannons)
      local cannon = cannons[index]
      local x, y, layer = cannon:get_position()
      map:create_enemy{
        name = "cannonball_big",
        breed = "traps/cannonball_big",
        x = x,
        y = y,
        layer = layer,
        direction = cannon:get_direction(),
      }
      sol.audio.play_sound("cannonball")
    else
      map:remove_entities("cannonball")
    end
    return true  -- Repeat the timer.
  end)

end

return cannonball_manager