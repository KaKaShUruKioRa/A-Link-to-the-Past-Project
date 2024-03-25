-- Initialize npcs behavior specific to this quest.

require("scripts/multi_events")

local npc_meta = sol.main.get_metatable("npc")

function npc_meta:on_interaction()
  local game = self:get_game()
  local name = self:get_name()
  local hero = game:get_hero()
  local map = game:get_map()

  local dialog_box = game:get_dialog_box()

  if name == nil then
    return
  end

  --Stèles
  if name:match("^ts") then
    dialog_box:set_style("empty")
    game:start_dialog(name,function() dialog_box:set_style("box") end)
  end

  --Stèles en hylien
  if name:match("^hs") then
    game:set_dialog_style("stone")
    if not game:has_item("inventory/book_of_mudora") then
      sol.audio.play_sound("wrong")
      game:start_dialog("hs.need_book_of_mudora")
      return
    end
    game:start_dialog(name)
  end

end

return true