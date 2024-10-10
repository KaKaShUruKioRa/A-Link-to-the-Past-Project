local item = ...
local game = item:get_game()
local map = game:get_map()

-- Event called when the game is initialized.
function item:on_started()
  item:set_savegame_variable("possession_pendant_of_wisdom")
  item:set_assignable(false)
  item:set_sound_when_picked(nil)
  item:set_brandish_when_picked(false)
  item:set_shadow(nil)
end

function item:on_obtaining()
  local game = item:get_game()
  local hero = game:get_hero()
  local map = game:get_map()
  local x_hero,y_hero, layer_hero = hero:get_position()

  local key_item_entity = map:create_custom_entity({
      name = "brandish_key_item",
      sprite = "entities/items",
      x = x_hero,
      y = y_hero - 24,
      width = 16,
      height = 16,
      layer = layer_hero,
      direction = 0
    })
  key_item_entity:get_sprite():set_animation("quest/pendant_of_wisdom")
  key_item_entity:get_sprite():set_direction(0)

  map:get_entity("shadow"):set_enabled(false)
  hero:freeze()
  hero:set_animation("brandish")
  game:set_pause_allowed(false)
  --game:set_dungeon_finished()
  sol.audio.play_music("victory")
  sol.timer.start(10000,function() 
    game:start_dialog("_treasure.quest/pendant_of_wisdom.1",function()
      local last_dialog
      if game:get_value("get_pendant_of_power") then last_dialog = "misc.pendants_all" else last_dialog = "misc.pendants_only_one" end
      game:start_dialog(last_dialog, function()
        map:get_entity("brandish_key_item"):set_enabled(false)
        hero:set_animation("stopped")
        game:set_life(game:get_max_life())
        game:set_magic(game:get_max_magic())
        sol.timer.start(1000,function()
          hero:start_victory()
          sol.timer.start(1000,function()
            game:set_pause_allowed(true)
            hero:teleport("A Link To The Past/Light World/Overworld/death_mountain_west","dest_dungeon_cemetery_0","fade")
          end)
        end)
      end)
    end)  
  end)
end