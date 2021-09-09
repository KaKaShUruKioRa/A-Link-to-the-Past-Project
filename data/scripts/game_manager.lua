-- Script that creates a game ready to be played.

-- Usage:
-- local game_manager = require("scripts/game_manager")
-- local game = game_manager:create("savegame_file_name")
-- game:start()

local game_manager = {}

require("scripts/multi_events")
local initial_game = require("scripts/initial_game")

-- Creates a game ready to be played.
function game_manager:create(file_name)

  local exists = sol.game.exists(file_name)
  local game = sol.game.load(file_name)
  if not exists then
    -- Initialize a new savegame.
    initial_game:initialize_new_savegame(game)
  end

  -- Function called when the player presses a key during the game.
  game:register_event("on_key_pressed", function(game, key)

    if game.customizing_command then
      -- Don't treat this input normally, it will be recorded as a new command binding
      -- by the commands menu.
      return false
    end

    local handled = false
    if game:is_pause_allowed() then  -- Keys below are menus.
      if key == game:get_value("keyboard_save") then
        if not game:is_paused() and
          not game:is_dialog_enabled() and
          game:get_life() > 0 then
        game:start_dialog("save_quit", function(answer)
          if answer == 1 then
            -- Continue.
            sol.audio.play_sound("danger")
          elseif answer == 2 then
            -- Save and quit.
            sol.audio.play_sound("danger")
            game:save()
            sol.main.reset()
          else
            -- Quit without saving.
            sol.audio.play_sound("danger")
            sol.main.reset()
          end
        end)
        handled = true
      end
      end
    end

    return handled
  end)

  -- Function called when the player presses a joypad button during the game.
  game:register_event("on_joypad_button_pressed", function(game, button)
    if game.customizing_command then
      -- Don't treat this input normally, it will be recorded as a new command binding.
      return false
    end

    local handled = false

    local joypad_action = "button " .. button
    if game:is_pause_allowed() then  -- Keys below are menus.
      if joypad_action == game:get_value("joypad_save") then
        if not game:is_paused() and
            not game:is_dialog_enabled() and
            game:get_life() > 0 then
          game:start_dialog("save_quit", function(answer)
            if answer == 2 then
              -- Continue.
              sol.audio.play_sound("danger")
            elseif answer == 3 then
              -- Save and quit.
              sol.audio.play_sound("danger")
              game:save()
              sol.main.reset()
            else
              -- Quit without saving.
              sol.audio.play_sound("danger")
              sol.main.reset()
            end
          end)
          handled = true
        end
      end
    end

    return handled
  end)

  return game
end

-- TODO the engine should have an event game:on_world_changed().
local game_meta = sol.main.get_metatable("game")
game_meta:register_event("on_map_changed", function(game)

  local map = game:get_map()
  local new_world = map:get_world()
  local previous_world = game.previous_world
  local world_changed = previous_world == nil or
      new_world == nil or
      new_world ~= previous_world
  game.previous_world = new_world
  if world_changed then
    if game.notify_world_changed ~= nil then
      game:notify_world_changed(previous_world, new_world)
    end
  end
end)

game_meta:register_event("on_game_over_started", function(game)
  -- Reset the previous world info on game-over
  -- so that notify_world_changed gets called.
  game.previous_world = nil
end)

return game_manager
