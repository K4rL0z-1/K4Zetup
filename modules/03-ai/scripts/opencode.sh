#!/usr/bin/env bash
set -euo pipefail

if ! grep -q "opencode" ~/.bashrc; then
    if ! command -v curl &> /dev/null; then
        gum spin --spinner dot --title "Installing Dependence: curl - ("${0##*/}")..." -- \
        sudo DEBIAN_FRONTEND=noninteractive apt install -y -qq curl
    fi

    gum spin --spinner dot --title "Installing Opencode - ("${0##*/}")..." -- \
    curl -fsSL https://opencode.ai/install | bash
fi