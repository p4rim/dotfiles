#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_FILE="$REPO_DIR/packages.txt"
DOTFILES_DIR="$REPO_DIR/dotfiles"

if [[ $EUID -eq 0 ]]; then
    echo "Do not run this script as root."
    exit 1
fi

if [[ ! -f "$PACKAGES_FILE" ]]; then
    echo "packages.txt not found: $PACKAGES_FILE"
    exit 1
fi

if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "dotfiles directory not found: $DOTFILES_DIR"
    exit 1
fi

# Install packages
echo "==> Installing packages..."

grep -Ev '^[[:space:]]*(#|$)' "$PACKAGES_FILE" \
    | sudo pacman -Syu --needed -

# Rust
echo "==> Setting up Rust..."

rustup set profile default
rustup toolchain install stable
rustup default stable

rustup component add \
    rustfmt \
    clippy \
    rust-src \
    rust-analyzer

# Enable services
echo "==> Enabling services..."

sudo systemctl enable --now NetworkManager.service
sudo systemctl enable --now bluetooth.service

# Stow dotfiles BEFORE Oh My Zsh
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

# Install Oh My Zsh AFTER .zshrc is already stowed
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

# Set Zsh as default shell
ZSH_PATH="$(command -v zsh)"

if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$ZSH_PATH" ]]; then
    echo "==> Setting Zsh as default shell..."
    chsh -s "$ZSH_PATH"
else
    echo "==> Zsh is already the default shell."
fi

# XDG directories
echo "==> Creating XDG user directories..."
xdg-user-dirs-update

# Refresh fonts
echo "==> Refreshing font cache..."
fc-cache -f

echo
echo "==> Setup complete."
echo "Reboot, log in, then run:"
echo "start-hyprland"
