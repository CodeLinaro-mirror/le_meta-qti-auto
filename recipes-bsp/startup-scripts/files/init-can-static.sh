#!/bin/sh
# Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries. 
# SPDX-License-Identifier: BSD-3-Clause-Clear

if [ -L /sys/class/net/can0 ]; then
    echo "Configure CAN0 bitrate to 500kbps & Enable"
	/sbin/ip link set can0 type can bitrate 500000
	/sbin/ip link set up can0
fi
