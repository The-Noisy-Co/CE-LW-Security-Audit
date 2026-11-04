#!/usr/bin/env bash
set -u
source "$(dirname "$0")/lib/common.sh"
section "08 · IDENTITY / ACCESS POSTURE"; root_notice
check "Root identity" id
check "Local account names and shells only" bash -c "awk -F: '{print \$1,\$3,\$4,\$7}' /etc/passwd | head -n 140"
check "Administrative group membership" bash -c "getent group wheel sudo 2>/dev/null | sed -E 's/(:[^:]*:)[^:]*$/\1[REDACTED MEMBERS]/' | head -n 10"
if has sshd; then
  check "Effective SSH security subset" bash -c "sshd -T 2>/dev/null | grep -Ei '^(permitrootlogin|passwordauthentication|pubkeyauthentication|kbdinteractiveauthentication|permituserenvironment|x11forwarding|maxauthtries|loglevel) ' | head -n 25"
fi
if [[ -d /etc/ssh ]]; then
  check "SSH public configuration filename metadata" bash -c "find /etc/ssh -maxdepth 2 -type f -name '*.conf' -printf '%p\n' | head -n 30"
fi
if has last; then check "Recent login sessions" last -n 25; fi
if has lastb; then
  note "Failed-login logs can contain private source metadata; use journald summaries below rather than dumping lastb."
fi
if has journalctl; then
  check "SSH service auth-event counts (last 7d)" bash -c "journalctl -u sshd -u ssh --since '7 days ago' --no-pager -q 2>/dev/null | grep -Eic 'Failed password|Invalid user|Accepted publickey|Accepted password' || true"
fi
note "Never dump /etc/shadow, private SSH keys, full sudoers files, password hashes, tokens or credentials."
note "Privileged access, MFA, sudo policies, key ownership and credential rotation require a controlled review."
