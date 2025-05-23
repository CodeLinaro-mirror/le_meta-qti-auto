FILESEXTRAPATHS:prepend:sa525m := "${THISDIR}/files:"

VOLATILE_BINDS:sa525m:qti-distro-tele-debug = "\
/systemrw/adb_devid  /etc/adb_devid\n\
/systemrw/data /etc/data/\n\
/systemrw/data/adpl /etc/data/adpl/\n\
/systemrw/data/usb /etc/data/usb/\n\
/systemrw/data/ipa /etc/data/ipa/\n\
/systemrw/boot_hsusb_comp /etc/usb/boot_hsusb_comp\n\
/systemrw/wifi /etc/misc/wifi/\n\
/systemrw/c2c/phone_home.json /etc/c2c/phone_home.json\n\
/systemrw/c2c/c2c_vehicle.json /etc/c2c/c2c_vehicle.json\n\
/systemrw/c2c/c2c_default.conf /etc/c2c/c2c_default.conf\n\
/systemrw/tel.conf /etc/tel.conf\n\
/systemrw/OSNMA_MerkleTree.xml /etc/OSNMA_MerkleTree.xml\n\
/systemrw/tm.conf /etc/tm.conf\n\
/systemrw/resourcemanager.xml /etc/resourcemanager.xml\n\
/systemrw/enable /etc/cv2x/enable\n\
/systemrw/chrony.conf /etc/chrony.conf\n\
/systemrw/ObeConfig.conf /etc/ObeConfig.conf\n\
/systemrw/qvirtmgr.json /etc/qvirtmgr.json\n\
/systemrw/power_state.conf /etc/power_state.conf\n\
/systemrw/qmi_fw.conf /vendor/etc/qmi_fw.conf\n\
/systemrw/gptp_cfg.ini /etc/gptp_cfg.ini\n\
/systemrw/commonapi4someip.ini /etc/commonapi4someip.ini\n\
/systemrw/vsomeip-location.json /etc/vsomeip-location.json\n\
/systemrw/sensors.conf /etc/sensors.conf\n\
/systemrw/gptp_cfg.ini /etc/gptp_cfg.ini\n\
/systemrw/izat.conf /etc/izat.conf\n\
/systemrw/gps.conf /etc/gps.conf\n\
/systemrw/sap.conf /etc/sap.conf\n\
/systemrw/apdr.conf /etc/apdr.conf\n\
/systemrw/eCall.conf /etc/eCall.conf\n\
/systemrw/telux_chrony-sock.conf /etc/telux_chrony-sock.conf\n\
/systemrw/telux_power_refd.conf /etc/telux_power_refd.conf\n\
/systemrw/vsomeip-sensor_service.json /usr/etc/vsomeip/SensorInterface/vsomeip-sensor_service.json\n\
/systemrw/httpd.conf /etc/httpd.conf\n\
/systemrw/qits_env_file /etc/qits_env_file\n\
/systemrw/telsdk_app.conf /etc/telsdk_app.conf\n\
/systemrw/Datafilter.conf /etc/Datafilter.conf\n\
/systemrw/rtcmConfig.conf /etc/rtcmConfig.conf\n\
"
VOLATILE_BINDS:sa525m:qti-distro-tele-perf = "\
/systemrw/adb_devid  /etc/adb_devid\n\
/systemrw/data /etc/data/\n\
/systemrw/data/adpl /etc/data/adpl/\n\
/systemrw/data/usb /etc/data/usb/\n\
/systemrw/data/ipa /etc/data/ipa/\n\
/systemrw/boot_hsusb_comp /etc/usb/boot_hsusb_comp\n\
/systemrw/wifi /etc/misc/wifi/\n\
/systemrw/c2c/phone_home.json /etc/c2c/phone_home.json\n\
/systemrw/c2c/c2c_vehicle.json /etc/c2c/c2c_vehicle.json\n\
/systemrw/c2c/c2c_default.conf /etc/c2c/c2c_default.conf\n\
/systemrw/tel.conf /etc/tel.conf\n\
/systemrw/OSNMA_MerkleTree.xml /etc/OSNMA_MerkleTree.xml\n\
/systemrw/tm.conf /etc/tm.conf\n\
/systemrw/resourcemanager.xml /etc/resourcemanager.xml\n\
/systemrw/enable /etc/cv2x/enable\n\
/systemrw/chrony.conf /etc/chrony.conf\n\
/systemrw/ObeConfig.conf /etc/ObeConfig.conf\n\
/systemrw/power_state.conf /etc/power_state.conf\n\
/systemrw/qmi_fw.conf /vendor/etc/qmi_fw.conf\n\
/systemrw/gptp_cfg.ini /etc/gptp_cfg.ini\n\
/systemrw/commonapi4someip.ini /etc/commonapi4someip.ini\n\
/systemrw/vsomeip-location.json /etc/vsomeip-location.json\n\
/systemrw/sensors.conf /etc/sensors.conf\n\
/systemrw/gptp_cfg.ini /etc/gptp_cfg.ini\n\
/systemrw/izat.conf /etc/izat.conf\n\
/systemrw/gps.conf /etc/gps.conf\n\
/systemrw/sap.conf /etc/sap.conf\n\
/systemrw/apdr.conf /etc/apdr.conf\n\
/systemrw/eCall.conf /etc/eCall.conf\n\
/systemrw/telux_chrony-sock.conf /etc/telux_chrony-sock.conf\n\
/systemrw/telux_power_refd.conf /etc/telux_power_refd.conf\n\
/systemrw/vsomeip-sensor_service.json /usr/etc/vsomeip/SensorInterface/vsomeip-sensor_service.json\n\
/systemrw/httpd.conf /etc/httpd.conf\n\
/systemrw/qits_env_file /etc/qits_env_file\n\
/systemrw/telsdk_app.conf /etc/telsdk_app.conf\n\
/systemrw/Datafilter.conf /etc/Datafilter.conf\n\
/systemrw/rtcmConfig.conf /etc/rtcmConfig.conf\n\
"

VOLATILE_BINDS:sa525m-televm = "\
/systemrw/enable /etc/cv2x/enable\n\
/systemrw/chrony.conf /etc/chrony.conf\n\
/systemrw/data /etc/data/\n\
/systemrw/tm.conf /etc/tm.conf\n\
/systemrw/power_state.conf /etc/power_state.conf\n\
/systemrw/tel.conf /etc/tel.conf\n\
/systemrw/OSNMA_MerkleTree.xml /etc/OSNMA_MerkleTree.xml\n\
/systemrw/rtcmConfig.conf /etc/rtcmConfig.conf\n\
/systemrw/ObeConfig.conf /etc/ObeConfig.conf\n\
/systemrw/qmi_fw.conf /vendor/etc/qmi_fw.conf\n\
/systemrw/gps.conf /etc/gps.conf\n\
/systemrw/eCall.conf /etc/eCall.conf\n\
/systemrw/qits_env_file /etc/qits_env_file\n\
/systemrw/telsdk_app.conf /etc/telsdk_app.conf\n\
"

VOLATILE_BINDS:sa525m-fotavm = "\
/systemrw/power_state.conf /etc/power_state.conf\n\
/systemrw/tel.conf /etc/tel.conf\n\
/systemrw/qmi_fw.conf /vendor/etc/qmi_fw.conf\n\
/systemrw/gps.conf /etc/gps.conf\n\
"

#############################################################################################
# An optional third parameter "Target" can be specified to set the execution priority of the
# volatile bind service file. If not provided, the default target is "Basic.target".
#############################################################################################

VOLATILE_BINDS:sa510m = "\
/systemrw/tel.conf /etc/tel.conf multi-user.target\n\
/systemrw/gptp_cfg.ini /etc/gptp_cfg.ini multi-user.target\n\
/systemrw/sensors.conf /etc/sensors.conf multi-user.target\n\
/systemrw/wifi /etc/misc/wifi/\n\
/systemrw/data/adpl /etc/data/adpl/ multi-user.target\n\
/systemrw/data/dnsmasq.conf /etc/data/dnsmasq.conf\n\
"

do_install:append (){
    #Remove deprecated StandardOutput=syslog
    for service in ${SYSTEMD_SERVICE:${PN}}; do
         sed -i '/StandardOutput=syslog/d' ${D}${systemd_system_unitdir}/$service
     done
}


do_compile () {
    while read spec mountpoint target; do
        if [ -z "$spec" ]; then
            continue
        fi

       if [ -z "$target" ]; then
            target="basic.target"
       fi

        servicefile="$(echo "${spec#/}" | tr / -).service"
        [ "$mountpoint" != ${localstatedir}/lib ] || var_lib_servicefile=$servicefile
        sed -e "s#@what@#$spec#g; s#@where@#$mountpoint#g" \
            -e "s#@whatparent@#${spec%/*}#g; s#@whereparent@#${mountpoint%/*}#g" \
            -e "s#@avoid_overlayfs@#${@d.getVar('AVOID_OVERLAYFS')}#g" \
            -e "s/basic.target/${target}/g" \
            volatile-binds.service.in >$servicefile
    done <<END
${@d.getVar('VOLATILE_BINDS').replace("\\n", "\n")}
END

    if [ -e "$var_lib_servicefile" ]; then
        # As the seed is stored under /var/lib, ensure that this service runs
        # after the volatile /var/lib is mounted.
        sed -i -e "/^Before=/s/\$/ systemd-random-seed.service/" \
               -e "/^WantedBy=/s/\$/ systemd-random-seed.service/" \
               "$var_lib_servicefile"
    fi
}
do_compile[dirs] = "${WORKDIR}"

