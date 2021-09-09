-- The magic meter shown in the game screen.

local magic_meter_builder = {}

function magic_meter_builder:new(game)

  local magic_meter = {}

  local surface = sol.surface.create(88, 8)
  local magic_meter_img = sol.surface.create("hud/magic_meter.png")
  local magic_displayed = game:get_magic()
  local max_magic_displayed = 0

  function magic_meter:set_dst_position(x, y)
    magic_meter.dst_x = x
    magic_meter.dst_y = y
  end

  -- Checks whether the view displays the correct info
  -- and updates it if necessary.
  local function check()

    local max_magic = game:get_max_magic()
    local magic = game:get_magic()

    -- Maximum magic.
    if max_magic ~= max_magic_displayed then
      if magic_displayed > max_magic then
        magic_displayed = max_magic
      end
      max_magic_displayed = max_magic
    end

    -- Current magic.
    if magic ~= magic_displayed then
      local increment
      if magic < magic_displayed then
        increment = -1
      elseif magic > magic_displayed then
        increment = 1
      end
      if increment ~= 0 then
        magic_displayed = magic_displayed + increment

        -- Play the magic meter sound.
        if (magic - magic_displayed) % 10 == 1 then
          sol.audio.play_sound("magic_meter")
        end
      end
    end

    return true  -- Repeat the timer.
  end

  function magic_meter:on_draw(dst_surface)

    -- Is there a magic meter to show?
    if max_magic_displayed == 0 then
      return
    end

    local x, y = magic_meter.dst_x, magic_meter.dst_y
    local width, height = dst_surface:get_size()
    if x < 0 then
      x = width + x
    end
    if y < 0 then
      y = height + y
    end

    -- Draw the container.
    magic_meter_img:draw_region(0, 0, 16, 48, dst_surface, x, y)
    local height = magic_displayed
    if max_magic_displayed > 32 then
      -- Draw the 1/2 symbol.
      magic_meter_img:draw_region(32, 0, 16, 16, dst_surface, x, y)
      height = math.ceil(height / 2)
    end
    -- Draw the content.
    magic_meter_img:draw_region(20, 11, 8, height, dst_surface, x + 4, y + 43 - height)
  end

  -- Periodically check.
  check()
  sol.timer.start(game, 20, check)

  return magic_meter
end

return magic_meter_builder