local item = ...

-- When it is created, this item creates another item randomly chosen
-- and then destroys itself.

-- Probability of each item between 0 and 100.
local probabilities = {
                                           -- Nothing (52%)
  [{ "consumables/magic_jar", 1 }]   = 24, -- Magic Jar (24%)
  [{ "consumables/magic_jar", 2 }]   = 12, -- Magic Jar 2 (12%) 
  [{ "consumables/heart", 1 }]       = 6,  -- Heart (6%) 
  [{ "consumables/rupee", 2 }]       = 6,  -- 5 Rupees (6%) 
}

function item:on_pickable_created(pickable)

  local treasure_name, treasure_variant = self:choose_random_item()
  if treasure_name ~= nil then
    local map = pickable:get_map()
    local x, y, layer = pickable:get_position()
    map:create_pickable{
      layer = layer,
      x = x,
      y = y,
      treasure_name = treasure_name,
      treasure_variant = treasure_variant,
    }
  end
  pickable:remove()
end

-- Returns an item name and variant.
function item:choose_random_item()

  local random = math.random(100)
  local sum = 0

  for key, probability in pairs(probabilities) do
    sum = sum + probability
    if random < sum then
      return key[1], key[2]
    end
  end

  return nil
end