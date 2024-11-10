#!/bin/zsh
source ~/.zshrc

anki &
sleep 2
kill "$(pgrep -n kitty)"
