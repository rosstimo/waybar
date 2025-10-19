#!/bin/bash

# list contents of waybar configs directory then update symbolic link to config
# requires: walker
#
# this command lists the contents of the waybar config directory and pipes it to walker
# passing the output of the command (user selection) to a variable
configChoice=$(ls configs | walker -d -p 'Waybar Config')

# Update the symbolic link to point to the selected config
ln -sf "configs/$configChoice" config

# kill all instances of waybar to restart it with the new config
killall waybar
# restart waybar
waybar &