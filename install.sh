#!/bin/bash

echo "Installing Abey Hosting Server..."

mkdir -p /opt/ahs

chmod +x /opt/ahs/ahs

ln -sf /opt/ahs/ahs /usr/local/bin/ahs

echo "Done."

echo

echo "Run:"
echo

echo "sudo ahs"
