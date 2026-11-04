#!/usr/bin/env bash
set -u
source "$(dirname "$0")/lib/common.sh"
section "04 · PLESK / HOSTING INVENTORY"; root_notice
if has plesk; then
  check "Plesk version" plesk version
  check "Plesk PHP handlers" plesk bin php_handler --list
  check "Hosting site names (sensitive metadata)" plesk bin site --list
else
  gap "Plesk not installed or not in PATH"
fi
if has rpm; then
  check "Plesk and sw-engine packages" bash -c "rpm -qa | grep -Ei '^(plesk|sw-engine|psa-|php[0-9]|plesk-php)' | sort | head -n 140"
elif has dpkg-query; then
  check "Plesk and sw-engine packages" bash -c "dpkg-query -W -f='${binary:Package} ${Version}\n' 2>/dev/null | grep -Ei '^(plesk|sw-engine|psa-)' | head -n 140"
fi
if has systemctl; then
  check "Panel service status" systemctl is-active sw-cp-server
  check "Plesk engine status" systemctl is-active sw-engine
fi
note "Plesk sw-engine has separate security advisories: verify vendor fix and process restart state manually."
note "Plesk admin accounts, MFA, API credentials, subscriptions and extensions require controlled console review."
