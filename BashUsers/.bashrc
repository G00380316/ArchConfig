# ~/.bashrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Terminal Styling
neofetch

# History settings
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=10000

# Shell options
shopt -s checkwinsize
shopt -s globstar

# Prompt customization
PS1='\u@\h:\w\$ '

# Add color support for ls and other commands
if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b ~/.dircolors)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# Custom aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias q='exit'
alias e='exec bash'
alias rs='reboot'
alias k='pkill'
alias f='fd'
alias g='rg'
alias n='nvim'
alias ss='shutdown -h now'
alias vp='zathura'
alias vi='feh'
alias yt='yt-dlp'
alias calc='bc'

# Useful functions
mkcd() { mkdir -p "$1" && cd "$1"; }
extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2) tar xvjf "$1" ;;
            *.tar.gz) tar xvzf "$1" ;;
            *.zip) unzip "$1" ;;
            *) echo "Unsupported file type: $1" ;;
        esac
    else
        echo "$1 not found!"
    fi
}

# Enable programmable completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

# Set terminal title
case "$TERM" in
    xterm*|rxvt*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
        ;;
esac

# Pyenv configuration
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH=$PATH:/usr/local/go/bin
. "$HOME/.cargo/env"

# Pyenv configuration
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
export PATH=$PATH:/usr/local/go/bin

# Dont forget to build the Rust module
export PATH="$HOME/.config/waybar/waybar-module-pomodoro/target/release:$PATH"

# Terminal Styling
#
#eval "$(oh-my-posh init bash)"
#eval "$(oh-my-posh init bash --config ~/.poshthemes/jandedobbeleer.omp.json)"
#eval "$(oh-my-posh init bash --config ~/.poshthemes/velvet.omp.json)"
#eval "$(oh-my-posh init bash --config ~/.poshthemes/tokyo.omp.json)"
eval "$(oh-my-posh init bash --config ~/.poshthemes/tokyonight_storm.omp.json)"
