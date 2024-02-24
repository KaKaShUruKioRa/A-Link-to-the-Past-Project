local cannonball_manager = {}

local i = 0

-- cannonball_manager:create_cannons(map, prefix, initial_timer, cannons_numtime_stop, cannon_breed)
-- map : The map.
-- prefix : The prefix of the entities.
-- initial_timer : The value for sol.timer.start, it is used to adjust the firing frequency. If nil, it will take the value 1000 (or 5000 for big) by default.
-- cannons_numtime_stop : The number of times a cannon is fired before it pauses (mainly used to make way for the big_cannon). If nil, the canon will not pause.
-- cannon_breed : The "breed" of the cannon to summon. If nil, will take "traps/cannonball" by default.

function cannonball_manager:create_cannons(map, prefix, initial_timer, cannons_numtime_stop, cannon_breed)
  -- Random cannonballs.
  if cannon_breed == nil then cannon_breed = "traps/cannonball" end
  local cannons = {}
  for cannon in map:get_entities(prefix) do
    if cannon:get_type() == "custom_entity" then
      cannons[#cannons + 1] = cannon
    end
  end
  if #cannons == 0 then
    return
  end
  if initial_timer == nil then initial_timer = 1000 end
  sol.timer.start(map, initial_timer, function()
    local index = math.random(#cannons)
    local cannon = cannons[index]
    local x, y, layer = cannon:get_position()
    local hero = map:get_entity("hero")
    if hero:is_in_same_region(cannons[1]) then
      if cannons_numtime_stop ~= nil then
        if cannons_numtime_stop > 1 then
          i = i + 1
          if i == cannons_numtime_stop then
            i = 0
            return true
          end
        end
      end
      map:create_enemy{
        name = "cannonball",
        breed = cannon_breed,
        x = x,
        y = y,
        layer = layer,
        direction = cannon:get_direction(),
      }
      sol.audio.play_sound("cannonball")
    else
      if cannons_numtime_stop ~= nil then
        if cannons_numtime_stop > 1 then
          i = i + 1
          if i == cannons_numtime_stop then
            i = 0
          end
        end
      end
      map:remove_entities("cannonball")
    end
    return true  -- Repeat the timer.
  end)

end

return cannonball_manager