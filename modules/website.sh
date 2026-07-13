#!/bin/bash

# ==========================================
# Abey Hosting Server (AHS)
# Website Module
# Version 1.0.0
# ==========================================

source /opt/ahs/lib/core.sh

source /opt/ahs/modules/user.sh
source /opt/ahs/modules/database.sh
source /opt/ahs/modules/nginx.sh
source /opt/ahs/modules/wordpress.sh

create_site() {

    DOMAIN="$1"
    EMAIL="$2"

    echo

    #############################################
    # Validate Input
    #############################################

    if ! validate_domain "$DOMAIN"; then
        log_error "Invalid domain name."
        return 1
    fi

    if ! validate_email "$EMAIL"; then
        log_error "Invalid email address."
        return 1
    fi

    #############################################
    # Variables
    #############################################

    USERNAME=$(echo "$DOMAIN" | tr '.' '_')

    WEBROOT="/var/www/$DOMAIN"

    DBNAME="wp_${USERNAME}"
    DBUSER="wp_${USERNAME}"
    DBPASS=$(generate_password)

    SITECONF="/opt/ahs/sites/$DOMAIN.conf"

    #############################################
    # Already Exists?
    #############################################

    if website_exists "$DOMAIN"; then
        log_error "Website already exists."
        return 1
    fi

    #############################################
    # Create Website Folder
    #############################################

    log_info "Creating website folders..."

    mkdir -p "$WEBROOT/public"
    mkdir -p "$WEBROOT/logs"
    mkdir -p "$WEBROOT/backup"
    mkdir -p "$WEBROOT/ssl"

    if [ $? -ne 0 ]; then
        log_error "Unable to create website folders."
        return 1
    fi

    log_success "Website folders created."

    #############################################
    # Create Linux User
    #############################################

    create_linux_user "$USERNAME" "$WEBROOT"

    if [ $? -ne 0 ]; then
        return 1
    fi

    #############################################
    # Set Ownership
    #############################################

    chown -R "$USERNAME:$USERNAME" "$WEBROOT"

    #############################################
    # Create Database
    #############################################

    create_database "$DBNAME" "$DBUSER" "$DBPASS"

    if [ $? -ne 0 ]; then
        return 1
    fi

    #############################################
    # Create Nginx Site
    #############################################

    create_nginx_site "$DOMAIN" "$WEBROOT"

    if [ $? -ne 0 ]; then
        return 1
    fi

    enable_nginx_site "$DOMAIN"

    reload_nginx

    #############################################
    # Install WordPress
    #############################################

    install_wordpress \
        "$DOMAIN" \
        "$WEBROOT" \
        "$DBNAME" \
        "$DBUSER" \
        "$DBPASS" \
        "$EMAIL"

    #############################################
    # Save Site Configuration
    #############################################

    cat > "$SITECONF" <<EOF
DOMAIN=$DOMAIN
EMAIL=$EMAIL
USERNAME=$USERNAME
WEBROOT=$WEBROOT
DATABASE=$DBNAME
DBUSER=$DBUSER
DBPASS=$DBPASS
STATUS=ACTIVE
CREATED=$(current_date)
EOF

    #############################################
    # Summary
    #############################################

    echo
    echo "======================================"
    echo " Website Created Successfully"
    echo "======================================"
    echo
    echo "Domain      : $DOMAIN"
    echo "Email       : $EMAIL"
    echo "Linux User  : $USERNAME"
    echo "Web Root    : $WEBROOT"
    echo
    echo "Database    : $DBNAME"
    echo "DB User     : $DBUSER"
    echo "DB Password : $DBPASS"
    echo
    echo "Config File : $SITECONF"
    echo

    log_success "Website provisioning completed."

}

###################################################
# Delete Website
###################################################

delete_site() {

    echo "Delete Website - Coming Soon"

}

###################################################
# List Websites
###################################################

list_sites() {

    echo
    echo "Registered Websites"
    echo

    if [ ! -d /opt/ahs/sites ]; then
        echo "No websites found."
        return
    fi

    for file in /opt/ahs/sites/*.conf
    do
        [ -f "$file" ] || continue
        grep "^DOMAIN=" "$file" | cut -d= -f2
    done

}

###################################################
# Website Information
###################################################

website_info() {

    DOMAIN="$1"

    CONF="/opt/ahs/sites/$DOMAIN.conf"

    if [ ! -f "$CONF" ]; then
        log_error "Website not found."
        return 1
    fi

    cat "$CONF"

}
