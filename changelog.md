# Changelog

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda : A Link to the Past (Solarus Edition) 0.5.0

`Changes from February 26, 2025` v0.5.0

🗺**Overworld**
- __Dark World__: Creation of the general map.
  * Division of the **Overworld** into different zones, fully playable with **generic Enemies** using the **Master Sword**.
  * All **Caves** (some are generic) with **Silver Arrows**, **Golden Quiver**, **Golden Sword**.
  * All **Houses** (some are generic) with **Red Shield**.
  * 9 Generic **Dungeons**: **Palace of Darkness**, **Swamp Palace**, **Skull Woods**, **Thieves Town**, **Ice Palace**, **Misery Mire**, **Turtle Rock**, **Ganon’s Tower**, and **Pyramid of Power**.

🗺**Dark World Dungeons**
  * Added **Items** in **each Dungeon**: **Hammer**, **Hookshot**, **Fire Rod**, **Titan’s Mitt**, **Red and Blue Tunics**, **Cane of Somaria**, **Mirror Shield**. (Some are generic)
  * 7 Generic **Bosses** in the **first 7 Dungeons**.

🗺**Ganon’s Tower**
  * **Agahnim** and his clones with Dialogues, Behavior, and Final Teleportation to the **Pyramid of Power**.

🗺**Pyramid of Power**
  * **Ganon** with a unique pattern while awaiting the real **Alttp** battle.

- __Light World__:
  * Added parallax effect in **Death Mountain**.
  * Modified access to **Warps** for the **Dark World**.
  * Added **Musician** and his **Ocarina** (Flute from **Alttp**) that plays music.
  * Fixed **Houses** on the exterior (Layer issue).

🗺**Hyrule Tower**
- Added **Golden Chain&Ball Knight**.
- Added **Sword Knights** and **Spear Knights**.
- Added Boss **Agahnim**, his Introduction (temporary FX), Dialogues, Behavior, and Teleportation to the **Dark World**.

🪄**Items**
- **Cane of Somaria**: Creates a **Red Block**, pushable, liftable, and destructible, which sends projectiles that deal damage in all 4 directions. (No mobile platform yet)
- **Hammer**: Allows **hitting stakes** that block the player in various locations throughout the game.
- **Hookshot**: **Grabs certain objects** (blocks, vases) allowing access to certain places in the game.
- **Fire Rod**: Creates a **fireball that damages** enemies and **lights torches from a distance**.
- **Titan’s Mitt**: Allows the player to lift **Black Stones** (heavier).
- **Red and Blue Tunics**: **Reduces damage** taken from enemies by **Link**.
- **Tempered and Golden Sword**: **Increases damage dealt** by **Link**.
- **Silver Arrows** and their **Quiver**: Essential for fighting **Ganon**.
- **Mirror Shield**: Does nothing extra for now.
- **Ocarina**: Plays **Music**. (That’s all for now)

👾**Enemies**
- **Sword Knight**: A knight that charges towards **Link**, with **Sword Raised**.
- **Spear Knight**: A knight that **throws Spears** at **Link**.
- **Golden Chain&Ball Knight**: Much more resistant, swings his **Golden Chain&Ball** and throws it at **Link**.
- **Blue and Red Taros**: Dark Knight, charges with a Spear at **Link**.
- **Stals**: Skull that hides among real skulls and attacks **when approached**.
- **Hinox**: A **Giant Monster** that **throws bombs**. (Not functional yet)
- **Moblin**: A **Pig-Man** that roams and **throws Spears**. (Not functional yet)
- **Snap Dragon**: Enemy with a **Large Jaw** that **moves diagonally**.
- **Blue Bari**: **Electric Medusa** that floats and moves randomly, it **electrifies for a short time**, making it risky to attack.
- **Green and Red Goriya**: Moves in **Mirror of Link**. The **Red** one spits **Flames**.
- **Blue Zazzak**: **Alligator Knight** that moves randomly and is quite resistant.
- **Zol**: Comes out of the ground, **advances and hops**.
- Boss **Agahnim 1**: Appears from a shadow sphere and charges one of three attacks: A **Large Ball** that can be reflected, a **Magic Circle** that splits into 6 smaller balls, and a **Chain Lightning** (always from the North).
- Boss **Agahnim 2**: Similar to Agahnim but spawns **Two Clones**.
- Boss **Ganon**: The **Evil Boar** that must be immobilized by a **Silver Arrow** and hit with the **Sword**. (Temporary pattern while waiting for the final behavior).

💬**Dialogues**
- **Cane of Somaria**: Item acquisition: *_treasure.inventory/cane_of_somaria.1*
- **Cane of Byrna**: Item acquisition: *_treasure.inventory/cane_of_byrna.1*
- **Hammer**: Item acquisition: *_treasure.inventory/hammer.1*
- **Hookshot**: Item acquisition: *_treasure.inventory/hookshot.1*
- **Fire Rod**: Item acquisition: *_treasure.inventory/fire_rod.1*
- **Titan’s Mitt**: Item acquisition: *_treasure.equipment/glove.2*
- **Red and Blue Tunics**: Item acquisition: *_treasure.equipment/tunic.2* and *_treasure.equipment/tunic.3*
- **Tempered and Golden Sword**: Item acquisition: *_treasure.equipment/sword.3* and *_treasure.equipment/sword.4*
- **Silver Arrows**: Item acquisition: *_treasure.inventory/bow.2*
- **Mirror Shield**: Item acquisition: *_treasure.equipment/shield.3*
- **Ocarina**: Item acquisition: *_treasure.inventory/ocarina.1*
- **Fire Medallion**: Item acquisition: *_treasure.inventory/bombos_medallion.1*
- **Ether Medallion**: Item acquisition: *_treasure.inventory/ether_medallion.1*
- **Earthquake Medallion**: Item acquisition: *_treasure.inventory/quake_medallion.1*
- **Fire Medallion Stele**: Read with and without the **Book of Mudora**: *crypted.bombos_stele* and *uncrypted.bombos_stele*
- **Ether Medallion Stele**: Read with and without the **Book of Mudora**: *crypted.ether_stele* and *uncrypted.ether_stele*
- **Zelda**: **Princess Zelda** gets **captured at the Sanctuary** right after acquiring **Master Sword**: *npc.zelda.call_for_help*
- **Priest**: The Priest is dying after **Zelda’s capture**: *npc.priest.dying*
- **Sahasrahla**: Various dialogues:
  * **Link** discovers the **Dark World** for the **First time**: *npc.sahasrahla.dark_world*
  * **Telepathic Stone** at the **Thieves Town**: *ts.hint_thieves_town*
  * **Telepathic Stone** at the **Ice Palace**: *ts.hint_ice_palace_1*, *ts.hint_ice_palace_2*, and *ts.hint_ice_palace_3*
  * **Telepathic Stone** at the **Misery Mire**: *ts.hint_misery_mire*
  * **Telepathic Stone** at the **Pyramid of Power**: *ts.hint_pyramid_of_power*
- **Light Agahnim**:
  * Just before and after the **Ritual** on **Princess Zelda**: *enemy.agahnim1.after_ritual* and *enemy.agahnim1.after_ritual*
  * **Introduction** and **End of Combat** at the **Top of Hyrule Tower**: *enemy.agahnim1.introduction* and *enemy.agahnim1.defeated*
- **Dark Agahnim**: **Introduction** at the **Top of Ganon’s Tower**: *agahnim2.introduction*.
- **Ganon**: **Combat Introduction** and **Combat Interlude**: *enemy.ganon.*.
- **Triforce**: Endgame Dialogue: *end.triforce*

🖼️**Sprites**
- Added **Agahnim Projection** Sprites: *agahnim_projo_1.dat*, *agahnim_projo_2.dat*, and *agahnim_projo_3.dat*.
- Added **Chain& Ball Golden Knight** Sprites: *agahnim_projo_1.dat*, *agahnim_projo_2.dat*, and *agahnim_projo_3.dat*.
- Added Sprites for **Sword 3 and 4**: *sword_star3.dat*, *sword_star4.dat*.
- Modified and Added **Dark World and Dungeon Stakes**: *hammer_stake_dark.dat*, *hammer_stake_dungeon.dat*, and *hammer_stake_light.dat*.

🎵**Sounds and Music**
- Added **Electric Sounds** for **Agahnim**: *electrical_shock_1.ogg*, *electrical_shock_2.ogg*, *ritual_shock.ogg*, and *link_shocked.ogg*.
- Added sounds for **Ganon** and **Agahnim**: *agahnim_dash.ogg* and *bat_crash.ogg*.
- Added sounds for **Ocarina**: *ocarina.ogg* and *ocarina_complet.ogg*.

📱**HUD**
- Modified the **Game Over screen in English**.

☠️**Enemy Fixes**
- Fixed **Movement Speed** of certain **Enemies**.
- Fixed **Detection** for **Stals**.

📟**Script**
- Fixed error in __debug.lua__ (Developer only).
- Edited __dungeon_infos.lua__ for **Map and Compass** in the future.
- Added __random_drop.lua__ (randomization of loot in Overworld and generic dungeons).

🗃**Organization** (Developer only)
- Added **place_holder/store_blueprint** for **Overworld**: *Archived/Other/blue_print/A Link to the Past/World/Overworld/COORDONNEE_MAPNAME* (Developer only).
- Added **place_holder/store_blueprint** for **House**: *Archived/Other/blue_print/A Link to the Past/World/Houses/HOUSENAME* (Developer only).
- Added **place_holder/store_blueprint** for **Cave**: *Archived/Other/blue_print/A Link to the Past/World/Caves/CAVENAME* (Developer only).
- Added **place_holder/store_blueprint** for **Dungeon**: *Archived/Other/blue_print/A Link to the Past/World/Dungeons/DUNGEONNAME/FLOOR/FLOOR_DUNGEONNAME* (Developer only).
- Fixed and Adjusted the **Secret Room** and its **Dimensional Room** for teleporting anywhere in the game (Developer only).

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda : A Link to the Past (Solarus Edition) 0.4.1

`Changes  for December 10, 2024` v0.4.1 (hotfix)

🗺**Overworld**
- __Light World__:
  * Added all available **Overworld Enemies** (Some enemies temporarily replaced by others while waiting for final sprites).
  * Fixed **Grass** not making a sound when cut.
  * Fixed and added **Missing Tiles**.

🗺**Kakariko Village**
- Fixed **Jumpers** causing a **SoftLock** in a wall.
- Fixed roofs and house doors, allowing the Hero to enter houses.
- Added the **Book of Mudora** unlockable by charging on top of the **Bookshelf** of the **Library** in the village using **Pegasus Shoes**.

🗺**Desert of Mystery**
- Added NPC **Aginah** in his **Cave** with dialogues.
- The **Book of Mudora** now serves to read the **Engraved Stone** and unlock access to the **Desert Palace** dungeon.

🗺**Death Mountain**
- Added the **Lost Old Man** in the **Cave** who follows you, with his **Dialogues**.
- Added the **Magic Mirror**, which works specifically in the **West Mountain** and dungeons.
- Added **Bunny Link**, in a pseudo **Dark World**.
- Added a **Transition between the two Worlds** with the **Teleporter** in the **West Mountain** (Teleport to **Dark World**) and the **Magic Mirror** (Return to **Light World**).

🗺**Lake Hylia**
- Modified the **Ice Rod Cave**, and added the **Ice Rod**.
- Added a **Missing Cave** under a **Large Rock**.

🗺**Great Swamp**
- Modified a **Cave** in the **Great Swamp** (**It's a Secret**).

🗺**Lost Woods**
- Removed the **Thick Mist** and added a clearing effect when the **Master Sword**  is removed.
- The **Music** changes after this event.

🗺**Sacred Grove**
- The **Master Sword** can now be removed from the **Pedestal** with a small cutscene and **Dialogue**.
- The **Engraved Stones** can now be deciphered with the **Book of Mudora**.
- The **Thick Mist** is removed after **Master Sword** is taken from its pedestal.

🪄**Items**
- **Magic Mirror**: Allows you to **Return** to the **Light World** or to a **Dungeon Entrance**.
- **Book of Mudora**: Allows you to **Read** the **Engraved Stones** (Ancient Hylian).
- **Ice Rod**: Allows you to **Throw** an **Ice Breath** (currently only deals damage).

👾**Enemies**
- **Cuccos**: **Chicken** that wander around and get angry when hit too many times.
- **Armos**: A stone enemy that **wakes up and charges** towards **Link** when he's too close.
- **Octorok**: **Shoots Rocks** in front of him, which can hurt **Link**.
- **Sand Crabs**: Moves like a crab, literally.
- **Crow**: Flies and charges at **Link**, then runs away.
- **Vulture**: Flies in a circle around him, gradually getting closer.
- **Zora**: Shoots small **Fireballs** from **deep waters** or walks slowly toward **Link** on **land**.

💬**Dialogues**
- **Magic Mirror**: Obtaining the item: *_treasure.inventory/magic_mirror.1*
- **Book of Mudora**: Obtaining the item: *_treasure.equipment/book_of_mudora.1* (to be modified to **inventory** later)
- **Ice Rod**: Obtaining the item: *_treasure.inventory/ice_rod.1*
- **Sacred Grove Stone**: Read with and without the **Book of Mudora**: *crypted.grove_stone* and *crypted.grove_stone*
- **Sign**: Sign of the **Exit Cave** of **Death Mountain**: *sign.death_mountain_west*
- **Lost Old Man**: Various Dialogues:
  * When meeting him for the **first time** in the **Dark Cave**: *npc.grandpa.first_meeting*
  * While escorting him in the **Dark Cave**: *npc.grandpa.warning_hole*, *npc.grandpa.pot_heart*, and *npc.grandpa.turn_right*
  * When arriving **at his home**: *npc.grandpa.arrived*
  * When he is **at home**, with and without the **Moon Pearl**: *npc.grandpa.at_home* and *npc.grandpa.moon_perl*
- **The Tyrant**: Dialogue in the **Dark World**, with and without the **Moon Pearl**: *npc.cursed_bully.meeting* and *npc.cursed_bully.moon_pearl*
- **Pink Ball**: Dialogue in the **Dark World**, with and without the **Moon Pearl**: *npc.pink_ball.meeting* and *npc.pink_ball.moon_pearl*
- **Aginah**: Various Dialogues:
  * First encounter with Aginah: *npc.aginah.first_meeting*
  * When you have the **Book of Mudora**: *npc.aginah.book_of_mudora*
  * After getting the pendant from the **Desert Palace**: *npc.aginah.after_pendant*
- **The Thief**: It's a secret: *npc.thief.it_s_a_secret*
- **Sahasrahla**: Obtaining the **Master Sword**: *npc.sahasrahla.master_sword*

💬**Translation**
- Translated all texts and images for the **English Version**.

🖼️**Sprites**
- Added **Cuccos**: *chicken.dat*
- Added **Armos**: *armos.dat*
- Added **Octorok**: *octorok.dat*
- Added **Sand Crabs**: *sand_crab.dat*
- Added **Crows**: *crow.dat*
- Added **Vultures**: *vulture.dat*
- Added **Zoras**: *zora.dat* and *zora_underwater*
- Added **Bunny Link**: *bunny.dat*
- Added **Master Sword** stuck in the pedestal: *excalibur.dat* (to be modified later)

☠️**Enemy Fixes**
- Fixed **Damage Taken** from **Thrown Objects** by **Enemies**.
- Fixed **Health Points** of some **Enemies**.
- Fixed **Hitbox** for **Beemos** and **Armos**.

📟**Script**
- __stone_big_white.lua__ Added the ability to **Lift** **Large White Stones**.
- __stone_explode.lua__ Added the ability to **Destroy** **Stacked Stones** by **Charging** with **Pegasus Shoes**.

🎮**GameFix**
- **Magic Items** no longer refill **Magic**.
- Added **Bombs** to the inventory when opening a chest with bombs inside.

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda : A Link to the Past (Solarus Edition) 0.4.0

`Changes from November 28, 2024` v0.4.0

🗺**Overworld**
- __Light World__:
  * Added **Desert Palace**.
  * Added **Tower of Hera**.

🗺**Desert Palace**
- Added a key that falls from the torch with the **Pegasus Shoes**.
- Added **Power Glove**.
- Added **Green** & **Purple Leevers**, **Mini Moldorm**, **Red Devalant** and its **Quicksand**, and **Beemos**.
- Added the Boss **Lanmolas**, its reward, and its Pendant.
- Added a system to **Shake the Camera**.
- Added New **Item Drops** for the **New Enemies** (Prize Packs).
- Added **Dialogues** for **Sahasrahla**, **Power Glove**.

🗺**Tower of Hera**
- Added the **Moon Pearl** without behavior/code.
- Added **Blue** & **Red Hardhat Beetles**, **Red Skeletons**, and **Kodongo**.
- Added **Spark**, **Fire Bar**, and **Bumper**.
- Added **Star Switch**.
- Added the Boss **Moldorm**, its reward, and its Pendant.
- Added New **Item Drops** for the **New Enemies** (Prize Packs).
- Added **Dialogues** for **Sahasrahla**.

🗺**East Ruins**
- Added **Dialogues** for **Sahasrahla**.
- **Sahasrahla** gives the **Pegasus Shoes** after retrieving the first Pendant.

🪄**Items**
- **Power Glove**: Allows you to lift **White Stones**.
- **Moon Pearl**: Allows **Link** to **no longer be a Rabbit** in the **Dark World**.

👾**Enemies**
- **Blue Archer Soldier**: Roams around, retreats when it detects **Link**, then **shoots arrows** and repositions.
- **Red Skeleton**: Moves randomly, **jumps back** when **Link** attacks, and **throws a bone**.
- **Blue & Red Hardhat Beetles**: **Repel Link** when hit by the sword.
- **Green & Purple Leevers**: Emerge from the sand and charge at **Link**, then return to the sand. Only **Movement Speed** changes between the **Swap Colors**.
- **Mini Moldorm**: A small, round worm that bounces off the edges.
- **Red Devalant** and its **Quicksand**: Emerges from quicksand (fixed position) and spits small fireballs.
- **Beemos**: **360° Turret** that **fires lasers**.
- **Kodongo**: Moves, stops, and spits fireballs.
- **Spark**: Circles around the edges, **sparkling**, and damages if **Link** touches it.
- **Fire Bar**: 4 **Fireballs** that spin around a block and damage if **Link** touches them.
- **Bumper**: Repels **Link** if he touches it with its hitbox.
- **Star Switch**: Changes the positions of the **Holes**.
- Boss **Lanmolas**: 3 **Sandworms** that burst from the ground, throw stones in 4 directions (8 directions when only one remains), then dive back in. Hitbox for **Link's Sword** on their **heads**.
- Boss **Moldorm**: A worm that moves randomly and bounces off edges. Repels **Link** if his sword touches the head. Hitbox for **Link's Sword** on its **tail**.

💬**Dialogues**
- **Power Glove**: Obtaining the item: *_treasure.equipment/glove.1*
- **Moon Pearl**: Obtaining the item: *_treasure.equipment/moon_pearl.1*
- **Map**: Obtaining the item: *_treasure.dungeons/map.1*
- **Compass**: Obtaining the item: *_treasure.dungeons/compass.1*
- **Desert Stele**: Read with and without the **Book of Mudora**: : *crypted.desert_stone* and *crypted.desert_stone*
- **Sahasrahla**:
  * **Telepathic Stone** for the **Desert Palace**: *ts.hint_desert*
  * **Telepathic Stone** for the **Tower of Hera**: *ts.hint_hera1* and *ts.hint_hera_2*

🖼️**Sprites**
- Added **Blue Archer Soldier** : *soldier_archer.dat* and *soldier_archer_projectile.dat*
- Added **Green** & **Purple Leevers** : *leever_green.dat* and *leever_red.dat*
- Added **Mini Moldorm** : *mini_moldorm.dat* and *mini_moldorm_tail.dat*
- Added **Beemos** : *beemos.dat* and *beemos_laser.dat*
- Added **Blue** & **Red Hardhat Beetles** : *hardhat_beetle_blue.dat* and *hardhat_beetle_red.dat*
- Added **Red Skeletons** : *skeleton_red.dat* and *skeleton_bone.dat*
- Added **Kodongo** : *kodongo.dat* and *kodondo_flame.dat*
- Added **Quicksand**, **Red Devalant** & **Purple** : *quicksand.dat*, *devalant_blue.dat* and *devalant_red.dat*
- Added **Spark** and **Fire Bar** : *spark.dat* and *fire_bar.dat*
- Added **Bumper** and **Star Switch** : *bumber.dat* and **switch_star.dat*

☠️**Enemy Fixes**
- Fixed issues with the timing of **EyeGores** sleep and detection.

📟**Script**
- Added meta/__camera.lua__.

🧠**Debug**
- __Secret Room__: Teleportation to a **Secret Room** with the "," key (Developer only).
- __Boss Room__: Teleportation to a **Secret Room** for Bosses with the "=" key (Developer only).
- __Enemies Room__: Teleportation to a **Secret Room** for Enemies with the ")" key (Developer only).

🗃**Organization**
- Added a **Boss Room** *Secret Room/Boss/boss_choiche_room* (Developer only).
- Added an **Enemies Room** *Secret Room/Enemies/enemies_choiche_room* (Developer only).

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda : A Link to the Past (Solarus Edition) 0.3.0

`Changes from June 20, 2024` v0.3.0

🗺**Overworld**
- __Light World__:
  * Added **Hyrule Castle Cave**.
  * Added **Hyrule Castle**.
  * Added **Secret Passage**.

🗺**Link's House**
- Added **Friendly Guards** blocking access to the **Overworld** during the game's introduction.
- Added **Rain**, **Twilight** effects.
- Added **Rain Sound**.
- Added **Guards' Dialogues**, and the **Signboard**.

🗺**Hyrule Castle**
- Added **Destructible Curtains**.
- Added **Guards' Dialogues**, and **Zelda's** dialogue.
- Added different **Blue** & **Green Soldiers**.
- Added the **Hyrule Castle Cave** where **Uncle** is located.
- Added **Electric Barrier** preventing access to the **Hyrule Tower**.
- Added the **Boomerang**.
- Added the **Mini-Boss** **Chain&Ball Knight** guarding **Princess Zelda**.
- Added the **Escort Quest** for **Zelda** from the Castle to the Sanctuary.
- Added the **Pushable Emblem** with Zelda to enter the **Secret Passage**.

🗺**Secret Passage**
- Added **Rats**, **Keeses**, & **Snakes**.
- Added **Pull Levers**.

🗺**Sanctuary**
- Added **Zelda** and the **Priest** Dialogues.
- Added the **Heart Container** in the chest.

🗺**House**
- __Link's House__: **Link** starts asleep in his bed, **Zelda** speaks to us via telepathy, and **Link's Uncle** leaves the house.

🪄**Items**
- **Boomerang**: Allows you to throw a **Boomerang** that returns after a maximum distance or upon hitting something. **Freezes** certain enemies.

👾**Enemies**
- **Rat**: Roams around and damages **Link** upon contact.
- **Keese**: Flies in the air toward **Link**.
- **Snake**: Roams around and accelerates towards **Link**, dealing damage on contact.
- **Blind Green Soldier**: Moves randomly.
- **Green and Blue Soldiers**: Move, detect **Link**, then charge towards him.
- **Electric Barrier**: **Electrocutes Link** on contact or if struck by a sword weaker than **Master Sword**. Blocks access to **Hyrule Tower**.
- Mini-Boss **Chain&Ball Knight**: Spins and throws his **Chain&Ball Chain** at **Link**.

💬**Dialogues**
- **Link's Uncle**: Various Dialogues:
  * **Uncle Leaving** Link's House: *escape.uncle*
  * **Uncle's Death**: *escape.uncle_dead*
- **Signboard**: Signboard in front of **Hyrule Castle** during and after the **Introduction**: *sign.default*, *sign.escape*
- **Guards**: Various Dialogues:
  * **Guard Taunts** or **Guard Tutorial**: *escape.soldiers.1*, *escape.soldiers.2*, *escape.soldiers.3*, *escape.soldiers.4*, *escape.soldiers.5*, *escape.soldiers.6*, *escape.soldiers.7*
  * **Guard Taunt** at the **Entrance of Hyrule Castle**: *escape.soldiers.front_castle*
  * The Guard on the **Castle Roof** gives **Lore**/**Context of Events**: *escape.soldiers.tower*
- **Zelda**: Various Dialogues:
  * **Telepathic Introduction** of **Princess Zelda**: *escape.intro*
  * If **Link takes too long** to find the **secret cave** to enter **Hyrule Castle**: *escape.zelda_backseat*
  * When **Link rescues Zelda** from her **Cell**: *escape.zelda_rescued*, *escape.zelda_rescued_question*, and *escape.zelda_rescued_yes*
  * During the **escort of Princess Zelda**: *escape.zelda_following_1*, *escape.zelda_following_2*, *escape.zelda_following_3*, *escape.zelda_following_4*, and *escape.zelda_following_5*
  * Upon **Princess Zelda's arrival** at the **Sanctuary**: *escape.end_2*
  * Default dialogue **after rescuing** **Princess Zelda**: *sanctuary.zelda_default*
- **Priest**:
  * Upon **Princess Zelda's arrival** at the **Sanctuary**: *escape.end_1*, *escape.end_3*
  * Default dialogue **after rescuing** **Princess Zelda**: *sanctuary.priest_default*

📱**HUD**
- Added **Music** for **Title Screen** and **Save Selection** menus.

📟**Script**
- Added __meta/map.lua__.
- Added __ceilling_drop_manager.lua__.
- Added __electric_barrier.lua__.

🗃**Organization**
- Added a **/devdata** folder (Developer only).

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda : A Link to the Past (Solarus Edition) 0.2.0

`Changes on March 28, 2024` v0.2.0

🗺 **Overworld**  
- __Light World__:  
  * Added the **Eastern Palace**.  
  * Added the **Sanctuary**.  

🗺 **Eastern Palace**  
- Added a system for **Map Transitions** (Separators that reset certain enemies).  
- Added the **Bow** and **Pegasus Shoes**.  
- Implemented a system for managing **Dark Rooms** and their lighting (**Torch/Lantern**).  
- Added **Green & Red EyeGores**, **Evil Tiles**, **Blue Skeletons**, and **Cannonballs**.  
- Added the boss **Armos Knight**, its Reward, and its Pendant.  
- Created metatables for handling **Switches**, **Small Keys**, and **Big Keys**.  
- Implemented an **Enemy Drop System** for item rewards (Prize Packs).  
- Added dialogues for **Sahasrahla**, the **Bow**, **Rupees**, **Chests**, **Small Keys**, and **Big Keys**.  

🪄 **Items**  
- **Bow**: Allows **shooting arrows** at enemies or certain switches.  
- **Pegasus Shoes**: Enables **running** until the player stops or collides with a wall (*bonk*).  
  - Deals damage to enemies on impact.  
  - Knocks down high objects.  
  - Breaks certain walls and stone piles (not yet on trees).  

👾 **Enemies**  
- **Green & Red EyeGores**:  
  - Awakens when **Link** is too close and moves toward him, **becoming vulnerable to attacks** (especially the **Bow**).  
  - **Red EyeGores** are stronger, faster, and only vulnerable to the **Bow**.  
- **Evil Tiles**: **Tiles** that rise from the ground and charge at **Link**.  
- **Blue Skeleton**: Moves randomly and **jumps backward** when attacked by **Link**.  
- **Cannonball**: Mobile cannon on **side walls** of rooms that fires projectiles in a straight line.  
- Boss **Armos Knight**:  
  - **Six large Blue Knight Statues**, vulnerable to the **Bow**, that dance and charge around the combat arena.  
  - The **last surviving knight enrages**, turns **Red**, and violently jumps toward **Link**.  

💬 **Dialogues**  
- **Bow**: Obtaining the item: *_treasure.inventory/bow.1*  
- **Pegasus Shoes**: Obtaining the item: *_treasure.equipment/pegasus_shoes.1*  
- **Rupees**: Dialogue for **Rupee Collection**:  
  *_treasure.consumables/rupee.1*, *_treasure.consumables/rupee.2*, *_treasure.consumables/rupee.3*, *_treasure.consumables/rupee.4*, *_treasure.consumables/rupee.5*, *_treasure.consumables/rupee.6*  
- **Big Chest**: If the **Player** attempts to open it **without having** the **Big Key**: *NoBigKey*  
- **Big Key Door**: If the **Player** attempts to open it **without having** a **Big Key**: *NoBigKey*  
- **Locked Door**: If the **Player** attempts to open it **without having** a **Small Key**: *NoSmallKey*  
- **Small Keys**: Dialogue for **Obtaining a Key**: *_treasure.dungeons/small_key.1*  
- **Big Keys**: Dialogue for **Obtaining a Key**: *_treasure.dungeons/big_key.1*  
- **Sahasrahla**: Various dialogues:  
  * **First Encounter**: *npc.sahasrahla.first_meeting*, *npc.sahasrahla.first_meeting_question*, *npc.sahasrahla.first_meeting_answer*  
  * After obtaining the **Eastern Palace Pendant**: *npc.sahasrahla.give_courage_pendent*  
  * After receiving the **Pegasus Shoes**: *npc.sahasrahla.pegasus_gifted*  
  * After obtaining the **Ice Rod**: *npc.sahasrahla.ice_rod*  
  * **Telepathic Stone** from the **Eastern Palace**: *ts.hint_eastern*  

🎮 **GameFix**  
- Fixed the **Game Over crash**.  

📱 **HUD**  
- Adapted the **HUD** and **Menus** to match the **A Link to the Past** format (256x224).  

🗃 **Organization**  
- Created **Blueprints** for **Light Dungeons** in the TileSets.  
- Updated **Tilesets** (for **Sanctuary**).  
- Added a **Resources/Images** folder for **Artworks**.

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda : A Link to the Past (Solarus Edition) 0.1.2  

`Changes on February 23, 2024` v0.1.2 (hotfix)  

🗺 **Overworld**  
- __Light World__:  
  * Fixed benches in **Kakariko Village**.  
  * Fixed a **Decorative Tile** overlay above **Link's House**.  

- __Dark World__:  
  - Linked all **Houses** to the **Dark World**.  

🗺 **Kakariko Village**  
- Fixed a **Jumper** that caused a **Soft Lock** inside a wall.  

🗺 **Library**  
- Fixed a **Tile** in the **Library**.  

🎮 **GameFix**  
- Fixed a **bug** with the **Joystick** in **Menus** (the **Selector** no longer behaves erratically).  
- Fixed misaligned selections in *game_manager.lua*.  
- Fixed the Player's **Health Points** in the *Savegame*.  

📱 **HUD**  
- Fixed **Health Points** display in the **HUD**.  

🗃 **Organization**  
- Created **Blueprints** for **Light Dungeons** in the Tilesets (Developer only).  
- Created **All Floors** folders and **All Floors** maps for **Light Dungeons** (Developer only).  

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda : A Link to the Past (Solarus Edition) 0.1.1  

`Changes on January 21, 2022` v0.1.1 (hotfix)  

🗺 **Overworld**  
- __Light World__: Linked all **Caves**, **Houses**, and **Dungeons** to the **Light World**.  
- __Dark World__: Linked all **Houses** to the **Dark World**.  

🗃 **Organization**  
- Created __.dat__ files for **Houses** in the **Light World** and **Dark World**.  
- Created __.dat__ files for **Caves** in the **Light World** and **Dark World**.  
- Created __.dat__ files for **Dungeons** in the **Light World** and **Dark World**.  

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda : A Link to the Past (Solarus Edition) 0.1.0

`Changes on January 14, 2022` v0.1.0

🗺 **Overworld**
- __Light World__: Created the general map  
  * Division of the **Overworld** into different zones, playable to some extent (without enemies)  

🗺 **House**  
- __Link's House__: First interior map, **Link's House**, opening to the outside world of the **Light World**  

📟 **Script**  
- Added __Debug.lua__, with shortcut keys to grant items, heal, move faster, and walk through walls (Developer only).  
- Added __Console.lua__ to enter in-game commands (Developer only).  
- Added 3 *"Custom Entities"* for **Large White Stones**, **Black Stones**, and **Breakable Stones**.  

🧠 **Debug**  
- __Secret Room__: **Secret room** filled with items, teleporters to different zones, **Houses**, **Caves**, and **Dungeons** to facilitate testing.  
- Reused **Debug/Console** scripts from **The Only One Project** (Developer only).  

🗃 **Organization**  
- Created folders in *data/maps* for **A Link to the Past**.  
    * Division of the two worlds: **Light World** and **Dark World**.  
    * Division of **Overworld**, **Houses**, **Caves**, and **Dungeons**.  
- Created folders in *data/maps* for **Archived** content.  
    * Division of **Secret Room** and **Overworlds** (Developer only).  
    * Division of **Secret Room**, **Dimension Room**, **Overworld**, **Houses**, **Caves**, and **Dungeons** (Developer only).  
- Added and modified **Logos/Icons** and **Artwork**.  
- Added and described the **ReadMe**.  