#!/bin/bash

killall -q polybar

echo "---" | tee -a /tmp/polybar.log
for m in $(xrandr | grep -w 'connected' | awk '{print $1}'); do
    MONITOR=$m polybar --reload | tee -a /tmp/polybar.log & disown
done
echo "Bars launched..."
