#!/bin/sh
# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

echo 1555200 >  /sys/devices/system/cpu/bus_dcvs/DDR/soc:qcom,memlat:ddr:silver/min_freq
echo 1353600 > /sys/devices/system/cpu/bus_dcvs/DDR/soc:qcom,memlat:ddr:silver-compute/min_freq
