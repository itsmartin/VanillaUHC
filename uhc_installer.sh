#!/bin/bash

# Global default fallback URLs (these can be overridden in uhc.cfg if desired)

UHC_SCRIPT_URL="https://raw.githubusercontent.com/itsmartin/VanillaUHC/master/uhc"
PREGEN_URL="https://raw.githubusercontent.com/itsmartin/VanillaUHC/master/mc_pregen"


fail() {
    echo "$1" 1>&2
    exit 1
}

property_set() {
	sed -i "/$1/c\\$1=$2" server.properties
}

send() {
	screen -S uhc -p 0 -X stuff "`printf "$1\r"`"
}



# Check if a config file exists, and read it if so

if [ -s uhc.cfg ]; then
	echo "Reading parameters from uhc.cfg"
	. uhc.cfg
else
	# Prompt user for all settings interactively
	echo "No config file found, interactive mode"
	read -p "Seed []: " SEED
	read -p "Max players [20]: " MAX_PLAYERS
	read -p "MOTD [Ultra Hardcore]: " MOTD
	read -p "Op user: " OP
	read -p "World radius: " RADIUS

	# Only prompt for a world if there isn't already a world here
	if [ ! -d world ]; then
		read -p "Pregenerated world download URL - must be a .tar.gz containing /world (leave blank to generate): " WORLD_URL
	fi

	# Only prompt for a jar download if there isn't a server jar here already
	if [ ! -e minecraft_server.jar ]; then
		read -p "Server JAR URL: " JAR_URL
	fi
fi

# Prompt user for any required values not provided in the config file

if [ -z "$MAXPLAYERS" ]; then
	MAX_PLAYERS="20"
fi

if [ -z "$MOTD" ]; then
	MOTD="Ultra Hardcore"
fi

if [ -z "$RADIUS" ]; then
	RADIUS="2000"
fi

# Download whatever we need to download now

if [ ! -e minecraft_server.jar ]; then
	echo "Downloading Minecraft..."
	wget -nv -O minecraft_server.jar "$JAR_URL" || fail "Could not download Minecraft!"
fi

if [ ! -d world ]; then
	if [ -n "$WORLD_URL" ]; then
		echo "Downloading world..."
		wget -nv -o world.tgz "$WORLD_URL" || fail "Could not download world!"
		echo "Decompressing world..."
		tar -xzf world.tgz || fail "Could not decompress world!"
	fi
fi

if [ ! -e server-icon.png ]; then
	if [ -n "$ICON_URL" ]; then
		echo "Attempting to download server icon..."
		wget -nv -O server-icon.png "$ICON_URL" || echo "Could not download icon, ignoring"
	fi
fi

echo "Downloading UHC scripts..."
wget -nv -O uhc $UHC_SCRIPT_URL || fail "Could not download script: uhc"
wget -nv -O mc_pregen $PREGEN_URL || fail "Could not download script: mc_pregen"

# Make scripts executable
chmod +x uhc mc_pregen


# If no java installed, set it up

[ $(type -p java) ] || {

	# Install Java and update everything
	echo "Setting up java..."

	add-apt-repository -y ppa:webupd8team/java
	apt-get -q update
	echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
	apt-get -y install oracle-java7-installer
	[ $(type -p java) ] || fail "Java installation failed!"
}




# Set up the server

# Accept the EULA
echo "eula=true" >eula.txt

# Run the server 1 time to create the server.properties file

if [ ! -e server.properties ]; then
	echo "Running server to generate server.properties..."

	if [ -d world ]; then
		# World exists already
		echo "stop" | java -jar minecraft_server.jar nogui
	else
		# No world exists, so we delete it after running the server
		echo "stop" | java -jar minecraft_server.jar nogui
		echo "Removing world..."
		rm -rf world
	fi

	# Update server.properties
	echo "Setting server properties..."

	property_set white-list true
	property_set spawn-protection 0
	property_set motd "$MOTD"
	property_set level-seed "$SEED"
	property_set enable-command-block true
	property_set max-players "$MAX_PLAYERS"
	property_set difficulty 3
	property_set gamemode 2
fi


if [ ! -d world ]; then
	# No world exists, so we should pregenerate one
	echo "Pregenerating a world of radius $((RADIUS+350))..."
	./mc_pregen $((RADIUS+350))
fi


# Start the server
echo "Starting server and sleeping for 20 seconds..."
./uhc start_server
sleep 20


# op $OP if specified
if [ -n "$OP" ]; then
	echo "Opping $OP..."
	send "op $OP"
fi


# Run the world setup script
echo "Launching world setup script..."
./uhc setup

echo "Complete!"