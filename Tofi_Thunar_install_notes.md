
# Thunar Installations

- *sudo pacman -S thunar

To make Thunar the default file manager, you can update the system’s MIME type associations. This is typically done using xdg-mime:

- *xdg-mime default thunar.desktop inode/directory application/x-gnome-saved-search

Set Thunar to Launch via Keybinding

If you want to use a keybinding to launch Thunar in Hyprland, you can add a new keybinding to your hyprland.conf file (usually located at ~/.config/hypr/hyprland.conf):

- *bind = $Mod + e, exec thunar

This will open Thunar when you press $Mod + e.

If you no longer want to keep Dolphin installed, you can remove it with:

- *sudo pacman -R dolphin

This will uninstall Dolphin, leaving Thunar as your default file manager.



# Extra

---

The issue persists because OBS is detecting a mismatch in the Qt libraries, specifically a mix of versions (6.7.2 and 6.8.0). Although some progress has been made, the "safe mode" launch indicates underlying issues related to the Qt configuration. Here's how to resolve this issue:
1. Identify Conflicting Qt Libraries

List all installed qt6 packages again and confirm no 6.7.2 versions remain:

pacman -Q | grep qt6

If any 6.7.2 versions are still present, reinstall them to match 6.8.0:

sudo pacman -S qt6-5compat qt6-declarative qt6-multimedia qt6-wayland qt6-webengine qt6-tools

2. Remove Orphaned Packages

There may be outdated or unused libraries causing the conflict:

sudo pacman -Qdt

Remove these packages:

sudo pacman -Rns $(pacman -Qdtq))

# To DO

There are some keymaps that have to be removed that are mapped to terminal mode
edit the install script to account for the removal of wofi and dolphin and account for the isntallation of tofi and Thunar

# Why this was happening to OBS

The issue persists because OBS is detecting a mismatch in the Qt libraries, specifically a mix of versions (6.7.2 and 6.8.0). Although some progress has been made, the "safe mode" launch indicates underlying issues related to the Qt configuration. Here's how to resolve this issue:

1. Identify Conflicting Qt Libraries

List all installed qt6 packages again and confirm no 6.7.2 versions remain:

pacman -Q | grep qt6

If any 6.7.2 versions are still present, reinstall them to match 6.8.0:

sudo pacman -S qt6-5compat qt6-declarative qt6-multimedia qt6-wayland qt6-webengine qt6-tools

# Making Tofi compatiable with xdg-desktop-portal-wlr.service

To configure xdg-desktop-portal-wlr to use Tofi as your new launcher, you can adjust its settings by setting an appropriate command in your environment variables or modifying the service configuration:

    Create or edit the service override file for xdg-desktop-portal-wlr:

systemctl --user edit xdg-desktop-portal-wlr.service

Set the TOFI launcher for screencasting: Add the following lines under the [Service] section:

[Service]
Environment=SELECT_SOURCE=tofi

Reload the systemd daemon and restart the service:

    systemctl --user daemon-reload
    systemctl --user restart xdg-desktop-portal-wlr.service

    Test screencasting with Tofi as the output chooser: Use a tool like OBS Studio to verify that Tofi is being invoked when choosing the output to screencast.

If Tofi requires any specific flags or options, adjust the command by replacing tofi in the Environment=SELECT_SOURCE value with the full command (e.g., tofi --your-flags-here).

# Future Tweaks for Thunar

To make Thunar's UI look cooler and more polished, you can customize it with a few tweaks to themes, icons, and extensions. Here’s how you can enhance the appearance and functionality of Thunar on Arch Linux:
1. Install a Beautiful GTK Theme

To make Thunar match your desired aesthetic, you can install a modern and beautiful GTK theme. Here are some popular themes you can use:

    Adwaita-dark (default dark mode for GTK)
    Arc (clean and modern)
    Materia (simple and elegant)
    Flat Remix (flat and colorful)

To install one of these themes, you can search for them in the AUR (e.g., using yay or pacman for system themes).

Example for Arc:

yay -S arc-gtk-theme

2. Install and Apply Icon Themes

Icon themes can drastically change the look of the Thunar UI. Here are some popular ones:

    Papirus (clean and modern)
    Numix (minimalist and elegant)
    La Capitaine (macOS-style icons)

To install Papirus:

yay -S papirus-icon-theme

You can then apply the icon theme by going to Settings > Appearance and selecting it under the Icons tab.
3. Use a File Manager Extension

You can install useful extensions that improve the functionality and look of Thunar:

    Thunar Media Tags Plugin (tags media files)
    Thunar Archive Plugin (adds zip/tar file handling)
    Thunar Custom Actions (create custom actions for files)

Install with:

sudo pacman -S thunar-archive-plugin thunar-media-tags-plugin

4. Enable Thunar’s Dark Mode

If you prefer dark mode, make sure the GTK theme you're using supports it. You can set it globally via the environment variable:

export GTK_THEME=Adwaita:dark

To make this permanent, add it to your ~/.profile or ~/.xprofile file:

echo 'export GTK_THEME=Adwaita:dark' >> ~/.profile

5. Enhance Thunar with Desktop Icons

If you prefer to use Thunar as your file manager and still have desktop icons, you can use xfdesktop to enable them:

sudo pacman -S xfdesktop

Enable it:

xfdesktop --load

6. Thunar Custom Actions for Power Users

Custom actions in Thunar can add more functionality and ease of use. For instance, you can create actions like opening a terminal in a folder or creating new text files directly from Thunar.

    Go to Edit > Configure custom actions.
    Add new actions, such as:
        Open Terminal Here
        Create New Document
        Preview Images

7. Use a Transparent or Semi-Transparent Background

If you're using a compositing window manager like Hyprland or Compton (Picom), you can add transparency to Thunar:

    Make sure your window manager has transparency enabled.
    Edit the ~/.config/picom.conf or ~/.config/hypr/hyprland.conf file to set transparency levels.

8. Font Customization

Change the font used in Thunar for a more modern feel:

    Open Settings > Appearance.
    Go to the Font tab, and select your preferred font, such as Ubuntu or Noto Sans.

9. Enable Thunar’s Side Pane

The side pane can give you easy access to your folders. Make sure it’s enabled:

    Go to View > Side Pane or press F9.

10. Apply Tweaks Using dconf-editor

You can fine-tune Thunar’s behavior using the dconf-editor. To install:

sudo pacman -S dconf-editor

Then open it, and navigate to:

org > x > thunar

From there, you can tweak various aspects, such as icon sizes, behavior, etc.

With these tweaks, Thunar will have a more modern and polished look that fits seamlessly with your Arch Linux setup. Let me know if you'd like more specific instructions for any of these steps!
