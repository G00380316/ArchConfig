#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
. "$HOME/.cargo/env"
export PATH="$HOME/.config/waybar/waybar-module-pomodoro/target/release:$PATH"
