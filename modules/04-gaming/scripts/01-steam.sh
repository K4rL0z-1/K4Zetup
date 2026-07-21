#!/usr/bin/env bash
set -euo pipefail

if ! command -v steam &> /dev/null; then
    tmpfile="/tmp/steam.deb"

    if ! command -v curl &> /dev/null; then
        gum spin --spinner dot --title "Installing Dependence: curl - ("${0##*/}")..." -- \
        sudo DEBIAN_FRONTEND=noninteractive apt install -y -qq curl
    fi

    gum spin --spinner globe --title "Downloading Steam Package From steampowered.com - ("${0##*/}")..." -- \
    curl -fsSL -o "$tmpfile" \
        "https://cdn.akamai.steamstatic.com/client/installer/steam.deb"

    gum spin --spinner dot --title "Installing Steam - ("${0##*/}")..." -- \
    sudo DEBIAN_FRONTEND=noninteractive apt install -y -qq "$tmpfile"

    gum spin --spinner dot --title "Removing Steam From "/tmp/" Directory - ("${0##*/}")..." -- \
    rm -f "$tmpfile"
fi