# Changelog

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda A Link to the Past (Solarus Edition) 0.5.0

`Changes on February 15, 2025` v0.5.0

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda A Link to the Past (Solarus Edition) 0.4.1

`Changes on December 10, 2024` v0.4.1 (hotfix)

 🗺**Overworld**
- __Light Overworld__
* Added all **Enemies** available in the Overworld (some temporarily replaced until proper sprites are available)
* Fixed **Grass** that did not make sound when cut
* Fixed and added **Missing Tiles**

 🗺**KaKaRiKo Village**
- Fixed **Jumpers** that caused **SoftLock** in walls.
- Fixed house roofs and doors; the hero can now enter houses
- Added the **Book of Mudora**, unlockable by dashing (with **Pegasus Boots**) into the **Bookshelves** of the **Library** in the village

 🗺**Desert of Mystery**
- Added the NPC **Aganih** in his **Cave**, with **Dialogues**
- **Book of Mudora** is now used to read the **Engraved Stone** and open access to the **Desert Palace** Dungeon

 🗺**Death Mountain**
- Added the **Lost Old Man** in the cave, who follows the hero, with **Dialogues**
- Added the **Magic Mirror**, functional in the **West Mountain** and dungeons
- Added **Bunny Link** in a pseudo **Dark World**
- Added the **Transition between the Two Worlds**
- Using the **Teleporter** in the **West Mountain** (to the Dark World)
- Using the **Magic Mirror** (to return to the Light World)

 🗺**Lake Hylia**
- Modified the **Ice Rod Cave** and added the **Ice Rod**
- Added a **Missing Cave** under a **Big Rock**

 🗺**Great Swamp**
- Modified a **Cave** in the **Great Swamp** (It's a **Secret**)

 🗺**Lost Wood**
 - Removed the **Thick Mist** and added a clearing effect after the **Master Sword** is removed
 - **Music** change after that

 🗺**Sacred Grove**
- The **Master Sword** can now be removed from its pedestal with a small cutscene and dialogue
- The **Engraved Stones** can be deciphered using the **Book of Mudora**
- Removed the **Thick Mist** after the **Master Sword** was removed from its base

 🪄**Items**
- **Magic Mirror**: Allows **Returning** to the **Light World** or to the **Entrance of a Dungeon**
- **Book of Mudora**: Allows **Reading** **Engraved Stones** (written in **Ancient Hylian**)
- **Ice Rod**: Allows **Casting a Frost Breath** (currently only applies damage)

 ☠️**Enemy Fixes**
- Fixed **Damage Taken** by **Enemies** from **Thrown Objects**
- Adjusted **Health Points** for some **Enemies**
- Fixed the **Hitbox** for **Beemos** and **Armos**

 📟**Scripts**
- `stone_big_white.lua`: Added the ability to **Lift Big White Stones**.
- `stone_explode.lua`: Added the ability to **Destroy Piled Stones** by **Charging** with the **Pegasus Boots**

 🎮**General Fixes**
- **Magic Items** no longer automatically refill **Magic**
- Add **Bombs** in Inventory when a chest contains bombs refill

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda A Link to the Past (Solarus Edition) 0.4.0

`Changes on November 28, 2024` v0.4.0

🗺**Overworld**
- __Light Overworld__:
  * Added **Desert Palace**
  * Added **Tower of Hera**

🗺**Desert Palace**
- Added a key on the torch which falls with the boots
- Added the **Power Gloves**
- Added **Leevers Purple** & **Green**, **Mini Moldorm**, **Quicksand**, **Devalant Blue** & **Red** and **Beemos**
- Added the Boss **Lanmolas**, his Reward, his Pendant
- Added System to **Shake the Camera** 
- Added new **Enemy Item Drops** (Prize Packs)
- Added Dialogues for **Sahasrahla**, **Power Gloves**

🗺**Tower of Hera**
- Added the **Moon Pearl** with no Code
- Added **Hardhat Beetle Purple** & **Green**, **Skeleton Red** and **Kodongo**
- Added **Spark** and **Firebar**
- Added **Bumper**
- Added **Switch Star**
- Added the Boss **Moldorm**, his Reward, his Pendant
- Added new **Enemy Item Drops** (Prize Packs)
- Added Dialogues for **Sahasrahla**

🗺**Eastern Ruins**
- Added **Dialogues** for **Sahasrahla**
- **Sahasrahla** give **Pegasus Shoes** after 

☠️**Ennemies Fix**
- Fix awakening and sleep timing  **Eyegore**

🖼️**Sprites**
- Added Sprites of **Soldier Archer**
- Added Sprites of **Leevers Purple** & **Green**, **Mini Moldorm** and **Beemos** 
- Added Sprites of **Kodongo**, **Hardhat Beetle Purple** & **Green** and **Skeleton Red** 
- Added Sprites of **Quicksand**, **Devalant Blue** & **Red**
- Added Sprites of **Spark** and **Firebar**
- Added Sprites of **Bumper**
- Added **Switch Star**

📟**Script**
- Added meta/__camera.lua__

🧠**Debug**
- __Secret Room__: Warp to the **General Secret Room** with ","
- __Boss Room__: Warp to the **Secret Boss Room** with "="
- __Enemies Room__: Warp to the **Secret Enemies Room** with ")"

🗃**Organization**
- Added a Secret Room/Boss/boss_choiche_room
- Added a Secret Room/Enemies/enemies_choiche_room

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda A Link to the Past (Solarus Edition) 0.3.0

`Changes on June 20, 2024` v0.3.0

🗺**Overworld**
- __Light Overworld__:
  * Added **Hyrule Castle Cave**
  * Added **Hyrule Castle**
  * Added the **Secret Passage**

🗺**Link House**
- Added friendly **Guards** blocking access to the **Overworld** during the game Introduction
- Added **Rain**, **Gloom**
- Added **Rain Sound**
- Added **Dialogue** for **Guards**, **Sign**

🗺**Hyrule Castle**
- Added **Destructible Curtain**
- Added **Dialogue** for **Guards**, **Zelda**
- Added various **Blue** & **Green Soldiers**
- Added **Hyrule Castle Cave** where the **Uncle** is located
- Added the **Electric Barrier** preventing access to **Hyrule Tower**
- Added the **Boomerang**
- Added **Mini-Boss Knight Chain & Ball** guarding **Princess Zelda**
- Added the quest to **Escort Zelda** from the Castle to the Sanctuary
- Added the **Pushable Emblem** with Zelda to enter the **Secret Passage**

🗺**Secret Passage**
- Added **Rats**, **Keeses** & **Ropes**
- Added **Levers to Pull**

🗺**Sanctuary**
- Added **Dialogues** for **Zelda** and the **Priest**
- Added the **Heart Container** in the chest

🗺**House**
- __Link's House__: Link starts asleep in his bed, Zelda talks to him telepathically, and Link's Uncle goes outside

📱**HUD**
- Added **Music** for **Title Screen** and **Savegames Menus**

📟**Script**
- Added meta/__map.lua__
- Added __ceiling_drop_manager.lua__
- Added __electric_barrier.lua__

🗃**Organization**
- Added a **/devdata** folder for **Developers**

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda A Link to the Past (Solarus Edition) 0.2.0

`Changes on March 28, 2024` v0.2.0  

🗺**Overworld**
- __Light Overworld__:
  * Added **Eastern Palace**
  * Added **Sanctuary**

🗺**Eastern Palace**
- Added a System for Map Transitions (Separator that resets certain enemies)
- Added the **Bow** and **Pegasus Boots**
- Added Systems for Managing Dark Rooms and their Lighting (Torch/Lantern)
- Added **EyeGores Red** & **Green**, **Evil Tiles**, **Skeletons**, and **Cannonballs**
- Added the Boss **Armos Knight**, his Reward, his Pendant
- Management metatables for **Switches**, **Small Keys** & **Boss Keys**
- Added a System for Managing **Enemy Item Drops** (Prize Packs)
- Added Dialogues for **Sahasrahla**, the **Bow**, **Rupees**, **Chests**, **Small Keys** & **Boss Keys**

🎮**GameFix**
- Fixed Game Over Crash

📱**HUD**
- Adapted the HUD, Menus to the **A Link to the Past** format (256x224)

🗃**Organization**
- Created **Blueprints** for **Light Dungeons** in TileSets
- Updated Tilesets (for **Sanctuary**)
- Added a **Resources/Images** Folder for **Artworks**

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda A Link to the Past (Solarus Edition) 0.1.2

`Changes on February 23, 2024` v0.1.2 (hotfix)

🗺**Overworld**
- __Light Overworld__:
  * Fixed the Benches in Kakariko
  * Fixed a Decorative Tile Overlay above Link's House

- __Dark Overworld__: Linked all Houses to the Dark World

🗺**Kakariko Village**
- Fixed a Jumper causing a SoftLock in a Wall

🗺**Library**
- Fixed a Tile in the Library

🎮**GameFix**
- Fixed a Bug with the Controller Joystick in the Menus (The Selector no longer goes crazy)
- Fixed Offset Choices in *game_manager.lua*
- Fixed Player Health Points in the Savegame

📱**HUD**
- Fixed the Display of Health Points in the HUD

🗃**Organization**
- Created Blueprints for Light Dungeons in TileSets
- Created All Floors and Map All Floors Folders for Light Dungeons

__--------------------------------------------------------------------------------------------------------------__

`Changes on January 21, 2022` v0.1.1 (hotfix)

🗺**Overworld**
- __Light Overworld__: Links to all Caves, Houses, and Dungeons in the Light World
- __Dark Overworld__: Links to all Houses in the Dark World

🗃**Organization**
- Created .dat Files for Light World and Dark World Houses
- Created .dat Files for Light World and Dark World Caves
- Created .dat Files for Light World and Dark World Dungeons

__--------------------------------------------------------------------------------------------------------------__

`Changes on January 14, 2022` v0.1.0  

🗺**Overworld**
- __Light Overworld__: Created the general map
  * Division of the Overworld into different zones, playable to some extent (without enemies)

🗺**House**
- __Link's House__: First interior map, Link's house opening to the outside world

📟**Script**
- Added __Debug.lua__
- Added __Console.lua__
- Added 3 "Custom Entities" for Large White, Black, and Breakable Stones

🧠**Debug**
- __Secret Room__: Secret room with lots of items, teleporters to various zones, houses, caves, and dungeons for easier testing
- Reused Debug/Console Scripts from The Only One Project

🗃**Organization**
- Created Folders in data/maps A Link to the Past
    * Division of Light and Dark Overworlds
    * Division of Overworld, Houses, Caves, Dungeons
- Created Folders in data/maps Archived
    * Division of Secret Room and Overworlds
    * Division of Secret Dimension, Overworld, Houses, Caves, Dungeons
- Added and Modified Logos/Icons and Artwork
- Added and Described the README
