#!/usr/bin/env bash
set -u
source "$(dirname "$0")/lib/common.sh"
section "03 · SSL / WEB SERVER"; root_notice
for app in nginx httpd apache2 openssl; do
  if has "$app"; then
    case "$app" in
      nginx) check "Nginx version" nginx -v ;;
      httpd) check "Apache version" httpd -v ;;
      apache2) check "Apache version" apache2 -v ;;
      openssl) check "OpenSSL version" openssl version -a ;;
    esac
  fi
done
if has systemctl; then
  for svc in nginx httpd apache2; do
    check "Service state: $svc" systemctl is-active "$svc"
  done
fi
if has ss; then
  check "Web TLS listeners" bash -c "ss -lntp | grep -E ':(80|443|8443)[[:space:]]' | head -n 60"
fi
if [[ -d /etc/letsencrypt/live ]]; then
  check "Let's Encrypt certificate entries (names only)" bash -c "find /etc/letsencrypt/live -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | head -n 100"
else gap "Let's Encrypt live directory absent"; fi
if has certbot; then
  check "Certbot certificate summary" certbot certificates
fi
if [[ -d /etc/nginx ]]; then
  check "Nginx config file names only" bash -c "find /etc/nginx -maxdepth 3 -type f \( -name '*.conf' -o -name '*.inc' \) -printf '%p\n' | head -n 100"
fi
note "No private keys, full config dumps, or external connection scans are collected."
note "For each domain test public TLS version, SNI, chain, expiry, HTTPS redirect, HSTS, proxy and Cloudflare status separately."
