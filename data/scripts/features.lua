-- Sets up all non built-in gameplay features specific to this quest.

-- Usage: require("scripts/features")

-- Features can be enabled to disabled independently by commenting
-- or uncommenting lines below.

require("scripts/debug")
require("scripts/console")
require("scripts/menus/alttp_dialog_box")
require("scripts/menus/pause")
require("scripts/hud/hud")
require("scripts/dungeons.lua")

require("scripts/meta/camera.lua")
require("scripts/meta/enemy.lua")
require("scripts/meta/map.lua")
require("scripts/meta/npc.lua")
require("scripts/meta/sensor.lua")
require("scripts/meta/teletransporter.lua")

require("scripts/meta/random_drop.lua")
RNGdrop:destructibles()
RNGdrop:enemies()

return true