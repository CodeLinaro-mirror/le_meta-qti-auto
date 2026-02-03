# Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
# SPDX-License-Identifier: BSD-3-Clause-Clear

#!/bin/sh

set -eu

BR="lxc_br0"
IP="192.168.200.10/24"
LXC_CONTAINER_LOG_PATH="/tmp/container_logs/bridge.log"

STAMP="/run/${BR}_ip_configured"

# If already done this boot, exit cleanly
if [ -f "${STAMP}" ]; then
    exit 0
fi

# Create bridge if it doesn't exist
if ! ip link show "${BR}" >/dev/null 2>&1; then
    ip link add name "${BR}" type bridge || { echo "Failed to create bridge ${BR}" > $LXC_CONTAINER_LOG_PATH; exit 1;}
fi

# Bring up bridge (safe if already up)
ip link set "${BR}" up  || { echo "Failed to bring up bridge ${BR}" > $LXC_CONTAINER_LOG_PATH; exit 1; }

# Add IP only if not already present
if ! ip -4 addr show dev "${BR}" | grep -qw "${IP}"; then
    ip addr add "${IP}" dev "${BR}" || { echo "Failed to add IP ${IP} to bridge ${BR}" > $LXC_CONTAINER_LOG_PATH; exit 1; }
fi

touch "${STAMP}"

exit 0
