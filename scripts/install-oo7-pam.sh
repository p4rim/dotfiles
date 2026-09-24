#!/usr/bin/env bash
# Install the reviewed TTY PAM template as a root-owned regular file.
set -euo pipefail
repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
template="$repo_dir/stow/oo7/.config/oo7/pam/login"
if (( EUID != 0 )); then
    exec sudo -- "$0" "$@"
fi
[[ -f /usr/lib/security/pam_oo7.so ]] || { echo "Install the oo7 package first." >&2; exit 1; }
# Refuse to overwrite unrelated local PAM changes.
if ! diff -u <(sed '/pam_oo7\.so/d' /etc/pam.d/login) <(sed '/pam_oo7\.so/d' "$template"); then
    echo "PAM configuration differs from the saved template; review it manually." >&2
    exit 1
fi
if cmp -s "$template" /etc/pam.d/login; then
    echo "oo7 TTY PAM configuration is already installed."
    exit 0
fi
backup=$(mktemp /etc/pam.d/login.before-oo7.XXXXXXXX)
cp --preserve=all -- /etc/pam.d/login "$backup"
install -o root -g root -m 0644 -- "$template" /etc/pam.d/login
printf 'Installed oo7 TTY PAM configuration. Backup: %s\n' "$backup"
