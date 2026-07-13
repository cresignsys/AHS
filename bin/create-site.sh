#!/bin/bash

source /opt/ahs/lib/core.sh
source /opt/ahs/modules/website.sh

clear

echo "======================================"
echo "      Create New Website"
echo "======================================"
echo

read -p "Domain Name : " DOMAIN
read -p "Admin Email : " EMAIL

echo
echo "Creating website..."
echo

create_site "$DOMAIN" "$EMAIL"

echo
read -p "Press Enter to continue..."
