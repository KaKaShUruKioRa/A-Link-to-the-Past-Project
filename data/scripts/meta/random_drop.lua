RNGdrop = {}  

--------------------------------------------------------------------
local enemy = sol.main.get_metatable("enemy")
local destructible = sol.main.get_metatable("destructible")
--------------------------------------------------------------------

function RNGdrop:destructibles()
   function destructible:on_created()
      local world = self:get_map():get_world()
      if world == "Dark World" or world == "Light World" then
         RNGdrop:randomized_treasure(self)
      end
   end
end

function RNGdrop:enemies()
   function enemy:on_dying()
      local world = self:get_map():get_world()
      if world == "Dark World" or world == "Light World" or self:get_game():get_dungeon() then
         RNGdrop:randomized_treasure(self)
      end
   end
end

--------------------------------------------------------------------

function RNGdrop:randomized_treasure(map_entity)
   if map_entity:get_treasure() == nil then
      local RandNum = math.random(10000)
      if RandNum < 40  then
         map_entity:set_treasure("consumables/rupee", 1, nil)
      elseif  RandNum > 40 and RandNum < 48 then
         map_entity:set_treasure("consumables/rupee", 2, nil)
      elseif RandNum > 48 and RandNum < 50 then
         map_entity:set_treasure("consumables/rupee", 3, nil)
      elseif RandNum > 50 and RandNum < 90 then
         map_entity:set_treasure("consumables/heart", 1, nil)
      elseif RandNum > 90 and RandNum < 130 then
         map_entity:set_treasure("consumables/arrow_refill", 1, nil)
      elseif RandNum > 130 and RandNum < 138 then
         map_entity:set_treasure("consumables/arrow_refill", 2, nil)
      elseif RandNum > 138 and RandNum < 140 then
         map_entity:set_treasure("consumables/arrow_refill", 3, nil)
      elseif RandNum > 140 and RandNum < 180 then
         map_entity:set_treasure("consumables/bomb_refill", 1, nil)
      elseif RandNum > 180 and RandNum < 188 then
         map_entity:set_treasure("consumables/bomb_refill", 2, nil) 
      elseif RandNum > 188 and RandNum < 190 then
         map_entity:set_treasure("consumables/bomb_refill", 3, nil)
      elseif RandNum > 190 and RandNum < 230 then
         map_entity:set_treasure("consumables/magic_jar", 1, nil)
      elseif RandNum > 230 and RandNum < 232 then
         map_entity:set_treasure("consumables/magic_jar", 2, nil)
      elseif RandNum > 232 and RandNum < 234 then
         map_entity:set_treasure("consumables/fairy", 1, nil)
      end
   end
end

return RNGdrop