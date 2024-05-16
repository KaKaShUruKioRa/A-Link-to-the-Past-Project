local map = ...
local game = map:get_game()

local night_overlay = sol.surface.create(map:get_size())
local alpha = 192
night_overlay:fill_color({0, 0, 64, alpha})

local night = false

-- DEBUT DE LA MAP
function map:on_started(destination)

  if not game:get_value("intro_done") then
    --sol.audio.play_music("beginning")
    sol.audio.play_sound("rain_in",true)
    sol.timer.start(map,5000,function()
      sol.audio.play_sound("rain_in",true)
      return true
    end)
  end

  if destination ~= newgame then
    uncle:set_enabled(false)
    snores:set_enabled(false)
    return
  end

  map:set_entities_enabled("sleeping",false)
  night = true
  sol.audio.play_music("none")

  -- The intro scene is playing.
  game:set_pause_allowed(false)
  snores:get_sprite():set_ignore_suspend(true)
  bed:get_sprite():set_animation("hero_sleeping")
  bed:get_sprite():set_direction(game:get_ability("tunic") - 1)
  hero:freeze()
  hero:set_visible(false)

  local dialog_box = game:get_dialog_box()

  sol.timer.start(map, 2500, function()

    -- Show intro message.
    dialog_box:set_style("empty")
    game:start_dialog("NoBigKey", function()     
      sol.audio.play_music("beginning")
      night_overlay:fade_out(80,function()
        sol.timer.start(map, 1000, function()
          -- Wake up.
          snores:remove()
          bed:get_sprite():set_animation("hero_waking")
          uncle:get_sprite():set_direction(2)
          dialog_box:set_style("box")
          game:start_dialog("NoBigKey", function()
            local m = sol.movement.create("path")
            m:set_path{4,4,4,4,4,4,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6}
            m:set_speed(40)
            m:set_ignore_obstacles(true)
            uncle:get_sprite():set_animation("walking")
            m:start(uncle,function()
              uncle:set_enabled(false)

              -- Jump from the bed.
              hero:set_visible(true)
              hero:start_jumping(0, 24, true)
              game:set_pause_allowed(true)
              game:set_hud_enabled(true)
              bed:get_sprite():set_animation("empty_open")
              sol.audio.play_sound("hero_lands")

              -- Start the savegame from outside the bed next time.
              game:set_starting_location(map:get_id(), "dest_start")

            end)
          end)
        end)
     end)
   end)
 end)
end

-- Show the night overlay.
function map:on_draw(dst_surface)
  if night then night_overlay:draw(dst_surface) end
end


function chest_lantern:on_opened()
  if game:get_value("get_lamp") then
    hero:start_treasure("consumables/rupee",2,"after_lamp_rupees_HOUSE")
  else
    hero:start_treasure("inventory/lantern",1,"get_lamp")
  end
end