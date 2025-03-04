# Changelog

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda : A Link to the Past (Solarus Edition) 0.5.0

`Changements du 26 Février 2025` v0.5.0

 🗺**Overworld**
- __Monde des Ténèbres__ : Création de la carte générale.
  * Répartition de l'**Overworld** en différente zone, totalement jouable avec des **Ennemis** génériques avec **Epée Trempée**.
  * Toutes les **Grottes** (certaines sont génériques) avec **Flèches d'Argent**, **Carquois Dorée**, **Epée Dorée**.
  * Toutes les **Maisons** (certaines sont génériques) avec **Bouclier Rouge**.
  * **9 Donjons** génériques : **Palais des Ténèbres**, **Palais des Marécages **, **Palais des Squelettes **, **Palais des Gargouilles**, **Palais des Glaces **, **Palais des Démons**, **Palais du Rocher de la Tortue**, **Tour de Ganon** et **Pyrmide du Pouvoir**.
  * 

🗺**Donjons Monde des Ténèbres**
  * Ajout des **Objets** dans **chaque Donjon** : **Marteau**, **Grappin**, **Baguette de Feu**, **Moufle du Titan**, **Tuniques Rouge** et **Bleu**, **Canne de Somaria**, **Bouclier Miroir**. (certains sont générique)
  * **7 Boss** génériques dans les **7 premiers Donjons**.
  
🗺**Tour de Ganon**
  * **Agahnim** et ses clones avec ses Dialogues, son Comportement, et la Téléportation Finale à la **Pyramide du Pouvoir**.

🗺**Pyramide du Pouvoir**
  * **Ganon** avec un pattern unique en attendant le vrai combat d'**Alttp**.
  * **Scene de Fin** avec la **Triforce** et son dialogue, et début de la **Scene de Crédit**.

- __Monde de la Lumière__:
  * Ajout de la parallaxe dans la **Montagne de la Mort**.
  * Modification des accès aux **Warps** pour le **Monde des Ténèbres**.
  * Ajout du **Musicien** et de son **Ocarina** (Flûte d'**Alttp**) qui joue de la musique.
  * Correction des **Maisons** à l'exterieur. (Problème de Layer)

🗺**Tour d'Hyrule**
- Ajout de **Chevalier d'Or à Fléau**.
- Ajout des **Chevaliers à Epée** et des **Chevaliers Lanciers**.
- Ajout du Boss **Agahnim**, son Introduction (FXs temporaires), ses Dialogues, son Comportement, et la Téléportation dans le **Monde des Ténèbres**.

🪄**Objets**
- **Canne de Somaria** : Crée un **Bloc Rouge**, poussable, soulevable et destructible qui envoie des projectiles infligeants des dégats sur les 4 côtés. (pas de plateforme mobile pour le moment)
- **Marteau** : Permet de **taper les pieux** qui bloquent le joueur à certains endroits dans tout le jeu.
- **Grappin** : **Agrippe certains objets** (blocs, vases) permettant l'accès à certains endroits du jeu.
- **Baguette de Feu** : Crée une **boule de feu qui fait des dégats** aux ennemis, et **permet d'allumer des torches à distance**.
- **Moufle du Titan** : Permet de soulever les **Pierres Noires** (plus lourde).
- **Tuniques Rouge** et **Bleu** : **Réduit les dégats** des ennemis infligés à **Link**
- **Demi Magie** : Réduit le coût des **Objets Magiques**.
- **Epée Trempée et Dorée** : **Augmente les dégats infligés** par **Link**
- **Fléches d'Argent** et son **Carquois** : Indispensable pour combattre **Ganon**.
- **Bouclier Miroir** : Ne fait rien de plus pour le moment.
- **Ocarina** : Fait de la **Musique**. (Et c'est tout pour le moment)

👾**Ennemis**
- **Chevalier à Epée** : Chevalier qui court sur **Link**, **Epée à Main Levée**.
- **Chevalier Lancier** : Chevalier qui **jète des Lances** sur **Link**.
- **Chevalier dorée à Fléau** : Bien plus résistant, qui fait tournoyer son **Fléau en or** puis le lance sur **Link**
- **Taros Bleu** et **Rouge** : Chevalier des Ténèbres, charge avec un Lance **Link**
- **Stals** : Crâne qui se cache parmis de vrai crâne et attaque **quand on s'approche de lui**.
- **Hinox** : Un **Monstre Géant** qui **balance des bombes**. (pas encore fonctionnel)
- **Moblin** : Un **Homme Cochon** qui se balade et **jète des Lances**.
- **Dragon Claquant** : Ennemi à **Grande Mâchoire** qui **se balade en diagonale**.
- **Bari Bleu** : **Méduse électrique** qui flotte et se déplace aléatoire, elle **s'électrifie quelques instants** la rendant risqué à attaquer.
- **Goriya Vert** et **Rouge** : Se déplace en **Miroir de Link**. Le **Rouge** crache des Flammes.
- **Zazzak Bleu** : **Chevalier Aligator** se déplace aléatoire et sont assez résistant.
- **Zol** : sort du sol **avance et sautille**.
- Boss **Agahnim 1** : Sors d'une sphère d'ombre et charge une des 3 attaques suivantes : Une **Grosse Boule** qui peut être renvoyées, un **Cercle de Magiques** qui peut se scinder en 6 petites boules, et une **Chaine d'Eclair** (toujours depuis le Nord)
- Boss **Agahnim 2** : Similaire à Agahnim mais fait apparaître **Deux Clones** en plus.
- Boss **Ganon** : Le **Maléfique Sanglier** qui doit être immobilisé par une **Flèche d'Argent** et frappés avec l'**Epée**. (Pattern Provisoire en attendant son vrai comportement)

💬**Dialogues**
- **Canne de Somaria** : Obtention de l'Objet : *_treasure.inventory/cane_of_somaria.1*
- **Canne de Byrna** : Obtention de l'Objet : *_treasure.inventory/cane_of_byrna.1*
- **Marteau** : Obtention de l'Objet : *_treasure.inventory/hammer.1*
- **Grappin** : Obtention de l'Objet : *_treasure.inventory/hookshot.1*
- **Baguette de Feu** : Obtention de l'Objet : *_treasure.inventory/fire_rod.1*
- **Moufle du Titan** : Obtention de l'Objet : *_treasure.equipment/glove.2*
- **Tuniques Rouge** et **Bleu** : Obtention de l'Objet : *_treasure.equipment/tunic.2* et *_treasure.equipment/tunic.3*
- **Epée Trempée et Dorée** : Obtention de l'Objet : *_treasure.equipment/sword.3* et *_treasure.equipment/sword.4*
- **Fléches d'Argent** : Obtention de l'Objet : *_treasure.inventory/bow.2*
- **Bouclier Miroir** : Obtention de l'Objet : *_treasure.equipment/shield.3*
- **Ocarina** : Obtention de l'Objet : *_treasure.inventory/ocarina.1*
- **Medallion de Feu** : Obtention de l'Objet : *_treasure.inventory/bombos_medallion.1*
- **Medaillon de l'Ether** : Obtention de l'Objet : *_treasure.inventory/ether_medallion.1*
- **Médaillon de Tremblement de Terre** : Obtention de l'Objet : *_treasure.inventory/quake_medallion.1*
- **Stèle du Médaillon de Feu** : Lire sans et avec le **Livre de Mudora** : *crypted.bombos_stele* et *uncrypted.bombos_stele*
- **Stèle du Médaillon de l'Ether** : Lire sans et avec le **Livre de Mudora** : *crypted.ether_stele* et *uncrypted.ether_stele*
- **Demi-Magie** : Dialogues du **Vampire** qui donne la **Demi-Magie** : *npc.purple_mad.after_demi_magic* et *npc.purple_mad.before_demi_magic*
- **7 Cristaux** : Différents Dialogues :
  * Dialogue du **Sage 1** à la fin du **Palais des Ténèbres** : *_treasure.quest/crystal_1.1*
  * Dialogue du **Sage 2** à la fin du **Palais des Marécages** : *_treasure.quest/crystal_2.1*
  * Dialogue du **Sage 3** à la fin du **Palais des Squelettes** : *_treasure.quest/crystal_3.1*
  * Dialogue du **Sage 4** à la fin du **Palais des Gargouilles** : *_treasure.quest/crystal_4.1*
  * Dialogue du **Sage 5** à la fin du **Palais des Glaces** : *_treasure.quest/crystal_5.1*
  * Dialogue du **Sage 6** à la fin du **Palais des Démons** : *_treasure.quest/crystal_6.1*
  * Dialogue de **Zelda** à la fin de **Palais du Rocher de la Tortue** : *_treasure.quest/crystal_7.1*
- **Zelda** : La **Princesse Zelda** se fait **capturer au Sanctuaire** juste après avoir obtenu **Excalibur** : *npc.zelda.call_for_help*
- **Prêtre** : Le Prêtre est sur le point de mourir après **la capture de Zelda** : *npc.priest.dying*
- **Sahasrahla** : Différents Dialogues :
  * **Link** découvre le **Monde des Ténèbres** pour la **Première fois** : *npc.sahasrahla.dark_world*
  * **Pierre Télépathique** du **Palais des Gargouilles** : *ts.hint_thieves_town*
  * **Pierre Télépathique** du **Palais des Glaces** : *ts.hint_ice_palace_1*, *ts.hint_ice_palace_2* et *ts.hint_ice_palace_3*
  * **Pierre Télépathique** du **Palais des Démons** : *ts.hint_misery_mire*
  * **Pierre Télépathique** de la **Pyramide du Pouvoir** : *ts.hint_pyramid_of_power*
- **Kiki** : Différents Dialogues :
  * Le Singe **échange 10 Rubis** pour nous suivre : *npc.kiki.following_question*, *npc.kiki.following_no* and *npc.kiki.following_yes*
  * Le Singe **échange 100 Rubis** pour ouvrir le **Palais des Ténèbres** : *npc.kiki.opening_question*, *npc.kiki.opening_no*and *npc.kiki.opening_yes*
  * Le Singe ne veut pas entrée dans la **Cachette Sombre** : *npc.kiki.no_entry*
- **Agahnim de Lumière** : Différents Dialogues :
  * Juste avant et après le **Rituel** sur la **Princesse Zelda** : *enemy.agahnim1.after_ritual* et *enemy.agahnim1.after_ritual*, 
  * **Introduction** et **Fin de Combat** au **Sommet de la Tour d'Hyrule** : *enemy.agahnim1.introduction* et *enemy.agahnim1.defeated*
- **Agahnim des Ténèbres** : **Introduction** **Sommet de la Tour de Ganon** : *agahnim2.introduction*,
- **Ganon** : **Introduction au Combat** et **Interlude du Combat** : *enemy.ganon.introduction* et *enemy.ganon.interlude* 
- **Trifoce** : Dialogue de **Fin Jeu** : *end.triforce*

🖼️**Sprites**
- Ajout des Sprites **Agahmnim Projection** : *agahnim_projo_1.dat*, *agahnim_projo_2.dat* et *agahnim_projo_3.dat*
- Ajout des Sprites **Chain& Ball Golden Knight** : *agahnim_projo_1.dat*, *agahnim_projo_2.dat* et *agahnim_projo_3.dat*
- Ajout des Sprites pour l'**Epée 3 et 4** : *sword_star3.dat*, *sword_star4.dat*
- Modification et Ajout des **Pieux du Monde des Ténèbres et des Donjons** : *hammer_stake_dark.dat*, *hammer_stake_dungeon.dat* et *hammer_stake_light.dat*
- Ajout d'Animation pour la **Triforce** : *triforce.dat*

🎵**Sons et Musiques**
- Ajout des sons **Electriques** pour **Agahnim** : *electrical_shock_1.ogg*, *electrical_shock_2.ogg*, *ritual_shock.ogg* et *link_shocked.ogg*
- Ajout des sons pour **Ganon** et **Agahnim** : *agahnim_dash.ogg** et *bat_crash.ogg*
- Ajout des sons pour l'**Ocarina** : *ocarina.ogg* et *ocarina_complet.ogg*
- Ajout du son des **Cristaux** et de **Sauvegarde et Quitter** : *savequit.ogg*

📱**HUD**
- Modification du **Game Over** pour la version **Anglaise**.
- Texte "**The End**" à la fin du Jeu

☠️**Corrections Ennemis**
- Correction de la **Vitesse de Déplacement** de certains **Ennemis**
- Correction de la **Détection** des **Stals**

📟**Script**
- Correction d'erreur __debug.lua__ (Développeur seulement)
- Edition du __dungeon_infos.lua__ pour la **Carte et Boussole** dans le futur
- Ajout de __random_drop.lua__ (randomisation des loots dans les Overworlds et donjons génériques)

🗃**Organisation**
- Ajout de **place_holder/store_blueprint** d'**Overworld** : *Archived/Autres/blue_print/A Link to the Past/World/Overworld/COORDONNEE_MAPNAME* (Développeur seulement)
- Ajout de **place_holder/store_blueprint** de **Maison** : *Archived/Autres/blue_print/A Link to the Past/World/Houses/HOUSENAME* (Développeur seulement)
- Ajout de **place_holder/store_blueprint** de **Grotte** : *Archived/Autres/blue_print/A Link to the Past/World/Caves/CAVENAME* (Développeur seulement)
- Ajout de **place_holder/store_blueprint** de **Donjon** : *Archived/Autres/blue_print/A Link to the Past/World/Dungeons/DUNGEONNAME/FLOOR/FLOOR_DUNGEONNAME* (Développeur seulement)
- Correction et Ajustements de la **Salle Secrète** et ses **Salle des Dimensions** pour se téléporter n'importe où dans le jeu (Développeur seulement)

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda : A Link to the Past (Solarus Edition) 0.4.1

`Changements du 10 Décembre 2024` v0.4.1 (hotfix)

🗺**Overworld**
- __Monde de la Lumière__:
  * Ajout de tous les **Ennemis** de l'Overworld disponible (Certains Ennemis remplacées par d'Autres en attendant d'avoir les Sprites).
  * Correction des **Herbes** qui ne faisaient pas de bruit à la découpe.
  * Corrections et Ajouts de **Tuiles Manquantes**.

🗺**Village Cocorico**
- Correction de **Jumpers** qui faisaient **SoftLock** dans un Mur.
- Correction des Toits et Portes des Maisons, le Héros peut entrer dans les maisons.
- Ajout du **Livre de Mudora** débloquable en fonçant (**Bottes de Pégase**) dans les **Bibliotèques** de la **Librairie** du Village.

🗺**Désert de Mystère**
- Ajout du PNJ **Aginah** dans sa **Grotte** et ses **Dialogues**.
- **Livre de Mudora** sert désormais à lire la **Pierre Gravée** et ouvrir l'accès au Donjon **Palais du Désert**.

🗺**Montagne de la Mort**
- Ajout du **Vieil Homme Perdus** dans la **Grotte** qui vous suit, avec ses **Dialogues**.
- Ajout du **Miroir Magique** qui fonctionne spécifiquement dans la **Montagne Ouest** et dans les Donjons.
- Ajout du **Link Lapin**, dans un Pseudo **Monde des Ténèbres**.
- Ajout de la **Transition entre les deux Mondes** avec le **Téléporteur** de la **Montagne Ouest** (Téléportation **Monde des Ténèbres**) et le **Miroir Magique** (Retour **Monde de la Lumière**).

🗺**Lac Hylia**
- Modification de la **Ice Rod Cave**, et ajout du **Bâton de Glace**.
- D'une **Grotte Manquante** sous un **Gros Rocher**.

🗺**Grand Marais**
- Modification d'une **Grotte** du **Grand Marais** (**C'est un Secret**).

 🗺**Bois Perdus**
 - Suppression de l'**Epaisse Brume** et ajout d'un effet d'éclairci quand on a retiré l'**Epée de Légende** (Excalibur).
 - La **Musique** change après cet événement.

 🗺**Bosquet Sacré**
 - L'**Epée de Légende** (Excalibur) a retirer du **Piédestal** avec une petite cinématique et **Dialogue**.
 - La **Pierres Gravées** peut être décrypter avec le **Livre de Mudora**.
 - Suppression de l'**Epaisse Brume** après que l'**Epée de Légende** ait été retiré de son socle.

🪄**Objets**
- **Miroir Magique** : Permet de **Revenir** dans le **Monde de la Lumière** ou à l'**Entrée d'un Donjon**.
- **Livre de Mudora** : Permet de **Lire** les **Pierres Gravées** (**Ancien Hylien**).
- **Baguette de Glace** : Permet de **Jeter** un **Souffle de Glace** (Applique seulement des Dégats pour le Moment).

👾**Ennemis**
- **Cocottes** : **Poule** qui se balade, et s'énerve quand on les tape trop.
- **Armos** : Ennemi de Pierre, qui **se réveille et fonce** sur **Link** quand il est trop proche.
- **Octorok** : Il **crache des Pierres** devant lui, ce qui peut blesser **Link**.
- **Crabes des Sables** : Se déplace en crabe, littéralement.
- **Crow** : Vol et fonce sur **Link** puis s'enfuit.
- **Vautour** : Vol en cercle autour de lui, et se rapproche petit à petit.
- **Zora** : Crache des petites des **Boules de Feu** depuis les **eaux profondes**, ou marche lentement vers **Link** sur le **Sol**.

💬**Dialogues**
- **Miroir Magique** : Obtention de l'Objet : *_treasure.inventory/magic_mirror.1*
- **Livre de Mudora** : Obtention de l'Objet : *_treasure.equipment/book_of_mudora.1* (à modifier en **inventory** plus tard)
- **Baguette de Glace** : Obtention de l'Objet : *_treasure.inventory/ice_rod.1*
- **Stèle du Bosquet Sacré** : Lire sans et avec le **Livre de Mudora** : : *crypted.grove_stone* et *crypted.grove_stone*
- **Panneau** : Panneau de la **Grotte de Sortie** de la **Montagne de la Mort** : *sign.death_moutain_west*
- **Vieil Homme Perdus** : Différents Dialogues :
  * Quand on le rencontre pour la **première fois**, dans la **Grotte Sombre** : *npc.grandpa.first_meeting*
  * Pendant qu'on l'escorte dans la **Grotte Sombre** : *npc.grandpa.warning_hole*, *npc.grandpa.pot_heart* et *npc.grandpa.turn_right*
  * Quand on arrive juste **devant chez lui** : *npc.grandpa.arrived*
  * Quand il est **chez lui**, sans et avec la **Perle de Lune** : *npc.grandpa.at_home* et *npc.grandpa.moon_perl*
- **Le Tyran** : Dialogue dans le **Monde des Ténèbres** sans et avec la **Perle de Lune** : *npc.cursed_bully.meeting* et *npc.cursed_bully.moon_pearl*
- **Balle Rose** : Dialogue dans le **Monde des Ténèbres** sans et avec la **Perle de Lune** : *npc.pink_ball.meeting* et *npc.pink_ball.moon_pearl*
- **Aginah** : Différents Dialogues :
  * Première Rencontre avec Aginah : *npc.aginah.first_meeting*
  * Quand tu as le **Livre de Mudora** : *npc.aginah.book_of_mudora*
  * Quand tu as récupèré le pendentif du **Palais du Désert** : *npc.aginah.after_pendant*
- **Le Voleur** : C'est un Secret : *npc.thief.it_s_a_secret*
- **Sahasrahla** : Obtention de l'**Epée de Légende** : *npc.sahasrahla.master_sword*

💬**Traduction**
- Traduction de tous les textes et images pour la **Version Anglaise**

🖼️**Sprites**
- Ajout des **Cocottes** : *chicken.dat*
- Ajout des **Armos** : *armos.dat*
- Ajout des **Octorok** : *octorok.dat*
- Ajout des **Crabes des Sables**. *sand_crab.dat*
- Ajout des **Crow** : *crow.dat*
- Ajout des **Vautour** : *vulture.dat*
- Ajout des **Zora** : *zora.dat* et *zora_underwater*
- Ajout de **Link Lapin** : *bunny.dat*
- Ajout d'**Excalibur** plantée dans le piédestal : *excalibur.dat* (à modifier plus tard)

☠️**Corrections Ennemis**
- Correction des **Dégats Subis** par les **Ennemis** par les **Objets Jetés**.
- Correction des **Points de Vie** de certains **Ennemis**.
- Correction de la **Hitbox** des **Beemos** et des **Armos**.

📟**Script**
- __stone_big_white.lua__ Ajout de la possibilité de **Soulever** les **Grosses Pierres Blanches**.
- __stone_explode.lua__ Ajout de la capacité de **Détruire** les **Pierres Entassées** au **Chargeant** avec les **Bottes de Pégase**.

🎮**GameFix**
- Les **Objets Magiques** ne remplissent plus la **Magie**.
- Ajout des **Bombes** dans l'Inventaire quand on ouvre un coffre avec des bombes.

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda : A Link to the Past (Solarus Edition) 0.4.0

`Changements du 28 Novembre 2024` v0.4.0

🗺**Overworld**
- __Monde de la Lumière__:
  * Ajout de **Palais du Désert**.
  * Ajout de **Tour d'Héra**.

🗺**Palais du Désert**
- Ajout d'une clé qui tombe de la torche avec les **Bottes de Pégase**.
- Ajout des **Gant de Puissance**.
- Ajout de **Leevers Vert** & **Violet**, **Mini Moldorm**, **Devalant Rouge** et ses **Sables Mouvants** et **Beemos**.
- Ajout du Boss **Lanmolas**, sa Récompense, son Pendentif.
- Ajout d'un système pour **Secouer la Caméra** .
- Ajout de Nouveaux **Drops d'Objets** sur les **Nouveaux Ennemis** (Prizes Packs).
- Ajout de **Dialogues** de **Sahasrahla**, **Gant de Puissance**.

🗺**Tour d'Héra**
- Ajout de la **Perle de Lune** sans Comportement/Code
- Ajout des **Hardhat Beetle Bleus** & **Rouges**, **Squelettes Rouges** et **Kodongo**.
- Ajout de **Spark**, **Barre de Feu** et **Bumper**.
- Ajout de **Interrupteur Etoile**.
- Ajout du Boss **Moldorm**, sa Récompense, son Pendentif.
- Ajout de Nouveaux **Drops d'Objets** sur les **Nouveaux Ennemis** (Prizes Packs).
- Ajout de **Dialogues** de **Sahasrahla**.

🗺**Ruines à l'Est**
- Ajout de **Dialogues** pour **Sahasrahla**.
- **Sahasrahla** donne les **Bottes de Pégase** après avoir récupéré le premier Pendentif.

🪄**Objets**
- **Gant de Puissance** : Permet de soulever des **Pierres Blanches**.
- **Perle de Lune** : Permet à **Link** de **ne plus être en Lapin** dans le **Monde des Ténèbres**.

👾**Ennemis**
- **Soldat Archer Bleu** : Se promène, et recule quand il détecte Link puis **tire des flèches** et se repositionne.
- **Squelette Rouge** : Se déplace aléatoire, et **saute en arrière** à l'attaque de **Link**, et **jète un Os**.
- **Hardhat Beetle Bleu** & **Rouge** : Le **repousse LinK** quand on le frappe à l'épée.
- **Leevers Vert** & **Violet** : Sortent du Sable et foncent sur Link, puis retour dans les sables. Seul **Vitesse de Déplacement** changent entre les **Swap Colors**
- **Mini Moldorm** : Petit ver rondelé qui rebondit sur les rebords.
- **Devalant Rouge** et ses **Sables Mouvants** : Sort des sables mouvants (position fixe) et crache des petites boules de feu.
- **Beemos** : **Tourelle 360°** qui **tire des Laser**
- **Kodongo** : Il se déplace, s'arrête et crache des boules de feu.
- **Spark** : Fait le **tour des rebords**, en **scintillant**, et fait des dégats si **Link** le touche.
- **Barre de Feu** : 4 **Boules de Feu** qui tourne autour d'un bloc et fait des dégats si **Link** les touche.
- **Bumper** : Repousse **Link** s'il le touche avec sa Hitbox.
- **Interrupteur Etoile** : Modifie l'emplacement des **Trous**.
- Boss **Lanmolas** : 3 **Vers de Sable** qui jaillissent du sol, balancent des pierres dans les 4 directions (8 Directions quand il en reste qu'un) puis replonge. Hitbox pour l'**Epée de Link** sur leur **tête**.
- Boss **Moldorm** : Ver qui se déplace aléatoirement et rebondit contre les rebords. Repousse link si l'Epée touche la tête, Hitbox pour l'**Epée de Link** sur sa **queue**.

💬**Dialogues**
- **Gant de Puissance** : Obtention de l'Objet : *_treasure.equipment/glove.1*
- **Perle de Lune** : Obtention de l'Objet : *_treasure.equipment/moon_pearl.1*
- **Carte** : Obtention de l'Objet : *_treasure.dungeons/map.1*
- **Boussole** : Obtention de l'Objet : *_treasure.dungeons/compass.1*
- **Stèle du Désert** : Lire sans et avec le **Livre de Mudora** : : *crypted.desert_stone* et *crypted.desert_stone*
- **Sahasrahla** : 
  * **Pierre Télépathique** du **Palais du Désert** : *ts.hint_desert*
  * **Pierre Télépathique** du **Tour d'Héra** : *ts.hint_hera1* et *ts.hint_hera_2*

🖼️**Sprites**
- Ajout du **Soldat Archer Bleu** : *soldier_archer.dat* et *soldier_archer_projectile.dat*
- Ajout des **Leevers Verts** & **Violets** : *leever_green.dat* et *leever_red.dat*
- Ajout des **Mini Moldorm** : *mini_moldorm.dat* et *mini_moldorm_tail.dat*
- Ajout des **Beemos** : *beemos.dat* et *beemos_laser.dat*
- Ajout des **Hardhat Beetle Bleus** & **Rouges** : *hardhat_beetle_blue.dat* et *hardhat_beetle_red.dat*
- Ajout des **Squelettes Rouges** : *skeleton_red.dat* et *skeleton_bone.dat*
- Ajout de **Kodongo** : *kodongo.dat* et *kodondo_flame.dat*
- Ajout des **Quicksand**, **Devalant Blue** & **Violet** : *quicksand.dat*, *devalant_blue.dat* et *devalant_red.dat*
- Ajout des **Spark** and **Barre de Feu** : *spark.dat* et *fire_bar.dat*
- Ajout des **Bumper** et **Interrupteur Etoile** : *bumber.dat* et **switch_star.dat*

☠️**Corrections Ennemis**
- Corrige des problèmes de timing des **Cyclopes** d'endormissement et de détection

📟**Script**
- Ajout de meta/__camera.lua__

🧠**Debug**
- __Salle Secrète__: Téléportation dans une **Pièce Secrète** avec la touche "," (Développeur seulement)
- __Boss Room__: Téléportation dans une **Pièce Secrète** pour les Boss avec la touche "=" (Développeur seulement)
- __Enemies Room__: Téléportation dans une **Pièce Secrète** pour les Ennemis avec la touche ")" (Développeur seulement)

🗃**Organisation**
- Ajout d'une **Salle des Boss** *Secret Room/Boss/boss_choiche_room* (Développeur seulement)
- Ajout d'une **Salle des Ennemis** *Secret Room/Enemies/enemies_choiche_room* (Développeur seulement)

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda : A Link to the Past (Solarus Edition) 0.3.0

`Changements du 20 Juin 2024` v0.3.0

🗺**Overworld**
- __Monde de la Lumière__ : 
  * Ajout de **Grotte du Château d'Hyrule**.
  * Ajout de **Château d'Hyrule**.
  * Ajout du **Secret Passage**.

🗺**Maison de Link**
- Ajout de **Gardes** amicaux bloquant l'accès à l'**Overworld** pendant l'Introduction du Jeu.
- Ajout de la **Pluie**, de la **Pénombre**.
- Ajout de **Bruit de la Pluie**.
- Ajout de **Dialogues** des **Gardes**, du **Panneau**.

🗺**Château d'Hyrule**
- Ajout de **Rideaux Destructibles**.
- Ajout de **Dialogues** des **Gardes**, de **Zelda**.
- Ajout des différents **Soldiers Blue** & **Green**.
- Ajout du **Grotte du Château d'Hyrule** où se trouve l'**Oncle**.
- Ajout de la **Barrière Electrique** empêchant d'aller à la **Hyrule Tower**.
- Ajout du **Boomerang**.
- Ajout du **Mini-Boss** **Chevalier à Fléau** qui garde la **Princesse Zelda**.
- Ajout de la quête d'**Escorte de Zelda** du Château au Sanctuaire.
- Ajout du **Blason Poussable** avec Zelda pour entrée dans le **Passage Secret**.

🗺**Secret Passage**
- Ajout des **Rats**, **Chauve-souris** & **Serpents**.
- Ajout des **Leviers à Tirer**.

🗺**Sanctuary**
- Ajout des **Dialogues** de **Zelda** et le **Prêtre**.
- Ajout du **Réceptable de Coeur** dans le coffre.

🗺**Maison**
- __Maison de Link__ : **Link** démarre endormi dans son lit, **Zelda** nous parle par télépathie et l'**Oncle de Link** sort dehors.

🪄**Objets**
- **Boomerang** : Permet d'envoyer un **Boomerang** qui revient après une distance maximum ou avoir touché quelque chose. **Immobilise** certains ennemis.

👾**Ennemis**
- **Rat** : Se promène et fait des dégats en touchant **Link**.
- **Chauve-souris** : Virvolte dans les airs en direction de **Link**.
- **Serpent** : Se promène et accèlère face à **Link** lui infligeant des dégats au contact.
- **Soldat Vert Aveugle** : Se déplace aléatoirement.
- **Soldat Vert et Blue** : Se déplace, détecte **Link**, puis lui cours dessus.
- **Barrière Electrique** : **Electrocute Link** à son contact ou si une Epée inférieur à **Excalibur** la frappe. Bloque l'entrée de la **Tour d'Hyrule**
- Mini-Boss **Chevalier à Fléau Gris** : Fait tournoyer puis envoie son **Fléau Chainé** sur **Link**.

💬**Dialogues**- 
- **Oncle** de **Link** : Différents Dialogues :
  * **Départ de l'Oncle** de la **Maison de Link** : *escape.uncle*
  * **Mort de l'Oncle** : *escape.uncle_dead*
- **Panneau** : : Panneau devant le **Château d'Hyrule**, pendant et après l'**Introduction** : *sign.default*, *sign.escape*
- **Gardes** : Différents Dialogues :
  * **Brimades** ou **Tutoriel des Gardes** : *escape.soldiers.1*, *escape.soldiers.2*, *escape.soldiers.3*, *escape.soldiers.4*, *escape.soldiers.5*, *escape.soldiers.6* et   *escape.soldiers.7*
  * **Brimade des Gardes** à l'**Entrée du Château d'Hyrule** : *escape.soldiers.front_castle*
  * Le Garde sur le **Toit du Château** donne du **Lore**/**Contexte des Evènements** : *escape.soldiers.tower*
- **Zelda** : Différents Dialogues :
  * **Introduction Télépathique** de la **Princesse Zelda** : *escape.intro*
  * Si **Link met du temps** à trouver la **grotte secrète** pour entrer dans le **Château d'Hyrule** : *escape.zelda_backseat*
  * Quand **Link libère Zelda** de sa **Cellule** : *escape.zelda_rescued*, *escape.zelda_rescued_question* et *escape.zelda_rescued_yes*
  * Pendant l'escorte de la **Princesse Zelda** : *escape.zelda_following_1*, *escape.zelda_following_2*, *escape.zelda_following_3*, *escape.zelda_following_4* et *escape.zelda_following_5*
  * A l'arrivée de la **Princesse Zelda** dans la **Sanctuaire** : *escape.end_2*
  * Dialogue par défaut **après le Sauvetage** de la **Princesse Zelda** : *sanctuary.zelda_default*
- **Prêtre** :
  * A l'arrivée de la **Princesse Zelda** dans la **Sanctuaire** : *escape.end_1*, *escape.end_3*
  * Dialogue par défaut **après le Sauvetage** de la **Princesse Zelda** : *sanctuary.priest_default*

📱**HUD**
- Ajout de la **Musique** pour les Menus **Ecran Titre** et **Selection de Sauvegarde**.

📟**Script**
- Ajout de __meta/map.lua__
- Ajout de __ceilling_drop_manager.lua__
- Ajout de __electric_barrier.lua__

🗃**Organisation**
- Ajout d'un Dossier de **/devdata** (Développeur seulement).

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda : A Link to the Past (Solarus Edition) 0.2.0

`Changements du 28 Mars 2024` v0.2.0

🗺**Overworld**
- __Monde de la Lumière__ : 
  * Ajout du **Palais de l'Est**
  * Ajout du **Sanctuary**

🗺**Palais de l'Est**
- Ajout d'un Système pour les **Transitions de Map** (Séparateur qui reset de certains ennemis)
- Ajout de l'**Arc** et des **Bottes de Pégase**
- Ajout du Systèmes de Gestion des **Salles Sombres** et de leurs éclairages (**Torche/Lanterne**)
- Ajout des **Cyclopes Verts** & **Rouges**, **Tuiles Maléfiques**, **Squelettes Bleus**, et **Canons à Boule**
- Ajout du Boss **Armos Knight**, sa Récompense, son Pendentif
- Metatables de gestion des **Interrupteurs**, des **Petites Clés** & **Grandes Clés**
- Ajout d'un Système de Gestion des **Drops d'Objets** sur les Ennemis (Prizes Packs)
- Ajout Dialogues de **Sahasrahla**, de l'**Arc**, des **Rubis**, des **Coffres**, des **Petites Clés** & **Grandes Clés** 

🪄**Objets**
- **Arc** : Permet de **tirer des flèches** sur ses ennemis ou certains interrupteurs.
- **Bottes de Pégase** : Permet **de Courir** jusqu'à ce que le joueur l'arrête ou qu'il tape dans un mur (*bonk*). Il blesse les ennemis qu'il rencontre et fait tomber les objets en hauteur, détruit certains murs et empilements de pierres (pas encore dans les arbres). 

👾**Ennemis**
- **Cyclope Vert** & **Rouge** : S'éveille quand **Link** est trop proche, et se déplace vers lui **devenant vulnérable aux attaques** (surtout à l'**Arc**). Les **Rouges** sont plus résistant, plus rapide et uniquement sensible à  l'**Arc**.
- **Tuiles Maléfiques** : **Carreau** qui se soulève du sol puis fonce sur **Link**.
- **Squelette Bleu** : Se déplace aléatoire, et **saute en arrière** à l'attaque de **Link**.
- **Canon à Boule** : Canon mobile sur les Murs de Côtés des Salles, qui tire des Boulets en ligne Droite.
- Boss **Armos Knight** : 6 **Grandes Statues de Chevaliers Bleus** sensible à l'**Arc** qui dance et charge dans l'arène de combat. Le **dernier en vie s'enrage**, devient **Rouge**, et saute violement sur **Link**.

💬**Dialogues**
- **Arc** : Obtention de l'Objet : *_treasure.inventory/bow.1*
- **Bottes de Pégase** : Obtention de l'Objet : *_treasure.equipment/pegasus_shoes.1*
- **Rubis** : Dialogue d'**Obtention de Rubis** : *_treasure.consumables/rupee.1, *_treasure.consumables/rupee.2*, *_treasure.consumables/rupee.3*, *_treasure.consumables/rupee.4*,  *_treasure.consumables/rupee.5* et *_treasure.consumables/rupee.6*
- **Grand Coffre** : Si le **Joueur** tente de l'ouvrir **sans possèder** la **Grande Clé** : *NoBigKey*
- **Porte à Grande Serrure** : Si le **Joueur** tente de l'ouvrir **sans possèder** une **Grande Clé** : *NoBigKey* 
- **Porte à Serrure** : Si le **Joueur** tente de l'ouvrir **sans possèder** une **Petite Clé** : *NoSmallKey* 
- **Petites Clés** : Dialogue d'**Obtention de Clé** : *_treasure.dungeons/small_key.1*
- **Grandes Clés** : Dialogue d'**Obtention de Clé** : *_treasure.dungeons/big_key.1*
- **Sahasrahla** : Différents Dialogues :
  * **Première Rencontre** : *npc.sahasrahla.first_meeting*, *npc.sahasrahla.first_meeting_question* et *npc.sahasrahla.first_meeting_answer*
  * Quand tu as récupèré le pendentif du **Palais de l'Est** : *npc.sahasrahla.give_courage_pendent*
  * Après avoir reçu les **Bottes de Pégase** : *npc.sahasrahla.pegasus_gifted*
  * Après avoir récupèré la **Baguette de Glace** : *npc.sahasrahla.ice_rod*
  * **Pierre Télépathique** du **Palais de l'Est** : *ts.hint_eastern*

🎮**GameFix**
- Correction du **Crash** de **Game Over**.

📱**HUD**
- Adaptation du **HUD**, des **Menus** pour le format **A Link to the Past**. (256x224)

🗃**Organisation**
- Créations des **BluePrints** pour les **Donjons de la Lumière** dans les TileSets.
- Mise à jour des **Tilesets** (pour **Sanctuary**).
- Ajout d'un Dossier de **Ressources/Images** pour les **Artworks**.

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda : A Link to the Past (Solarus Edition) 0.1.2

`Changements du 23 Février 2024` v0.1.2 (hotfix)

🗺**Overworld**
__Monde de la Lumière__ : 
* Correction des Bancs du **Village Cocorico**.
* Correction d'une Superposition de **Tiles Décoratives** au dessus de **Maison de Link**.

__Monde des Ténèbres__ : Liens de toutes les **Maisons** avec le **Monde des Ténèbres**.

🗺**Village Cocorico**
- Correction d'un **Jumper** qui faisait **SoftLock** dans un Mur.

🗺**Bibliothèque**
- Correction d'une **Tile** dans la **Bibliothèque**.

🎮**GameFix**
- Correction d'un **Bug** avec le **Joystick des Manettes** dans les **Menus** (Le **Sélecteur** ne s'affole plus).
- Correction de Choix Décalé dans le *game_manager.lua*.
- Correction des **Points de Vie** du Joueur dans le *Savegame*.

📱**HUD**
- Correction des **Points de vie** afficher dans le **HUD**.

🗃**Organisation**
- Créations des **BluePrints** pour les **Donjons de la Lumière** dans les TileSets. (Développeur seulement)
- Créations des Dossiers **All Floors** et Map **All Floors** pour les **Donjons de la Lumière**. (Développeur seulement)

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda : A Link to the Past (Solarus Edition) 0.1.1

`Changements du 21 Janvier 2022` v0.1.1 (hotfix)

🗺**Overworld**
- __Monde de la Lumière__ : Liens de toutes les **Grottes**, **Maisons** et **Donjon** avec le **Monde de la Lumière**
- __Monde des Ténèbres__ : Liens de toutes les **Maisons** avec le **Monde des Ténèbres**

🗃**Organisation**
- Création des Fichiers __.dat__ pour les **Maisons** du **Monde de la Lumière** et du **Monde des Ténèbres**
- Création des Fichiers __.dat__ pour les **Grottes** du **Monde de la Lumière** et du **Monde des Ténèbres**
- Création des Fichiers __.dat__ pour les **Donjons** du **Monde de la Lumière** et du **Monde des Ténèbres**

__--------------------------------------------------------------------------------------------------------------__

## The Legend of Zelda : A Link to the Past (Solarus Edition) 0.1.0

`Changements du 14 Janvier 2022` v0.1.0  

🗺**Overworld**
- __Monde de la Lumière__ : Création de la carte générale 
  * Répartition de l'**Overworld** en différente zone, jouable dans une moindre mesure (sans ennemis)

🗺**Maison**
- __Maison de Link__ : Première map intérieur, la **Maison de Link** qui donne sur l'extérieur du **Monde de la Lumière**

📟**Script**
- Ajout de __Debug.lua__ avec des touches de raccourci pour se donner des objets, se soigner, se déplacer plus vite et à travers les murs.  (Développeur seulement).
- Ajout de __Console.lua__ pour pouvoir entrée des commandes in-game. (Développeur seulement)
- Ajout de 3 *"Custom Entity"* pour les **Grosses Pierres Blanches**, **Noires**, et **Fracassable**.

🧠**Debug**
- __Salle Secrète__ : **Salle secrète** avec pleins d'objets, de téléporteur vers les différentes zones,  **Maisons**, **Grottes**, **Donjons** pour faciliter les tests.
- Reprise des **Scripts** *Debug/Console* de **The Only One Projet**  (Développeur seulement).

🗃**Organisation**
- Création des Dossiers dans *data/maps* **A Link to the Past**.
    * Répartition des deux mondes : **Monde De la Lumière** et **Monde des Ténèbres**.
    * Répartition des **Overworld**, **Maisons**, **Grottes**, **Donjons**.
- Création des Dossiers dans *data/maps* **Archived**.
    * Répartition des **Salle Secrète** et des **Owerworlds**. (Développeur seulement)
    * Répartition **Salle Secrète** et **Salle des Dimensions**, **Overworld**, **Maisons**, **Grottes**, **Donjons**. (Développeur seulement)
- Ajout et Modification des **Logos/Icônes** et **Artwork**.
- Ajout et Description du **ReadMe**.
