#!/usr/bin/env bash
set -u
source "$(dirname "$0")/lib/common.sh"
section "06 · DATABASE SERVER POSTURE"; root_notice
for app in mysqld mariadbd mysql mariadb postgres psql; do
  if has "$app"; then
    check "Binary version: $app" "$app" --version
  fi
done
if has systemctl; then
  for svc in mariadb mysql mysqld postgresql; do
    check "Database service: $svc" systemctl is-active "$svc"
  done
fi
if has ss; then
  check "DB listeners (interfaces and process labels)" bash -c "ss -lntp | grep -E ':(3306|33060|5432|6379)[[:space:]]' | head -n 70"
fi
if has rpm; then
  check "Installed DB package versions" bash -c "rpm -qa | grep -Ei 'mariadb|mysql|postgres|redis' | sort | head -n 100"
elif has dpkg-query; then
  check "Installed DB package versions" bash -c "dpkg-query -W 2>/dev/null | grep -Ei 'mariadb|mysql|postgres|redis' | head -n 100"
fi
note "No SQL queries are run; no credentials, grants, schema, table data or database content are exported."
note "Review DBA accounts, remote exposure, TLS, backups and least privilege through approved database administration."
