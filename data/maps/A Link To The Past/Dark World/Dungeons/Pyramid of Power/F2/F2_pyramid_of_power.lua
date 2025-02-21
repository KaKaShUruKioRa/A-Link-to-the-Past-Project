-- Lua script of map Archived/A Link to the Past/Light World/Non Playable Zone/Dungeons/Tower of Hera/F6/.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()

local door_manager = require("scripts/maps/door_manager")
door_manager:manage_map(map)
local chest_manager = require("scripts/maps/chest_manager")
chest_manager:manage_map(map)
local separator_manager = require("scripts/maps/separator_manager")
separator_manager:manage_map(map)

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

  -- You can initialize the movement and sprites of various
  -- map entities here.
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

--BOSS : Activation Agahnim 2
function sensor_boss:on_activated()
  self:set_enabled(false)
  hero:freeze()
  
  game:start_dialog("enemy.ganon.introduction", function()
    sol.timer.start(map,200,function()
      sol.audio.play_music("ganon_battle")
      hero:unfreeze()
      boss_ganon:set_enabled(true)
    end)
  end)
end

--BOSS : Mort Ganon, et dialogue de fin
function boss_ganon:on_dying()  
  sol.audio.stop_music()
  game:set_value("boss_ganon", true)
  sol.timer.start(6000, function()
    sol.audio.play_music("triforce")
    game:start_dialog("end.triforce", function()
      hero:start_victory()
      sol.audio.play_music("credits")
    end)
  end)
end
