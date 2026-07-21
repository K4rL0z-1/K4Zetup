#!/usr/bin/env bash
set -euo pipefail

clean_list() {
    grep -vE '^\s*#|^\s*$' "$1" 2>/dev/null || true
}

mapfile -t pkgs < <(clean_list "$MODULES_DIR/02-dev/vscode-extensions.txt")
if ! command -v code &> /dev/null; then
    echo "You don't have Vscode installed. Skipping..."
else
    if [ ${#pkgs[@]} -gt 0 ]; then
        while read -r ext; do
            gum spin --spinner dot --title "Installing Vscode Extensions: "$ext" - ("${0##*/}")..." -- \
            code --install-extension "$ext"
        done < <(clean_list "$MODULES_DIR/02-dev/vscode-extensions.txt")
    fi
fi
