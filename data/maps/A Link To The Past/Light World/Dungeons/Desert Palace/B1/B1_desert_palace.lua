local map = ...
local game = map:get_game()

local door_manager = require("scripts/maps/door_manager")
door_manager:manage_map(map)
local chest_manager = require("scripts/maps/chest_manager")
chest_manager:manage_map(map)
local separator_manager = require("scripts/maps/separator_manager")
separator_manager:manage_map(map)

function map:on_started(destination)
  --Carte obtenue
  if game:get_value("desert_map") then auto_chest_map:set_enabled(true) end
  --Clé suspendue obtenue
  if game:get_value("desert_key_4") then map:set_entities_enabled("bonk_sensor", false) end
end


--Clé sur la torche qui tombe si on fonce dedans
function bonk_sensor:on_activated_repeat()
  if hero:get_state() == "running" and hero:get_animation() == "hurt" then
    bonk_sensor:set_enabled(false)
    sol.audio.play_sound("secret")
    m = sol.movement.create("jump")
    m:set_ignore_obstacles(true)
    m:set_direction8(2)
    m:set_distance(16)
    m:set_speed(32)
    m:start(torch_key)
  end
end

--Tuer les Devalant supprime le sable mouvant dessous
function quicksand_1_devalant:on_dying()
  sol.timer.start(map, 500, function() map:set_entities_enabled("quicksand_1",false) end)
end
function quicksand_2_devalant:on_dying()
  sol.timer.start(map, 500, function() map:set_entities_enabled("quicksand_2",false) end)
end
function quicksand_3_devalant:on_dying()
  sol.timer.start(map, 500, function() map:set_entities_enabled("quicksand_3",false) end)
end
function quicksand_4_devalant:on_dying()
  sol.timer.start(map, 500, function() map:set_entities_enabled("quicksand_4",false) end)
end
function quicksand_5_devalant:on_dying()
  sol.timer.start(map, 500, function() map:set_entities_enabled("quicksand_5",false) end)
end
function quicksand_6_devalant:on_dying()
  sol.timer.start(map, 500, function() map:set_entities_enabled("quicksand_6",false) end)
end
function quicksand_7_devalant:on_dying()
  sol.timer.start(map, 500, function() map:set_entities_enabled("quicksand_7",false) end)
end
function quicksand_8_devalant:on_dying()
  sol.timer.start(map, 500, function() map:set_entities_enabled("quicksand_8",false) end)
end
function quicksand_9_devalant:on_dying()
  sol.timer.start(map, 500, function() map:set_entities_enabled("quicksand_9",false) end)
end