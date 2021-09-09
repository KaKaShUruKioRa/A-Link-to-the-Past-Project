local item = ...
local game = item:get_game()

function item:on_created()
  self:set_savegame_variable("possession_magic_meter")
end

function item:on_variant_changed(variant)
  -- Obtaining a magic meter changes the max magic.
  local max_magics = {32, 64}
  local max_magic = max_magics[variant]
  if max_magic == nil then
    error("Invalid variant '" .. variant .. "' for item 'magic_meter'")
  end

  game:set_max_magic(max_magic)

  -- Unlock pickable magic jars.
  local magic_flask = self:get_game():get_item("consumables/magic_jar")
  magic_flask:set_obtainable(true)
end

