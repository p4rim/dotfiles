#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$REPO_DIR/dotfiles"
PACKAGES_FILE="$REPO_DIR/packages.txt"

if [[ $EUID -eq 0 ]]; then
    echo "Run this as your normal user, not root."
    exit 1
fi

# Install/update packages
sudo pacman -Syu --needed - < "$PACKAGES_FILE"

# Enable services
sudo systemctl enable NetworkManager.service
sudo systemctl enable bluetooth.service

# Install Oh My Zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Set Zsh as default shell
ZSH_PATH="$(command -v zsh)"

if [[ "$SHELL" != "$ZSH_PATH" ]]; then
    chsh -s "$ZSH_PATH"
fi

# Create standard user directories
xdg-user-dirs-update

# Stow every dotfile package
cd "$DOTFILES_DIR"

for package in */; do
    stow --restow --target="$HOME" "${package%/}"
done

# Refresh fonts
fc-cache -f

echo
echo "Setup complete."
echo "Log out/reboot, then start Hyprland with:"
echo "  start-hyprland"
echo
echo "GitHub login:"
echo "  gh auth login"
