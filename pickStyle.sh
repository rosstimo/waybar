#!/bin/bash

# list contents of waybar style directory then update symbolic link to style.css
# requires: walker
#
# this command lists the contents of the waybar style directory and pipes it to walker
# passing the output of the command (user selection) to a variable
styleChoice=$(ls style | walker -d -p 'Waybar Style')

# Update the symbolic link to point to the selected style
ln -sf "style/$styleChoice" style.css

# kill all instances of waybar to restart it with the new style
killall waybar
# restart waybar
waybar &