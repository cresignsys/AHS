#!/bin/bash

# ==========================================
# Abey Hosting Server (AHS)
# Core Library
# Version 1.0.0
# ==========================================

# -------------------------------
# Load Configuration
# -------------------------------

CONFIG_FILE="/opt/ahs/config/ahs.conf"

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "ERROR: Configuration file not found."
    exit 1
fi

# -------------------------------
# Load Libraries
# -------------------------------

LIB_DIR="/opt/ahs/lib"

[ -f "$LIB_DIR/logger.sh" ] && source "$LIB_DIR/logger.sh"
[ -f "$LIB_DIR/utils.sh" ] && source "$LIB_DIR/utils.sh"
[ -f "$LIB_DIR/validator.sh" ] && source "$LIB_DIR/validator.sh"

# -------------------------------
# Reload Configuration
# -------------------------------

load_config() {
    source "$CONFIG_FILE"
}

# -------------------------------
# Root Permission Check
# -------------------------------

require_root() {

    if [ "$EUID" -ne 0 ]; then

        echo
        echo "======================================"
        echo "ERROR"
        echo "======================================"
        echo
        echo "Please run using:"
        echo
        echo "sudo ahs"
        echo
        exit 1

    fi

}

# -------------------------------
# Command Exists
# -------------------------------

command_exists() {

    command -v "$1" >/dev/null 2>&1

}

# -------------------------------
# Service Running
# -------------------------------

check_service() {

    systemctl is-active --quiet "$1"

}

service_status() {

    if check_service "$1"; then

        log_success "$1 is running"

    else

        log_error "$1 is NOT running"

    fi

}

# -------------------------------
# File Exists
# -------------------------------

file_exists() {

    [ -f "$1" ]

}

# -------------------------------
# Directory Exists
# -------------------------------

directory_exists() {

    [ -d "$1" ]

}

# -------------------------------
# Generate Password
# -------------------------------

generate_password() {

    openssl rand -base64 18

}

# -------------------------------
# Date
# -------------------------------

current_date() {

    date "+%Y-%m-%d %H:%M:%S"

}

# -------------------------------
# System Information
# -------------------------------

server_hostname() {

    hostname

}

server_uptime() {

    uptime -p

}

server_memory() {

    free -h

}

server_disk() {

    df -h /

}

# -------------------------------
# PHP Version
# -------------------------------

php_version() {

    php -v | head -1

}

# -------------------------------
# MySQL Version
# -------------------------------

mysql_version() {

    mysql --version

}

# -------------------------------
# Nginx Version
# -------------------------------

nginx_version() {

    nginx -v 2>&1

}

# -------------------------------
# Website Exists
# -------------------------------

website_exists() {

    DOMAIN="$1"

    [ -d "/var/www/$DOMAIN" ]

}

# -------------------------------
# Linux User Exists
# -------------------------------

linux_user_exists() {

    id "$1" >/dev/null 2>&1

}

# -------------------------------
# Database Exists
# -------------------------------

database_exists() {

    DB="$1"

    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" \
    -e "USE \`$DB\`;" >/dev/null 2>&1

}

# -------------------------------
# End
# -------------------------------
