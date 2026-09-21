#!/usr/bin/env bash
# Preview by default. Run with --apply to link, or --delete to unlink.
set -euo pipefail

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
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

exec stow --dir="$repo_dir/stow" --target="$HOME" --no-folding \
    --verbose "${action[@]}" "${packages[@]}"
