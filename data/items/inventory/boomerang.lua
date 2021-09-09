local item = ...

function item:on_created()

  self:set_savegame_variable("possession_boomerang")
  self:set_assignable(true)
end

function item:on_using()

  -- TODO : Moove the boomerang's sprite in a proper location
  local hero = self:get_map():get_entity("hero")
  if self:get_variant() == 1 then
    hero:start_boomerang(128, 160, "boomerang1", "entities/boomerang1")
  else
    -- boomerang 2: longer and faster movement
    hero:start_boomerang(192, 320, "boomerang2", "entities/boomerang2")
  end
  self:set_finished()
end

