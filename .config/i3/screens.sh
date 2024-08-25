#!/bin/bash

# fallback uses all connected monitors alphabetically left-to-right
last_monitor=
for monitor in $(xrandr | grep -w 'connected' | awk '{print $1}'); do
    if [[ -z last_monitor ]]; then
        xrandr --output $monitor --mode $(xrandr | grep $monitor -A 1 | tail -n 1 | awk '{print $1}') --rate $(xrandr | grep $monitor -A 1 | tail -n 1 | awk '{print $2}' | sed -e 's/*//g' -e 's/+//g')
    else
        xrandr --output $monitor --mode $(xrandr | grep $monitor -A 1 | tail -n 1 | awk '{print $1}') --rate $(xrandr | grep $monitor -A 1 | tail -n 1 | awk '{print $2}' | sed -e 's/*//g' -e 's/+//g') --right-of $last_monitor
    fi
    last_monitor=$monitor
done
