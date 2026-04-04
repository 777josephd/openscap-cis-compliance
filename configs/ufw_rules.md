# UFW Firewall Configuration

## Firewall Selection Rationale

ufw (Uncomplicated Firewall) was selected as the firewall 
framework for this Ubuntu environment based on:
- Native Ubuntu integration and default tooling
- Full CIS compliance achievable
- Simpler management appropriate for this environment
- Both ufw and nftables manage the underlying netfilter subsystem

nftables findings are documented as justified exceptions in 
remediation-decisions.md.

## Final Configuration

<img width="1590" height="577" alt="z8 UFW FINAL" src="https://github.com/user-attachments/assets/f399c90e-04e4-4fb5-a5c3-d134f85a85d8" />


## Rules Applied

| Rule | Direction | Rationale |
|---|---|---|
| Default deny | Incoming | Block all unsolicited traffic |
| Default allow | Outgoing | Permit all outbound traffic |
| Allow 22/tcp | Incoming | SSH access |
| Allow on lo | Incoming | Loopback interface |
| Deny 127.0.0.0/8 | Incoming | Prevent loopback spoofing |
| Deny ::1 | Incoming | Prevent IPv6 loopback spoofing |

## Implementation Notes

SSH rule added before enabling default deny to prevent lockout.
Rules applied in sequence — order is critical for ufw.
