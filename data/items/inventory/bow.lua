-- This item represent the equipable bow in the inventory
-- <!> Obtaining the Bow automatically gives a basic quiver

local item = ...
local game = item:get_game()

local sound_timer

function item:on_created()
  item:set_savegame_variable("possession_bow")
  item:set_assignable(true)
end

function item:on_obtaining(variant, savegame_variable)
  -- Obtaining the Bow automatically gives a quiver
  local quiver = game:get_item("equipment/bow_quiver")
  if not quiver:has_variant() then
    quiver:set_variant(1)
    -- We fills the quiver because on_obtaining is not called
    quiver:set_amount(quiver:get_max_amount())
  end
end

-- Called when the player uses the bombs of his inventory
function item:on_using()
  local quiver = game:get_item("equipment/bow_quiver")
  if quiver:get_amount() == 0 then
    if sound_timer == nil then
      sol.audio.play_sound("wrong")
      sound_timer = sol.timer.start(game, 500, function()
      sound_timer = nil
      end)
    end
  else
    local map = game:get_map()
    local hero = game:get_hero()
    quiver:remove_amount(1)
    hero:start_bow()
  end
  item:set_finished()
end