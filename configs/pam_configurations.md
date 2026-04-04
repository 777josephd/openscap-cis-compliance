# PAM Configuration Changes

## Overview

PAM (Pluggable Authentication Modules) hardening was implemented 
across multiple configuration files and the pam-configs framework. 
Changes affect authentication, password policy, and account lockout.

## Warning

PAM changes carry the highest operational risk of any hardening 
category. Incorrect PAM configuration can prevent all system 
authentication. The following safeguards were used:
- Compliant passwords set before any PAM changes
- Root password established before enforce_for_root applied
- Two active SSH sessions maintained throughout changes
- Authentication tested after each individual change
- nullok verified removed after every pam-auth-update execution

## Files Modified

### /etc/security/faillock.conf
| Parameter | Value | Purpose |
|---|---|---|
| deny | 4 | Lock after 4 failed attempts |
| fail_interval | 900 | Count failures within 15 minutes |
| unlock_time | 900 | Lock account for 15 minutes |

### /etc/security/pwquality.conf
| Parameter | Value | Purpose |
|---|---|---|
| minlen | 14 | Minimum 14 character passwords |
| minclass | 4 | All four character classes required |
| dcredit | -1 | Minimum 1 digit |
| ucredit | -1 | Minimum 1 uppercase |
| lcredit | -1 | Minimum 1 lowercase |
| ocredit | -1 | Minimum 1 special character |
| maxrepeat | 3 | No more than 3 consecutive identical chars |
| maxsequence | 3 | No more than 3 sequential characters |
| difok | 2 | Minimum 2 characters different from old |
| dictcheck | 1 | Check against dictionary words |
| enforcing | 1 | Enforce requirements strictly |
| enforce_for_root | — | Apply complexity to root account |

### /etc/login.defs
| Parameter | Value | Purpose |
|---|---|---|
| PASS_MAX_DAYS | 365 | Maximum password age |
| PASS_MIN_DAYS | 1 | Minimum password age |
| PASS_WARN_AGE | 7 | Warning days before expiration |

### /etc/default/useradd
| Parameter | Value | Purpose |
|---|---|---|
| INACTIVE | 45 | Days until inactive account disabled |

## PAM Stack Files Created

### /usr/share/pam-configs/cac_faillock
Enables pam_faillock.so authfail in the PAM auth stack.

### /usr/share/pam-configs/cac_faillock_notify  
Adds pam_faillock.so preauth and account checks.

### /usr/share/pam-configs/cac_pwhistory
Configures password history with remember=24, enforce_for_root,
use_authtok parameters.

## PAM Stack Final State

### /etc/pam.d/common-auth
```
auth requisite pam_faillock.so preauth
auth [success=2 default=ignore] pam_unix.so try_first_pass
auth [default=die] pam_faillock.so authfail
auth requisite pam_deny.so
auth required pam_permit.so
auth optional pam_cap.so
```

### /etc/pam.d/common-account
```
account [success=1 new_authtok_reqd=done default=ignore] pam_unix.so
account required pam_faillock.so
account requisite pam_deny.so
account required pam_permit.so
```

### /etc/pam.d/common-password
```
password requisite pam_pwquality.so retry=3
password required pam_pwhistory.so remember=24 enforce_for_root try_first_pass use_authtok
password [success=1 default=ignore] pam_unix.so obscure use_authtok try_first_pass yescrypt
password requisite pam_deny.so
password required pam_permit.so
```

## Account Configuration
- merlin: chage -M 365 applied
- sugroup: empty group created for pam_wheel su restriction
- /etc/pam.d/su: pam_wheel.so use_uid group=sugroup added

## Screenshots

<img width="1590" height="415" alt="z2 PAM Stack FINAL" src="https://github.com/user-attachments/assets/995e0971-3132-4782-819e-d8cbd78f029f" />


<img width="1590" height="234" alt="z3 PAM Config FINAL" src="https://github.com/user-attachments/assets/078ecd36-3dfc-445d-a042-0d227413d2ee" />


<img width="1590" height="531" alt="z5 PAM Faillock FINAL" src="https://github.com/user-attachments/assets/2dd42490-cc55-4d7b-b6ff-7baa6962a77e" />

