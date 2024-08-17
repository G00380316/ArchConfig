#!/bin/bash

# Run First without root if yay not installed

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then

    sudo pacman -S --noconfirm git

    # Clone and install yay
    git clone https://aur.archlinux.org/yay.git
    mv yay $HOME/.config
    cd $HOME/.config/yay
    makepkg -si --noconfirm

    # Clone Neovim Configuration Repository
    echo "Cloning Neovim configuration..."
    git clone https://github.com/G00380316/nvim.git
    mv nvim $HOME/.config

    # My Preferred Folders
    cd $HOME
    dircolors -p > ~/.dircolors
    mkdir -p  Documents
    mkdir -p  Videos
    mkdir -p Coding/Projects
    echo "Please run as root"

    # Move application config folders to .config
    echo "Moving configuration folders to .config directory..."
    cd ArchConfig
    mv .bashrc "$HOME"
    mv .bash_profile "$HOME"
    mv .poshthemes "$HOME"
    mv Pictures "$HOME/"
    mv firefox "$HOME/.config/"
    mv waybar "$HOME/.config/"
    mv wofi "$HOME/.config/"
    mv ly "$HOME/.config/"
    mv neofetch "$HOME/.config/"

    # Install swww using yay
    echo "Installing swww..."
    yay -S --noconfirm swww
    sudo pacman -S --noconfirm unzip

        # Install JetBrains Nerd Font
        echo "Installing JetBrains Nerd Font..."

        # Step 1: Download the Nerd Font
        echo "Downloading JetBrains Nerd Font..."
        FONT_ZIP="JetBrainsMono.zip"
        FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
        curl -LO "$FONT_URL"

        # Step 2: Extract the Font
        echo "Extracting the font..."
        unzip "$FONT_ZIP" -d JetBrainsMono

        # Step 3: Install the Font
        echo "Installing the font..."
        cd $HOME/.local/share
        mkdir -p fonts
        cd $HOME/ArchConfig
        mv JetBrainsMono $HOME/.local/share/fonts/
        fc-cache -fv
   
       # Installing oh my posh using yay
       echo "Installing oh my posh..."
       yay -S --noconfirm oh-my-posh-bin
        

        # Install Python using pyenv
        echo "Installing pyenv and Python..."
        curl https://pyenv.run | bash
        echo -e '\n# Pyenv configuration' >> ~/.bashrc
        echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
        echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
        echo 'eval "$(pyenv init -)"' >> ~/.bashrc
        source ~/.bashrc
        pyenv install 3.11.4
        pyenv global 3.11.4
        pip install -U hyfetch

        # Install Node.js using nvm
        echo "Installing nvm and Node.js..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
        source ~/.nvm/nvm.sh
        nvm install node
        nvm use node

        # Install Go
        echo "Installing Go..."
        wget https://golang.org/dl/go1.20.5.linux-amd64.tar.gz
        sudo tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
        source ~/.bashrc

        # Install Rust
        echo "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source ~/.cargo/env
        source ~/.bashrc
        rustup update
    exit
fi

# Update the system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Development Tools
echo "Installing basic development tools..."
sudo pacman -S --noconfirm base-devel curl git github-cli wget lazygit gcc jdk-openjdk ruby

# Browsing and Other Applications
echo "Installing Firefox, Waybar, Neovim, and OBS Studio..."
sudo pacman -S --noconfirm firefox waybar neovim obs-studio neofetch

    # Wallpaper configuration

    # Path to the wallpaper image
    WALLPAPER="$HOME/Pictures/Wallpapers/Luffylying.png"

    # Check if yay (AUR helper) is installed
    if ! command -v yay &> /dev/null
    then
        echo "yay could not be found. Please install yay to proceed."
        exit 1
    fi

    # Start swww daemon if it's not already running
    if ! pgrep -x "swww-daemon" > /dev/null
    then
        echo "Starting swww daemon..."
        swww-daemon &
        sleep 3  # Give the daemon a three second to start
    fi

    # Set the wallpaper
    if [ -f "$WALLPAPER" ]; then
        echo "Setting wallpaper to $WALLPAPER"
        swww img "$WALLPAPER"
        echo "Wallpaper set successfully."
    else
        echo "Wallpaper not found at $WALLPAPER. Please make sure the file exists."
        #exit 1
    fi

# AUR apps
yay -S --noconfirm betterbird-bin

# Cleaning Utility
sudo pacman -S --noconfirm bleachbit

# Clipboard manager
sudo pacman -S --noconfirm wl-clipboard

# To Screen-Capture Obs
sudo pacman -S --noconfirm ffmpeg

# Nvidia Setup
sudo pacman -S --noconfirm nvidia nvidia-utils egl-wayland

# This package provides integration for Wayland applications to access desktop services.
sudo pacman -S --noconfirm xdg-desktop-portal-wlr

# This package allows you to create virtual video devices and is often used for streaming or video processing applications.
sudo pacman -S --noconfirm v4l2loopback-dkms

# Install PHP and Lua
echo "Installing PHP and Lua..."
sudo pacman -S --noconfirm php lua

# Install Flatpak and Obsidian,Vesktop,Postman,DbGate,...etc
echo "Installing Flatpak and Obsidian..."
sudo pacman -S --noconfirm flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y org.mozilla.Thunderbird
flatpak install vesktop -y
flatpak install dbgate -y
flatpak install obsidian -y
flatpak install blanket -y
flatpak install flathub com.github.KRTirtho.Spotube -y
flatpak install flathub org.moneymanagerex.MMEX -y
flatpak install flathub dev.bragefuglseth.Keypunch -y
flatpak install flathub net.lugsole.bible_gui -y
flatpak install flathub com.usebruno.Bruno -y
#flatpak install flathub io.appflowy.AppFlowy -y
#flatpak install flathub org.kde.minuet -y

# Important we use flatseal to manager our flatpak apps (Cuase sometimes they don't render properly)
flatpak install flatseal -y 

# Extras

# Youtube Video downloader
sudo pacman -S --noconfirm yt-dlp

# Terminal Calculator
sudo pacman -S --noconfirm bc

# Monitor hardware health ( CPU temperatures, fan speeds, voltages, and other system health metrics.)
sudo pacman -S --noconfirm lm_sensors

# Command-line tool for visualizing directory structures in a clear, hierarchical format
sudo pacman -S --noconfirm tree

# Interactive process viewer and system monitor for Unix-like operating systems.
sudo pacman -S --noconfirm htop

# A simple, fast, and user-friendly alternative to the 'find' command. "'fd' -e" 'everthing'
sudo pacman -S --noconfirm fd

# A command-line search tool that recursively searches your current directory for a regex pattern "rg"
sudo pacman -S --noconfirm ripgrep

# Sound utility
sudo pacman -S --noconfirm pavucontrol

# For Display Utility
sudo pacman -S --noconfirm wlr-randr

# Audio
sudo pacman -S --noconfirm pipewire pipewire-pulse pipewire-jack
sudo pacman -Rns --noconfirm pulseaudio pulseaudio-alsa
sudo pacman -S --noconfirm blueman
sudo pacman -S --noconfirm bluez bluez-utils
# Might break install hasn't been tested so if any errors remove and run on your own after 
sudo systemctl --user enable --now pipewire pipewire-pulse

# Clean up
echo "Cleaning up..."
sudo pacman -Sc --noconfirm
rm -rf ~/ArchConfig/JetBrainsMono "$FONT_ZIP"

echo "All done! Now run util.sh and displaylinkinstall.sh and look at info.txt"
