#!/usr/bin/env bash
set -euo pipefail

if ! command -v flatpak &> /dev/null; then
    echo "You don't have Flatpak installed."
    gum spin --spinner dot --title "Installing Flatpak - ("${0##*/}")..." -- \
    sudo env DEBIAN_FRONTEND=noninteractive apt install -y -qq flatpak gnome-software-plugin-flatpak && flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
fi

clean_list() {
    grep -vE '^\s*#|^\s*$' "$1" 2>/dev/null || true
}

mapfile -t pkgs < <(clean_list "$MODULES_DIR/01-apps/flatpak-apps.txt")
if [ ${#pkgs[@]} -gt 0 ]; then
    gum spin --spinner dot --title "Installing Flatpak Apps - ("${0##*/}")..." -- \
    flatpak install -y flathub ${pkgs[*]}
fi