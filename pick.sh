#!/bin/bash


# Combined script to pick Waybar config or style using option flags
# Usage: pick.sh [-c] [-s] [-d] [-l <level>]
#   -c    Pick config
#   -s    Pick style
#   -d    Debug (show output)
#   -l    Log level: none, error, all
#   -h    Show help


LOG_LEVEL="none"
DEBUG=0
LOG_DIR="$HOME/.config/waybar/logs"
LOG_FILE="$LOG_DIR/waybar.log"
ERROR_LOG_FILE="$LOG_DIR/waybar_error.log"

show_help() {
    echo "Usage: $0 [-c] [-s] [-d] [-l <level>]"
    echo "  -c    Pick Waybar config"
    echo "  -s    Pick Waybar style"
    echo "  -d    Debug (show output)"
    echo "  -l    Log level: none, error, all"
    echo "  -h    Show help"
}

run_waybar() {
    mkdir -p "$LOG_DIR"
    if [ "$DEBUG" -eq 1 ]; then
        killall waybar
        waybar
    else
        case "$LOG_LEVEL" in
            none)
                killall waybar &>/dev/null
                waybar &>/dev/null &
                ;;
            error)
                killall waybar 2>/dev/null 1>/dev/null
                waybar 2>"$ERROR_LOG_FILE" 1>/dev/null &
                ;;
            all)
                killall waybar &>"$LOG_FILE"
                waybar &>>"$LOG_FILE" &
                ;;
            *)
                killall waybar &>/dev/null
                waybar &>/dev/null &
                ;;
        esac
    fi
}

pick_config() {
    configChoice=$(ls configs | walker -d -p 'Waybar Config')
    ln -sf "configs/$configChoice" config
    run_waybar
}

pick_style() {
    styleChoice=$(ls style | walker -d -p 'Waybar Style')
    ln -sf "style/$styleChoice" style.css
    run_waybar
}

if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

while getopts "cshdl:" opt; do
    case $opt in
        c)
            PICK_CONFIG=1
            ;;
        s)
            PICK_STYLE=1
            ;;
        d)
            DEBUG=1
            ;;
        l)
            LOG_LEVEL="$OPTARG"
            ;;
        h)
            show_help
            exit 0
            ;;
        *)
            show_help
            exit 1
            ;;
    esac
done

if [ "$PICK_CONFIG" = "1" ]; then
    pick_config
fi
if [ "$PICK_STYLE" = "1" ]; then
    pick_style
fi
