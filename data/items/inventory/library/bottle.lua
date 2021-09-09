return function(item)
  -- This script handles all bottles (each bottle script runs it).

  function item:on_using()

    local variant = self:get_variant()
    local game = self:get_game()
    local map = self:get_map()

    -- Empty bottle
    if variant == 1 then
      -- TODO : Prevent to spam the sound
      sol.audio.play_sound("wrong")
      self:set_finished()

    -- Red potion
    elseif variant == 2 then
      game:add_life(game:get_max_life())
      self:set_variant(1) -- make the bottle empty
      self:set_finished()

    -- Green potion
    elseif variant == 3 then
      game:add_magic(game:get_max_magic())
      self:set_variant(1) -- make the bottle empty
      self:set_finished()

    -- Blue potion
    elseif variant == 4 then
      game:add_life(game:get_max_life())
      self:set_variant(1) -- make the bottle empty
      game:add_magic(game:get_max_magic())
      self:set_finished()

    -- Fairy
    -- TODO : Associate the right sprite to variant 2
    -- TODO : In Zelda 3, are the fairies really releases or directly consumes?
    elseif variant == 5 then
      -- Release the fairy
      local x, y, layer = map:get_entity("hero"):get_position()
      map:create_pickable{
        treasure_name = "consumables/fairy",
        treasure_variant = 1,
        x = x,
        y = y,
        layer = layer
      }
      self:set_variant(1) -- make the bottle empty
      self:set_finished()

    -- Bee
    elseif variant == 6 then
      --TODO : Release the bee
    end

  end

end
