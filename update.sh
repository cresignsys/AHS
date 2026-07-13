#!/bin/bash

echo "======================================"
echo " Abey Hosting Server Updater"
echo "======================================"

chmod +x /opt/ahs/ahs

find /opt/ahs/bin -type f -exec chmod +x {} \;
find /opt/ahs/lib -type f -exec chmod +x {} \;
find /opt/ahs/modules -type f -exec chmod +x {} \;

echo
echo "Checking Bash scripts..."

for file in $(find /opt/ahs -name "*.sh")
do
    bash -n "$file"

    if [ $? -eq 0 ]; then
        echo "[ OK ] $file"
    else
        echo "[FAIL] $file"
    fi
done

echo
echo "Update Completed."
