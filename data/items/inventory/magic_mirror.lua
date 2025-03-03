local item = ...
local game = item:get_game()
  
function item:on_started()
  item:set_savegame_variable("possession_magic_mirror")
  item:set_assignable(true)
end

function item:on_using()
  local hero = game:get_hero()
  local map = game:get_map()

  if game:get_dungeon() then
    -- Teleport.
    sol.audio.play_sound("warp")
    hero:teleport(game:get_starting_location())
  
  elseif map:get_id() == "A Link to the Past/Light World/Overworld/death_mountain_west" and map:get_tileset() == "out/outside_darkworld_main" then
    sol.audio.play_sound("world_warp")

    hero:teleport(game:get_map():get_id(), "_same")

  elseif map:get_world() == "Dark World" then
    sol.audio.play_sound("world_warp")

    for warp_world in map:get_entities_by_type("teletransporter") do
        if string.match(warp_world:get_name(), "link_warp_world_") then --Si le Tp a pour nom "link_warp_word_*"
          hero:teleport(warp_world:get_destination_map(), warp_world:get_destination_name())
        end
      end
  else
    sol.audio.play_sound("wrong")
  end
  item:set_finished()
end
