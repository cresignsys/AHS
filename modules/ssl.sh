#!/bin/bash

# ==========================================
# Abey Hosting Server (AHS)
# SSL Module
# Version 1.0.0
# ==========================================

source /opt/ahs/lib/core.sh

install_ssl() {

    DOMAIN="$1"
    EMAIL="$2"

    log_info "Installing Let's Encrypt SSL..."

    certbot --nginx \
        -d "$DOMAIN" \
        -d "www.$DOMAIN" \
        --non-interactive \
        --agree-tos \
        --email "$EMAIL" \
        --redirect

    if [ $? -eq 0 ]; then
        log_success "SSL installed successfully."
    else
        log_error "SSL installation failed."
        return 1
    fi
}

renew_ssl() {

    log_info "Renewing SSL certificates..."

    certbot renew --quiet

    if [ $? -eq 0 ]; then
        log_success "SSL certificates renewed."
    else
        log_error "SSL renewal failed."
    fi
}

check_ssl() {

    DOMAIN="$1"

    echo
    echo "Checking SSL certificate..."

    echo | openssl s_client -connect "$DOMAIN:443" -servername "$DOMAIN" 2>/dev/null \
        | openssl x509 -noout -dates
}
