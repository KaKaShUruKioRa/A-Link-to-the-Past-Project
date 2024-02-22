-- This script displays chests with common conditions like killing enemies,
-- based on the name of the chest and of enemies.
-- chests with prefix auto_chest are automatically shown when killing
-- the last enemy with prefix auto_enemy_<chest_name>,
-- or when activating the switch auto_switch_<chest_name>,
-- or when lighting the last torch auto_torch_<chest_name>.

local chest_manager = {}

function chest_manager:manage_map(map)

  -- Find chests with prefix auto_chest.
  for chest in map:get_entities("auto_chest") do
    -- If there are enemies whose name matches the chest, link them to the chest.
    chest_manager:open_when_enemies_dead(chest)
    -- If there is a switch whose name matches the chest, link it to the chest.
    chest_manager:open_when_switch_activated(chest)
    -- If there are torches whose name matches the chest, link them to the chest.
    chest_manager:open_when_torches_lit(chest)
    chest_manager:open_when_timed_torches_lit(chest)

  end
end

-- Returns whether there exists at least one entity with the specified
-- prefix in the region of the hero.
local function has_entities_with_prefix_in_region(map, prefix)

  local hero = map:get_hero()
  for entity in map:get_entities(prefix) do
    if entity:is_in_same_region(hero) then
      return true
    end
  end
  return false
end

function chest_manager:open_when_enemies_dead(chest)

  local chest_prefix = chest:get_name()
  local enemy_prefix = "auto_enemy_" .. chest_prefix

  local map = chest:get_map()
  local enemies = {}
  local function enemy_on_dead()
    if not chest:is_enabled() and not has_entities_with_prefix_in_region(map, enemy_prefix) then
      local chest_prefix_x,chest_prefix_y = chest:get_position()
      sol.audio.play_sound("correct")
      map:move_camera(chest_prefix_x,chest_prefix_y,256,function()
        sol.audio.play_sound("chest_appears")
        map:get_entity(chest_prefix.."_appears_effect"):get_sprite():set_ignore_suspend(true)
        map:get_entity(chest_prefix.."_appears_effect"):set_enabled(true)
        sol.timer.start(2000,function()
          chest:get_sprite():set_ignore_suspend(true)
          chest:set_enabled(true)
          chest:get_sprite():fade_in(100,function()
            sol.audio.play_sound("secret")
            map:get_entity(chest_prefix.."_appears_effect"):set_enabled(false)
          end)
        end)
      end,1000,5000)
    end
  end

  for enemy in map:get_entities(enemy_prefix) do
    enemy.on_dead = enemy_on_dead
  end
end

function chest_manager:open_when_switch_activated(chest)

  local map = chest:get_map()
  local chest_prefix = chest:get_name()
  local chest_prefix_x,chest_prefix_y = chest:get_position()
  local switch_name = "auto_switch_" .. chest_prefix
  local switch = map:get_entity(switch_name)
  if switch ~= nil then
    function switch:on_activated()
      sol.audio.play_sound("chest_appears")
      map:set_entities_enabled(chest_prefix,true)
    end
    if chest:is_open() then
      -- chest saved in state open.
      switch:set_activated(true)
      switch:set_locked()
    end
  end

end

function chest_manager:open_when_torches_lit(chest)

  local map = chest:get_map()
  local chest_prefix = chest:get_name()
  local chest_prefix_x, chest_prefix_y = chest:get_position()
  local torch_prefix = "auto_torch_" .. chest_prefix

  local remaining = 0
  local function torch_on_lit()
    if not chest:is_enabled() then
      remaining = remaining - 1
      if remaining == 0 then
        sol.audio.play_sound("correct")
        map:move_camera(chest_prefix_x,chest_prefix_y,256,function()
          sol.audio.play_sound("chest_appears")
          map:get_entity(chest_prefix.."_appears_effect"):get_sprite():set_ignore_suspend(true)
          map:get_entity(chest_prefix.."_appears_effect"):set_enabled(true)
          sol.timer.start(2000,function()
            chest:get_sprite():set_ignore_suspend(true)
            chest:set_enabled(true)
            chest:get_sprite():fade_in(100,function()
              sol.audio.play_sound("secret")
              map:set_entities_enabled(chest_prefix,true)
              map:get_entity(chest_prefix.."_appears_effect"):set_enabled(false)
            end)
          end)
        end,1000,5000)
      end
    end
  end
  local function torch_on_unlit()
    remaining = remaining + 1
  end

  local has_torches = false
  for torch in map:get_entities(torch_prefix) do
    if not torch:is_lit() then
      remaining = remaining + 1
    end
    torch.on_lit = torch_on_lit
    torch.on_unlit = torch_on_unlit
    has_torches = true
    if chest:is_open() then
      torch:set_lit(true)
    end
  end
  if has_torches and remaining == 0 then
    chest:set_enabled(true)
  end
end

function chest_manager:open_when_timed_torches_lit(chest)

  local map = chest:get_map()
  local chest_prefix = chest:get_name()
  local chest_prefix_x, chest_prefix_y = chest:get_position()
  local torch_prefix = "auto_timed_torch_" .. chest_prefix

  local remaining = 0
  local function torch_on_lit()
    if not chest:is_enabled() then
      remaining = remaining - 1
      if remaining == 0 then
        sol.audio.play_sound("correct")
        map:move_camera(chest_prefix_x,chest_prefix_y,256,function()
          sol.audio.play_sound("chest_appears")
          map:get_entity(chest_prefix.."_appears_effect"):get_sprite():set_ignore_suspend(true)
          map:get_entity(chest_prefix.."_appears_effect"):set_enabled(true)
          sol.timer.start(2000,function()
            chest:get_sprite():set_ignore_suspend(true)
            chest:set_enabled(true)
            chest:get_sprite():fade_in(100,function()
              sol.audio.play_sound("secret")
              map:set_entities_enabled(chest_prefix,true)
              map:get_entity(chest_prefix.."_appears_effect"):set_enabled(false)
            end)
          end)
        end,1000,5000)
      end
    end
  end
  local function torch_on_unlit()
    remaining = remaining + 1
    if remaining < 0 then remaining = 0 end
  end

  local has_torches = false
  for torch in map:get_entities(torch_prefix) do
    if not torch:is_lit() then
      remaining = remaining + 1
    end
    torch.on_lit = torch_on_lit
    torch.on_unlit = torch_on_unlit
    has_torches = true
    if chest:is_open() then
      torch:set_lit(true) torch:set_duration(0)
    else torch:set_duration(10000) end
  end
  if has_torches and remaining == 0 then
    chest:set_enabled(true)
  end
end

return chest_manager