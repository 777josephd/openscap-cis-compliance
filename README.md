# CIS Ubuntu 24.04 LTS Compliance Automation Lab

![Score](https://img.shields.io/badge/CIS%20Compliance-90.89%25-brightgreen)
![OS](https://img.shields.io/badge/OS-Ubuntu%2024.04%20LTS-orange)
![Benchmark](https://img.shields.io/badge/Benchmark-CIS%20Level%201%20Server-blue)
![Scanner](https://img.shields.io/badge/Scanner-OpenSCAP-red)
![Automation](https://img.shields.io/badge/Automation-Ansible-black)
## Overview

This project demonstrates a full compliance engineering lifecycle — 
from baseline assessment through automated remediation and verification 
— against the CIS Ubuntu 24.04 LTS Level 1 Server Benchmark using 
OpenSCAP and Ansible.

Starting from a freshly provisioned Ubuntu Server with a baseline 
compliance score of approximately 68%, this project systematically 
identifies, prioritizes, and remediates security control failures, 
achieving a final score of 90.89% through structured remediation 
across nine control categories.

## Environment

| Component | Details |
|---|---|
| Hypervisor | Proxmox VE |
| Target OS | Ubuntu Server 24.04 LTS |
| Control Node | Rocky Linux 9 |
| Scanner | OpenSCAP 1.3.x with SSG v0.1.80 |
| Benchmark | CIS Ubuntu 24.04 LTS Level 1 Server |
| Ansible | 2.x (via EPEL) |

## Objectives

- Assess baseline CIS compliance posture of a freshly provisioned 
  Ubuntu Server 24.04 LTS system
- Prioritize findings by severity and remediation impact
- Implement systematic hardening across nine control categories
- Automate remediation using Ansible for repeatable deployment
- Document justified exceptions with risk-based rationale
- Demonstrate measurable compliance improvement through iterative 
  scanning

## Compliance Results

| Scan | Pass | Fail | Score | Change |
|---|---|---|---|---|
| Baseline | 233 | 110 | ~68% | — |
| Post-SSH Hardening | 272 | 83 | 73.01% | +5.01% |
| Post-Network Hardening | 291 | 64 | 75.81% | +2.80% |
| Post-System Hardening | 321 | 36 | 88.26% | +12.45% |
| Post-PAM Fixes | 324 | 33 | 90.89% | +2.63% |

## Remediation Categories

### 1. Package Management
Removed unnecessary and potentially vulnerable packages including 
rsync, ftp, tnftp, and telnet. These services represent unnecessary 
attack surface on a server with no legitimate use case for file 
transfer protocols. Aligned with CIS Section 2 - Services.

### 2. SSH Hardening
Explicitly configured 16 SSH daemon parameters covering authentication 
controls, session management, cryptographic algorithms, and access 
restrictions. Key changes include:
- Restricted ciphers to AES-CTR and ChaCha20-Poly1305 variants
- Limited MACs to ETM (Encrypt-then-MAC) mode only
- Set explicit session timeout and authentication attempt limits
- Added warning banner per legal/compliance requirements
- Restricted SSH access to named users via AllowUsers directive

Aligned with CIS Section 5.2 - SSH Server Configuration.

### 3. Authentication and Password Policy
Implemented comprehensive PAM stack hardening including:
- pam_faillock: account lockout after 4 failed attempts, 
  15-minute lockout window
- pam_pwquality: 14-character minimum, complexity requirements, 
  dictionary word prevention
- pam_pwhistory: 24-password history, enforced for root
- Password aging: 365-day maximum, 1-day minimum
- pam_wheel: restricted su command to empty sugroup

Aligned with CIS Section 5.3 - Configure PAM and 
Section 5.4 - User Accounts and Environment.

### 4. Network and Kernel Parameters
Applied 20 sysctl kernel parameter hardening settings covering:
- IPv6 router advertisement and redirect acceptance disabled
- IPv4 ICMP redirect acceptance and forwarding disabled  
- Martian packet logging enabled
- Reverse path filtering enabled
- TCP SYN cookie protection enabled
- Source-routed packet acceptance disabled

Settings applied persistently via /etc/sysctl.d/99-cis-hardening.conf.
Aligned with CIS Section 3 - Network Configuration.

### 5. Firewall Configuration
Implemented ufw firewall with default deny incoming policy:
- Default deny all incoming traffic
- Default allow all outgoing traffic
- Explicit allow for SSH (port 22/tcp)
- Loopback interface permitted
- Anti-spoofing rules for 127.0.0.0/8 and ::1

Aligned with CIS Section 3.5 - Firewall Configuration.

### 6. System Hardening
- Disabled core dumps for all users and SUID programs
- Enabled ASLR (kernel.randomize_va_space = 2)
- Disabled USB storage module loading
- Blacklisted unnecessary filesystem modules
- Configured /dev/shm with nodev, nosuid, noexec mount options
- Disabled Apport crash reporting service
- Disabled rsyncd service

Aligned with CIS Section 1.5 - Additional Process Hardening.

### 7. File Permissions and Access Controls
- Set umask to 027 in login.defs, bash.bashrc, and /etc/profile
- Configured 15-minute interactive session timeout
- Restricted cron and at execution to authorized users
- Set correct permissions on cron directories and crontab
- Configured sudo audit logging
- Configured sudo re-authentication requirement

Aligned with CIS Section 5.1 - Configure sudo and 
Section 6 - System Maintenance.

### 8. File Integrity Monitoring
Installed and initialized AIDE (Advanced Intrusion Detection 
Environment) to establish a cryptographic baseline of system files. 
The AIDE database provides detection capability for unauthorized 
file modifications, additions, and deletions.

Note: In production environments, AIDE initialization should be 
performed after all hardening is complete to capture the clean 
hardened baseline. Periodic checks should be scheduled via cron.

Aligned with CIS Section 1.3 - Filesystem Integrity Checking.

### 9. AppArmor
Installed apparmor-utils and enforced all available AppArmor profiles.
Configured AppArmor in the GRUB bootloader to ensure mandatory access 
controls are active from boot. 119 profiles enforced.

Aligned with CIS Section 1.6 - Mandatory Access Control.

### 10. Logging
- Configured systemd-journald to forward logs to rsyslog
- Configured systemd-timesyncd with NTP pool servers

Aligned with CIS Section 4 - Logging and Auditing.

## Justified Exceptions

The following findings were intentionally left unremediated with 
documented risk-based rationale:

| Rule | Severity | Rationale |
|---|---|---|
| Set Boot Loader Password in grub2 | High | Compensating control: Proxmox hypervisor authentication provides equivalent physical access protection. Applying GRUB passwords in a VM introduces recovery risk without meaningful security benefit. |
| Set UEFI Boot Loader Password | High | Same rationale as above. |
| Ensure /tmp Located On Separate Partition | Medium | Architectural decision made at provisioning time. Requires full system rebuild to remediate. Would be addressed in OS build standard in production. |
| nftables findings (4 rules) | Medium | ufw selected as firewall framework. nftables and ufw are mutually exclusive. Documented architectural decision. |
| Remove ufw Package | Medium | Contradictory finding — ufw is the selected and configured firewall framework for this environment. |

## Lessons Learned

During initial implementation, PAM hardening changes caused 
authentication lockout due to a non-compliant account password 
existing prior to complexity enforcement. This required environment 
rebuild and informed several process improvements:

- Compliant credentials must be established before PAM hardening
- Break-glass root account with compliant password required before 
  implementing enforce_for_root
- Two active SSH sessions should be maintained throughout PAM changes
- pam-auth-update --force can reintroduce nullok — verify after 
  every PAM stack modification
- Authentication must be tested after each individual PAM change

## Tools and Technologies

| Tool | Purpose |
|---|---|
| OpenSCAP 1.3.x | SCAP-compliant vulnerability and compliance scanner |
| SCAP Security Guide v0.1.80 | CIS benchmark OVAL/XCCDF content |
| Ansible | Remediation automation and playbook execution |
| Proxmox VE | Type-1 hypervisor for lab environment |
| Rocky Linux 9 | Ansible control node (RHEL-family) |
| Ubuntu Server 24.04 LTS | Compliance target |
| ufw | Host-based firewall |
| AIDE | File integrity monitoring |
| AppArmor | Mandatory access control |

## Repository Structure

```
openscap-cis-compliance-lab/
├── README.md
├── docs/
│   ├── environment-baseline.md
│   ├── remediation-decisions.md
│   ├── compliance-summary.md
│   └── lessons-learned.md
├── scripts/
│   └── environment-baseline.sh
├── configs/
│   ├── sshd_config_changes.md
│   ├── pam_configurations.md
│   ├── sysctl_hardening.conf
│   └── ufw_rules.md
├── screenshots/
│   ├── baseline
│   ├── network
│   ├── pam
│   ├── results
│   ├── ssh
│   └── apparmor
└── ansible/
    ├── inventory.ini
    ├── site.yml
    └── roles
```

## References

- [CIS Ubuntu Linux 24.04 LTS Benchmark](https://www.cisecurity.org)
- [OpenSCAP Project](https://www.open-scap.org)
- [ComplianceAsCode/content](https://github.com/ComplianceAsCode/content)
- [NIST SP 800-53](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final)
- [DISA STIG Repository](https://public.cyber.mil/stigs/)
