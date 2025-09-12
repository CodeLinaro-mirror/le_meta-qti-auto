#!/bin/sh
# Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted (subject to the limitations in the
# disclaimer below) provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#
#    * Redistributions in binary form must reproduce the above
#      copyright notice, this list of conditions and the following
#      disclaimer in the documentation and/or other materials provided
#      with the distribution.
#
#    * Neither the name of Qualcomm Innovation Center, Inc. nor the names of its
#      contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
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

mtd_file=/proc/mtd

ubi_device_number=0

FindAndAttachUBI() {
    partition=$1

    mtd_block_number=`cat $mtd_file | grep -i "\b$partition\b" | sed 's/^mtd//' | awk -F ':' '{print $1}'`
    if [ -z "$mtd_block_number" ]; then
        echo "MTD : Partition $partition not found" > /dev/kmsg
    else
        echo "MTD : Attaching UBI device /dev/mtdblock$mtd_block_number for $partition @$ubi_device_number" > /dev/kmsg

        ubiattach -m $mtd_block_number -d $ubi_device_number /dev/ubi_ctrl
        count=1000 # wait for the ubi-device node to be created for a max of (1000 * 0.010 = ) 10 seconds
        while [ 1 ]; do
            if [ -c /dev/ubi${ubi_device_number} ]; then
                echo "/dev/ubi${ubi_device_number} created" > /dev/kmsg
                break
            else
                count=$(($count - 1))
                if [ $count -lt 1 ]; then
                    echo "/dev/ubi${ubi_device_number} not yet created, rebooting" > /dev/kmsg
                    /sbin/reboot
                    break
                else
                    sleep 0.010
                fi
            fi
        done
    fi

    ls -al /dev | grep -i "ubi" > /dev/kmsg
}

FindAndMountUBI () {
    volume=$1
    dir=$2

    echo "MTD : Looking for UBI volume : $dir for $volume" > /dev/kmsg
    mkdir -p $dir

    for ubidev in /dev/ubi0_*; do
        volname=`ubinfo $ubidev | grep Name\: | awk '{print $2}'`
        if [ "$volname" == "$volume" ]; then
            echo "Found Volume: $volname" > /dev/kmsg
            mount -t ubifs $ubidev $dir -o bulk_read
            echo "MTD : Mounting of $ubidev on $dir done" > /dev/kmsg
            break
        fi
    done
}

eval FindAndAttachUBI  system
eval FindAndMountUBI   usrfs   /data

# set selinux to permissive mode before we start recovery executable
/usr/sbin/setenforce 0

exit
