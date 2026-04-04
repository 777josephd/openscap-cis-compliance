# Environment Baseline

## Purpose

This document captures the pre-hardening system state of the 
compliance target. Baseline data was collected using the 
`environment-baseline.sh` script before any hardening changes 
were applied.

## System Identity

<img width="1728" height="491" alt="SystemIdentity" src="https://github.com/user-attachments/assets/06bcfa83-c570-486d-8304-b7d4b5bb52fb" />


## Operating System

<img width="1728" height="320" alt="OSVersion" src="https://github.com/user-attachments/assets/213a2c57-b7c2-46c0-b29e-4d8fc24b53e8" />


## Hardware Profile

| Component | Details |
|---|---|
| Hypervisor | Proxmox VE |
| CPU | Allocated vCPUs |
| RAM | Allocated GB |
| Storage | 20GB local-lvm |
| Network | SOC VLAN |

## Running Services

<img width="1728" height="457" alt="Services" src="https://github.com/user-attachments/assets/f5655236-146c-4279-a7b0-905232c21eb5" />


## Network Configuration

<img width="1728" height="291" alt="NetworkConfig" src="https://github.com/user-attachments/assets/c99d0101-2a40-4c1e-ab54-418715d10d41" />


## Listening Ports (Pre-Hardening)

<img width="1728" height="202" alt="ListeningPorts" src="https://github.com/user-attachments/assets/49428752-503c-4ea1-839b-1a17b4f08297" />


## Baseline Compliance Score

<img width="1636" height="573" alt="oscap-b1" src="https://github.com/user-attachments/assets/0f3851c8-2423-4c97-b391-64073be3a9bc" />


**Baseline Score: ~69%**
- Pass: 233
- Fail: 110
- Not Applicable: 65
