#!/usr/bin/env bash
# Read-only audit helpers
set -o pipefail
export LC_ALL=C
section() { printf '\n========== %s ==========\n' "$1"; }
note() { printf '[INFO] %s\n' "$1"; }
gap() { printf '[NOT TESTED] %s\n' "$1"; }
has() { command -v "$1" >/dev/null 2>&1; }
check() {
  local label="$1"; shift
  printf '\n--- %s ---\n' "$label"
  if has timeout; then
    timeout 20s "$@" 2>&1 || printf '[UNAVAILABLE/ERROR] exit=%s\n' "$?"
  else
    "$@" 2>&1 || printf '[UNAVAILABLE/ERROR] exit=%s\n' "$?"
  fi
}
root_notice() {
  if [[ "$(id -u)" -ne 0 ]]; then gap "Not root; inventory may be incomplete"; fi
}
