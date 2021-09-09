local behavior = {}

-- Behavior of an item that uses magic.

-- Example of use from an item script:

-- local item = ...
-- local behavior = require("items/lib/magic_item")
-- local properties = {
--   magic_needed = 4,
--   sound_on_success = nil,
--   hero_animation = "rod",
--   animation_sprite = "hero/fire_rod",
--   animation_delay = 300,
--   sound_on_success = "lamp",
--   sound_on_fail = "wrong",
--   savegame_variable = "possession_fire_rod",
--   assignable = true,
--   do_magic = function()
--     print("not yet implemented")
--   end
-- }
-- behavior:create(item, properties)

function behavior:create(item, properties)

  local game = item:get_game()

  -- Set default properties.
  if properties.magic_needed == nil then
    properties.magic_needed = 1
  end
  if properties.assignable == nil then
    properties.assignable = true
  end
  if properties.animation_delay == nil then
    -- useful only if properties.animation_sprite is defined
    properties.animation_delay = 300
  end
  if properties.do_magic == nil then
    properties.do_magic = function()
      print("not yet implemented")
   end
  end



  function item:on_created()

    if properties.savegame_variable then
      item:set_savegame_variable(properties.savegame_variable)
    end
    item:set_assignable(properties.assignable)
  end

  function item:on_using()

    local map = item:get_map()
    local hero = map:get_hero()

    -- Give the hero the animation of using the item
    local custom_entity = nil
    if properties.hero_animation then
      hero:set_animation(properties.hero_animation)
    end
    if properties.animation_sprite then
      local x, y, layer = hero:get_position()
      custom_entity = map:create_custom_entity({
        x = x,
        y = y,
        layer = layer,
        width = 16,
        height = 16,
        direction = hero:get_direction(),
        sprite = properties.animation_sprite,
      })
    end

    -- Do magic if there is enough magic.
    if game:get_magic() >= properties.magic_needed then
      if properties.sound_on_success then
        sol.audio.play_sound(properties.sound_on_success)
      end
      game:remove_magic(properties.magic_needed)
      properties.do_magic() -- the customized part is here
    elseif properties.sound_on_fail then
      sol.audio.play_sound(properties.sound_on_fail)
    end

    if custom_entity then
      -- Make sure that the magic item stays on the hero.
      -- Even if he is using this item, he can move
      -- because of holes or ice.
      sol.timer.start(custom_entity, 10, function()
        custom_entity:set_position(hero:get_position())
        return true
      end)
    end

    -- Remove the magic item and restore control after a delay.
    if properties.hero_animation or custom_entity then
      sol.timer.start(hero, properties.animation_delay, function()
        if custom_entity then
          custom_entity:remove()
        end
        item:set_finished()
      end)
    else
      item:set_finished()
    end
  end

  item.is_magic = true
end

-- Check if the hero obtains a magic item to give the magic meter
local item_meta = sol.main.get_metatable("item")
item_meta:register_event("on_obtained", function(item)
  local magic_meter = item:get_game():get_item("equipment/magic_meter")
  if item.is_magic and not magic_meter:has_variant() then
    magic_meter:set_variant(1)
  end
end)

return behavior
