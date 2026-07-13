#!/bin/bash

# ==========================================
# Abey Hosting Server (AHS)
# Nginx Module
# Version 1.0.0
# ==========================================

source /opt/ahs/lib/core.sh

NGINX_AVAILABLE="/etc/nginx/sites-available"
NGINX_ENABLED="/etc/nginx/sites-enabled"
TEMPLATE="/opt/ahs/templates/nginx-site.conf"

create_nginx_site() {

    DOMAIN="$1"
    WEBROOT="$2"

    CONF="$NGINX_AVAILABLE/$DOMAIN.conf"

    log_info "Creating Nginx configuration..."

    if [ ! -f "$TEMPLATE" ]; then
        log_error "Template not found: $TEMPLATE"
        return 1
    fi

    cp "$TEMPLATE" "$CONF"

    sed -i "s|{{DOMAIN}}|$DOMAIN|g" "$CONF"
    sed -i "s|{{WEBROOT}}|$WEBROOT|g" "$CONF"

    log_success "Nginx configuration created."

}

enable_nginx_site() {

    DOMAIN="$1"

    ln -sf \
        "$NGINX_AVAILABLE/$DOMAIN.conf" \
        "$NGINX_ENABLED/$DOMAIN.conf"

    log_success "Site enabled."

}

disable_nginx_site() {

    DOMAIN="$1"

    rm -f "$NGINX_ENABLED/$DOMAIN.conf"

    log_success "Site disabled."

}

delete_nginx_site() {

    DOMAIN="$1"

    rm -f "$NGINX_AVAILABLE/$DOMAIN.conf"
    rm -f "$NGINX_ENABLED/$DOMAIN.conf"

    log_success "Nginx configuration removed."

}

reload_nginx() {

    log_info "Testing Nginx configuration..."

    nginx -t

    if [ $? -ne 0 ]; then
        log_error "Nginx configuration test failed."
        return 1
    fi

    systemctl reload nginx

    if [ $? -eq 0 ]; then
        log_success "Nginx reloaded."
    else
        log_error "Failed to reload Nginx."
        return 1
    fi

}

list_nginx_sites() {

    ls "$NGINX_ENABLED"

}
