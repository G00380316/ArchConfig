#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

# My Preferred Folders
mkdir -p ~/pictures ~/documents ~/videos ~/applications ~/coding/projects

# Update the system
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Development Tools
echo "Installing basic development tools..."
sudo pacman -S --noconfirm base-devel curl git wget unzip lazygit gcc

# Clone Neovim Configuration Repository
echo "Cloning Neovim configuration..."
git clone https://github.com/G00380316/nvim.git ~/.config/nvim

# Browsing and Other Applications
echo "Installing Firefox, Waybar, Neovim, and OBS Studio..."
sudo pacman -S --noconfirm firefox waybar neovim obs-studio

# Install Programming Languages

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

# Install Java using SDKMAN!
echo "Installing SDKMAN! and Java..."
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java

# Install Node.js using nvm
echo "Installing nvm and Node.js..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.nvm/nvm.sh
nvm install node
nvm use node

# Install Ruby using rbenv
echo "Installing rbenv and Ruby..."
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-installer | bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
rbenv install 3.1.2
rbenv global 3.1.2

# Install Go
echo "Installing Go..."
wget https://golang.org/dl/go1.20.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.20.5.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# Install Rust
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
rustup update

# Install PHP and Lua
echo "Installing PHP and Lua..."
sudo pacman -S --noconfirm php lua

# Install JetBrains Nerd Font
echo "Installing JetBrains Nerd Font..."

# Step 1: Download the Nerd Font
echo "Downloading JetBrains Nerd Font..."
FONT_ZIP="JetBrainsMono.zip"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
cd ~/Downloads
curl -LO "$FONT_URL"

# Step 2: Extract the Font
echo "Extracting the font..."
unzip "$FONT_ZIP" -d JetBrainsMono

# Step 3: Install the Font
echo "Installing the font..."
mkdir -p ~/.local/share/fonts
mv JetBrainsMono/* ~/.local/share/fonts/
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

flatpak install flathub org.vesktop.Vdesktop -y
flatpak install flathub md.obsidian.Obsidian -y
flatpak install flathub com.getpostman.Postman -y
flatpak install flathub org.dbgate.DbGate -y

# Clean up
echo "Cleaning up..."
sudo pacman -Sc --noconfirm
rm -rf ~/Downloads/JetBrainsMono "$FONT_ZIP"

echo "All done!"

