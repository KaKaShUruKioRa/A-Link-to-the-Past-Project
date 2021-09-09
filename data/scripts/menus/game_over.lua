-- Adds a game-over animation to games.

-- Usage:
-- require("scripts/menus/game_over")

require("scripts/multi_events")

-- Starts the game-over animation.
local function start_game_over(game)

  sol.audio.play_sound("hero_dying")
  local map = game:get_map()
  local hero = game:get_hero()
  local death_count = game:get_value("death_count") or 0
  game.lit_torches_by_map = nil  -- See entities/torch.lua
  game:set_value("death_count", death_count + 1)
  hero:get_sprite():set_animation("dying")
  hero:get_sprite():set_ignore_suspend(true)
  local timer = sol.timer.start(game, 3000, function()
    -- Restart the game.
    game:start()
  end)
end

-- Set up game-over features on any game that starts.
local game_meta = sol.main.get_metatable("game")
game_meta:register_event("on_game_over_started", start_game_over)

return true
