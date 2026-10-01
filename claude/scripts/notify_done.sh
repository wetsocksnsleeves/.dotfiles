#!/bin/bash

# Use provided message or generate default
if [ -n "$1" ]; then
  message="$1"
else
  # Determine the notification message based on tmux session
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
fi

# Send notification based on OS
if [ "$(uname)" = "Darwin" ]; then
  # macOS
  osascript -e "display notification \"$message\" with title \"Claude Code\"" 2>/dev/null
else
  # Linux
  notify-send "Claude Code" "$message" 2>/dev/null
fi
