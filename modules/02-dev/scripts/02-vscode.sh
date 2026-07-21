#!/usr/bin/env bash
set -euo pipefail

if ! command -v code &> /dev/null; then
    tmpfile="/tmp/vscode.deb"

    if ! command -v curl &> /dev/null; then
        gum spin --spinner dot --title "Installing Dependence: curl - ("${0##*/}")..." -- \
        sudo DEBIAN_FRONTEND=noninteractive apt install -y -qq curl
    fi

    gum spin --spinner globe --title "Downloading VSCode Package From microsoft.com - ("${0##*/}")..." -- \
    curl -fsSL -o "$tmpfile" \
        "https://go.microsoft.com/fwlink/?LinkID=760868"

    gum spin --spinner dot --title "Installing VSCode - ("${0##*/}")..." -- \
    sudo DEBIAN_FRONTEND=noninteractive apt install -y -qq "$tmpfile"

    gum spin --spinner dot --title "Removing VSCode From "/tmp/" Directory - ("${0##*/}")..." -- \
    rm -f "$tmpfile"
fi