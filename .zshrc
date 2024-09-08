# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
#export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"


# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Path to your Oh My Zsh installation.
#export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="powerlevel10k/powerlevel10k"

# type p10k configure to open up wizard again
plugins=(git fzf)
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

#source $ZSH/oh-my-zsh.sh

# User configuration

# Terminal Styling
cat .nf 2> /dev/null
setsid neofetch >| .nf

# History
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space #ignores a command if there is a space before it
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

### Custom aliases and Keybinds ###
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias q='exit'
alias e='exec zsh'
alias rs='reboot'
alias k='pkill'
alias g='rg'
alias n='nvim'
alias ni='nvim $(fzf --preview="bat --color=always {}")'
alias ss='shutdown -h now'
alias vp='zathura'
alias vi='feh'
alias yt='yt-dlp'
alias calc='bc'
alias f='fzf'
alias fp='fzf --preview="bat --color=always {}"'
alias ls='ls --color'
alias vim='nvim'
alias c='clear'
alias lt='tmux attach-session -t "$(tmux ls | tail -n1 | cut -d: -f1)"'

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Use fzf for history search
bindkey '^R' fzf-history-widget
bindkey '^E' fzf-file-widget
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey -e

### Useful functions ###
#
# Add color support for ls and other commands
if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b ~/.dircolors)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi

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

### Terminal Styling ###
#
# Set terminal title
case "$TERM" in
    xterm*|rxvt*)
        precmd() { print -Pn "\e]0;%n@%m: %~\a" }
        ;;
esac

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Oh My Posh Terminal Styling
# eval "$(oh-my-posh init zsh --config ~/.poshthemes/tokyonight_storm.omp.json)"

### Coding Languages Setup ###
#
# Pyenv configuration
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Go and Cargo
export PATH=$PATH:/usr/local/go/bin
source "$HOME/.cargo/env"

### Tools ###
#
# FZF Configuration

# Define the fzf installation path
FZF_HOME="${HOME}/.fzf"

# Check if fzf is installed; if not, clone and install it
if [ ! -d "$FZF_HOME" ]; then
  echo "fzf not found. Installing fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_HOME"
  "$FZF_HOME/install" --all
fi

# Source fzf key bindings and fuzzy completion if it exists
#[ -f "$FZF_HOME/fzf.zsh" ] && source "$FZF_HOME/fzf.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# Enable fzf tab completion
# export FZF_TMUX=0  # Optional: disable tmux integration if you don't use it
export FZF_COMPLETION_TRIGGER='**'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
export FZF_DEFAULT_COMMAND='fd --type f'  # Example using fd for fuzzy search

# Zoxide Setup
eval "$(zoxide init --cmd cd zsh)"

# Rust Waybar module
export PATH="$HOME/.config/waybar/waybar-module-pomodoro/target/release:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
