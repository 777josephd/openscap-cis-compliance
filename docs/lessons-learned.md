# Lessons Learned

## Overview

This project involved two complete implementation cycles. The first 
run encountered a PAM-induced authentication lockout requiring 
environment rebuild. The second run incorporated lessons from the 
first to produce a cleaner, more deliberate implementation.

A second PAM lockout occurred during the second run when adding 
`account required pam_faillock.so` to `/etc/pam.d/common-account`. 
Recovery required GRUB rescue mode with `init=/bin/bash` kernel 
parameter to bypass PAM entirely and restore the configuration.

## Incident 1: First Run Authentication Lockout

**Cause:** Non-compliant account password existed prior to 
implementing `pam_pwquality` with `enforce_for_root`. PAM complexity 
enforcement rejected the existing password during authentication.

**Impact:** Complete loss of SSH and console authentication for 
the merlin account. Root had no password set, eliminating that 
recovery path. GRUB recovery was unavailable due to VM configuration.

**Resolution:** Environment rebuild with compliant credentials 
established before any PAM hardening.

**Process Changes Implemented:**
- Compliant password set immediately after VM provisioning
- Root password set before enforce_for_root applied
- Two active SSH sessions maintained throughout PAM changes
- Authentication tested after each individual PAM modification

## Incident 2: Second Run sudo/su Lockout

**Cause:** Adding `account required pam_faillock.so` to 
`/etc/pam.d/common-account` broke the PAM account validation 
stack for sudo and su, while SSH continued functioning briefly 
before also failing after reboot.

**Impact:** sudo and su access lost. SSH access lost after reboot. 
Root console login rejected despite correct password.

**Resolution:** GRUB rescue mode via `init=/bin/bash` kernel 
parameter, remounting filesystem read-write, and removing the 
problematic PAM line manually.

**Recovery Steps:**
1. Accessed GRUB menu via Proxmox console
2. Edited boot entry — appended `init=/bin/bash` to kernel line
3. Booted to bash shell bypassing PAM entirely
4. `mount -o remount,rw /`
5. Removed `account required pam_faillock.so` from common-account
6. `sync && reboot`

<img width="1790" height="994" alt="trous1" src="https://github.com/user-attachments/assets/e49f7e85-7a8b-49b0-830b-3c8057e7dcaa" />


## Enterprise Parallels

These incidents directly mirror real-world scenarios:

**Break-glass accounts:** Both incidents highlight why dedicated 
recovery accounts with separately stored credentials are mandatory 
in enterprise environments. Break-glass accounts stored in 
privileged access management vaults (CyberArk, HashiCorp Vault) 
exist precisely for PAM failure recovery.

**Out-of-band management:** Proxmox console access served the same 
role as iDRAC/iLO on physical servers — providing recovery access 
independent of the OS authentication stack.

**Change management:** PAM changes in production require tested 
rollback procedures, maintenance windows, and dual-administrator 
verification. Both incidents would have been prevented by proper 
change control.

**Testing in non-production:** This lab environment served its 
purpose — identifying failure modes before they could impact 
production systems.

## Key Technical Lessons

| Lesson | Application |
|---|---|
| Set compliant credentials before PAM hardening | Provisioning checklist item |
| Establish root recovery account before enforce_for_root | Pre-hardening requirement |
| Test authentication after every PAM change | Verification procedure |
| Verify nullok removed after every pam-auth-update | Post-update checklist |
| pam_faillock in common-account requires careful implementation | Known risk item |
| GRUB init=/bin/bash bypasses PAM for emergency recovery | Recovery runbook |
