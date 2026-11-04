#!/usr/bin/env bash
set -u
source "$(dirname "$0")/lib/common.sh"
section "07 · NETWORK / DNS / MAIL"; root_notice
if has ss; then check "Listening TCP / UDP services" ss -lntup; fi
if has ip; then
  check "Network interfaces (address metadata)" ip -brief address
  check "Routes" ip route
fi
if has firewall-cmd; then
  check "Firewalld status" firewall-cmd --state
  check "Firewalld active zones" firewall-cmd --get-active-zones
  check "Firewalld default zone" firewall-cmd --get-default-zone
fi
if has nft; then
  check "Nftables table names" nft list tables
fi
if has systemctl; then
  for svc in postfix dovecot exim4 fail2ban firewalld; do
    check "Service: $svc" systemctl is-active "$svc"
  done
fi
for app in postfix postconf dovecot; do
  if has "$app"; then
    case "$app" in
      postconf) check "Postfix version metadata" postconf mail_version ;;
      dovecot) check "Dovecot version" dovecot --version ;;
    esac
  fi
done
if [[ -f /etc/resolv.conf ]]; then
  check "Resolver nameserver names (no DNS queries)" bash -c "grep -E '^nameserver[[:space:]]' /etc/resolv.conf | head -n 12"
fi
note "No external port scans, registrar requests, Cloudflare API calls, SPF/DKIM/DMARC tests or mail probe are made."
note "Investigate origin bypass, public-facing DNS records and remote firewall settings separately."
