#!/usr/bin/env bash
set -euo pipefail

if ! command -v node &> /dev/null; then
    if ! command -v curl &> /dev/null; then
        gum spin --spinner dot --title "Installing Dependence: curl - ("${0##*/}")..." -- \
        sudo DEBIAN_FRONTEND=noninteractive apt install -y -qq curl
    fi

    gum spin --spinner dot --title "Installing NodeJS - ("${0##*/}")..." -- \
    # https://nodejs.org/en/download
    # Download and install nvm:
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash

    # in lieu of restarting the shell
    \. "$HOME/.nvm/nvm.sh"

    # Download and install Node.js:
    nvm install 24

    # Verify the Node.js version:
    node -v # Should print "v24.18.0".

    # Verify npm version:
    npm -v # Should print "11.16.0".
fi