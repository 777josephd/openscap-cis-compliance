# CIS Ubuntu 24.04 LTS Compliance Automation Lab

![Score](https://img.shields.io/badge/CIS%20Compliance-90.93%25-brightgreen)
![OS](https://img.shields.io/badge/OS-Ubuntu%2024.04%20LTS-orange)
![Benchmark](https://img.shields.io/badge/Benchmark-CIS%20Level%201%20Server-blue)
![Scanner](https://img.shields.io/badge/Scanner-OpenSCAP-red)
![Automation](https://img.shields.io/badge/Automation-Ansible-black)
![Status](https://img.shields.io/badge/Status-Active-brightgreen)

## Overview

This project demonstrates a full compliance engineering lifecycle —
from baseline assessment through automated remediation and verification
— against the CIS Ubuntu 24.04 LTS Level 1 Server Benchmark using
OpenSCAP and Ansible.

Starting from a freshly provisioned Ubuntu Server with a baseline
compliance score of approximately 69%, this project systematically
identifies, prioritizes, and remediates security control failures,
achieving a final score of 90.93% through structured remediation
across ten control categories. All remediation is codified as an
idempotent Ansible playbook executable from a Rocky Linux 9 control
node, enabling repeatable deployment across any Ubuntu 24.04 LTS target.

## Environment

| Component | Details |
|---|---|
| Hypervisor | Proxmox VE |
| Target OS | Ubuntu Server 24.04 LTS (10.0.10.16) |
| Control Node | Rocky Linux 9 (10.0.10.105) |
| Scanner | OpenSCAP 1.3.x with SSG v0.1.80 |
| Benchmark | CIS Ubuntu 24.04 LTS Level 1 Server |
| Ansible | 2.x (via EPEL) |
| Network | Segmented VLAN — SOC Lab environment |

## Objectives

- Assess baseline CIS compliance posture of a freshly provisioned
  Ubuntu Server 24.04 LTS system
- Prioritize findings by severity and remediation impact
- Implement systematic hardening across ten control categories
- Automate remediation using Ansible for repeatable deployment
- Document justified exceptions with risk-based rationale
- Demonstrate measurable compliance improvement through iterative
  scanning

## Compliance Results

| Scan | Pass | Fail | Score | Change |
|---|---|---|---|---|
| Baseline | 233 | 110 | ~69% | — |
| Post-1: SSH + Authentication | 272 | 83 | 73.01% | +4.01% |
| Post-2: Network + Firewall | 291 | 64 | 75.81% | +2.80% |
| Post-3: System Hardening | 321 | 36 | 88.26% | +12.45% |
| Post-4: PAM Fixes | 324 | 33 | 90.89% | +2.63% |
| Final: Ansible Validation | 329 | 28 | 90.93% | +0.04% |

**Baseline**
<img width="1636" height="573" alt="oscap-b1" src="https://github.com/user-attachments/assets/6f1a52ca-8706-4ab7-b0b5-f09da2809276" />
**Post-4**
<img width="1641" height="571" alt="oscap-g4" src="https://github.com/user-attachments/assets/cd8e94bd-802f-4fd1-a37a-6eb9d468cf7d" />
**Final**
<img width="1164" height="405" alt="final-report" src="https://github.com/user-attachments/assets/5aba692d-79f6-4f6f-b1e9-6438088c9032" />


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
- Blacklisted unnecessary filesystem modules (cramfs, freevxfs,
  hfs, hfsplus, jffs2)
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

Full exception rationale documented in
[docs/remediation-decisions.md](docs/remediation-decisions.md).

## Ansible Automation

All remediation tasks are codified as an Ansible playbook executed
from a Rocky Linux 9 control node targeting the Ubuntu Server via
SSH. The playbook implements all ten hardening categories as
idempotent roles — safe to run multiple times without unintended
side effects.

### Architecture

The playbook uses a single role (`remediate_cis`) with tasks
organized by control category, a dedicated handlers file for service
restarts, a Jinja2 template for sysctl configuration, static files
for PAM configuration, and a centralized vars file containing all
CIS benchmark values as named variables.

This architecture means CIS benchmark values are defined once in
`vars/main.yml` and referenced throughout all task files — changing
a value like `pam_faillock_deny` propagates to every task that
references it automatically.

### Playbook Structure
```
ansible/
├── site.yml                         # Master playbook
├── inventory.ini                    # Target inventory
└── roles/
└── remediate_cis/
├── tasks/
│   ├── main.yml             # Imports all category files
│   ├── packages.yml         # Category 1 - Package removal
│   ├── ssh.yml              # Category 2 - SSH hardening
│   ├── pam.yml              # Category 3 - PAM and password policy
│   ├── network.yml          # Category 4 - Kernel parameters
│   ├── firewall.yml         # Category 5 - ufw configuration
│   ├── system.yml           # Category 6 - System hardening
│   ├── filesystem.yml       # Category 7 - File permissions
│   ├── aide.yml             # Category 8 - File integrity
│   ├── apparmor.yml         # Category 9 - Mandatory access control
│   └── logging.yml          # Category 10 - Logging configuration
├── handlers/
│   └── main.yml             # Service restart handlers
├── templates/
│   └── 99-cis-hardening.conf.j2  # sysctl Jinja2 template
├── files/
│   ├── issue.net            # SSH warning banner
│   ├── cac_faillock         # PAM faillock config
│   ├── cac_faillock_notify  # PAM faillock notify config
│   └── cac_pwhistory        # PAM password history config
└── vars/
    └──  main.yml            # CIS benchmark values as variables
```

### Key Ansible Modules Used

| Module | Purpose |
|---|---|
| `ansible.builtin.apt` | Package installation and removal |
| `ansible.builtin.lineinfile` | Manage single configuration lines |
| `ansible.builtin.replace` | Pattern-based file content replacement |
| `ansible.builtin.copy` | Deploy static configuration files |
| `ansible.builtin.template` | Deploy Jinja2-templated configurations |
| `ansible.builtin.file` | Manage file permissions and ownership |
| `ansible.builtin.sysctl` | Apply kernel parameters |
| `ansible.builtin.systemd` | Manage system services |
| `ansible.builtin.command` | Execute system commands |
| `ansible.builtin.group` | Manage system groups |
| `community.general.ufw` | Manage firewall rules |

### Usage

**Prerequisites:**
- Ansible installed on Rocky Linux 9 control node
- SSH key-based authentication established to target
- Target running Ubuntu Server 24.04 LTS
- Compliant account passwords set on target before execution
```bash
# Verify connectivity
ansible -i inventory.ini compliance_targets -m ping

# Syntax check
ansible-playbook -i inventory.ini site.yml --syntax-check

# Dry run — simulate changes without applying
ansible-playbook -i inventory.ini site.yml --check -K

# Live run — apply all hardening
ansible-playbook -i inventory.ini site.yml -K
```

### Execution Result

Ansible playbook executed successfully against a manually hardened
target confirming idempotent behavior:
PLAY RECAP
ubuntu-cis : ok=100  changed=2  unreachable=0  failed=0
skipped=2  rescued=0  ignored=1

The low changed count (2) confirms the playbook correctly identified
existing configurations and only modified what required updating —
demonstrating true idempotency.

### Important Operational Notes

**PAM Changes:** PAM hardening carries the highest operational risk
in this playbook. The following safeguards are built into the
execution order:

- nullok removal tasks execute after pam-auth-update to prevent
  empty password reintroduction
- SSH hardening executes before PAM changes to ensure remote
  access remains available throughout
- Compliant account credentials must exist on the target before
  execution — the playbook does not manage account passwords

**SSH Restart Handler:** The SSH restart handler is notified only
when sshd_config actually changes, preventing unnecessary service
interruptions on idempotent runs.

**AIDE Initialization:** The AIDE task checks for an existing
database before initializing — it will not overwrite an existing
baseline on subsequent runs.

## Lessons Learned

Two PAM-induced authentication lockouts occurred during development,
both requiring GRUB recovery mode (`init=/bin/bash`) for remediation.
These incidents directly informed the playbook's execution order
and safety considerations, and parallel real-world enterprise change
management requirements.

Full incident documentation, root cause analysis, and enterprise
parallels in [docs/lessons-learned.md](docs/lessons-learned.md).

Key process improvements implemented as a result:
- Compliant credentials established before any PAM changes
- Root recovery account with compliant password required before
  enforce_for_root is applied
- Two active SSH sessions maintained throughout PAM changes
- nullok verified absent after every pam-auth-update execution
- Authentication tested after each individual PAM modification

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
openscap-cis-compliance/
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
│   ├── baseline/
│   ├── results/
│   ├── ssh/
│   ├── pam/
│   ├── network/
│   └── apparmor/
└── ansible/
├── site.yml
├── inventory.ini
└── roles/
└── remediate_cis/
├── tasks/
│   ├── main.yml
│   ├── packages.yml
│   ├── ssh.yml
│   ├── pam.yml
│   ├── network.yml
│   ├── firewall.yml
│   ├── system.yml
│   ├── filesystem.yml
│   ├── aide.yml
│   ├── apparmor.yml
│   └── logging.yml
├── handlers/
│   └── main.yml
├── templates/
│   └── 99-cis-hardening.conf.j2
├── files/
│   ├── issue.net
│   ├── cac_faillock
│   ├── cac_faillock_notify
│   └── cac_pwhistory
└── vars/
    └──  main.yml
```

## References

- [CIS Ubuntu Linux 24.04 LTS Benchmark](https://www.cisecurity.org)
- [OpenSCAP Project](https://www.open-scap.org)
- [ComplianceAsCode/content](https://github.com/ComplianceAsCode/content)
- [NIST SP 800-53](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final)
- [DISA STIG Repository](https://public.cyber.mil/stigs/)
