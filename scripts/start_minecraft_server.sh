#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
MIN_RAM=2000
AVAIL_RAM=$(free -m | awk '/Mem:/ { print $7 }')

# Update the server jar
${DIR}/update_minecraft_server.py 2>&1 | tee /dev/tty | systemd-cat -t minecraft

# Start the server with screen and redirect output to systemd
/usr/bin/java "-Xms${MIN_RAM}M" "-Xmx${AVAIL_RAM}M" -jar /home/minecraft/minecraft_server/server.jar nogui 2>&1 | tee /dev/tty | systemd-cat -t minecraft
