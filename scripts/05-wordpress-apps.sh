#!/usr/bin/env bash
set -u
source "$(dirname "$0")/lib/common.sh"
section "05 · WORDPRESS / APPLICATION INVENTORY"; root_notice
if has wp; then check "WP-CLI version" wp --info; else gap "WP-CLI not available"; fi
if [[ -d /var/www/vhosts ]]; then
  check "Top-level vhost directory names" bash -c "find /var/www/vhosts -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | head -n 120"
  check "WordPress install paths (maxdepth 5)" bash -c "find /var/www/vhosts -maxdepth 5 -type d -name wp-includes 2>/dev/null | head -n 60"
  check "WordPress config path metadata only" bash -c "find /var/www/vhosts -maxdepth 5 -type f -name wp-config.php -printf '%TY-%Tm-%Td %u:%g %m %p\n' 2>/dev/null | head -n 80"
  check "Directory permissions summary" bash -c "find /var/www/vhosts -mindepth 1 -maxdepth 2 -type d -printf '%m %u:%g %p\n' 2>/dev/null | head -n 100"
else
  gap "/var/www/vhosts not available"
fi
note "WP-CLI core/plugin/theme update checks are NOT automatically run on every site: they may bootstrap application code."
note "An authorized app owner must assess plugin/theme CVEs, user accounts, REST/AJAX endpoints, and custom code."
note "This script does not recursively scan whole webroots or alter files."
