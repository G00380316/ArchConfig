#!/usr/bin/env bash

# Default directory if no input is provided within the timeout
default_dir=~/

# Timeout duration for `fzf` (in seconds)
fzf_timeout=3

# Step 1: Handle directory selection with timeout
if [[ $# -eq 1 ]]; then
    selected=$1
else
    echo "You have $fzf_timeout seconds to select a directory. Defaulting to $default_dir if no selection is made."

    # Run fzf in the background
    find ~/ ~/.config ~/Documents ~/OneDrive ~/Coding ~/Coding/Projects -maxdepth 3 -type d | fzf > /tmp/fzf_selection &

    # Wait for the selection or timeout
    fzf_pid=$!
    for ((i = 0; i < fzf_timeout; i++)); do
        if ! kill -0 $fzf_pid 2>/dev/null; then
            # If fzf has exited, break out of the loop
            break
        fi
        sleep 1
    done

    # Kill fzf if still running after the timeout
    if kill -0 $fzf_pid 2>/dev/null; then
        kill $fzf_pid
        echo "No selection made in $fzf_timeout seconds. Defaulting to $default_dir."
        selected=$default_dir
    else
        # Read the selection from the temporary file
        selected=$(< /tmp/fzf_selection)
    fi

    # Clean up the temporary file
    rm -f /tmp/fzf_selection
fi

# Step 2: If no directory selected, attach to an existing session or create a new default session
if [[ -z $selected ]]; then
    echo "No directory selected. Attaching to the last session or creating a default session."
    last_session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | head -n 1)

    if [[ -n $last_session ]]; then
        echo "Attaching to the last session: $last_session"
        tmux attach-session -t "$last_session"
    else
        default_session_name=$(basename "$default_dir" | tr . _)
        echo "No existing sessions found. Creating a new session: $default_session_name"
        tmux new-session -s "$default_session_name" -c "$default_dir"
    fi
    exit 0
fi

# Step 3: Prepare session name and check for tmux
selected_name=$(basename "$selected" | tr . _)

# Step 4: Check if the selected session exists
if ! tmux has-session -t=$selected_name 2>/dev/null; then
    echo "Creating a new session: $selected_name"
    tmux new-session -ds "$selected_name" -c "$selected"
fi

# Step 5: Attach or switch to the session
if [[ -z $TMUX ]]; then
    echo "Attaching to session: $selected_name"
    tmux attach-session -t "$selected_name"
else
    echo "Switching to session: $selected_name"
    tmux switch-client -t "$selected_name"
fi
