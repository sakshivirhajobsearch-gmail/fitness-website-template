#!/usr/bin/env bash
set -euo pipefail

echo "[BeforeInstall] Backing up current site at /var/www/html if exists"
if [ -d /var/www/html ]; then
  ts=$(date +%Y%m%d%H%M%S)
  mkdir -p /var/www/backup
  tar czf /var/www/backup/html-$ts.tgz -C /var/www html || true
fi

echo "[BeforeInstall] Ensuring Apache httpd is installed"
if command -v yum >/dev/null 2>&1; then
  yum install -y httpd
  systemctl enable httpd
  systemctl stop httpd || true
elif command -v apt-get >/dev/null 2>&1; then
  apt-get update
  apt-get install -y apache2
  systemctl enable apache2
  systemctl stop apache2 || true
fi

mkdir -p /var/www/html
