# Compliance Summary

## Assessment Details

| Field | Value |
|---|---|
| Target | Ubuntu Server 24.04 LTS |
| Hostname | ubuntuscap |
| IP Address | 10.0.10.16 |
| Benchmark | CIS Ubuntu 24.04 LTS Level 1 Server |
| SCAP Content | SSG v0.1.80 |
| Assessment Date | April 2026 |

## Score Progression

| Scan | Pass | Fail | N/A | Score |
|---|---|---|---|---|
| Baseline | 233 | 110 | 65 | ~69% |
| Post-1 (SSH + Auth) | 272 | 83 | — | 73.01% |
| Post-2 (Network + Firewall) | 291 | 64 | — | 75.81% |
| Post-3 (System Hardening) | 321 | 36 | — | 88.26% |
| Post-4 (PAM Fixes) | 324 | 33 | — | 90.89% |

## Remaining Failures by Category

| Category | Count | Notes |
|---|---|---|
| Justified Exceptions | 7 | Documented in remediation-decisions.md |
| pwquality parameters | 7 | Requires further OVAL investigation |
| ufw findings | 3 | Partially satisfied — OVAL path checks |
| sysctl findings | 5 | OVAL path-specific checks |
| Other | 11 | Further remediation planned |

## Control Categories Fully Remediated

- SSH Server Configuration
- Package Management
- File Integrity Monitoring (AIDE)
- AppArmor Mandatory Access Control
- Core Dumps and ASLR
- USB and Filesystem Module Restrictions
- Cron and At Access Controls
- Sudo Configuration
- Session Timeout
- Logging Configuration

## Screenshots

**Baseline**

<img width="1636" height="573" alt="oscap-b1" src="https://github.com/user-attachments/assets/6b5345fc-5a7b-4ef5-aeb0-d0e995ad9f5d" />

---

**Post-1**

<img width="1641" height="561" alt="oscap-d1" src="https://github.com/user-attachments/assets/5591ae50-7406-4940-83ec-f5aadbdb5a2d" />

---

**Post-2**

<img width="1644" height="569" alt="oscap-f2" src="https://github.com/user-attachments/assets/f50e5211-1ed5-4d5b-9e45-e3d55eba2be6" />

---

**Post-3**

<img width="1640" height="571" alt="oscap-g3" src="https://github.com/user-attachments/assets/9d35da13-8aff-4d4d-a85d-276cb8c857c9" />

---

**Post-4**

<img width="1641" height="571" alt="oscap-g4" src="https://github.com/user-attachments/assets/361798c3-35e0-4547-98d3-d17c8d09512d" />








