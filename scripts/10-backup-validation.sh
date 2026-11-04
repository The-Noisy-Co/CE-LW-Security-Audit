#!/usr/bin/env bash
set -u
source "$(dirname "$0")/lib/common.sh"
section "10 · BACKUP / RECOVERY READINESS"; root_notice
if has plesk; then
  check "Plesk version (backup ecosystem context)" plesk version
fi
if has systemctl; then
  check "Known backup services (name and state)" bash -c "systemctl list-units --all --type=service --no-pager | grep -Ei 'backup|restic|borg|duplicity|rsnapshot|rclone|veeam|acronis' | head -n 70"
  check "Known backup timers" bash -c "systemctl list-timers --all --no-pager | grep -Ei 'backup|restic|borg|duplicity|rsnapshot|rclone|veeam|acronis' | head -n 70"
fi
for path in /var/lib/psa/dumps /var/backups /backup; do
  if [[ -d "$path" ]]; then
    check "Backup directory metadata: $path" stat -c '%A %U:%G %n' "$path"
    check "Top-level backup file metadata: $path" bash -c "find '$path' -maxdepth 1 -type f -printf '%TY-%Tm-%Td %TH:%TM %s %f\n' 2>/dev/null | head -n 40"
  else
    gap "$path absent (not proof of missing remote backups)"
  fi
done
if has df; then check "Filesystem capacity" df -hP; fi
note "Backup files and database contents are NEVER opened, copied or restored."
note "Confirm offsite retention, immutability, access control and recovery with provider; schedule an approved restore test."
