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
Bgrep="busybox grep"
Becho="busybox echo"
#------------------------------------------------------------
# Temporary rootfs mount node
ROOT_MOUNT="/rootfs"
EXT4_PART_NAME="system"
RECINFO_PART_NAME="recoveryinfo"
SYSTEMRW_PART_NAME="systemrw"

# Function return status
STATUS_OK=0
STATUS_ERR=1
STATUS_INVAL=-1

SLOT_SUFFIX=""
DEV_NUM=-1
SYS_MMC_PATH="/sys/class/block"
RECINFO_PATH="/dev/block/bootdevice/by-name/recoveryinfo"
MAX_RETRY=150

KPI_FILE_PATH="/sys/kernel/boot_kpi/kpi_values"

# verity feature status
VERITY_ENV="/etc/verity.env"

# root certificate key path
CERT_CA_PATH="/etc/keys/x509_root.der"
abctl_cmd="/usr/bin/nad-abctl"

ENABLE_SYSTEMD_OVERLAY="${ROOT_MOUNT}/etc/systemd-overlay/enable"

LOGD() {
  busybox echo "$1"
}

WaitDevReady() {
    local maxTrials=300

    while [ ! "$1" "$2" ]; do
        busybox usleep 100000
        maxTrials=$( echo $(( ${maxTrials} - 1 )) )
        if [ ${maxTrials} -eq 0 ]; then
           LOGD "Error: WaitDevReady Timed Out $maxTrails"
           return ${STATUS_ERR}
        fi
    done
    return ${STATUS_OK}
}


GetSlotSuffix() {
    local boot_slot=""
    boot_slot=`busybox cat /proc/cmdline | busybox awk -F'SLOT_SUFFIX=' '{print $2}' | busybox awk '{print $1}' | busybox tr -d '"'`
    if [ "${boot_slot}" == "_a" ]; then
        SLOT_SUFFIX=""
    elif [ "${boot_slot}" == "_b" ]; then
        SLOT_SUFFIX="_b"
    else
        SLOT_SUFFIX=""
        LOGD "SLOT_SUFFIX not found in cmdline"
        return ${STATUS_ERR}
    fi
    return ${STATUS_OK}
}

#Partition name should be with suffix
EmmcGetPartitionID() {
    DEV_NUM=-1
    local UEVENT_PATH=""
    local PART_NAME=$1
    local retry_count=0

    # Fetch active part uevent then parse dev num from PARTN
    while [ $retry_count -lt $MAX_RETRY ]
    do
        UEVENT_PATH=$(busybox grep -wl "PARTNAME="$PART_NAME ${SYS_MMC_PATH}/mmcblk0p*/uevent)
        if [ -n $UEVENT_PATH ]; then
            DEV_NUM=$(busybox grep -w PARTN $UEVENT_PATH | busybox awk -F '=' '{print $2}')
            return ${STATUS_OK}
        fi
        busybox usleep 100000
        retry_count=$(( retry_count + 1))
    done

    LOGD "Error: EmmcGetPartitionID timed out $retry_count"
    return ${STATUS_ERR}
}

EarlySetup() {
    busybox.suid mount -t proc proc /proc
    busybox.suid mount -t sysfs sysfs /sys
    busybox.suid mount -t devtmpfs none /dev

    if [ -f "$KPI_FILE_PATH" ]; then
        echo -n 'M - Ramdisk-init Start' >> $KPI_FILE_PATH
    fi
    return ${STATUS_OK}
}

gracefullReboot () {
    local mode=$1
    if [ ! -e ${abctl_cmd} ]; then
        LOGD "${abctl_cmd} not found."
        return ${STATUS_ERR}
    fi

    LOGD "InitRamFS: Found issue, rebooting ${mode}..."
    busybox sleep 1

    ${abctl_cmd} --reboot ${mode}
    if [ "$?" -eq "${STATUS_INVAL}" ]; then
        LOGD "Error: reboot failed"
        return ${STATUS_ERR}
    fi
}

IsGPIOEnabled () {
    gpio_enable_status=`busybox cat /proc/cmdline | busybox awk -F'recoveryinfo_gpio=' '{print $2}' | busybox awk '{print $1}' | busybox tr -d '"'`
    return ${gpio_enable_status}
}

SetImageStatus() {
    arg=$1
    ${abctl_cmd} --set_image_set_status ${arg}
    if [ "$?" -eq "${STATUS_INVAL}" ]; then
        LOGD "Error: image set status failed"
        return ${STATUS_ERR}
    fi
    return ${STATUS_OK}
}

SlotSwitchReboot () {
    # Set image_set_status fields in recoveryinfo struct
    #  'A&B' Usable     :  SET_AB_USABLE(0)
    #  'A' corrupted     :  DONT_USE_SET_A(1)
    #  'B' corrupted     :  DONT_USE_SET_B(2)
    #  'A &B' corrupted  :  DONT_USE_SET_AB(3)
    local dont_use_set_a=1
    local dont_use_set_b=2
    local dont_use_set_ab=3
    local current_image_set_status=0
    DEV_NUM=-1

    if [ ! -e ${abctl_cmd} ]; then
        LOGD "${abctl_cmd} not found."
        return ${STATUS_ERR}
    fi

    # create symlink for recoveryinfo partition
    busybox mkdir -p "/dev/block/bootdevice/by-name/"
    EmmcGetPartitionID ${RECINFO_PART_NAME}
    if [ "${DEV_NUM}" == "${STATUS_INVAL}" ]; then
        LOGD "Cannot get ${RECINFO_PART_NAME} partition."
        return ${STATUS_ERR}
    fi
    busybox ln -s "/dev/mmcblk0p"${DEV_NUM} ${RECINFO_PATH}
    busybox chmod 777 "/dev/mmcblk0p"${DEV_NUM}

    # check current slot and image_set_status in recoveryinfo
    curr_slot=`busybox cat /proc/cmdline | busybox awk -F'SLOT_SUFFIX=' '{print $2}' | busybox awk '{print $1}' | busybox tr -d '"'`
    if [ "x${curr_slot}" == "x" ]; then
        # Single system (non AB)
        LOGD "slot_suffix not present"
        LOGD "non-AB scenario, reboot to edl"
        #XBL or ABL will take care of slot switching after reboot with Trial Boot Enabled.
        gracefullReboot edl
        return ${STATUS_ERR}
    else
        # A/B system case
        #Get current image set status
        (${abctl_cmd} --get_image_set_status)
        current_image_set_status=$?
        if [ "$current_image_set_status" -eq "${STATUS_INVAL}" ]; then
            LOGD "Error: incorrect image set status"
            return ${STATUS_ERR}
        fi

        if [ "$curr_slot" = "_a" ] && [ "$current_image_set_status" != "$dont_use_set_b" ]; then
            LOGD "system A partition corrupted "
            SetImageStatus ${dont_use_set_a}
            if [ "$?" -eq "${STATUS_ERR}" ]; then
                return ${STATUS_ERR}
            fi
        elif [ "$curr_slot" = "_b" ] && [ "$current_image_set_status" != "$dont_use_set_a" ]; then
            LOGD "system B partition corrupted "
            SetImageStatus ${dont_use_set_b}
            if [ "$?" -eq "${STATUS_ERR}" ]; then
                return ${STATUS_ERR}
            fi
        else
            LOGD "system A and B both partition is corrupted."
            SetImageStatus ${dont_use_set_ab}
            if [ "$?" -eq "${STATUS_ERR}" ]; then
                return ${STATUS_ERR}
            fi
        fi
    fi

    LOGD "Reboot device for Slot Switch or EDL"
    #XBL or ABL will take care of slot switching after reboot with Trial Boot Enabled.
    gracefullReboot
    return ${STATUS_ERR}
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
# Mount system partition
#
MountSystem () {
    local vb_option=""

    GetSlotSuffix
    if [ $? -ne ${STATUS_OK} ]; then
        LOGD "Unable to get slot suffix"
    fi

    EmmcGetPartitionID ${EXT4_PART_NAME}${SLOT_SUFFIX}
    if [ "${DEV_NUM}" == "${STATUS_INVAL}" ]; then
       LOGD "Cannot get ${EXT4_PART_NAME}${SLOT_SUFFIX} partition."
       return ${STATUS_ERR}
    fi
    block_device="/dev/mmcblk0p"$DEV_NUM

    # For root file system Verified boot enabling
    if  ${Bgrep} 'nad_avb=1' ${VERITY_ENV} > /dev/null; then
        dm_verity_device=/dev/mapper/${EXT4_PART_NAME}
        if ${Bgrep} 'secure=1' /proc/cmdline > /dev/null; then
            vb_option="-s"
        fi
        verified-boot -n ${EXT4_PART_NAME} -d ${block_device} -k ${CERT_CA_PATH} ${vb_option}

        if [ $? -ne ${STATUS_OK} ] ; then
            LOGD "Created dm-verity device ${dm_verity_device} failed."
            return ${STATUS_ERR}
        fi

        WaitDevReady "-b" "${dm_verity_device}"
        if [ $? -ne ${STATUS_OK} ]; then
            LOGD "Failed to wait on ${dm_verity_device}, exiting."
            return ${STATUS_ERR}
        else
            block_device=${dm_verity_device}
        fi
    fi
    busybox.suid mount $block_device ${ROOT_MOUNT} -oro
    if [ $? -ne ${STATUS_OK} ]; then
       LOGD "Error: mount ${block_device} failed"
       return ${STATUS_ERR}
    fi
    return ${STATUS_OK}
}

MountSystemrw() {
    EmmcGetPartitionID ${SYSTEMRW_PART_NAME}
    if [ "${DEV_NUM}" == "-1" ]; then
        LOGD "Cannot get systemrw partition."
        return ${STATUS_ERR}
    fi

    block_device="/dev/mmcblk0p"$DEV_NUM

    busybox.suid mount -t ext4 "${block_device}" ${ROOT_MOUNT}/systemrw -o rw,noexec,nosuid,nodev
    if [ $? -ne ${STATUS_OK} ]; then
        LOGD "Error: mount ${block_device} failed"
        return ${STATUS_ERR}
    fi

    return ${STATUS_OK}
}

MountSystemdOverlay() {
    busybox mkdir -p ${ROOT_MOUNT}/systemrw/lib-systemd-system
    busybox mkdir -p ${ROOT_MOUNT}/systemrw/lib-systemd-system-work
    busybox mkdir -p ${ROOT_MOUNT}/systemrw/etc-systemd-system
    busybox mkdir -p ${ROOT_MOUNT}/systemrw/etc-systemd-system-work

    busybox.suid mount -t overlay overlay ${ROOT_MOUNT}/lib/systemd/system -o lowerdir=${ROOT_MOUNT}/lib/systemd/system,upperdir=${ROOT_MOUNT}/systemrw/lib-systemd-system,workdir=${ROOT_MOUNT}/systemrw/lib-systemd-system-work,noexec,nosuid,nodev
    if [ $? -ne ${STATUS_OK} ]; then
        LOGD "Error: mount overlay ${ROOT_MOUNT}/lib/systemd/system failed"
        return ${STATUS_ERR}
    fi

    busybox.suid mount -t overlay overlay ${ROOT_MOUNT}/etc/systemd/system -o lowerdir=${ROOT_MOUNT}/etc/systemd/system,upperdir=${ROOT_MOUNT}/systemrw/etc-systemd-system,workdir=${ROOT_MOUNT}/systemrw/etc-systemd-system-work,noexec,nosuid,nodev
    if [ $? -ne ${STATUS_OK} ]; then
        LOGD "Error: mount overlay ${ROOT_MOUNT}/etc/systemd/system failed"
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
            IsGPIOEnabled
            if [ $? -eq 1 ]; then
                #GPIO Enabled keeping behavior similar to Mount failure.
                LOGD "GPIO Enabled do not switch slots "
            else
                LOGD "GPIO disabled switch the slots or boot to EDL "
                SlotSwitchReboot
            fi
            return ${STATUS_ERR}
        else
            LOGD "Init: ${task1}"
        fi

        if [ -f "$KPI_FILE_PATH" ]; then
            echo -n 'M - Ramdisk-init End' >> $KPI_FILE_PATH
        fi
    done
    local tasks_list2="
                    MoveMountToSystem
                    SwitchToSystem
                    "
    if [ -e ${ENABLE_SYSTEMD_OVERLAY} ]; then
        tasks_list2="
                    MountSystemrw
                    MountSystemdOverlay
                    $tasks_list2
                    "
    fi
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
