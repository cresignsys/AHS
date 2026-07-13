#!/bin/bash

echo
echo "========== SERVER STATUS =========="
echo

echo "Hostname:"
hostname

echo
echo "Uptime:"
uptime -p

echo
echo "Memory:"
free -h

echo
echo "Disk:"
df -h /

echo
echo "PHP:"
php -v | head -1

echo
echo "MySQL:"
mysql --version

echo
echo "Nginx:"
nginx -v 2>&1

echo
echo "==================================="
