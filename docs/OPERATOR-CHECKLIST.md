# Per-server operator checklist

Server: __________  UTC date: __________  Engineer: __________

- [ ] Written permission and server scope established
- [ ] Production owner notified, backups / rollback owner confirmed
- [ ] Read-only scripts reviewed; no secrets collected
- [ ] 01 Linux completed
- [ ] 02 PHP completed; every website's effective runtime separately checked
- [ ] 03 SSL/web completed; public hostname coverage reviewed separately
- [ ] 04 Plesk completed; internal sw-engine and extension updates separately verified
- [ ] 05 WordPress completed; vulnerable applications reviewed separately
- [ ] 06 DB completed; grants reviewed securely without exporting secrets
- [ ] 07 Network/DNS/mail completed; external and Cloudflare settings reviewed
- [ ] 08 Access completed; sensitive user/key review completed separately
- [ ] 09 Triage completed; security engineer reviewed evidence limits
- [ ] 10 Backup metadata completed; approved restore exercise performed
- [ ] Authenticated vulnerability scanning completed by qualified assessor
- [ ] Known CVEs validated against vendor backport advisories
- [ ] Remediation explicitly approved, documented and independently retested
- [ ] Residual risks and untested components recorded
- [ ] Written report and final sign-off received

Assessment: [ ] Verified within scope  [ ] Remediation needed  [ ] Further investigation  [ ] Incomplete

Findings / gaps:

Liquid Web ticket:
