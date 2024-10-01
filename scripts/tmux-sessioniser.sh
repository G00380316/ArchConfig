#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/.config ~/Documents ~/OneDrive ~/Coding ~/Coding/Projects -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

# Check if tmux is running
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    # Create a new session if tmux is not running at all
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

# Check if last session exists
last_session=$(tmux list-sessions -F "#{session_name}" 2> /dev/null | tail -n 1)

if [[ -z $last_session ]]; then
    # Try to resurrect sessions if none exist
    echo "No last session found. Attempting to resurrect..."
    tmux-resurrect restore

    # Recheck after resurrection if any sessions now exist
    last_session=$(tmux list-sessions -F "#{session_name}" 2> /dev/null | tail -n 1)
fi

# If we still don't have any sessions after resurrection, create a new one
if [[ -z $last_session ]]; then
    echo "No sessions available, creating a new session."
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

# Check if the selected session exists
if ! tmux has-session -t=$selected_name 2> /dev/null; then
    # Create a new detached session if selected session doesn't exist
    tmux new-session -ds $selected_name -c $selected
fi

# If inside tmux, switch to selected or last session, otherwise attach
if [[ -z $TMUX ]]; then
    echo "Attaching to session: $selected_name or $last_session"
    tmux attach-session -t $selected_name || tmux attach-session -t $last_session
else
    echo "Switching to session: $selected_name"
    tmux switch-client -t $selected_name || tmux switch-client -t $last_session
fi

