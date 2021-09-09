-- A Link To The Past title screen.
-- Made by Olivier Clero, based on the original title screen from A Link To The Past.
-- Usage:
-- local title_screen = require("menus/title_screen")
-- sol.menu.start(title_screen)
-- title_screen.on_finished = function()
--   -- Do whatever you want next (start a game...)
-- end

local title_screen = {}

-- Called when the menu is started.
function title_screen:on_started()
  -- Keep trace of the current step.
  self.step = 0
  self.finished = false

  -- Adapt to the quest size.
  self.surface_w, self.surface_h = sol.video.get_quest_size()

  -- Load images.
  self.triforce_sprite = sol.sprite.create("menus/title_screen/triforce")
  self.triforce_sprite_w, self.triforce_sprite_h = self.triforce_sprite:get_size()

  self.logo_zelda_img = sol.surface.create("menus/title_screen/logo_zelda.png")
  self.logo_zelda_img_w, self.logo_zelda_img_h = self.logo_zelda_img:get_size()
  self.logo_zelda_z_img = sol.surface.create("menus/title_screen/logo_zelda_z.png")

  self.logo_tlo_img = sol.surface.create("menus/title_screen/logo_tlo.png")
  self.logo_tlo_img_w, self.logo_tlo_img_h = self.logo_tlo_img:get_size()

  self.logo_sword_img = sol.surface.create("menus/title_screen/logo_sword.png")
  self.logo_sword_img_w, self.logo_sword_img_h = self.logo_sword_img:get_size()

  self.logo_subtitle_img = sol.surface.create("menus/title_screen/logo_subtitle.png")
  self.logo_subtitle_img_w, self.logo_subtitle_img_h = self.logo_subtitle_img:get_size()

  self.copyright_img = sol.surface.create("menus/title_screen/copyright.png")
  self.copyright_img_w, self.copyright_img_h = self.copyright_img:get_size()

  self.background_img = sol.surface.create("menus/title_screen/background.png")
  self.background_img_w, self.background_img_h = self.background_img:get_size()
  
  self.shine_sprite = sol.sprite.create("menus/title_screen/small_shine")
  
  self.press_start_sprite = sol.sprite.create("menus/title_screen/press_start")
  self.press_start_sprite_w, self.press_start_sprite_h = self.press_start_sprite:get_size()

  -- Black surface for the final fade-out
  self.black_surface = sol.surface.create(self.surface_w, self.surface_h)
  self.black_surface:fill_color({0, 0, 0})

  -- Black stripes
  self.black_stripe = sol.surface.create(self.surface_w, 24)
  self.black_stripe:fill_color({0, 0, 0})

  -- White surface (for the white flash)
  self.white_flash_img = sol.surface.create(self.surface_w, self.surface_h)
  self.white_flash_img:fill_color({255, 255, 255})

  -- Start animation.
  self:step_1()
end

-- Draws this menu.
function title_screen:on_draw(dst_surface)

  local dst_w, dst_h = dst_surface:get_size()
  
  -- NB: the order is important here to get the layers in the correct order.
  
  -- Background.
  if self.step >= 4 then   
    local background_img_x = (dst_w - self.background_img_w) / 2
    local background_img_y = (dst_h - self.background_img_h) / 2 - 13
    self.background_img:draw(dst_surface, background_img_x, background_img_y)
  end

  -- Cinematic black stripes.
  self.black_stripe:draw(dst_surface, 0, 0)
  self.black_stripe:draw(dst_surface, 0, dst_h - 24)
  
  -- Flash.
  if self.step >= 4 then 
    self.white_flash_img:draw(dst_surface, 0, 0)  
  end

  -- Triforce.
  local triforce_sprite_x = (dst_w - self.triforce_sprite_w) / 2
  local triforce_sprite_y = (dst_h - self.triforce_sprite_h) / 2
  self.triforce_sprite:draw(dst_surface, triforce_sprite_x, triforce_sprite_y)    

  -- Zelda.
  if self.step >= 2 then
    local logo_zelda_img_x = (dst_w - self.logo_zelda_img_w) / 2
    local logo_zelda_img_y = (dst_h - self.logo_zelda_img_h) / 2 + 9
    self.logo_zelda_img:draw(dst_surface, logo_zelda_img_x, logo_zelda_img_y)

    local logo_tlo_img_x = (dst_w - self.logo_tlo_img_w) / 2 + 16
    local logo_tlo_img_y = dst_h / 2 - 30
    self.logo_tlo_img:draw(dst_surface, logo_tlo_img_x, logo_tlo_img_y)
  end

  -- Sword.
  if self.step >= 3 then
    self.logo_sword_img:draw(dst_surface)
  end

  -- Z part that is over the sword.
  if self.step >= 2 then
    local logo_zelda_z_img_x = (dst_w - self.logo_zelda_img_w) / 2
    local logo_zelda_z_img_y = (dst_h - self.logo_zelda_img_h) / 2 + 9
    self.logo_zelda_z_img:draw(dst_surface, logo_zelda_z_img_x, logo_zelda_z_img_y)
  end

  -- Little shine on Zelda logo.
  if self.step == 5 then
    local shine_sprite_x = (dst_w - self.logo_zelda_img_w) / 2 + 112
    local shine_sprite_y = (dst_h - self.logo_zelda_img_h) / 2 + 21
    self.shine_sprite:draw(dst_surface, shine_sprite_x, shine_sprite_y)
  end

  -- Subtitle (A Link to the Past).
  if self.step >= 4 then
    local logo_subtitle_img_x = (dst_w - self.logo_subtitle_img_w) / 2 + 34
    local logo_subtitle_img_y = (dst_h - self.logo_subtitle_img_h) / 2 + 39
    self.logo_subtitle_img:draw(dst_surface, logo_subtitle_img_x, logo_subtitle_img_y)
  end

  -- Press Start.
  if self.step >= 6 then
    local press_start_sprite_x = (dst_w - self.press_start_sprite_w) / 2
    local press_start_sprite_y = (dst_h - self.press_start_sprite_h) / 2 + 68
    self.press_start_sprite:draw(dst_surface, press_start_sprite_x, press_start_sprite_y)
  end

  -- Copyright.
  local copyright_img_x = (dst_w - self.copyright_img_w) / 2
  local copyright_img_y = dst_h - self.copyright_img_h - 9
  self.copyright_img:draw(dst_surface, copyright_img_x, copyright_img_y)

  -- Final fade-out
  if self.step >= 7 or self.finished then
    self.black_surface:draw(dst_surface, 0, 0)    
  end
end

-- Resets the timer.
function title_screen:reset_timer()
  if self.timer ~= nil then
    self.timer:stop()
    self.timer = nil
  end
end

-- Triforce
function title_screen:step_1()
  self.step = 1
  
  self:reset_timer()
  
  self.copyright_img:fade_in()

  self.triforce_sprite:set_animation("moving", function()
    self.triforce_sprite:set_animation("static")
    self:step_2()
  end)
  
end

-- Logo fade-in
function title_screen:step_2()
  self.step = 2

  self:reset_timer()

  self.triforce_sprite:set_animation("static")
  self.logo_tlo_img:fade_in(40)
  self.logo_zelda_img:fade_in(40, function()
    self:step_3()
  end)
  self.logo_zelda_z_img:fade_in(40)

end

-- Sword
function title_screen:step_3()
  self.step = 3

  self:reset_timer()

  local sword_movement = sol.movement.create("target")
  local logo_sword_img_x = (self.surface_w - self.logo_sword_img_w) / 2 - 50
  local logo_sword_img_y = (self.surface_h - self.logo_sword_img_h) / 2
  self.logo_sword_img:set_xy(logo_sword_img_x, - self.logo_sword_img_h)
  local speed = (logo_sword_img_y + self.logo_sword_img_h) / 0.4
  sword_movement:set_speed(speed)
  sword_movement:set_target(logo_sword_img_x, logo_sword_img_y)
  sword_movement:start(self.logo_sword_img, function()
    self:step_4()
  end)

end

-- White flash
function title_screen:step_4()
  self.step = 4

  self:reset_timer()
  
  self.logo_subtitle_img:fade_in(40)

  local fade_in_delay = 60
  self.white_flash_img:fade_out(fade_in_delay, function()
    self:step_5()
  end)
end

-- Little shine
function title_screen:step_5()
  self.step = 5

  self:reset_timer()

  self.timer = sol.timer.start(500, function()
    self.shine_sprite:set_animation("default", function()
      self:reset_timer()

      self.timer = sol.timer.start(500, function()
        self:step_6()
      end)
    end)
  end)
end

-- Press Start
function title_screen:step_6()
  self.step = 6

  self:reset_timer()
  
  -- Stop the menu after a delay
  self.timer = sol.timer.start(10000, function()
    self:step_7()
  end)

end

-- Final fade-out
function title_screen:step_7()
  self.step = 7

  self:reset_timer()

  if not self.finished then
    self.black_surface:fade_in(60, function()
      if not self.finished then
        self:skip_menu()
      end
    end)
  end
end

-- Called when a keyboard key is pressed.
function title_screen:on_key_pressed(key)

  if key == "escape" then
    -- Escape: quit Solarus.
    sol.main.exit()
    return true
  elseif not self.finished then
    self:skip_menu()
    return true
  end
  
  return false
end

-- Called when a mouse button is pressed.
function title_screen:on_mouse_pressed(button, x, y)
  if not self.finished and (button == "left" or button == "right") then
    self:skip_menu()
  end
end

-- Skips the menu.
function title_screen:skip_menu()
  if not sol.menu.is_started(self) or self.finished then
    return
  end

  -- Store the state.
  self.finished = true

  -- Stop the timer.
  self:reset_timer()

  -- Quits after a fade to black.
  self.black_surface:fade_in(20, function()
    -- Quit the menu
    sol.menu.stop(self)
  end)
end

-- Return the menu to the caller.
return title_screen
