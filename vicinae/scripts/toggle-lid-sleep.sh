#!/bin/bash

# @vicinae.schemaVersion 1
# @vicinae.title Toggle Lid Sleep
# @vicinae.mode compact
# @vicinae.packageName Power
# @vicinae.icon 💻
# @vicinae.description Keep the Mac awake with the lid closed, or restore normal sleep

current=$(pmset -g | awk '/SleepDisabled/ {print $2}')
if [ "$current" = "1" ]; then new=0; else new=1; fi

cmd="/usr/bin/pmset -a disablesleep $new"
if ! sudo -n $cmd 2>/dev/null; then
  osascript -e "do shell script \"$cmd\" with administrator privileges" >/dev/null 2>&1 || { echo "Cancelled"; exit 1; }
fi

if [ "$new" = "1" ]; then
  echo "Lid sleep off: stays awake when closed"
else
  echo "Lid sleep restored"
fi
