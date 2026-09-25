# Personal package selections — official Arch core/extra only.
# One package per line; use # for comments. Pacman resolves dependencies.
# Installer requirements are in config/base-packages.txt.

# System and hardware
base
base-devel
efibootmgr
intel-ucode
linux
linux-firmware
mkinitcpio
nvidia-open

# Dotfile management
stow

# Terminal and command-line tools
fd
fzf
kitty
ripgrep
tmux
tree
unzip
zoxide

# Monitoring and documentation
btop
fastfetch
man-db
man-pages

# Development and source control
git
github-cli
neovim
nodejs
npm
tree-sitter-cli

# Networking and remote access
network-manager-applet
networkmanager
openssh

# Wayland desktop and integration
hyprland
hyprpaper
mako
qt5-wayland
qt6-wayland
quickshell
wl-clipboard

# XDG desktop integration
# xdg-desktop-portal itself is a dependency of the Hyprland backend.
xdg-desktop-portal-gtk # File-dialog fallback required by the Hyprland portal.
xdg-desktop-portal-hyprland
xdg-user-dirs
xdg-utils # xdg-open, xdg-mime, xdg-settings and desktop integration helpers.

# Launcher and file management
dmenu
dolphin
gvfs
thunar
tumbler
yazi

# Browsers and communication
chromium
discord
firefox

# Audio and media controls
pipewire
pipewire-alsa
pipewire-jack
pipewire-pulse
playerctl
wiremix
wireplumber

# Images, screenshots and multimedia
ffmpeg
grim
mpv
slurp
yt-dlp

# Virtual machines
gnome-boxes

# Fonts
noto-fonts
noto-fonts-cjk
noto-fonts-emoji
terminus-font
ttf-dejavu
ttf-jetbrains-mono
ttf-jetbrains-mono-nerd
ttf-liberation

# st is not included: the planned source build is outside this official-repo ISO.
