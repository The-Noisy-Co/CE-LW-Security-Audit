#!/usr/bin/env bash
set -u
source "$(dirname "$0")/lib/common.sh"
section "09 · THREAT TRIAGE (NOT FULL FORENSICS)"; root_notice
if has ps; then
  check "Process list (names only, not arguments)" bash -c "ps -eo user,pid,ppid,comm --sort=comm | head -n 130"
fi
if has systemctl; then
  check "Enabled service units" systemctl list-unit-files --type=service --state=enabled --no-pager
  check "Timers" systemctl list-timers --all --no-pager
fi
if [[ -d /etc/cron.d ]]; then
  check "System cron job filenames" bash -c "find /etc/cron.d /etc/cron.daily /etc/cron.hourly /etc/cron.weekly -maxdepth 1 -type f -printf '%TY-%Tm-%Td %p\n' 2>/dev/null | head -n 120"
fi
if has journalctl; then
  check "System errors last 7d (counts only)" bash -c "journalctl -p err --since '7 days ago' --no-pager -q 2>/dev/null | wc -l"
  check "SSH failed authentications last 7d (counts only)" bash -c "journalctl -u sshd -u ssh --since '7 days ago' --no-pager -q 2>/dev/null | grep -Eic 'Failed password|Invalid user|authentication failure' || true"
fi
if [[ -d /var/log/nginx ]]; then
  check "Web log filename metadata" bash -c "find /var/log/nginx -maxdepth 1 -type f -printf '%TY-%Tm-%Td %TH:%TM %s %p\n' | head -n 75"
fi
if [[ -d /var/www/vhosts ]]; then
  check "Recently changed PHP filenames (shallow, last 7d)" bash -c "find /var/www/vhosts -maxdepth 5 -type f -name '*.php' -mtime -7 -printf '%TY-%Tm-%Td %p\n' 2>/dev/null | head -n 100"
fi
note "Normal traffic and deployments can explain these observations; nothing here establishes compromise."
note "If compromise suspected, preserve evidence first and engage qualified incident responders."
note "No antivirus scan, broad filesystem crawl, quarantine, deletion, exploit test, or full log content export is performed."
