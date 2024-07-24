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

# Function return status
STATUS_OK=0
STATUS_ERR=1
STATUS_INVAL=-1
DEV_NUM=-1
UEVENT_PATH=""
SYS_MMC_PATH="/sys/class/block"
RECINFO_PATH="/dev/block/bootdevice/by-name/recoveryinfo"
MAX_RETRY=150

KPI_FILE_PATH="/sys/kernel/boot_kpi/kpi_values"

# verity feature status
VERITY_ENV="/etc/verity.env"

# root certificate key path
CERT_CA_PATH="/etc/keys/x509_root.der"
abctl_cmd="/usr/bin/nad-abctl"

LOGD() {
  busybox echo "$1"
}

WaitDevReady()
{
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

#Partition name should be without suffix
EmmcGetPartitionID() {
   DEV_NUM=-1
   UEVENT_PATH=""
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

SetImageOwner() {
    arg=$1
    ${abctl_cmd} --set_owner ${arg}
    if [ "$?" -eq "${STATUS_INVAL}" ]; then
        LOGD "Error: owner set failed"
        return ${STATUS_ERR}
    fi
    return ${STATUS_OK}
}

SlotSwitchReboot () {
    local sys_partn_name=""
    # Set image_set_status fields in recoveryinfo struct
    #  'A&B' Usable     :  SET_AB_USABLE(0)
    #  'A' corrupted     :  DONT_USE_SET_A(1)
    #  'B' corrupted     :  DONT_USE_SET_B(2)
    #  'A &B' corrupted  :  DONT_USE_SET_AB(3)

    # Set owner fields in recoveryinfo struct
    #  OWNER_XBL         :  1
    #  OWNER_HLOS        :  2
    local owner_hlos=2
    local dont_use_set_a=1
    local dont_use_set_b=2
    local dont_use_set_ab=3
    local current_image_set_status=0
    DEV_NUM=-1

    if [ ! -e ${abctl_cmd} ]; then
        LOGD "${abctl_cmd} not found."
        return ${STATUS_ERR}
    fi

    busybox mkdir -p "/dev/block/bootdevice/by-name/"
    EmmcGetPartitionID ${RECINFO_PART_NAME}
    if [ "${DEV_NUM}" == "${STATUS_INVAL}" ]; then
        LOGD "Cannot get ${RECINFO_PART_NAME} partition."
        return ${STATUS_ERR}
    fi
    busybox ln -s "/dev/mmcblk0p"${DEV_NUM} ${RECINFO_PATH}
    busybox chmod 777 "/dev/mmcblk0p"${DEV_NUM}
    # check current slot and image_set_status in recoveryinfo
    #  'A' corrupted     :  set image_set_status = DONT_USE_SET_A
    #  'B' corrupted     :  set image_set_status = DONT_USE_SET_B
    #  'A &B' corrupted  :  set image_set_status = DONT_USE_SET_AB

    curr_slot=`busybox cat /proc/cmdline | busybox awk -F'SLOT_SUFFIX=' '{print $2}' | busybox awk '{print $1}' | busybox tr -d '"'`
    if [ "x${curr_slot}" == "x" ]; then
        # Single system (non AB)
        LOGD "slot_suffix not present"
        LOGD "non-AB scenario, reboot to edl"
        #XBL or ABL will take care of slot switching after reboot with Trail Boot Enabled.
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

    # Set owner to HLOS & reboot device
    SetImageOwner ${owner_hlos}
    if [ "$?" -eq "${STATUS_ERR}" ]; then
        return ${STATUS_ERR}
    fi

    LOGD "Reboot device for Slot Switch or EDL"
    #XBL or ABL will take care of slot switching after reboot with Trail Boot Enabled.
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

    local vb_option=
    EmmcGetPartitionID ${EXT4_PART_NAME}
    if [ "${DEV_NUM}" == "${STATUS_INVAL}" ]; then
       LOGD "Cannot get ${EXT4_PART_NAME} partition."
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
