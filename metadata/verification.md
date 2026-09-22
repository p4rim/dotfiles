# Snapshot verification — 2026-09-21

The snapshot was checked against the local system after synchronization.

- All 54 home configuration files in 22 Stow packages matched their live sources
  byte for byte, including Unix permission bits. No extra or stale home files
  remained relative to `home-paths.json`, excluding obsolete backup files.
- All 21 st/dwm source and build files matched `extra-home-paths.json` sources.
- All seven saved `/etc` files matched the system, including permissions.
- The saved oo7 service symlink matched the live enablement symlink.
- Pacman inventories, Flatpak inventories, and the dconf export were refreshed.
- Stow preview created no files in a temporary home. Installing every package
  produced all 54 expected symlinks with the correct destinations. Repeating the
  installation succeeded, and unstowing removed every link.
- Installing and removing just Hyprland, tmux, Neovim, Zsh, Kitty, and Rofi also
  succeeded. An existing conflicting tmux file was rejected without alteration.
- All 21 Hyprland/Neovim Lua files compiled. Shell startup files and the Stow
  helper passed shell syntax checks. JSON manifests/lockfile, Thunar XML, and the
  Python launcher parsed successfully.
- The saved tmux configuration loaded in a separate temporary server; mouse,
  status bar, and Wayland clipboard settings were verified.
- A scan for common private keys, token formats, credential assignments, and
  URLs containing passwords found no matches in the exported repository.

`checksums.sha256` covers every regular repository file except itself and Git's
internal files. The service symlink is recorded separately above.

This validates snapshot fidelity and Stow installation, not a fresh OS boot.
Application packages, compatible Hyprland/Neovim versions, Oh My Zsh, and optional
builds/services still need installation as described in the README. Personal
identity, author preferences, and `/home/zen` paths are preserved intentionally.
Browser profiles, credentials, password-manager data, history, downloaded plugins,
caches, and old config backups are excluded.

The previous repository contents were backed up outside this repository at
`~/.local/state/nero/backups/20260921-045026-146003/` before synchronization.
The active system and home configuration files were not replaced or stowed.
