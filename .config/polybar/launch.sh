#!/bin/bash

killall -q polybar

echo "---" | tee -a /tmp/polybar.log
polybar | tee -a /tmp/polybar.log & disown
echo "Bars launched..."
