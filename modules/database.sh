#!/bin/bash

# ==========================================
# Abey Hosting Server (AHS)
# Database Module
# Version 1.0.0
# ==========================================

source /opt/ahs/lib/core.sh

create_database() {

    DBNAME="$1"
    DBUSER="$2"
    DBPASS="$3"

    log_info "Creating MySQL database..."

    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<EOF
CREATE DATABASE IF NOT EXISTS \`$DBNAME\`;
CREATE USER IF NOT EXISTS '$DBUSER'@'localhost' IDENTIFIED BY '$DBPASS';
GRANT ALL PRIVILEGES ON \`$DBNAME\`.* TO '$DBUSER'@'localhost';
FLUSH PRIVILEGES;
EOF

    if [ $? -eq 0 ]; then
        log_success "Database created."
    else
        log_error "Database creation failed."
        return 1
    fi
}

delete_database() {

    DBNAME="$1"

    log_info "Deleting database..."

    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" \
        -e "DROP DATABASE IF EXISTS \`$DBNAME\`;"

    if [ $? -eq 0 ]; then
        log_success "Database deleted."
    else
        log_error "Database deletion failed."
    fi
}

database_exists() {

    DBNAME="$1"

    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" \
        -e "USE \`$DBNAME\`;" >/dev/null 2>&1
}

list_databases() {

    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" \
        -e "SHOW DATABASES;"
}
