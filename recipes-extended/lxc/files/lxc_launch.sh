#!/bin/sh

#Copyright (c) 2023 Qualcomm Innovation Center, Inc. All rights reserved.
#SPDX-License-Identifier: LGPL-2.1-only

LXC_CON_NAME="telaflxc"
LXC_CONF_PATH="/etc/lxc/lxc_networking.conf"
DEF_VETH_HOST_IP="192.168.2.200"
LXC_CONTAINER_LOG_PATH="/tmp/con_log"

exec_lxc_ops() {
   OPS="$1"

   if [ ! -d "$LXC_CONTAINER_LOG_PATH" ]; then
      mkdir -p $LXC_CONTAINER_LOG_PATH
   fi

   case $OPS in
      start)
         if [ -n "$(ls -A /lxcrootfs 2>/dev/null)" ]; then
            #loading modules for lxc
            modprobe macvlan
            modprobe ip6table_nat
            modprobe xt_CHECKSUM

            lxc-create -n $LXC_CON_NAME -f $LXC_CONF_PATH -t none -o $LXC_CONTAINER_LOG_PATH/lxc-create.log -l TRACE
            lxc-start -n $LXC_CON_NAME -o $LXC_CONTAINER_LOG_PATH/lxc-start.log -l TRACE
            #set ip for veth host
            lxc-info -n $LXC_CON_NAME | grep Link: | awk '{print $2}' | xargs -t -I {} ifconfig {} "$DEF_VETH_HOST_IP"
         else
            echo "No files in /lxcrootfs, skipping lxc create/start" > /dev/kmsg
         fi
         ;;
      stop)
         if [ -n "$(ls -A /lxcrootfs 2>/dev/null)" ]; then
            lxc-stop -n $LXC_CON_NAME
            lxc-destroy -n $LXC_CON_NAME -o $LXC_CONTAINER_LOG_PATH/lxc-destroy.log -l TRACE
            #manually deleting the container path, because
            #container marked as non mananged in conf
            rm "/tmp/container" -rf
            rmmod xt_CHECKSUM
            rmmod ip6table_nat
            rmmod macvlan
         else
            echo "No files in /lxcrootfs, skipping lxc stop/destroy" > /dev/kmsg
         fi
         ;;

      *)
      echo "No proper input"
      ;;
   esac
}

eval exec_lxc_ops $1
exit 0
