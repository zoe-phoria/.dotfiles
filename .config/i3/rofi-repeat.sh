#!/bin/bash
# read input and forward to stdout
rofi -dmenu -password -no-fixed-num-lines -p "$(printf "$1" | sed s/://)"
