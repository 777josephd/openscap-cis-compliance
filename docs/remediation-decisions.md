# Remediation Decisions and Justified Exceptions

## Decision Framework

Remediation priority was determined using a risk-based approach 
aligned with NIST SP 800-30:

1. **Severity** — High findings addressed first regardless of 
   complexity
2. **Exploitability** — Controls addressing active attack vectors 
   prioritized over theoretical risks
3. **Implementation risk** — Changes with potential to break 
   system access (PAM, SSH) implemented with extra caution and 
   verification steps
4. **Compensating controls** — Where native remediation introduces 
   unacceptable risk, compensating controls documented with rationale


## Exception Register

### GRUB Boot Loader Password
**Finding:** Set Boot Loader Password in grub2 / Set UEFI Boot 
Loader Password

**Severity:** High

**Risk Accepted By:** Lab Administrator

**Rationale:** These controls prevent unauthorized boot manipulation 
by requiring a password to modify boot parameters. In a physical 
environment this protects against attackers with physical access 
booting into recovery mode to bypass OS authentication.

In this Proxmox VE virtualized environment, the hypervisor layer 
provides equivalent protection:
- Proxmox web UI requires authenticated access
- VM console access requires Proxmox credentials
- No physical keyboard/monitor access exists for an attacker

Applying GRUB passwords in a VM introduces significant recovery 
risk — a misconfigured GRUB password can render the VM unbootable 
with no recovery path. The compensating control (hypervisor 
authentication) provides equivalent protection without the 
operational risk.

**Enterprise parallel:** In production, this control would be 
implemented on physical servers. Virtual machines would rely on 
hypervisor access controls and out-of-band management (iDRAC, iLO) 
as compensating controls, which is standard practice.

---

### /tmp Partition Separation
**Finding:** Ensure /tmp Located On Separate Partition

**Severity:** Medium

**Risk Accepted By:** Lab Administrator

**Rationale:** Separate /tmp partition prevents /tmp from consuming 
root filesystem space and allows mount options (nodev, nosuid, 
noexec) to be applied. This is an architectural decision made at 
provisioning time and cannot be remediated without a full system 
rebuild.

Compensating control: nodev, nosuid, noexec applied to /dev/shm 
which provides partial mitigation. In production, this would be 
addressed in the OS build standard (kickstart/preseed configuration).

---

### nftables Findings
**Finding:** Verify nftables Service is Enabled / Ensure nftables 
Rules are Permanent / Ensure Base Chains Exist / Ensure a Table 
Exists

**Severity:** Medium

**Risk Accepted By:** Lab Administrator

**Rationale:** The CIS benchmark includes findings for both ufw and 
nftables. These are mutually exclusive firewall frameworks — ufw 
was selected as the firewall solution for this Ubuntu environment 
based on:
- Native Ubuntu integration and default tooling
- Simpler management syntax appropriate for this environment
- Full CIS-compliant configuration implemented (default deny, 
  explicit allow rules, loopback configuration)

nftables findings are accepted as ufw provides equivalent or 
superior firewall capability. Both tools manage the underlying 
netfilter subsystem.

---

### Remove ufw Package
**Finding:** Remove ufw Package

**Severity:** Medium

**Risk Accepted By:** Lab Administrator

**Rationale:** This finding is contradictory in the context of a 
system where ufw has been selected and configured as the firewall 
framework. Removing ufw would eliminate the configured firewall 
protection. This finding is accepted as the compensating ufw 
configuration fully satisfies the intent of firewall protection 
requirements.
