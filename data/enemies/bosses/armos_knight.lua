-- Armos Knight boss global movement.

local enemy = ...
local map = enemy:get_map()
local x, y, layer = 0, 0, 0
local frame = 0
local var_reverse_move = 1

-- phase -1, wait for hero
-- phase 0, wait Armos for to move on position
-- phase 1, move in circle (and use variable for reverse)
-- phase 2, move to up to down
-- phase 3, phase 2 of armos jump to hero

local armos_phase = -1

-- Palet 0 = Blue (Phase 1)
-- Palet 1 = Green and Pink line
-- Palet 2 = Brown
-- Palet 3 = Orange
-- Palet 4 = Green
-- Palet 5 = Light Blue
-- Palet 6 = Red
-- Palet 7 = Red (Phase 2)

local palet_armos_1 = 0
local palet_armos_2 = 7

local x_armos = 0
local y_armos = 0
local armos_id = {}

function enemy:please_distance()
  local x1, y1 = enemy:get_position()
  local x2, y2 = enemy:get_map():get_hero():get_position()
  print(sol.main.get_distance(x1, y1, x2, y2))
end

function enemy:on_created()
  x, y, layer = enemy:get_position()
  enemy:set_dying_sprite_id(nil)
  enemy:set_life(6)
  enemy:set_damage(0)
  enemy:set_visible(false)
  enemy:set_pushed_back_when_hurt(false)
  enemy:set_can_attack(false)
  enemy:set_invincible()
  local x_1, y_1, layer = enemy:get_position()
  for i = 1, 6 do
    local y_2
    if i < 4 then
      y_2 = 16
    else
      y_2 = -16
    end
    map:create_enemy({
      name = ("armosknight_"..tostring(enemy).."_"..i),
      breed = "bosses/armos_knight_separated",
      layer = layer,
      x = x_1+(48*(((i-1)% 3)-1)),
      y = y_1+16-(48*(math.ceil(i/3)%2)),
      direction = 0,
    })
    armos_id[i] = ("armosknight_"..tostring(enemy).."_"..i)
    map:get_entity(armos_id[i]):change_palet(palet_armos_1)
  end
end

function enemy:on_update()

  if armos_phase == -1 then
    local x1, y1 = enemy:get_position()
    local x2, y2 = enemy:get_map():get_hero():get_position()
    if (sol.main.get_distance(x1, y1, x2, y2) <= 72) then
      sol.timer.start(enemy, 2000, function()
        for i = 1, 6 do
          map:get_entity(armos_id[i]):change_state(3)
        end
      end)
      armos_phase = 0
    end
  else
    for i = 1, 6 do
      local number_armos_living = map:get_entities_count("armosknight_"..tostring(enemy))
      if (number_armos_living == 0) then
        enemy:set_position(x_armos, y_armos)
        enemy:set_life(0)
      elseif map:has_entity(armos_id[i]) then
        x_armos, y_armos = map:get_entity(armos_id[i]):get_position()
        if (number_armos_living == 1) and (map:get_entity(armos_id[i]):get_state() == 2) then
          map:get_entity(armos_id[i]):change_state(4)
          map:get_entity(armos_id[i]):change_palet(palet_armos_2)
          armos_phase = 3
        end
      end
    end
  end

  if (armos_phase == 0) and not (armos_phase == 3) then
    frame = 0
    local all_armos_in_place = true

    for i = 1, 6 do
      if map:has_entity(armos_id[i]) then
        local x_temp, y_temp = map:get_entity(armos_id[i]):get_position()
        local angle_temp
        if (math.ceil(i/3)%2 == 0) then
          angle_temp = math.rad( ( ((60*(i-4))+280) )*var_reverse_move )
        else
          angle_temp = math.rad( ( ((-60*(i-1))+220) )*var_reverse_move )
        end
        local target_x_temp = math.ceil(x+(math.cos(angle_temp)*64))
        local target_y_temp = math.ceil(y-(math.sin(angle_temp)*64))
        if not ((x_temp == target_x_temp) and (y_temp == target_y_temp)) then
          all_armos_in_place = false
        end
        map:get_entity(armos_id[i]):update_target(target_x_temp, target_y_temp)
      end
    end

    if all_armos_in_place == true then
      armos_phase = 1
    end
    
    
  elseif (armos_phase == 1) and not (armos_phase == 3) then
    frame = frame+1
    local distance_center
    if frame < 460 then
      distance_center = math.max(24, math.min(64, (-frame)+350))
    else
      distance_center = math.max(24, math.min(64, (frame)-460))
    end

    for i = 1, 6 do
      if map:has_entity(armos_id[i]) then
        local angle_temp
        if (math.ceil(i/3)%2 == 0) then
          angle_temp = math.rad( ( ((60*(i-4))+280)-(math.min(frame, 520)/2) )*var_reverse_move )
        else
          angle_temp = math.rad( ( ((-60*(i-1))+220)-(math.min(frame, 520)/2) )*var_reverse_move )
        end
        local target_x_temp = math.ceil(x+(math.cos(angle_temp)*distance_center))
        local target_y_temp = math.ceil(y-(math.sin(angle_temp)*distance_center))
        map:get_entity(armos_id[i]):update_target(target_x_temp, target_y_temp)
      end
    end
    
    if frame == 600 then
      frame = 0
      armos_phase = 2
      if var_reverse_move == 1 then
        var_reverse_move = -1
      else
        var_reverse_move = 1
      end
    end
    
    
  elseif (armos_phase == 2) and not (armos_phase == 3) then
    frame = frame+1

    for i = 1, 6 do
      if map:has_entity(armos_id[i]) then
        local target_x_temp
        if (math.ceil(i/3)%2 == 0) then
          target_x_temp = x+(72-((i-4)*29))
        else
          target_x_temp = x+(-72+((i-1)*29))
        end
        local target_y_temp = y+math.max(-72, math.min(72, frame-400))
        map:get_entity(armos_id[i]):update_target(target_x_temp, target_y_temp)
      end
    end
    
    if frame == 570 then
      frame = 0
      armos_phase = 0
    end
    
  end

end