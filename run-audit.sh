#!/usr/bin/env bash
# Run 10 read-only scripts locally on the authorized server. No service changes.
set -Eeuo pipefail
cd "$(dirname "$0")"
export LC_ALL=C
if [[ "$(id -u)" -ne 0 ]]; then
  echo "Run as root on an authorized target server." >&2
  exit 1
fi
umask 077
host="$(hostname -s | tr -cd 'A-Za-z0-9_.-' | cut -c1-60)"
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
out="reports/$host-$stamp"
mkdir -p "$out"
chmod 700 "$out"
printf 'Host: %s\nUTC: %s\n' "$(hostname -f)" "$stamp" > "$out/MANIFEST.txt"
status=0
for script in scripts/[0-9][0-9]-*.sh; do
  name="$(basename "$script" .sh)"
  echo "Running $name"
  if bash "$script" > "$out/$name.txt" 2>&1; then
    echo "$name OK" >> "$out/MANIFEST.txt"
  else
    echo "$name SCRIPT ERROR" >> "$out/MANIFEST.txt"
    status=1
  fi
done
echo "LOCAL reports: $out"
echo "Do NOT commit raw reports or share without reviewing for sensitive information."
exit "$status"
