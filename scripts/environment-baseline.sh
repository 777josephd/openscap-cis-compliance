#!/bin/bash
###############################################################
# environment-baseline.sh
# 
# Purpose:  Capture pre-hardening system baseline snapshot
#           for OpenSCAP CIS compliance documentation
#
# Usage:    Run ONCE before any hardening changes are applied
#           sudo bash environment-baseline.sh
#
# Output:   Timestamped baseline file in ~/openscap-lab/docs/
#           Format: baseline_<hostname>_<timestamp>.txt
#
# Author:   JAD
# Project:  OpenSCAP CIS Ubuntu 24.04 LTS Compliance Lab
# Date:     April 2026
###############################################################

# --- Dynamic filename ---
HOSTNAME=$(hostname)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE=/home/merlin/openscap-lab/docs/baseline_${HOSTNAME}_${TIMESTAMP}.txt

# --- Ensure output directory exists ---
mkdir -p /home/merlin/openscap-lab/docs

# --- Guard: warn if a baseline already exists for this host ---
if ls /home/merlin/openscap-lab/docs/baseline_${HOSTNAME}_*.txt 1> /dev/null 2>&1; then
    echo "WARNING: A baseline file for ${HOSTNAME} already exists."
    echo "Re-running this script may indicate an error in your workflow."
    read -p "Continue anyway? (y/N): " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || exit 1
fi

# --- All output to single file ---
{
    echo "================================================================"
    echo "SYSTEM BASELINE REPORT"
    echo "Host:      ${HOSTNAME}"
    echo "Captured:  $(date)"
    echo "Purpose:   Pre-hardening snapshot for OpenSCAP CIS compliance lab"
    echo "================================================================"
    echo ""

    echo "--- System Identity ---"
    hostnamectl
    echo ""

    echo "--- OS Version ---"
    cat /etc/os-release
    echo ""

    echo "--- Kernel Version ---"
    uname -r
    echo ""

    echo "--- Hardware Profile ---"
    lscpu
    echo ""
    free -h
    echo ""

    echo "--- Disk Layout ---"
    lsblk
    echo ""

    echo "--- Network Interfaces ---"
    ip a
    echo ""

    echo "--- Local Users (excluding nologin) ---"
    cat /etc/passwd | grep -v nologin
    echo ""

    echo "--- Sudo Group Members ---"
    getent group sudo
    echo ""

    echo "--- Running Services ---"
    systemctl list-units --type=service --state=running
    echo ""

    echo "--- Listening Ports ---"
    ss -tulnp
    echo ""

    echo "--- Installed Packages ---"
    dpkg --get-selections

} > "$OUTPUT_FILE" 2>&1

echo "Baseline captured: $OUTPUT_FILE"
