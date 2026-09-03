#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_FILE="$REPO_DIR/packages.txt"
DOTFILES_DIR="$REPO_DIR/dotfiles"

# ------------------------------------------------------------
# Checks
# ------------------------------------------------------------

if [[ $EUID -eq 0 ]]; then
    echo "Do not run this script as root."
    echo "Run: ./install.sh"
    exit 1
fi

if [[ ! -f "$PACKAGES_FILE" ]]; then
    echo "Missing packages file: $PACKAGES_FILE"
    exit 1
fi

if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "Missing dotfiles directory: $DOTFILES_DIR"
    exit 1
fi

# ------------------------------------------------------------
# Install packages
# ------------------------------------------------------------

echo "==> Updating system and installing packages..."

# Remove comments and blank lines before passing packages to pacman.
grep -Ev '^[[:space:]]*(#|$)' "$PACKAGES_FILE" \
    | sudo pacman -Syu --needed -

# ------------------------------------------------------------
# Enable services
# ------------------------------------------------------------

echo "==> Enabling NetworkManager..."
sudo systemctl enable --now NetworkManager.service

echo "==> Enabling Bluetooth..."
sudo systemctl enable --now bluetooth.service

# ------------------------------------------------------------
# Oh My Zsh
# ------------------------------------------------------------

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "==> Installing Oh My Zsh..."

    RUNZSH=no \
    CHSH=no \
    KEEP_ZSHRC=yes \
        sh -c "$(curl -fsSL \
        https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "==> Oh My Zsh already installed."
fi

# ------------------------------------------------------------
# Set Zsh as default shell
# ------------------------------------------------------------

ZSH_PATH="$(command -v zsh)"

if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$ZSH_PATH" ]]; then
    echo "==> Setting Zsh as default shell..."
    chsh -s "$ZSH_PATH"
else
    echo "==> Zsh is already the default shell."
fi

# ------------------------------------------------------------
# XDG user directories
# ------------------------------------------------------------

echo "==> Creating XDG user directories..."
xdg-user-dirs-update

# ------------------------------------------------------------
# Stow dotfiles
# ------------------------------------------------------------

echo "==> Stowing dotfiles..."

cd "$DOTFILES_DIR"

for package in */; do
    package="${package%/}"

    echo "    -> $package"

    stow \
        --restow \
        --target="$HOME" \
        "$package"
done

# ------------------------------------------------------------
# Refresh fonts
# ------------------------------------------------------------

if command -v fc-cache >/dev/null 2>&1; then
    echo "==> Refreshing font cache..."
    fc-cache -f
fi

# ------------------------------------------------------------
# Finished
# ------------------------------------------------------------

echo
echo "======================================"
echo " Setup complete"
echo "======================================"
echo
echo "Next:"
echo "  - Reboot or log out/in"
echo "  - Login at the TTY"
echo "  - Run: start-hyprland"
echo "  - Login to GitHub with: gh auth login"
echo
