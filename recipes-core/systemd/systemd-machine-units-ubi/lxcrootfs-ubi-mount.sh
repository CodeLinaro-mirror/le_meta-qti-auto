#!/bin/sh
# Copyright (c) 2023-2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

UBI_SYS_CLASS="/sys/class/ubi/ubi0"
UBI_DEV_BLOCK="/dev/ubiblock0"
UBIFS_VOL_HEADER="1831 0610"
VERITY_ENV="/etc/verity.env"

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
    local ret=0

    while [ ! "$1" "$2" ]; do
        usleep 10000
        maxTrials=$( echo $(( ${maxTrials} - 1 )) )
        if [ ${maxTrials} -eq 0 ]; then
            ret=1
            break
        fi
    done
    return ${ret}
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
        return 1
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
           exit 0
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
            return 1
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
            return 1
          fi

          WaitDevReady "-b" "${dm_verity_device}"
          if [ $? -ne 0 ]; then
             echo "Failed to wait on ${dm_verity_device}, exiting." > /dev/kmsg
             return 1
          fi
          block_device=${dm_verity_device}
        fi
        mount -t squashfs $block_device $dir -o ro$extra_opts
   elif [ "$image_type" == "ubifs" ]; then
        mount -t ubifs ubi$ubi_dev_id:$partition $dir -o bulk_read$extra_opts
   else
       echo "not proper fs type, failed to mount" > /dev/kmsg
       exit 0
   fi

   if [ $? -ne 0 ] ; then
      echo "Unable to mount lxcrootfs volume " > /dev/kmsg
      exit 0
   fi
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
    eval FindAndMountUBIVolume $lxcrfs_part_name /lxcrootfs $lxcrfs_selinux_opt
    if [ $? -ne 0 ] ; then
       echo "lxcrfs volume mount failed" > /dev/kmsg
       exit 0
    fi
fi

exit 0
