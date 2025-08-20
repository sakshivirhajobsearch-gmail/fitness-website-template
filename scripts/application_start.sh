#!/usr/bin/env bash
set -euo pipefail
echo "[ApplicationStart] Starting web server"
if command -v systemctl >/dev/null 2>&1; then
  if systemctl list-unit-files | grep -q apache2.service; then
    systemctl restart apache2
  elif systemctl list-unit-files | grep -q httpd.service; then
    systemctl restart httpd
  else
    echo "No apache service found; attempting nginx"
    systemctl restart nginx || true
  fi
else
  service apache2 restart || service httpd restart || true
fi
