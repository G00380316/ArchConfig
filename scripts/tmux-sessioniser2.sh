#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/ ~/.config ~/Documents ~/OneDrive ~/Coding ~/Coding/Projects -maxdepth 3 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

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

