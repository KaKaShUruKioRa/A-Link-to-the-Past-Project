-- Lua script of map A Link to the Past/Light World/Houses/library.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local hero = map:get_hero()

-- Event called at initialization time, as soon as this map is loaded.
function map:on_started()

  -- You can initialize the movement and sprites of various
  -- map entities here.
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

function hero:on_obstacle_reached() 
end

function map:on_update()
  if self:get_entity("mudora_book_library_0") then
    if hero:get_state() == "running" and hero:get_direction4_to(mudora_book_library_0) == 1 and hero:get_distance(mudora_book_library_0) <= 52 then
        
      local mov_book = sol.movement.create("straight")
      mov_book:set_speed(22)            
      mov_book:set_angle(math.pi / 2)
      mov_book:set_ignore_obstacles(true)
      mov_book:set_max_distance(18)

      mov_book:start(mudora_book_library_0, function()
        sol.audio.play_sound("secret")
      end)
    end
  end
end