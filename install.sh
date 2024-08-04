#!/bin/bash

# Run First without root if yay not installed

# Clone and install yay
git clone https://aur.archlinux.org/yay.git
mv yay $HOME/.config
cd $HOME/.config/yay
makepkg -si --noconfirm

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

cd $HOME/ArchConfig

# My Preferred Folders
mkdir -p  Documents Videos Coding/Projects

# Update the system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Development Tools
echo "Installing basic development tools..."
sudo pacman -S --noconfirm base-devel curl git wget unzip lazygit gcc

# Install Postman via Flatpak as a fallback
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.getpostman.Postman

# Clone Neovim Configuration Repository
echo "Cloning Neovim configuration..."
git clone https://github.com/G00380316/nvim.git
mv nvim ~/.config

# Browsing and Other Applications
echo "Installing Firefox, Waybar, Neovim, and OBS Studio..."
sudo pacman -S --noconfirm firefox waybar neovim obs-studio neofetch

# To Screen-Capture Obs
sudo pacman -S --noconfirm ffmpeg

sudo pacman -S --noconfirm nvidia

# This package provides integration for Wayland applications to access desktop services.
sudo pacman -S --noconfirm xdg-desktop-portal-wlr

# This package allows you to create virtual video devices and is often used for streaming or video processing applications.
sudo pacman -S --noconfirm v4l2loopback-dkms

# Install PHP and Lua
echo "Installing PHP and Lua..."
sudo pacman -S --noconfirm php lua

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
sudo mkdir -p $HOME/.local/share/fonts
mv JetBrainsMono/* $HOME/.local/share/fonts/
fc-cache -fv

# Step 4: Verify the Installation
echo "Verifying the installation..."
if fc-list | grep -qi "JetBrains Mono"; then
    echo "JetBrains Nerd Font installed successfully!"
else
    echo "Font installation failed."
fi

# Install Flatpak and Obsidian,Vesktop,Postman,DbGate
echo "Installing Flatpak and Obsidian..."
sudo pacman -S --noconfirm flatpak

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install flathub vesktop -y
flatpak install flathub dbgate -y
flatpak install flathub obsidian -y
flatpak install flathub blanket -y

# Wallpaper configuration

sudo mv Pictures $HOME

# Path to the wallpaper image
WALLPAPER="$HOME/Pictures/Wallpapers/Luffylying.png"

# Check if yay (AUR helper) is installed
if ! command -v yay &> /dev/null
then
    echo "yay could not be found. Please install yay to proceed."
    exit 1
fi

# Install swww using yay
echo "Installing swww..."
yay -S --noconfirm swww

# Start swww daemon if it's not already running
if ! pgrep -x "swww-daemon" > /dev/null
then
    echo "Starting swww daemon..."
    swww-daemon
    sleep 1  # Give the daemon a second to start
fi

# Set the wallpaper
if [ -f "$WALLPAPER" ]; then
    echo "Setting wallpaper to $WALLPAPER"
    swww img "$WALLPAPER"
    echo "Wallpaper set successfully."
else
    echo "Wallpaper not found at $WALLPAPER. Please make sure the file exists."
    exit 1
fi

# Extras

# Youtube Video downloader
sudo pacman -S yt-dlp

# Terminal Calculator
sudo pacman -S bc

# Monitor hardware health ( CPU temperatures, fan speeds, voltages, and other system health metrics.)
sudo pacman -S lm_sensors

# Command-line tool for visualizing directory structures in a clear, hierarchical format
sudo pacman -S tree

# Interactive process viewer and system monitor for Unix-like operating systems.
sudo pacman -S htop

# A simple, fast, and user-friendly alternative to the 'find' command. "'fd' -e" 'everthing'
sudo pacman -S fd

# A command-line search tool that recursively searches your current directory for a regex pattern
sudo pacman -S ripgrep

# Move application config folders to .config
echo "Moving configuration folders to .config directory..."
mv mozilla $HOME/.config
mv waybar $HOME/.config
mv wofi $HOME/.config
mv ly $HOME/.config
mv neofetch $HOME/.config
mv Documents $HOME
mv Videos $HOME
mv Coding $HOME

# Clean up
echo "Cleaning up..."
sudo pacman -Sc --noconfirm
rm -rf ~/ArchConfig/JetBrainsMono "$FONT_ZIP"

echo "All done! Now run util.sh and displaylinkinstall.sh and look at info.txt"

