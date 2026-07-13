#!/bin/bash

source /opt/ahs/lib/core.sh
source /opt/ahs/modules/website.sh

clear

echo "========================================"
echo " Delete Website"
echo "========================================"
echo

read -p "Domain Name: " DOMAIN

echo
echo "WARNING!"
echo "This will permanently delete:"
echo
echo " - Website Files"
echo " - Database"
echo " - Database User"
echo " - Linux User"
echo " - Nginx Configuration"
echo " - Site Configuration"
echo

read -p "Continue? (yes/no): " ANSWER

if [ "$ANSWER" != "yes" ]; then
    echo
    echo "Cancelled."
    exit
fi

delete_site "$DOMAIN"

echo
read -p "Press Enter..."
