#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
RAM=$(free -m | awk '/Mem:/ { print $2 } /buffers\/cache/ { print $3 }')

# Update the server jar
/usr/games/steamcmd +login anonymous +force_install_dir /home/ark/server +app_update 376030 +quit 2>&1 | tee /dev/tty | systemd-cat -t minecraft

# Start the server with screen and redirect output to systemd
/home/ark/server/ShooterGame/Binaries/Linux/ShooterGameServer TheIsland?listen?SessionName=CustomCloudGaming -server -log 2>&1 | tee /dev/tty | systemd-cat -t minecraft
