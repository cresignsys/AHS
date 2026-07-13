#!/bin/bash

# ==========================================
# Abey Hosting Server (AHS)
# WordPress Module
# Version 1.0.0
# ==========================================

source /opt/ahs/lib/core.sh

install_wordpress() {

    DOMAIN="$1"
    WEBROOT="$2"
    DBNAME="$3"
    DBUSER="$4"
    DBPASS="$5"
    EMAIL="$6"

    log_info "Installing WordPress..."

    mkdir -p "$WEBROOT/public"

    cd "$WEBROOT/public" || return 1

    # Download WordPress
    wp core download --allow-root

    if [ $? -ne 0 ]; then
        log_error "Failed to download WordPress."
        return 1
    fi

    log_success "WordPress downloaded."

    # Create wp-config.php
    wp config create \
        --dbname="$DBNAME" \
        --dbuser="$DBUSER" \
        --dbpass="$DBPASS" \
        --dbhost="localhost" \
        --skip-check \
        --allow-root

    if [ $? -ne 0 ]; then
        log_error "Failed to create wp-config.php."
        return 1
    fi

    log_success "wp-config.php created."

    # Install WordPress
    wp core install \
        --url="http://$DOMAIN" \
        --title="$DOMAIN" \
        --admin_user="admin" \
        --admin_password="$(generate_password)" \
        --admin_email="$EMAIL" \
        --skip-email \
        --allow-root

    if [ $? -ne 0 ]; then
        log_error "WordPress installation failed."
        return 1
    fi

    log_success "WordPress installed."

    # Permissions
    chown -R www-data:www-data "$WEBROOT"

    find "$WEBROOT" -type d -exec chmod 755 {} \;

    find "$WEBROOT" -type f -exec chmod 644 {} \;

    log_success "Permissions updated."

}
