#!/bin/sh
#-----------------------------------------------------------------------------
# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear
#-----------------------------------------------------------------------------
        case "$1" in
                binderfs)
                        chmod 0664 /dev/binderfs/binder
                        chmod 0664 /dev/binderfs/hwbinder
                        chmod 0664 /dev/binderfs/vndbinder
                        chown -R binderfs.binderfs /dev/binderfs
                        chown -R binderfs.binderfs /dev/binder
                        chown -R binderfs.binderfs /dev/hwbinder
                        chown -R binderfs.binderfs /dev/vndbinder
                ;;
        esac
exit 0
