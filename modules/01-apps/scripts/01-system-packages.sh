#!/usr/bin/env bash
set -euo pipefail

clean_list() {
    grep -vE '^\s*#|^\s*$' "$1" 2>/dev/null || true
}

mapfile -t pkgs < <(clean_list "$MODULES_DIR/01-apps/system-packages.txt")
if [ ${#pkgs[@]} -gt 0 ]; then
    gum spin --spinner globe --title "Synchronizing Repositories - ("${0##*/}")..." -- \
    sudo apt update -qq
    gum spin --spinner dot --title "Installing Packages - ("${0##*/}")..." -- \
    sudo env DEBIAN_FRONTEND=noninteractive apt install -y -qq "${pkgs[@]}"
fi