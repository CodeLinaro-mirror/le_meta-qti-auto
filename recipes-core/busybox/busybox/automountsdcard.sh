#! /bin/sh

#
# Copyright (c) 2020-2021, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above
#      copyright notice, this list of conditions and the following
#      disclaimer in the documentation and/or other materials provided
#      with the distribution.
#    * Neither the name of The Linux Foundation nor the names of its
#      contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

destdir=/mnt/sdcard/

umount_partition()
{
        check_umount_point $1
        if grep -qs "^/dev/$1 " /proc/mounts ; then
                umount -lf "${destdir}";
        fi
}

mount_partition()
{
        check_mount_point $1
        if [ ! -d "${destdir}" ]; then
            mkdir "${destdir}"
        fi

# Mounting sd-card with user "root" and group "sdcard" with proper umask permissions so that non-root applications can access sdcard by adding to "sdcard" group. 

        if ! mount -t auto "/dev/$1" "${destdir}" -o uid=0,gid=1015,umask=002,context=system_u:object_r:sdcard_t:s0,nodev,noexec,nosuid; then
                # failed to mount
                exit 1
        fi
}

check_if_boot_dev()
{
                ret_val=`cat /proc/cmdline | grep "androidboot.bootdevice" |wc -l`
                if  [ $ret_val -ne 0 ]; then
                    boot_dev_list=`cat /proc/cmdline | awk '{ for ( n=1; n<=NF; n++ ) if($n ~ "androidboot.bootdevice") print $n }' | awk '{split($0,a, "=");print a[2]}'`
                    boot_dev=`echo $boot_dev_list | awk '{print $NF}'`
                    real_sysfs_path=`realpath /sys/class/block/$1`
                    ret_val=`echo $real_sysfs_path | grep /sys/devices/ | grep $boot_dev | wc -l`
                fi
                echo $ret_val
}


create_symlink()
{
                real_sysfs_path=`realpath /sys/class/block/$1`
                partition_name=`cat $real_sysfs_path/uevent | awk '{ for ( n=1; n<=NF; n++ ) if($n ~ "PARTNAME") print $n }' | awk '{split($0,a, "=");print a[2]}'`
                mkdir -p /dev/block/bootdevice/by-name/
                partition_name=/dev/block/bootdevice/by-name/$partition_name
                target_dev=/dev/$1
                ln -s $target_dev $partition_name
}

check_mount_point()
{
    case `cat /sys/devices/soc0/machine` in
        *845* )
    ret_val=`echo $1 | grep mmcblk | wc -l`
    if [ $ret_val -eq 0 ];then
        folder_list=`grep "/mnt/usb*" /proc/mounts | awk '{print $2}'`

        if [ "$folder_list" ];then
            for i in 0 1 2
            do
                destdir=/mnt/usbstorage$i
                for dir in $folder_list
                do
                    if [ "$dir" != "$destdir" ];then
                        break 2
                    fi
                done
            done
        else
            destdir=/mnt/usbstorage0
        fi
    fi
            ;;
        * )
            ;;
    esac
}

check_umount_point()
{
    case `cat /sys/devices/soc0/machine` in
         *845* )
    ret_val=`echo $1 | grep mmcblk | wc -l`
    if [ $ret_val -eq 0 ];then
        destdir=`grep $1 /proc/mounts | awk '{print $2}'`
    fi
            ;;
        * )
            ;;
    esac
}


case "${ACTION}" in
add|"")
        result=`check_if_boot_dev $1`
        if [ $result -eq 1 ]; then
                 create_symlink $1 &
        else
                 umount_partition ${1}
                 mount_partition ${1}
        fi
        ;;
remove)
        umount_partition ${1}
        ;;
esac


