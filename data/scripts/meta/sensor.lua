-- Initialize sensor behavior specific to this quest.

require("scripts/multi_events")

local sensor_meta = sol.main.get_metatable("sensor")

-- sensor_meta represents the default behavior of all sensors.
function sensor_meta:on_activated()
  -- self is the sensor.
  local hero = self:get_map():get_hero()
  local game = self:get_game()
  local map = self:get_map()
  local name = self:get_name()

  -- Sensors prefixed by "save_solid_ground_sensor" are where the hero come back
  -- when falling into a hole or other bad ground.
  if name:match("^save_solid_ground_sensor") then
    hero:save_solid_ground()
    return
  end
  -- Sensors prefixed by "reset_solid_ground_sensor" clear any place for the hero
  -- to come back when falling into a hole or other bad ground.
  if name:match("^reset_solid_ground_sensor") then
    hero:reset_solid_ground()
    return
  end

  -- Sensors prefixed by "dungeon_room_N" save the exploration state of the
  -- room "N" of the current dungeon floor.
  local room = name:match("^dungeon_room_(%d+)")
  if room ~= nil then
    game:set_explored_dungeon_room(nil, nil, tonumber(room))
    self:remove()
    return
  end

  --Prise en compte des layers et escaliers
  if name:match("^layer_up_sensor") then
    local x, y, layer = hero:get_position()
    if layer < map:get_max_layer() then
      hero:set_position(x, y, layer + 1)
    end
    return
  elseif name:match("^layer_down_sensor") then
    local x, y, layer = hero:get_position()
    if layer > map:get_min_layer() then
      hero:set_position(x, y, layer - 1)
    end
    return
  end

  --Sensors qui ferment les portes derrière nous (définitives (ex:passage sens unique) ou temporaire (ex:combat))
  local j = 0
  while j ~= 9 do
    j = j + 1
    if name:match("^sensor_falling_auto_door_"..j.."_e_open") then
      local prefix = j
      local x, y, layer = hero:get_position()
      map:open_doors("auto_door_"..prefix)
      hero:freeze()
      hero:set_animation("walking")
      hero:set_direction(0)
      local movement = sol.movement.create("straight")
      movement:set_speed(88)
      local angle = 0
      movement:set_angle(angle)
      if layer == 1 then movement:set_max_distance(56) else movement:set_max_distance(80) end
      movement:start(hero, function() map:close_doors("auto_door_"..prefix) hero:unfreeze() end)
    end
    if name:match("^sensor_falling_auto_door_"..j.."_n_open") then
      local prefix = j
      local x, y, layer = hero:get_position()
      map:open_doors("auto_door_"..prefix)
      hero:freeze()
      hero:set_animation("walking")
      hero:set_direction(1)
      local movement = sol.movement.create("straight")
      movement:set_speed(88)
      local angle = math.pi / 2
      movement:set_angle(angle)
      if layer == 1 then movement:set_max_distance(56) else movement:set_max_distance(80) end
      movement:start(hero, function() map:close_doors("auto_door_"..prefix) hero:unfreeze() end)
    end
    if name:match("^sensor_falling_auto_door_"..j.."_w_open") then
      local prefix = j
      local x, y, layer = hero:get_position()
      map:open_doors("auto_door_"..prefix)
      hero:freeze()
      hero:set_animation("walking")
      hero:set_direction(2)
      local movement = sol.movement.create("straight")
      movement:set_speed(88)
      local angle = math.pi
      movement:set_angle(angle)
      if layer == 1 then movement:set_max_distance(56) else movement:set_max_distance(80) end
      movement:start(hero, function() map:close_doors("auto_door_"..prefix) hero:unfreeze() end)
    end
    if name:match("^sensor_falling_auto_door_"..j.."_s_open") then
      local prefix = j
      map:open_doors("auto_door_"..prefix)
      hero:freeze()
      hero:set_animation("walking")
      hero:set_direction(3)
      local movement = sol.movement.create("straight")
      movement:set_speed(88)
      local angle = 3 * math.pi / 2
      movement:set_angle(angle)
      movement:set_max_distance(72)
      movement:start(hero, function() map:close_doors("auto_door_"..prefix) hero:unfreeze() end)
    end
  end

  --Son de secret après certains passages
  if name:match("^sensor_secret") then
    sol.audio.play_sound("secret")
  end  

  --Entrée dans pièce de Boss
  if name:match("^sensor_boss") then
    self:set_enabled(false)
    hero:freeze()
    sol.timer.start(map,200,function()
      sol.audio.play_music("boss")
      hero:unfreeze()
      local m = sol.movement.create("straight")
      m:set_max_distance(16)
      m:set_angle(math.pi / 2)
      m:start(map:get_camera())
    end)
  end
end

return true