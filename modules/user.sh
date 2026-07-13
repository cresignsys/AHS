#!/bin/bash

source /opt/ahs/lib/core.sh

create_linux_user() {

    USERNAME="$1"
    HOME_DIR="$2"

    if id "$USERNAME" >/dev/null 2>&1; then
        log_warning "User already exists: $USERNAME"
        return 1
    fi

    useradd -m -d "$HOME_DIR" -s /bin/bash "$USERNAME"

    if [ $? -eq 0 ]; then
        log_success "Linux user created: $USERNAME"
        return 0
    else
        log_error "Failed to create user: $USERNAME"
        return 1
    fi
}

delete_linux_user() {

    USERNAME="$1"

    if id "$USERNAME" >/dev/null 2>&1; then

        userdel -r "$USERNAME"

        log_success "User deleted: $USERNAME"

    else

        log_warning "User not found: $USERNAME"

    fi
}
