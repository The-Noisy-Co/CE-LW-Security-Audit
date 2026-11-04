# Audit scope and limitations

This toolkit supports the 23-section **Liquid Web Comprehensive Infrastructure Security Assessment & Remediation Request**.

| Sections | Scripts | Required independent work |
|---|---|---|
| PHP (1–2) | 02,04 | Actual web-facing handlers and vendor backports, current CVE applicability |
| Linux (3) | 01 | Authenticated patch/vulnerability scan |
| SSL/TLS and web (4–5) | 03 | External TLS test per public hostname, WAF and HTTP security |
| Plesk (6) | 04 | Extension patch levels, sw-engine and admin MFA |
| WordPress / applications (7) | 05 | Plugin/theme vulnerability scans and human application security testing |
| Database (8) | 06 | Privilege audit by DBA using approved secure access |
| Network, DNS, CDN, mail (9–11) | 07 | External scan, Cloudflare/registrar console review, SPF/DKIM/DMARC |
| Identity (12) | 08 | Credential/secret exposure review; do not dump secrets |
| Vulnerability testing (13) | 01–08 | Authenticated scan with written authorization |
| Incident triage (14) | 09 | Forensic investigation / malware scanning and log preservation |
| Backup/recovery (15) | 10 | Controlled restore tests |
| Remediation/retesting (16–17) | rerun baseline | Separate written approval, backup/rollback plan, validation |
| Monitoring (18) | 01,07,09 | Operational alerting/retention policy |
| Reporting (19–23) | local reports | Human sign-off, limitations and independent verification |

## Security conditions
* No automated changes to production systems, application configuration, users or firewall.
* Reading logs or conducting light checks can still create load or reveal private metadata.
* No script proves absence of compromise. No script should be used as a substitute for qualified incident response.
* Verify vendor backports and actual running PHP processes; CLI version alone is not enough.
* Treat all output as confidential, protect it, and never commit it.
