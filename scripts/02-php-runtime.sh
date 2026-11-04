#!/usr/bin/env bash
set -u
source "$(dirname "$0")/lib/common.sh"
section "02 · PHP RUNTIME / HANDLERS"; root_notice
if has php; then
  check "CLI PHP version" php -v
  check "CLI PHP ini locations" php --ini
  check "CLI PHP selected non-secret settings" bash -c "php -i 2>/dev/null | grep -Ei '^(Server API|Loaded Configuration File|display_errors|expose_php|allow_url_include|session.upload_progress.enabled|cgi.fix_pathinfo|open_basedir|disable_functions) => ' | head -n 50"
else gap "Default CLI PHP missing"; fi
for phpbin in /opt/plesk/php/*/bin/php /usr/local/bin/php /usr/bin/php; do
  [[ -x "$phpbin" ]] || continue
  check "PHP binary: $phpbin" "$phpbin" -v
done
if has plesk; then
  check "Plesk PHP handlers" plesk bin php_handler --list
  note "Review PHP website assignments in Plesk; CLI results may differ from FPM pool overrides."
else gap "Plesk command unavailable"; fi
if has systemctl; then
  check "PHP-FPM unit names (including stopped)" bash -c "systemctl list-units --all --type=service --no-pager | grep -i php | head -n 90"
fi
check "PHP-FPM process metadata" bash -c "ps -eo user,pid,comm,args | grep '[p]hp-fpm' | head -n 80"
note "For each domain, confirm active PHP handler, web-facing version, loaded binary, and any vendor backports."
note "Do not copy full phpinfo output; it can expose sensitive settings."
