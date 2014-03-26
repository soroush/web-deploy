#!/bin/bash
mkdir -p ./.backups
temp=$1".temp"
backup="./.backups/$1.backup"
echo "Backup $backup..."
cp -r --parents $1 ./.backups/
echo "Backup saved to $backup."
echo "Removing newlines..."
sed -i -e :a -e N -e 's/\n/ /' -e ta $1
echo "Collapsing whitespaces..."
sed -i -r -e 's/[ \t\n]+/ /g' $1
echo "Removing out of dom whitespaces..."
sed -i -r -e 's/>[ \t]+</></g' $1