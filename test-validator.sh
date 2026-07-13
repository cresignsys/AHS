#!/bin/bash

source /opt/ahs/lib/core.sh

echo

read -p "Domain : " DOMAIN

if validate_domain "$DOMAIN"; then
    echo "Valid Domain"
else
    echo "Invalid Domain"
fi

echo

read -p "Email : " EMAIL

if validate_email "$EMAIL"; then
    echo "Valid Email"
else
    echo "Invalid Email"
fi
