#!/usr/bin/env bash
set -euo pipefail
echo "[AfterInstall] Setting permissions on /var/www/html"
chown -R root:root /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;
