# dotfiles

Personal Arch Linux dotfiles, refreshed from the live system on 2026-09-21.
Configuration contents and executable permissions are preserved. Creating this
repository did not move, replace, or symlink the active files in your home directory.

## Layout

Each directory under `stow/` is a package whose contents mirror `$HOME`.
For example, `stow/nvim/.config/nvim/init.lua` links to `~/.config/nvim/init.lua`.

| Package | Configuration |
| --- | --- |
| `hypr` | Hyprland Lua modules, Hyprpaper, and wallpaper |
| `niri` | Niri compositor configuration |
| `nvim` | Neovim Lua configuration and plugin lockfile |
| `tmux` | `.tmux.conf` |
| `kitty`, `rofi`, `btop`, `zed` | Application settings |
| `zsh` | `.zshrc` and `.zshenv` |
| `bash` | `.bashrc`, `.bash_profile`, and `.bash_logout` |
| `shell` | Shared `.profile` |
| `emacs` | `.emacs.d/init.el` |
| `scripts` | Executable `.local/bin/dmenu-launcher` |
| `desktop` | Dolphin settings, MIME associations, and XDG user directories |
| `git`, `gh` | Git identity/preferences and GitHub CLI settings, without login tokens |
| `thunar` | Thunar shortcuts, custom actions, and Xfconf preferences |
| `novelwriter`, `manuskript`, `gearlever` | Flatpak app preferences, including retained settings for removed apps |
| `flatpak` | User Flatpak permission overrides |

`metadata/` holds installed package lists, versions, and the package-to-home-path
mapping, plus Flatpak application and remote inventories.
`extras/dconf.ini` is a text export of desktop preferences.
`extras/suckless/` contains the local st source/configuration and dwm build recipe;
`metadata/extra-home-paths.json` records their original locations.
`system/etc/` contains selected system configuration snapshots for manual review;
it is deliberately outside the home Stow packages.

The recheck results are recorded in `metadata/verification.md`. After cloning,
verify the saved snapshot from the repository root with:

```sh
sha256sum --check metadata/checksums.sha256
```

Regenerate the checksum list when intentionally updating the snapshot; it records
this export's regular files, not future edits or the absolute service symlink.

## Prerequisites

Install GNU Stow and Git on Arch:

```sh
sudo pacman -S --needed stow git
cd ~/dotfiles
```

Review `metadata/packages-native.txt` and `metadata/packages-foreign.txt` for the
currently explicitly installed packages. `metadata/package-versions.txt` records
all installed versions. The foreign list requires an appropriate external source;
it is not a list to pass directly to pacman.

The saved setup uses Hyprland **0.56.2-3 with the Lua `hl` API** and Neovim
**0.12.5-1 with `vim.pack`**. Use compatible builds. Shell startup also expects
Oh My Zsh at `~/.oh-my-zsh`, zoxide, and Rust's `~/.cargo/env`. Install these first
or adjust the corresponding startup files. Oh My Zsh itself is not vendored.

Hyprland references Kitty, Chromium, Dolphin, Hyprpaper, hyprpolkitagent,
Quickshell, brightnessctl, playerctl, and `wpctl`. The custom launcher uses
Python 3, dmenu, `gio`, and Kitty. No personal Quickshell configuration was found.
Tmux clipboard integration requires `wl-copy` and `wl-paste` from `wl-clipboard`.
Kitty uses Liberation Mono (`ttf-liberation`), and Rofi uses the `Arc-Dark` theme.
Neovim and Emacs download their configured plugins on first use; downloaded
plugins and language servers are not included. The saved service enablement expects
`/usr/lib/systemd/user/oo7-daemon.service` to exist.

These are faithful copies: `/home/zen` remains in shell, launcher,
and application paths. Git identity and author preferences are also preserved.
If restoring to another account, find and adjust those references first:

```sh
rg -n --hidden '/home/zen' stow
```

## Stow everything

Always specify `--target="$HOME"`: otherwise Stow's default target would be the
parent of `stow/`, which is this repository rather than your home directory.
`--no-folding` keeps real configuration directories and links individual files,
so application-generated files are less likely to end up inside the repository.

Preview first (makes no changes):

```sh
cd ~/dotfiles
./scripts/stow.sh --simulate
```

The helper discovers every package under `stow/`, uses your current `$HOME`, and
previews by default when run without arguments. It works from any working
directory. Select packages explicitly to restore only part of the setup:

```sh
./scripts/stow.sh --simulate hypr tmux nvim zsh kitty rofi
```

On this original machine, conflicts are expected because the original files still
exist. Back them up before proceeding. The following snippet moves only the
paths listed in `metadata/home-paths.json` to a timestamped directory in your
home folder. Close affected applications first. Run this once for initial setup,
not every time you restow. It also moves any existing configurations at these paths
on a different machine, so review the manifest first.

```sh
python3 - <<'PY'
from datetime import datetime
from pathlib import Path
import json
import shutil

home = Path.home()
backup = home / ('dotfiles-backup-' + datetime.now().strftime('%Y%m%d-%H%M%S-%f'))
backup.mkdir()
packages = json.loads(Path('metadata/home-paths.json').read_text())
for paths in packages.values():
    for relative in paths:
        source = home / relative
        if source.exists() or source.is_symlink():
            destination = backup / relative
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.move(str(source), str(destination))
print(f'Original files saved to: {backup}')
PY
```

Repeat the preview, then create the links:

```sh
./scripts/stow.sh --apply
```

Do not use `sudo` for home packages. Avoid `--adopt`: it would move existing home
files into the repository and replace the saved copies. Stow does not install
applications or start services. Restart applications to load their settings;
restore the saved user service enablement separately as described below.

## Individual packages and updates

```sh
# Install only Neovim and tmux.
stow --dir="$PWD/stow" --target="$HOME" --no-folding nvim tmux

# Refresh links after adding/removing configuration files.
stow --dir="$PWD/stow" --target="$HOME" --no-folding --restow nvim tmux

# Remove their links while preserving the repository's files.
stow --dir="$PWD/stow" --target="$HOME" --delete nvim tmux
```

Use `./scripts/stow.sh --delete` to unstow everything. Restore
original files from the timestamped backup afterward; check for new files created
by applications before copying anything back. Keep the repository at its current
location while stowed. To relocate it, unstow first, move it, then stow again.

After stowing, edits through home-directory symlinks edit the repository copies.
Review `git diff` before committing. This repository starts without a commit;
configure your own Git identity if needed, then save the snapshot:

```sh
git add .
git commit -m "Save current Arch Linux dotfiles"
```

## Additional settings

### Git defaults and signing

`stow/git/.gitconfig` preserves the Git identity and uses Neovim as the editor,
delta for diffs (including `git add -p`), and `master` for newly initialized
repositories. This does not rename existing branches. Install `neovim` and
`git-delta` alongside Git. Delta's `navigate` option enables `n`/`N` navigation.

Preview/install this package with `./scripts/stow.sh --simulate git` and
`./scripts/stow.sh --apply git`, backing up an existing `~/.gitconfig` first.
Once linked, `git config --global` edits the repository copy. For example:

```sh
git config --global core.editor nvim
git config --global init.defaultBranch master
```

Optional defaults to consider: `fetch.prune = true` removes stale remote-tracking
branches on fetch; `pull.ff = only` refuses divergent pulls until you explicitly
merge or rebase; `merge.conflictStyle = zdiff3` includes base context in conflicts.
Set each with `git config --global KEY VALUE` if you want that behavior.

Commit signing is not enabled until you choose and configure a key. For SSH
signing, use an existing signing key or generate a dedicated one (choose an
unused filename and a passphrase):

```sh
ssh-keygen -t ed25519 -f ~/.ssh/git_signing -C "Git signing"
git config --global gpg.format ssh
git config --global user.signingKey ~/.ssh/git_signing
git config --global commit.gpgSign true
```

The config stores only the key path; keep the private key outside this repo.
Register `~/.ssh/git_signing.pub` as a signing key with your Git hosting provider
for hosted verification. To verify locally, create an allowed-signers file:

```sh
mkdir -p ~/.config/git
printf '%s %s\n' "$(git config --global user.email)" "$(cat ~/.ssh/git_signing.pub)" >> ~/.config/git/allowed_signers
git config --global gpg.ssh.allowedSignersFile ~/.config/git/allowed_signers
# After creating a signed commit:
git verify-commit HEAD
```

Alternatively, for an existing GPG signing key, use `gpg.format openpgp`, set
`user.signingKey` to its full fingerprint (from
`gpg --list-secret-keys --keyid-format=long`), and set `commit.gpgSign true`.
Optional `tag.gpgSign true` signs tags by default too.

References: [Git configuration](https://git-scm.com/docs/git-config) and
[delta setup](https://dandavison.github.io/delta/get-started.html).

### Fresh Arch installation

1. Install the applications you want before starting the desktop. The native and
   foreign package lists are inventories, not a universal installation script:
   they include this machine's kernel/GPU packages and packages from configured
   repositories. Configure appropriate repositories and review the lists first.
2. Install Oh My Zsh and the tools required by the chosen shell configuration.
   Install Rust or adjust the `~/.cargo/env` references. Choose Zsh as your login
   shell separately if desired; Stow does not change the login shell.
3. Clone this repository to a permanent location, adjust username-specific paths
   if necessary, and run `./scripts/stow.sh --simulate`. Move conflicting defaults
   using the backup snippet above, then run `./scripts/stow.sh --apply`.
4. Restore the optional dconf settings and service below. For Flatpak preferences,
   install the matching application IDs from `metadata/flatpak-apps.tsv` using
   the remotes recorded in `metadata/flatpak-remotes.tsv`. Sign in again where needed.
   The retained `novelwriter` and `manuskript` settings use application IDs
   `io.novelwriter.novelwriter` and `ch.theologeek.Manuskript`, respectively;
   these apps are no longer in the installed-app inventory.
5. Start Hyprland with `start-hyprland`.

### Local st and dwm builds

These programs use compile-time configuration, so their files belong under
`extras/suckless/`, outside the home Stow packages. The st snapshot includes source,
`config.h`, and `config.mk`; compiled binaries and object files are excluded.
Build in a separate directory so generated files stay out of the repository:

```sh
mkdir -p ~/builds/dotfiles-st ~/builds/dotfiles-dwm
cp -a extras/suckless/st/. ~/builds/dotfiles-st/
cp -a extras/suckless/dwm/. ~/builds/dotfiles-dwm/
# With base-devel, libx11, libxft, fontconfig and freetype2 installed:
(cd ~/builds/dotfiles-st && make && sudo make install)
# Review PKGBUILD, then build/install dwm with the saved config.h:
(cd ~/builds/dotfiles-dwm && makepkg -si)
```

### Service and desktop preferences

The original absolute service symlink is preserved under `extras/systemd/`.
GNU Stow rejects absolute source symlinks, so this is excluded from the packages.
After installing the package providing `oo7-daemon.service`, restore enablement with:

```sh
systemctl --user enable oo7-daemon.service
```

Dconf preferences can be restored explicitly in a running desktop session. This
merges the exported keys into the current settings, replacing matching values:

```sh
dconf dump / > "$HOME/dconf-before-dotfiles.ini"
dconf load / < extras/dconf.ini
```

Review files under `system/etc/` individually before installing anything into
`/etc`. These include locale, console/X11 keyboard, zram, mkinitcpio, and makepkg
settings. They are reference snapshots, not a complete system backup, and are not
part of the home stow command. Boot configuration may require rebuilding initramfs;
locale changes may require `locale-gen`.

Excluded: browser/Discord profiles, logins, credentials, PulseAudio cookie,
keyrings, shell history, caches, generated state, installed editor plugins,
Codex authentication/session data and its installed binary, GitHub CLI login tokens,
password-manager databases, compiled build outputs, and obsolete
`*.before-*`/`.backups/` files. The empty GTK configuration directory has no files to
save. Pacman configuration and private repository credentials, network profiles,
SSH host keys, and other sensitive `/etc` data are not copied.

### oo7 TTY unlocking and GCR SSH agent

The `oo7` Stow package saves a PAM login template at `~/.config/oo7/pam/login`.
It contains no passwords or keyring data. PAM reads `/etc/pam.d/login`, so install
the template separately as a root-owned regular file:

On a fresh Arch installation, install the dependencies below and install dwm
as described above. Run these commands as your normal desktop user from this repo.
Back up conflicting `.xinitrc`, `.zshenv`, and `.zshrc` files before Stowing.
The saved Zsh configuration also needs the shell prerequisites listed above.

```sh
sudo pacman -S --needed oo7 gcr gcr-4 xorg-xinit stow
./scripts/stow.sh --apply oo7 zsh x11
./scripts/install-oo7-pam.sh
systemctl --user enable --now oo7-daemon.service gcr-ssh-agent.socket
```

Log out of the TTY completely, log back in with your account password, then run
`startx`. These configurations use `$HOME` and `$XDG_RUNTIME_DIR`, so the oo7/X11
setup does not depend on this machine's username. The rest of the dotfiles may
contain machine-specific paths. `gcr` supplies the graphical password prompter;
`gcr-4` supplies the SSH agent. Stow alone does not install PAM hooks or enable
services. If a future Arch PAM layout changes, the installer will stop for review.
Keyring contents are intentionally excluded: this restores the integration,
not saved passwords. Back up or migrate secrets separately if needed.

The installer asks for sudo authentication, backs up the existing login file,
and refuses to overwrite unrelated PAM changes. Keep a session open while testing
password login on another TTY. The keyring password must match the account password;
autologin cannot supply it. These hooks cover TTY login, not display managers or
password changes made through `passwd`.

The Zsh package sets `SSH_AUTH_SOCK` to `$XDG_RUNTIME_DIR/gcr/ssh` for local
sessions. Start a new login session to propagate it to dwm and its applications.
Stow does not enable services; run the systemctl command above when restoring.

### dwm X11 session startup

The `x11` Stow package provides `~/.xinitrc` for `startx`. It sources Arch's
`/etc/X11/xinit/xinitrc.d/*.sh` before starting dwm, publishing `DISPLAY` and
`XAUTHORITY` to D-Bus and systemd user services so GCR can show unlock dialogs.
Back up any existing `.xinitrc`, then run `./scripts/stow.sh --apply x11`.
Restart the X session for changes to take effect.

### Niri

The `niri` package contains `~/.config/niri/config.kdl`. Restore with
`./scripts/stow.sh --apply niri` after backing up any existing config. Launch
from a TTY with `niri-session`. Edit `stow/niri/.config/niri/config.kdl` (or the
linked home path); niri reloads changes automatically. Check syntax with
`niri validate`.
