#!/usr/bin/env bash
set -u
source "$(dirname "$0")/lib/common.sh"
section "01 · HOST / LINUX INVENTORY"; root_notice
check "UTC time" date -u
check "Hostname" hostname -f
check "Account" id
check "OS release" cat /etc/os-release
check "Kernel" uname -a
check "Uptime" uptime
if has timedatectl; then check "Time synchronization" timedatectl status; fi
if has systemctl; then
  check "Failed units" systemctl --failed --no-pager
  check "Enabled services" systemctl list-unit-files --type=service --state=enabled --no-pager
fi
if has rpm; then
  check "Installed core package versions" bash -c "rpm -qa | grep -Ei '^(kernel|glibc|openssl|openssh|curl|nginx|httpd|plesk|php)' | sort | head -n 120"
elif has dpkg-query; then
  check "Installed core package versions" bash -c "dpkg-query -W | grep -Ei '^(linux-image|libc6|openssl|openssh|curl|nginx|apache2|php)' | head -n 120"
fi
if has dnf; then
  check "Cached security advisories (no repo refresh)" dnf --cacheonly updateinfo list security
elif has apt; then
  note "APT package security applicability requires separate vendor/repository check; no apt update is run."
fi
if has getenforce; then check "SELinux" getenforce; fi
if has sestatus; then check "SELinux details" sestatus; fi
if has aa-status; then check "AppArmor summary" aa-status --enabled; fi
if has sysctl; then
  check "Selected kernel mitigations" sysctl kernel.randomize_va_space kernel.kptr_restrict fs.protected_hardlinks fs.protected_symlinks
fi
note "Kernel/build version alone does not establish vendor patch status."
