#!/bin/zsh

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

    echo "Cloning tpm for tmux configuration..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

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
    mv .zshenv "$HOME"
    mv .zshrc "$HOME"
    mv .p10k.zsh "$HOME"
    mv Pictures "$HOME/"
    mv scripts "$HOME/.config/"
    mv tmux "$HOME/.config/"
    mv firefox "$HOME/.config/"
    mv waybar "$HOME/.config/"
    mv ly "$HOME/.config/"
    mv neofetch "$HOME/.config/"
    mv tofi "$HOME/.config/"
    mv Thunar "$HOME/.config/"
    mv vlc "$HOME/.config/"
    mv onedrive "$HOME/.config/"
    mv xfce4 "$HOME/.config/"
    mv systemd "$HOME/.config/"

    # Install swww using yay
    echo "Installing swww..."
    yay -S --noconfirm swww
    sudo pacman -S --noconfirm unzip unrar

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

        # Install Python using pyenv
        echo "Installing pyenv and Python..."
        curl https://pyenv.run | zsh
        echo -e '\n# Pyenv configuration' >> ~/.zshrc
        echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.zshrc
        echo 'eval "$(pyenv init --path)"' >> ~/.zshrc
        echo 'eval "$(pyenv init -)"' >> ~/.zshrc
        source ~/.zshrc
        pyenv install 3.11.4
        pyenv global 3.11.4
        pip install -U hyfetch

        # Install Node.js using nvm
        echo "Installing nvm and Node.js..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | zsh
        source ~/.nvm/nvm.sh
        nvm install node
        nvm use node

        # Install Go
        echo "Installing Go..."
        wget https://golang.org/dl/go1.20.5.linux-amd64.tar.gz
        sudo tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
        source ~/.zshrc

        # Install Rust
        echo "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source ~/.cargo/env
        source ~/.zshrc
        rustup update
    exit
fi

# Update the system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Development Tools
echo "Installing basic development tools..."
sudo pacman -S --noconfirm base-devel curl git github-cli wget lazygit gcc jdk-openjdk ruby

# Flutter Install
git clone https://github.com/flutter/flutter.git -b stable
sudo mv flutter /opt/flutter

# Some dependencies
sudo pacman -S --noconfirm cmake
# To be completely honest most things surrounding the installation of android
# tools for flutter can be done through android Studio just navigate to the
# settings and seach for 'Android SDK'

yay -S --noconfirm android-studio
# yay -S --noconfirm android-sdk android-ndk

flutter doctor

# Install PHP and Lua
echo "Installing PHP and Lua..."
sudo pacman -S --noconfirm php lua

# Runtime dependencies
sudo pacman -S --noconfirm freetype2 harfbuzz cairo pango wayland libxkbcommon

# Build-time dependencies
sudo pacman -S --noconfirm meson scdoc wayland-protocols

# Disk Utility

sudo pacman -S --noconfirm gdisk ntfs-3g dosfstools

# File-Manager
sudo pacman -S --noconfirm thunar
xdg-mime default thunar.desktop inode/directory application/x-gnome-saved-search
sudo pacman -S --noconfirm  thunar-archive-plugin thunar-media-tags-plugin
sudo pacman -S --noconfirm xfdesktop
xfdesktop --load
sudo pacman -R --noconfirm dolphin

# Laptop Utility
sudo pacman -S --noconfirm tlp
sudo systemctl enable --now tlp
sudo pacman -S --noconfirm brightnessctl

# Internet configuration
echo "Installing Internet Modules"
# This is for Iphones(Ifuse is the module that mounts ifuse /path/to/mount/point)
sudo pacman -S --noconfirm iwd dhclient usbmuxd ifuse libimobiledevice
# This is for Android
sudo modprobe rndis_host
sudo modprobe cdc_ether
sudo modprobe usbnet
sudo systemctl start usbmuxd

# Adds Support to mount Android devices(mtpfs is the module that mounts mtpfs /path/to/mount/point)
sudo pacman -S --noconfirm gvfs-mtp mtpfs

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
yay -S --noconfirm onedrive-abraunegg
yay -S --noconfirm fzf bat
yay -S --noconfirm tofi
yay -R --noconfirm wofi
yay -S --noconfirm arc-gtx-theme
yay -S --noconfirm papirus-icon-theme
systemctl --user daemon-reload
systemctl --user restart xdg-desktop-portal-wlr.service

# Unhighlight if you want to install just don't forget to configure the graphical backend if your on wayland
yay -S --noconfirm microsoft-edge-stable-bin
yay -S --noconfirm google-chrome
yay -S --noconfirm anki-bin # Note that you might have to pip install modules to get it to work!!!

# Productivity
sudo pacman -S --noconfirm zoxide tmux
# Command-line Image viewer
sudo pacman -S --noconfirm feh

# Command-line PDF viewer
sudo pacman -S --noconfirm zathura zathura-pdf-mupdf

# Cleaning Utility
sudo pacman -S --noconfirm bleachbit

# Cleaning Utility
sudo pacman -S --noconfirm i7z

# Clipboard manager
sudo pacman -S --noconfirm wl-clipboard

# To Screen-Capture Obs
sudo pacman -S --noconfirm ffmpeg

# Simple Drag and drop video player
sudo pacman -S --noconfirm mpv

# Nvidia Setup
sudo pacman -S --noconfirm nvidia nvidia-utils egl-wayland nvidia-settings wayland-utils vulkan-tools

# Additional Nvidia setup for power saving settings

#nvidia-smi
#sudo pacman -S --noconfirm nvidia-prime mesa-utils
#__NV_PRIME_RENDER_OFFLOAD=1 glxinfo | grep "OpenGL renderer"

# This package provides integration for Wayland applications to access desktop services.
sudo pacman -S --noconfirm xdg-desktop-portal-wlr

# This package allows you to create virtual video devices and is often used for streaming or video processing applications.
sudo pacman -S --noconfirm v4l2loopback-dkms

# This is a Notification daemon
sudo pacman -S --noconfirm dunst

# Install Flatpak and Obsidian,Vesktop,Postman,DbGate,...etc
echo "Installing Flatpak and Obsidian..."
sudo pacman -S --noconfirm flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install vesktop -y
flatpak install dbgate -y
flatpak install obsidian -y
flatpak install blanket -y
flatpak install flathub com.github.KRTirtho.Spotube -y
flatpak install flathub org.moneymanagerex.MMEX -y
flatpak install flathub dev.bragefuglseth.Keypunch -y
flatpak install flathub net.lugsole.bible_gui -y
flatpak install flathub com.usebruno.Bruno -y
flatpak install flathub com.usebottles.bottles -y
flatpak install flathub org.onlyoffice.desktopeditors -y
# Still testing
flatpak install flathub org.gnome.Boxes -y
# This is an awesome Sound App equivalent to Nahimic / Doldby Atmos
#flatpak install flathub me.timschneeberger.jdsp4linux -y
#flatpak install flathub io.appflowy.AppFlowy -y
#flatpak install flathub org.kde.minuet -y

# Important we use flatseal to manager our flatpak apps (Cuase sometimes they don't render properly) [Issue was scaling make sure you dont change your scale from 1]
flatpak install flatseal -y

# Extras

# Torrent 
sudo pacman -S --noconfirm qbittorrent

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

# For Printing Utility
sudo pacman -S --noconfirm reflector
sudo reflector --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syy
sudo pacman -S --noconfirm splix cups cups-filters
sudo systemctl enable --now cups.service

#Add the printer:

#    Open a browser and go to http://localhost:631 to access the CUPS web interface.
#    Go to the Administration tab, then click Add Printer.
#    Follow the prompts to select your Samsung printer model, which should now be listed thanks to the splix driver.

#Test the printer: After adding it, print a test page to confirm it’s set up correctly.

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
