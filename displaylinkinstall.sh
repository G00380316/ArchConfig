#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

# Update the system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install an AUR helper (yay)
echo "Installing yay..."
sudo pacman -S --noconfirm git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay

# Install the DisplayLink driver
echo "Installing DisplayLink driver..."
yay -S --noconfirm displaylink

# Load the DisplayLink kernel module
echo "Loading the DisplayLink kernel module..."
sudo modprobe evdi

# Enable the DisplayLink service
echo "Enabling DisplayLink service..."
sudo systemctl enable displaylink.service
sudo systemctl start displaylink.service

# Clean up
echo "Cleaning up..."
sudo pacman -Sc --noconfirm

echo "Installation complete! Please reboot your system."
