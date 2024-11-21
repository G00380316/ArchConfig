#!/usr/bin/env bash

# Debug helper: Print a message with prefix
log() {
 # Comment the echo line when you don't need debugging
    # echo "[DEBUG] $1"
    :
}

# Flags for input behavior
skip_input=false
skip_restore=false

# Parse script arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --skip-input)
            skip_input=true
            shift
            ;;
        --skip-restore)
            skip_restore=true
            shift
            ;;
        *)
            log "Unknown argument: $1"
            shift
            ;;
    esac
done

# Step 1: Check if we are already in a tmux session
if [[ -n $TMUX ]]; then
    log "Already inside a tmux session: $(tmux display-message -p '#S')"
    exit 0
fi

# Step 2: Skip restore if requested, otherwise handle session restoration
if ! $skip_restore; then
    # Check for current tmux sessions
    last_session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | tail -n 1)

    if [[ -n $last_session ]]; then
        log "Attaching to last session: $last_session"
        tmux attach-session -t "$last_session"
        exit 0
    fi

    # Attempt to restore if no session is found
    log "No last session found. Attempting to resurrect..."
    tmux-resurrect restore

    # Recheck for sessions after resurrection
    last_session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | tail -n 1)
    if [[ -n $last_session ]]; then
        log "Attaching to resurrected session: $last_session"
        tmux attach-session -t "$last_session"
        exit 0
    fi
else
    log "Skipping session restoration as requested."
fi

# Step 3: Handle input only if input is not skipped
if ! $skip_input; then
    log "Handling input..."
    selected=$(find ~/ ~/.config ~/Documents ~/OneDrive ~/Coding ~/Coding/Projects -mindepth 1 -maxdepth 2 -type d | fzf)
else
    log "Skipping input handling as requested."
    selected=""
fi

if [[ -z $selected ]]; then
    log "No directory selected. Exiting."
    exit 0
fi

# Step 4: Prepare the session name
selected_name=$(basename "$selected" | tr . _)
log "Selected session name: $selected_name"

# Step 5: Start a new session or attach to an existing one
tmux_running=$(pgrep tmux)

if [[ -z $tmux_running ]]; then
    log "No tmux server running. Starting a new session."
    tmux new-session -s "$selected_name" -c "$selected"
    exit 0
fi

if ! tmux has-session -t="$selected_name" 2>/dev/null; then
    log "Session $selected_name does not exist. Creating it."
    tmux new-session -ds "$selected_name" -c "$selected"
fi

log "Attaching to session: $selected_name"
tmux attach-session -t "$selected_name"
