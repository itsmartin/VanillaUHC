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
* Run **bash uhc_installer.sh** and hope for the best
