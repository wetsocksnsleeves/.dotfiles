#!/bin/bash

# Determine the notification message
if [ -n "$TMUX" ]; then
  # Get the tmux session name
  session_name=$(tmux display-message -p '#S' 2>/dev/null)
  if [ -n "$session_name" ]; then
    message="Session: $session_name"
  else
    message="Task completed"
  fi
else
  message="Task completed"
fi

# Send Ghostty notification
printf "\033]777;notify;Claude Code;%s\007" "$message"
