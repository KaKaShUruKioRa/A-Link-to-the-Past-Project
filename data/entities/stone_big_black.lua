-- Lua script of custom self big_stone_black.
-- This script is executed every time a custom self with this model is created.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local self = ...
local game = self:get_game()
local map = self:get_map()
local hero = map:get_hero()

local handled = false

local big_lifting = sol.state.create("big_lifting")

local x_big_stone, y_big_stone
local distance_hero_from_big_stone 
local angle_hero_from_bigstone   
--Variable pour vérifié si link est encore en big_lifting ou non (pour hero:on_state_changing)
local hero_state_name, hero_state = hero:get_state()

big_lifting:set_can_control_direction(false)
big_lifting:set_can_control_movement(false)
big_lifting:set_can_use_sword(false)
big_lifting:set_can_use_item(false)
big_lifting:set_can_grab(false)
big_lifting:set_can_interact(false)
big_lifting:set_carried_object_action("throw")

-- Event called when the custom self is initialized.
function self:on_created()
  self:set_traversable_by(false)
  self:set_drawn_in_y_order(true)
  self:set_weight(2)
end

local function throw_big_stone()
  handled = true
  --Mise à jour de la position de la pierre
  local x_self, y_self = self:get_position()
  
  --Nouvelle position de la Grosse Pierre Jetée selon l'angle de Link
  if angle_hero_from_bigstone == 0 then
    self:set_position(x_self + (2*width_big_stone), y_self)
  elseif angle_hero_from_bigstone == 1 then
    self:set_position(x_self, y_self - (2*height_big_stone))
  elseif angle_hero_from_bigstone == 2 then
    self:set_position(x_self - (2*width_big_stone), y_self)
  elseif angle_hero_from_bigstone == 3 then
    self:set_position(x_self, y_self + (2*height_big_stone))
  else
    ERROR("Calcul distance hero from self a échoué")
  end
  
  sol.audio.play_sound("stone")

  --Mise à jour de la position de la pierre
  x_self, y_self = self:get_position()
  -- Toutes les entités de type ennemies se trouvant à proximité de la Grosse Pierre sont blessé
  for self_near_stone in map:get_entities_in_rectangle(x_self-32, y_self-32, 64, 64) do
    if self_near_stone:get_type() == "enemy" then
      self_near_stone:hurt(8)
    end
  end

  --Variable pour vérifier si link est encore en big_lifting ou non (pour hero:on_state_changing)
  hero_state_name, hero_state = hero:get_state()
  --Destruction de la Pierre après l'animation Destroy, libération du Hero et retour à la Free State
  self:get_sprite():set_animation("destroy", function()
    self:remove()
    hero:unfreeze()
  end)
end

function self:on_interaction() 
  if game:has_item("equipment/glove") and game:get_ability("lift") > 1 then
    local x_hero, y_hero, layer_hero = hero:get_position()
    local x_origin_hero, y_origin_hero = hero:get_origin()

    width_big_stone, height_big_stone = self:get_size()
    x_center_big_stone, y_center__big_stone = self:get_center_position()

    angle_hero_from_bigstone = hero:get_direction4_to(x_center_big_stone, y_center__big_stone)

    hero:start_state(big_lifting)
    --Variable pour vérifié si link est encore en big_lifting ou non (pour hero:on_state_changing)
    hero_state_name, hero_state = hero:get_state()

    sol.audio.play_sound("lift")
    stone_big_white_sprite = self:get_sprite()
    stone_big_white_sprite:set_animation("walking")
    hero:set_animation("lifting", function()
      self:set_position(x_hero-(width_big_stone/2) + x_origin_hero, y_hero-(height_big_stone/2) - y_origin_hero, layer_hero+1)
      hero:set_animation("carrying_stopped")
      stone_big_white_sprite:set_animation("stopped")
    end)
  else 
    hero:start_grabbing()
  end
end

function big_lifting:on_command_pressed(command)    
  if command == "action" and handled == false then
    sol.audio.play_sound("throw")
    hero:set_animation("rod", throw_big_stone())
  end
end

-- Si un ennemi touche link alors qu'il porte une grosse pierre...
-- Il jète autoamtiquement la pierre et prends des dégats hero:start_hurt()
-- Error: Entity state 'custom' did not stop properly to let state 'hurt' go, it started state 'hurt' instead. State 'hurt' will be forced
function hero:on_state_changing(state_name, next_state_name) 
  if state_name == "custom" and next_state_name == "hurt" then
    if hero_state:get_description() == "big_lifting" and handled == false then
      sol.audio.play_sound("throw")
      throw_big_stone()      
    end
  end
end