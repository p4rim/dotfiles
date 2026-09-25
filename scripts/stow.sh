#!/usr/bin/env bash
# Preview by default. Run with --apply to link, or --delete to unlink.
set -euo pipefail

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)

install_oo7_pam() (
    set -euo pipefail
    template=$1
    [[ -f /usr/lib/security/pam_oo7.so ]] || { echo "Install the oo7 package first." >&2; exit 1; }
    # Refuse to overwrite unrelated local PAM changes.
    base_stack() {
        sed -e '/pam_oo7\.so/d' \
            -e '/^# oo7 0\.6 TTY workaround: allow the async PAM sender to finish before TIOCNOTTY\.$/d' \
            -e '\|^session    optional     pam_exec\.so quiet type=open_session /usr/bin/sleep 3$|d' "$1"
    }
    if ! diff -u <(base_stack /etc/pam.d/login) <(base_stack "$template"); then
        echo "PAM configuration differs from the saved template; review it manually." >&2
        exit 1
    fi
    if cmp -s "$template" /etc/pam.d/login; then
        echo "oo7 TTY PAM configuration is already installed."
        exit 0
    fi
    if (( EUID != 0 )); then
        # Elevate only PAM installation, never Stow or its home directory target.
        sudo -- bash -c "$(declare -f install_oo7_pam); install_oo7_pam \"\$1\"" bash "$template"
        exit "$?"
    fi
    backup=$(mktemp /etc/pam.d/login.before-oo7.XXXXXXXX)
    cp --preserve=all -- /etc/pam.d/login "$backup"
    install -o root -g root -m 0644 -- "$template" /etc/pam.d/login
    printf 'Installed oo7 TTY PAM configuration. Backup: %s\n' "$backup"
)

mode=${1:---simulate}
if (($#)); then shift; fi
case "$mode" in
    --simulate) action=(--simulate --restow) ;;
    --apply) action=(--restow) ;;
    --delete) action=(--delete) ;;
    *) printf 'Usage: %s [--simulate|--apply|--delete] [package ...]\n' "$0" >&2; exit 2 ;;
esac

packages=("$@")
if ((${#packages[@]} == 0)); then
    for package_dir in "$repo_dir"/stow/*; do
        [[ -d "$package_dir" ]] && packages+=("${package_dir##*/}")
    done
fi
for package in "${packages[@]}"; do
    if [[ ! "$package" =~ ^[a-zA-Z0-9][a-zA-Z0-9_-]*$ || ! -d "$repo_dir/stow/$package" ]]; then
        printf 'Unknown package: %s\n' "$package" >&2
        exit 2
    fi
done

stow --dir="$repo_dir/stow" --target="$HOME" --no-folding \
    --verbose "${action[@]}" "${packages[@]}"

for package in "${packages[@]}"; do
    if [[ "$package" == oo7 ]]; then
        case "$mode" in
            --apply) install_oo7_pam "$repo_dir/stow/oo7/.config/oo7/pam/login" ;;
            --simulate) printf 'Would install the oo7 TTY PAM template (sudo if needed).\n' ;;
            --delete) printf 'oo7 links removed; /etc/pam.d/login is preserved.\n' ;;
        esac
        break
    fi
done
