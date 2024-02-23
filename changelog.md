# Changelog

## The Legend of Zelda A Link to the Past (Solarus Edition) 0.2 (en cours)

`Changements du ?? ????? 2022` v0.2.1 (hotfix)

🐛Bug

__--------------------------------------------------------------------------------------------------------------__

`Changements du 14 Janvier 2022` v0.2.0  

🗺**Overworld**

## The Legend of Zelda A Link to the Past (Solarus Edition) 0.1.1 (2022-01-21)

__--------------------------------------------------------------------------------------------------------------__

`Changements du 23 Février 2024` v0.1.2 (hotfix)

🗺**Overworld**
- __Light Overworld__ : 
- Correction des Bancs de KaKaRiKo
- Correction d'une Superposition de Tiles Décoratives au dessus de Link House

- __Dark Overworld__ : Liens de toutes les Maisons avec le Dark World

🗺**KaKaRiKo Village**
- Correction d'un Jumper qui faisait SoftLock dans un Mur

🗺**Library**
- Correction d'une Tile dans Library

🎮**GameFix**
- Correction d'une Bug avec le Joystick des Manettes dans les Menus (Le Sélecteur ne s'affole plus)
- Correction de Choix Décalé dans le *game_manager.lua*
- Correction des points de vie du Joueur dans le Savegame

**HUD**
- Correction des Points de vie afficher dans le HUD

🗃**Organisation**
- Créations des BluePrints pour les Light Dungeons dans les TileSets
- Créations des Dossiers All Floors et Map All Floors pour les Light Dungeons

__--------------------------------------------------------------------------------------------------------------__

`Changements du 21 Janvier 2022` v0.1.1 (hotfix)

🗺**Overworld**
- __Light Overworld__ : Liens de toutes les Grottes, Maisons et Dunjon avec le Light World
- __Dark Overworld__ : Liens de toutes les Maisons avec le Dark World

🗃**Organisation**
- Création des Fichiers .dat pour les Maisons du Light World et du Dark World
- Création des Fichiers .dat pour les Grottes du Light World et du Dark World
- Création des Fichiers .dat pour les Donjons du Light World et du Dark World

__--------------------------------------------------------------------------------------------------------------__

`Changements du 14 Janvier 2022` v0.1.0  

🗺**Overworld**
- __Light Overworld__ : Création de la carte générale 
* Répartition de l'Overworld en différente zone, jouable dans une moindre mesure (sans ennemis)

🗺**Maison**
- __Maison de Link__ : Première map intérieur, la maison de link qui donne sur le monde extérieur

📟**Script**
- Ajout de __Debug.lua__
- Ajout de __Console.lua__
- Ajout de 3 "Custom Entity" pour les Grosses Pierres Blanches, Noires, et Fracassable.

**Debug**
- __Secret Room__ : Salle secrète avec pleins d'objets, de téléporteur vers les différentes zones, maisons, grottes, et donjons pour faciliter les tests 
- Reprise des Scripts Debug/Console de The Only One Projet

🗃**Organisation**
- Création des Dossiers dans data/maps A Link to the Past
    * Répartition des deux mondes Light et Dark Overworld
    * Répartition des Overworld, Maisons, Grottes, Donjons
- Création des Dossiers dans data/maps Archived
    * Répartition des Secret Room et des Owerworlds
    * Répartition Secret Dimension, Overworld, Maisons, Grottes, Donjons
- Ajout et Modification des Logos/Icônes et Artwork
- Ajout et Description du ReadMe
