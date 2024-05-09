local map = ...
local game = map:get_game()

function map:on_started()
  if game:get_value("zelda_rescued") then
    zelda:set_enabled(false)
  end
  if game:get_value("follower_zelda_on") then
    sol.timer.start(map,1600,function()
      zelda_follower:set_enabled(true)
      zelda_follower:set_position(hero:get_position())
    end)
  end
end

function zelda:on_interaction()
  sol.audio.play_music("zelda")
  game:start_dialog("NoBigKey",function()
    game:set_value("zelda_rescued",true)
    zelda_follower:set_enabled(true)
    zelda_follower:set_position(zelda:get_position())
    zelda:set_enabled(false)
    game:set_value("follower_zelda_on",true)
    sol.audio.play_music("castle")
  end)
end

function chest_lantern:on_opened()
  if game:get_value("get_lamp") then
    hero:start_treasure("consumables/rupee",2,"after_lamp_rupees_castleB3")
  else
    hero:start_treasure("inventory/lantern",1,"get_lamp")
  end
end