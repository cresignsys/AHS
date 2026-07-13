#!/bin/bash

clear_screen() {
    clear
}

pause() {
    read -p "Press Enter to continue..."
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "Run using sudo."
        exit 1
    fi
}
