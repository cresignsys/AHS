#!/bin/bash

# ==========================================
# Abey Hosting Server
# Validator Library
# ==========================================

# -------------------------------
# Validate Domain
# -------------------------------

validate_domain() {

    local DOMAIN="$1"

    if [[ -z "$DOMAIN" ]]; then
        return 1
    fi

    if [[ "$DOMAIN" =~ ^([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$ ]]; then
        return 0
    fi

    return 1
}

# -------------------------------
# Validate Email
# -------------------------------

validate_email() {

    local EMAIL="$1"

    if [[ "$EMAIL" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
        return 0
    fi

    return 1
}

# -------------------------------
# Validate Linux Username
# -------------------------------

validate_username() {

    local USERNAME="$1"

    if [[ "$USERNAME" =~ ^[a-z_][a-z0-9_-]{2,31}$ ]]; then
        return 0
    fi

    return 1
}

# -------------------------------
# Validate Website Folder
# -------------------------------

validate_webroot() {

    local WEBROOT="$1"

    if [ -d "$WEBROOT" ]; then
        return 1
    fi

    return 0
}

# -------------------------------
# Validate Database Name
# -------------------------------

validate_database() {

    local DB="$1"

    if [[ "$DB" =~ ^[A-Za-z0-9_]+$ ]]; then
        return 0
    fi

    return 1
}

# -------------------------------
# Validate Password Length
# -------------------------------

validate_password() {

    local PASSWORD="$1"

    if [ ${#PASSWORD} -ge 12 ]; then
        return 0
    fi

    return 1
}

# -------------------------------
# Validate IP Address
# -------------------------------

validate_ip() {

    local IP="$1"

    if [[ "$IP" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        return 0
    fi

    return 1
}

# -------------------------------
# Validate Port Number
# -------------------------------

validate_port() {

    local PORT="$1"

    if [[ "$PORT" =~ ^[0-9]+$ ]] && [ "$PORT" -ge 1 ] && [ "$PORT" -le 65535 ]; then
        return 0
    fi

    return 1
}
