#! /bin/sh
# 
#
set -e

mode="800x600"
layout="--right-of LVDS"

if test $(xrandr -q | grep -q "VGA connected" >/dev/null 2>/dev/null); then
  if test $(xrandr -q | grep -q "current $mode" >/dev/null 2>/dev/null); then
    xrandr --output VGA --off
  else
    xrandr --output VGA --auto $layout --mode $mode
  fi
fi
