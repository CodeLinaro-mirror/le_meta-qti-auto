#!/system/bin/sh
# Copyright (c) 2014, 2017-2018, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#   * Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#   * Redistributions in binary form must reproduce the above
#     copyright notice, this list of conditions and the following
#     disclaimer in the documentation and/or other materials provided
#     with the distribution.
#   * Neither the name of The Linux Foundation nor the names of its
#     contributors may be used to endorse or promote products derived
#     from this software without specific prior written permission.
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
set -e

# PLATFORM_SUBTYPE_ID for TTP CV2X platform
SUBTYPE_ID_CV2X=1

# get soc platform to update product related information
if [ -f /sys/devices/soc0/hw_platform ]; then
    soc_hwplatform=`cat /sys/devices/soc0/hw_platform`
    soc_subtypeid=`cat /sys/devices/soc0/platform_subtype_id`
fi

case "$1" in
    start)
        echo -e "Starting CAN: "
        if [ "$soc_hwplatform" == "TTP" ] && [ "$soc_subtypeid" == "$SUBTYPE_ID_CV2X" ]; then
            ip link add name can0 type vcan
            ip link set up can0
            start-stop-daemon -S -b -a /usr/bin/cannelloni -- -I can0 -R 192.168.100.2 -t 10000
        else
            ip link set can0 type can bitrate 500000
            ip link set up can0
        fi
        echo "done"
        ;;
    stop)
        echo -e "Stopping CAN: "
        if [ "$soc_hwplatform" == "TTP" ] && [ "$soc_subtypeid" == "$SUBTYPE_ID_CV2X" ]; then
            start-stop-daemon -K -n cannelloni
            ip link set dev can0 down
            ip link del can0
        fi
        echo "done"
        ;;
    restart)
        $0 stop
        $0 start
        ;;
    *)
        echo "Usage $0 { start | stop | restart}" >&2
        exit 1
        ;;
esac

exit 0
