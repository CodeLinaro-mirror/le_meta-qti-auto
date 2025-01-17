#!/bin/sh
# Copyright (c) 2023-2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

UBI_SYS_CLASS="/sys/class/ubi/ubi0"
UBI_DEV_BLOCK="/dev/ubiblock0"
UBIFS_VOL_HEADER="1831 0610"
VERITY_ENV="/etc/verity.env"
ABCTL_CMD="/usr/bin/nad-abctl"

# Function return status
STATUS_OK=0
STATUS_ERR=1
STATUS_INVAL=-1
KPI_FILE_PATH="/sys/kernel/boot_kpi/kpi_values"

GetLXCRFSVolumeID () {

    partition=$1
    volcount=`cat ${UBI_SYS_CLASS}/volumes_count`

    for vid in `seq 0 $volcount`; do
        name=`cat ${UBI_SYS_CLASS}_$vid/name`
        if [ "$name" == "$partition" ]; then
            echo $vid
            break
        fi
    done
}

WaitDevReady()
{
    local maxTrials=200
    local ret=${STATUS_OK}

    while [ ! "$1" "$2" ]; do
        usleep 10000
        maxTrials=$( echo $(( ${maxTrials} - 1 )) )
        if [ ${maxTrials} -eq 0 ]; then
            echo "Error: WaitDevReady: Timed Out" > /dev/kmsg
            ret=${STATUS_ERR}
            break
        fi
    done
    return ${ret}
}

SetImageStatus() {
    arg=$1
    ${ABCTL_CMD} --set_image_set_status ${arg}
    if [ "$?" -eq "${STATUS_INVAL}" ]; then
        echo "Error: image set status failed" > /dev/kmsg
        return ${STATUS_ERR}
    fi
    return ${STATUS_OK}
}

IsGPIOEnabled () {
    gpio_enable_status=`cat /proc/cmdline | awk -F'recoveryinfo_gpio=' '{print $2}' | awk '{print $1}' | tr -d '"'`
    return ${gpio_enable_status}
}

SlotSwitchReboot () {
    # Set image_set_status fields in recoveryinfo struct
    #  'A &B' Usable     :  SET_AB_USABLE(0)
    #  'A' corrupted     :  DONT_USE_SET_A(1)
    #  'B' corrupted     :  DONT_USE_SET_B(2)
    #  'A &B' corrupted  :  DONT_USE_SET_AB(3)

    local dont_use_set_a=1
    local dont_use_set_b=2
    local dont_use_set_ab=3
    local current_image_set_status=0
    local lxcrfs_a="lxcrootfs_a"
    local lxcrfs_b="lxcrootfs_b"
    local curr_slot

    if [ ! -e ${ABCTL_CMD} ]; then
        echo "${ABCTL_CMD} not found, reboot to edl " > /dev/kmsg
        /bin/sh -c 'reboot edl'
    fi

    mtd_device=`cat /proc/mtd | grep recoveryinfo | awk -F ':' '{print $1}'`
    if [ -z "${mtd_device}" ]; then
        echo " recoveryinfo part not found, reboot to edl " > /dev/kmsg
        /bin/sh -c 'reboot edl'
    fi
    chmod 666 /dev/${mtd_device}

    volid=$(GetLXCRFSVolumeID $partition)
    lxcrfs_ab_name=$(cat /sys/class/ubi/ubi0_${volid}/name)
    curr_slot=`cat /proc/cmdline | awk -F'SLOT_SUFFIX=' '{print $2}' | awk '{print $1}' | tr -d '"'`
    if [ "x${curr_slot}" == "x" ]; then
        echo "SLOT_SUFFIX not present or invalid, reboot to edl" > /dev/kmsg
        /bin/sh -c 'reboot edl'
        exit 1
    else
        # A/B system case
        #Get current image set status
        (${ABCTL_CMD} --get_image_set_status)
        current_image_set_status=$?
        if [ "$current_image_set_status" -eq "-1" ]; then
            echo "Error: incorrect image set status" > /dev/kmsg
            /bin/sh -c 'reboot edl'
            exit 1
        fi

        if [ "$SLOT_SUFFIX" = "_a" ] && [ "$current_image_set_status" != "$dont_use_set_b" ]; then
            echo "$lxcrfs_a volume corrupted " > /dev/kmsg
            SetImageStatus ${dont_use_set_a}
            if [ "$?" -eq "${STATUS_ERR}" ]; then
                /bin/sh -c 'reboot edl'
                exit 1
            fi
        elif [ "$SLOT_SUFFIX" = "_b" ] && [ "$current_image_set_status" != "$dont_use_set_a" ]; then
            echo "$lxcrfs_b volume corrupted " > /dev/kmsg
            SetImageStatus ${dont_use_set_b}
            if [ "$?" -eq "${STATUS_ERR}" ]; then
                /bin/sh -c 'reboot edl'
                exit 1
            fi
        else
            echo "$lxcrfs_a and $lxcrfs_b volume corrupted" > /dev/kmsg
            SetImageStatus ${dont_use_set_ab}
            if [ "$?" -eq "${STATUS_ERR}" ]; then
                /bin/sh -c 'reboot edl'
                exit 1
            fi
        fi
    fi
    #Set owner is set by SetImageStatus command internally, perform device crash.
    echo "RBM: Crashing for switching slots or EDL mode" > /dev/kmsg
    #XBL or ABL will take care of slot switching after reboot with Trail Boot Enabled.
    /bin/sh 'echo c > /proc/sysrq-trigger'
    exit 1
}

FindAndMountUBIVolume () {
    partition=$1
    dir=$2
    extra_opts=$3
    ubi_dev_id=0
    local image_type="ubifs"

    volid=$(GetLXCRFSVolumeID $partition)
    if [ "$volid" == "" ]; then
        echo "volume index not found for $partition volume "  > /dev/kmsg
        return ${STATUS_ERR}
    fi

    device=/dev/ubi0_$volid
    block_device=${UBI_DEV_BLOCK}_$volid
    # Check if the image type is squashfs in UBI volume
    if dd if=${device}\
        count=1 bs=4 2>/dev/null | grep 'hsqs' > /dev/null; then
        image_type="squashfs"
    elif dd if=${device} count=1 bs=4 2>/dev/null |\
        hexdump | grep "${UBIFS_VOL_HEADER}" > /dev/null; then
        image_type="ubifs"
    else
        image_type="unknown"
    fi

    if [ "$image_type" == "squashfs" ]; then
        ubiblock --create $device
        WaitDevReady "-b" "${block_device}"
        if [ $? -ne 0 ]; then
            echo "Failed to wait on ${block_device}, exiting." > /dev/kmsg
            return ${STATUS_ERR}
        fi
        restorecon ${block_device}
        if [ $? -ne 0 ] ; then
            echo "Failed restorecon on ${block_device}." > /dev/kmsg
        fi
        if [ ! -e "${VERITY_ENV}" ]; then
          VERITY_ENV="/proc/cmdline"
        fi
        if grep 'nad_avb=1' ${VERITY_ENV} > /dev/null; then
            # The system certificate CA is in the rootfs volume, verified-boot utility
            # need to use this CA to verify the user certificate.
            volid=$(GetLXCRFSVolumeID "rootfs"$SLOT_SUFFIX)
            if [ "$volid" == "" ]; then
                echo "volume index not found for rootfs "  > /dev/kmsg
                return ${STATUS_ERR}
            fi
            if dd if=/dev/ubi0_$volid count=1 bs=4 2>/dev/null | grep 'hsqs' > /dev/null; then
                CERT_CA_PATH=/dev/ubiblock0_$volid
            else
                CERT_CA_PATH=/dev/mapper/system
            fi
            dm_verity_name=lxcrootfs
            dm_verity_device=/dev/mapper/${dm_verity_name}
            verified-boot -n ${dm_verity_name} -d $block_device -p ${CERT_CA_PATH} > /dev/kmsg
            if [ $? -ne 0 ] ; then
                echo CERT_CA_PATH=${CERT_CA_PATH} > /dev/kmsg
                echo "Creation of dm-verity device ${dm_verity_device} failed." > /dev/kmsg
                return ${STATUS_ERR}
            fi

            WaitDevReady "-b" "${dm_verity_device}"
            if [ $? -ne 0 ]; then
                echo "Failed to wait on ${dm_verity_device}, exiting." > /dev/kmsg
                return ${STATUS_ERR}
            fi
            block_device=${dm_verity_device}
        fi
        mount -t squashfs $block_device $dir -o ro$extra_opts
    elif [ "$image_type" == "ubifs" ]; then
        mount -t ubifs ubi$ubi_dev_id:$partition $dir -o bulk_read$extra_opts
    else
        echo "not proper fs type, failed to mount" > /dev/kmsg
        return ${STATUS_ERR}
    fi
    echo -n 'M - lxcrootfs mount finish' >> $KPI_FILE_PATH
}

lxcrfs_part_name="lxcrootfs$SLOT_SUFFIX"
is_lxcrfs_vol_enabled=`ubinfo -d 0 -N $lxcrfs_part_name`

if [ -x /sbin/restorecon ]; then
   lxcrfs_selinux_opt=",context=system_u:object_r:lxcrootfs_t:s0"
else
   lxcrfs_selinux_opt=""
fi

if [ ! -z "$is_lxcrfs_vol_enabled" ];
then
    echo -n 'M - lxcrootfs mount start' >> $KPI_FILE_PATH
    eval FindAndMountUBIVolume $lxcrfs_part_name /lxcrootfs $lxcrfs_selinux_opt
    if [ $? -ne ${STATUS_OK} ] ; then
        echo "lxcrfs volume mount failed" > /dev/kmsg
        IsGPIOEnabled
        if [ "$?" -eq "${STATUS_ERR}" ]; then
            #GPIO Enabled moving device to EDL.
            echo "GPIO Enabled boot to EDL" > /dev/kmsg
            /bin/sh -c 'reboot edl'
        else
            echo "GPIO disabled, switch slots" > /dev/kmsg
            SlotSwitchReboot
        fi
        exit 0
    fi
fi
exit 0
