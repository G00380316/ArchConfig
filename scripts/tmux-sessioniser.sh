#!/usr/bin/env bash

# Default directory if no input is provided within the timeout
default_dir=~/


if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/ ~/.config ~/Documents ~/OneDrive ~/Coding ~/Coding/Projects -mindepth 1 -maxdepth 3 -type d | sed 's|^/home/enoch/||' | fzf)
fi

if [[ -z $selected ]]; then
    selected=$default_dir
fi

# Step 2: If no directory selected, attach to an existing session or create a new default session
if [[ -z $selected ]]; then
    #echo "No directory selected. Attaching to the last session or creating a default session."
    last_session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | head -n 1)

    if [[ -n $last_session ]]; then
        #echo "Attaching to the last session: $last_session"
        tmux attach-session -t "$last_session"
    else
        default_session_name=$(basename "$default_dir" | tr . _)
        #echo "No existing sessions found. Creating a new session: $default_session_name"
        tmux new-session -s "$default_session_name" -c "$default_dir"
    fi
    exit 0
fi

# Step 3: Prepare session name and check for tmux
selected_name=$(basename "$selected" | tr . _)

# Step 4: Check if the selected session exists
if ! tmux has-session -t=$selected_name 2>/dev/null; then
    #echo "Creating a new session: $selected_name"
    tmux new-session -ds "$selected_name" -c "$selected"
fi

# Step 5: Attach or switch to the session
if [[ -z $TMUX ]]; then
    #echo "Attaching to session: $selected_name"
    tmux attach-session -t "$selected_name"
else
    #echo "Switching to session: $selected_name"
    tmux switch-client -t "$selected_name"
fi
