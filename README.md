VanillaUHC
==========

Bash scripts for running UHC matches in vanilla Minecraft


What it does
------------

This script is designed to help you to run a UHC without the need for Bukkit (e.g. in the latest Minecraft snapshot).

At present, only limited testing has been done, so please use with care.


The files
---------

**mc_pregen** *radius* - pre-generates a world to the specified size. Should be run from within the server directory. Expects the server
to be called *minecraft_server.jar*.

**uhc** *command* [params] - script to run the UHC. Run **uhc** on its own for a list of options.

The server is run in a screen session. If you are already using screen for something else, this *might* cause unexpected behaviours.
I haven't tested it.

**uhc_installer.sh** - handy script for installing everything on a new server. I use this to set up a server on a fresh Ubuntu install on a VPS. If the config file is used, the script *should* run fully unattended, including downloading Oracle Java (Ubuntu only). Users are advised to read the script carefully and edit it to their liking.

**uhc.cfg** - configuration parameters for uhc_install.sh and uhc.


Setup
-----

* Create an empty folder for your server to run in
* Tweak **uhc.cfg** to your liking
* Copy it to your server along with **uhc_installer.sh**
* Run **bash uhc_installer.sh** and hope for the best. This script will:
 * Download all the other scripts
 * Install Java if it's not found
 * Download Minecraft
 * Modify some settings in server.properties
 * Op a specified player if desired
 * Download a world file if you give it one, or pregenerate the world to the required size if not
 * Start the server, set up some gamerules and build the spawn platform


Running the match
-----------------

* Start the server with **uhc start_server** if it's not running
* If you didn't use the installer, you may want to set up the world and spawn with **uhc setup**
* Open the server (remove the whitelist) with **uhc open**
* When the server is full, close the server with **uhc close**
 * This will (hopefully) automatically whitelist all online players, and enable whitelisting, so current players can relog but new players cannot join.
* Set up teams using vanilla /scoreboard commands if desired
* Ensure that all participating players are in gamemode 2 (adventure) and all non-participating players are in gamemode 3 (spectator)
* Begin the 60-second countdown with **uhc ready**


Gameplay defaults
-----------------

There isn't much flexibility in the way this script does things, so if you want to change any of the following you will have to edit the script.

* The server is automatically set to HARD mode.
* All players spawn in Adventure mode by default. The world spawn is on a glass platform high above 0,0, bordered by barrier blocks so that players can't leave.
* The game begins after a 60-second countdown, triggered by the **uhc ready** command. During the countdown, players are scattered across the map and frozen. (If you set TEAMS="true" in **uhc.cfg**, teams will be kept together).
* When the game starts, players are provided with basic stone tools, a leather chestplate and a 5-shot bow with 5 arrows.
* Players get 30 seconds of invincibility when the match starts.
* The time is set to 0 when the match starts (you can do **uhc permaday** or **uhc permanight* if you like)
* Players will respawn at 0,0 when they die, and automatically get put into Spectator mode (there is a command block at spawn which handles this). *Note: if players change their spawn by sleeping in beds this won't work*
* A match time announcment is made every 20 minutes in chat.
