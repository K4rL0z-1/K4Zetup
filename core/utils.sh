ls_scripts() {
    ls "$MODULES_DIR"/"$1"/scripts/
}

execute_scripts() {
    local module="$1"
    shift

    for scriptName in "$@"; do
        local scriptPath
        scriptPath=$(find "$module" -name "$scriptName" -print -quit)

        if [[ -n "$scriptPath" ]]; then
            bash "$scriptPath"
        fi
    done
}