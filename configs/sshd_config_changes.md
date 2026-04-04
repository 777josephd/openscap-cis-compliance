# SSH Server Configuration Changes

## File Modified
`/etc/ssh/sshd_config`

## Changes Applied

| Parameter | Value | CIS Requirement | Rationale |
|---|---|---|---|
| PermitRootLogin | no | no | Prevents direct root SSH access |
| PermitEmptyPasswords | no | no | Prevents authentication without passwords |
| LoginGraceTime | 60 | ≤60 | Limits window for authentication attempts |
| MaxAuthTries | 4 | ≤4 | Limits brute force attempts per connection |
| MaxSessions | 10 | ≤10 | Limits concurrent sessions |
| ClientAliveInterval | 15 | non-zero | Detects and terminates idle sessions |
| ClientAliveCountMax | 3 | ≤3 | Maximum missed keepalives before disconnect |
| MaxStartups | 10:30:60 | 10:30:60 | Limits unauthenticated connection attempts |
| HostbasedAuthentication | no | no | Disables host-based trust relationships |
| IgnoreRhosts | yes | yes | Disables .rhosts file authentication |
| PermitUserEnvironment | no | no | Prevents environment variable injection |
| Banner | /etc/issue.net | required | Legal warning banner |
| LogLevel | INFO | INFO | Sufficient logging without verbosity |
| AllowUsers | merlin | configured | Restricts SSH to named users only |

## Cryptographic Configuration

### Ciphers

```

chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr, aes128-gcm@openssh.com,aes256-gcm@openssh.com

```
Removed: 3DES, Blowfish, RC4, and other weak ciphers.

### MACs
```

hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com, hmac-sha2-512,hmac-sha2-256

```
ETM (Encrypt-then-MAC) mode required. Removed: MD5, SHA1, 
96-bit, and non-ETM variants.

### Key Exchange Algorithms
```

sntrup761x25519-sha512@openssh.com,curve25519-sha256, curve25519-sha256@libssh.org,ecdh-sha2-nistp256, ecdh-sha2-nistp384,ecdh-sha2-nistp521, diffie-hellman-group-exchange-sha256, diffie-hellman-group16-sha512, diffie-hellman-group18-sha512, diffie-hellman-group14-sha256

```
Removed: diffie-hellman-group1-sha1 and other weak KEX algorithms.

## Additional Changes

| File | Change | Purpose |
|---|---|---|
| /etc/issue.net | Warning banner created | Legal notice for connecting users |
| /etc/ssh/sshd_config | Permissions set to 0600 | Restrict config file readability |
| /etc/pam.d/common-auth | nullok removed | Prevent empty password authentication |
| /etc/pam.d/common-password | nullok removed | Prevent empty password changes |

<img width="1590" height="667" alt="z1 SSH Config FINAL" src="https://github.com/user-attachments/assets/cbb29ed9-3923-4959-8bd9-4e4659b10e42" />


