#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

# Remove unwanted applications from the menu
echo "Removing unwanted applications from the menu..."

# Remove Avahi tools
echo "Removing Avahi tools..."
if ls /usr/share/applications | grep -q avahi; then
    sudo rm /usr/share/applications/avahi-discover.desktop && echo "Removed avahi-discover.desktop"
else
    echo "No Avahi tools found to remove."
fi

# Remove VNC applications
echo "Removing VNC applications..."
if ls /usr/share/applications | grep -q -i vnc; then
    sudo rm /usr/share/applications/bvnc.desktop && echo "Removed bvnc.desktop"
else
    echo "No VNC applications found to remove."
fi

# Remove SSH applications
echo "Removing SSH applications..."
if ls /usr/share/applications | grep -q -i ssh; then
    sudo rm /usr/share/applications/bssh.desktop && echo "Removed bssh.desktop"
else
    echo "No SSH applications found to remove."
fi

echo "All done!"
