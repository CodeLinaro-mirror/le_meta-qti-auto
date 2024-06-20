#!/bin/sh

# Copyright (c) 2022-2024 Qualcomm Innovation Center, Inc. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted (subject to the limitations in the
# disclaimer below) provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#
#     * Neither the name of Qualcomm Innovation Center, Inc. nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE
# GRANTED BY THIS LICENSE. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT
# HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
# GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


PATH=/sbin:/bin:/usr/sbin:/usr/bin

#------------------------------------------------------------
# Temporary rootfs mount node
ROOT_MOUNT="/rootfs"
EXT4_PART_NAME="system"

# Function return status
STATUS_OK=0
STATUS_ERR=1

DEV_NUM=-1
UEVENT_PATH=""
SYS_MMC_PATH="/sys/class/block"
MAX_RETRY=150

KPI_FILE_PATH="/sys/kernel/boot_kpi/kpi_values"

LOGD() {
  busybox echo "$1"
}

WaitDevReady()
{
    local maxTrials=300

    while [ ! "$1" "$2" ]; do
        usleep 100000
        maxTrials=$( echo $(( ${maxTrials} - 1 )) )
        if [ ${maxTrials} -eq 0 ]; then
           LOGD "Error: WaitDevReady Timed Out $maxTrails"
           return ${STATUS_ERR}
        fi
    done
    return ${STATUS_OK}
}

EmmcGetPartitionID() {
   DEV_NUM=-1
   local PART_NAME=$1
   local retry_count=0

   # We will only take "_a" and "_b" as correct active slot
   # Else all will be ignored and DEV_NUM will set as -1

   act_slot=`busybox cat /proc/cmdline | busybox awk -F'SLOT_SUFFIX=' '{print $2}' | busybox awk '{print $1}' | busybox tr -d '"'`
   if [ "${act_slot}" == "_a" ]; then
      act_slot=""
   elif [ "${act_slot}" != "_b" ]; then
      return
   fi

   # Fetch active part uevent then parse dev num from PARTN

   while [ -z $UEVENT_PATH ]
   do
      UEVENT_PATH=$(busybox grep -w $PART_NAME$act_slot ${SYS_MMC_PATH}/mmcblk0p*/uevent | busybox cut -d ":" -f 1)
      busybox usleep 100000
      retry_count=$(( retry_count + 1))
      if [ $retry_count -ge $MAX_RETRY ]; then
         LOGD "Error: EmmcGetPartitionID timed out $retry_count"
         break
      fi
   done

   DEV_NUM=$(busybox grep -w PARTN $UEVENT_PATH | busybox awk -F '=' '{print $2}')
}

EarlySetup() {
    busybox.suid mount -t proc proc /proc
    busybox.suid mount -t sysfs sysfs /sys
    busybox.suid mount -t devtmpfs none /dev

    if [ -f "$KPI_FILE_PATH" ]
    then
        echo -n 'M - Ramdisk-init Start' >> $KPI_FILE_PATH
    fi
    return ${STATUS_OK}
}

MoveMountToSystem() {
    busybox.suid mount -n --move /proc ${ROOT_MOUNT}/proc
    busybox.suid mount -n --move /sys ${ROOT_MOUNT}/sys
    busybox.suid mount -n --move /dev ${ROOT_MOUNT}/dev
    return ${STATUS_OK}
}

SwitchToSystem() {
    exec busybox switch_root ${ROOT_MOUNT} /sbin/init
    LOGD "switch_root failure: We are not expected to reach here..."
}

#
# Mount the root file system
#
MountSystem () {

   EmmcGetPartitionID ${EXT4_PART_NAME}
   if [ "${DEV_NUM}" == "-1" ]; then
      LOGD "Cannot get ${EXT4_PART_NAME} partition."
      return ${STATUS_ERR}
   fi

   block_device="/dev/mmcblk0p"$DEV_NUM

   busybox.suid mount $block_device ${ROOT_MOUNT} -oro
   if [ $? -ne ${STATUS_OK} ]; then
      LOGD "Error: mount ${block_device} failed"
      return ${STATUS_ERR}
   fi

   return ${STATUS_OK}
}

MainBoot() {

    local tasks_list1="
                    EarlySetup
                    MountSystem
                    "

    for task1 in ${tasks_list1}; do
        ${task1}
        if [ $? -ne ${STATUS_OK} ]; then
            LOGD "Error: ${task1} failed"

            # According to the conditions does system switch or reboot
            return ${STATUS_ERR}
        else
            LOGD "Init: ${task1}"
        fi
    if [ -f "$KPI_FILE_PATH" ]
    then
        echo -n 'M - Ramdisk-init End' >> $KPI_FILE_PATH
    fi
    done
    local tasks_list2="
                    MoveMountToSystem
                    SwitchToSystem
                    "
    for task2 in ${tasks_list2}; do
        ${task2}
        if [ $? -ne ${STATUS_OK} ]; then
            LOGD "Error: ${task2} failed"
            return ${STATUS_ERR}
        else
            LOGD "Init: ${task2}"
        fi
    done
    return ${STATUS_OK}
}

MainBoot

if [ $? -ne ${STATUS_OK} ]; then
   LOGD "MainBoot Error: InitRamFS boot failed"
fi
