# CE-LW-Security-Audit

Read-only security inventory and initial triage for **authorized** CrossExamined / Liquid Web Linux + Plesk servers.

**10 modules + 1 master runner.** No patches, restarts, reboots, configuration changes, exploit tests or aggressive network scans.

## Getting started
Use GitHub Codespaces to **edit** scripts. The Codespace is **not** the Liquid Web target server.

1. Review scripts before use.
2. Copy this repository to an authorized target server using an approved transfer method.
3. Open a root shell on that server.
4. Run `bash run-audit.sh`.
5. Review local outputs in `reports/<server>-<UTC timestamp>/`. Do not commit or share them without redaction.

For one script: `bash scripts/02-php-runtime.sh`.

## Modules
01 Host & Linux | 02 PHP | 03 SSL/TLS & web | 04 Plesk | 05 WordPress & apps |
06 Database | 07 Network/DNS/mail | 08 Identity/access | 09 Threat triage | 10 Backups.

Outputs contain potentially sensitive server metadata and reports are gitignored. These checks do not guarantee security. External vulnerability scans, Cloudflare account review, detailed malware/forensic investigation, and restore tests require separate tools, permissions and approval.

See `docs/AUDIT-SCOPE.md` and `docs/OPERATOR-CHECKLIST.md` for coverage gaps, sign-off, and change-control guidance.
