#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
RAM=$(free -m | awk '/Mem:/ { print $2 } /buffers\/cache/ { print $3 }')

# Update the server jar
${DIR}/update_minecraft_server.py 2>&1 | tee /dev/tty | systemd-cat -t minecraft

# Start the server with screen and redirect output to systemd
/usr/bin/java "-Xms${RAM}M" "-Xmx${RAM}M" -jar /home/minecraft/minecraft_server/server.jar nogui 2>&1 | tee /dev/tty | systemd-cat -t minecraft
