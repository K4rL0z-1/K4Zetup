#!/usr/bin/env bash
set -euo pipefail

sudo -v || exit 1
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &
SUDO_KEEPALIVE_PID=$!
trap 'kill $SUDO_KEEPALIVE_PID 2>/dev/null' EXIT

clear

export BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
export MODULES_DIR="$BASE_DIR/modules"

APPS_MODULE="$MODULES_DIR/01-apps"
DEV_MODULE="$MODULES_DIR/02-dev"
AI_MODULE="$MODULES_DIR/03-ai"
GAMING_MODULE="$MODULES_DIR/04-gaming"
EXTRA_MODULE="$MODULES_DIR/05-extra"

source "$BASE_DIR"/core/utils.sh

gum style --border double --margin "1" --padding "1" --border-foreground  212 "K4Zetup"

mapfile -t appsScripts < <(ls_scripts "01-apps" | gum choose --no-limit --header "Apps Module:")
mapfile -t devScripts < <(ls_scripts "02-dev" | gum choose --no-limit --header "Dev Module:")
mapfile -t aiScripts < <(ls_scripts "03-ai" | gum choose --no-limit --header "Ai Module:")
mapfile -t gamingScripts < <(ls_scripts "04-gaming" | gum choose --no-limit --header "Gaming Module:")

if gum confirm; then
    execute_scripts "$APPS_MODULE" "${appsScripts[@]}"
    execute_scripts "$DEV_MODULE" "${devScripts[@]}"
    execute_scripts "$AI_MODULE" "${aiScripts[@]}"
    execute_scripts "$GAMING_MODULE" "${gamingScripts[@]}"

    gum style --foreground 82 --border rounded --padding "1" "Installation complete! It is recommended to restart the computer."
else
    clear
    gum style "Process cancelled by the user"
fi

