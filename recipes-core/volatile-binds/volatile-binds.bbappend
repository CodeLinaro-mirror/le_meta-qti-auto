FILESEXTRAPATHS:prepend:sa525m := "${THISDIR}/files:"

VOLATILE_BINDS:sa525m:qti-distro-tele-debug = "\
/systemrw/adb_devid  /etc/adb_devid\n\
/systemrw/data /etc/data/\n\
/systemrw/data/adpl /etc/data/adpl/\n\
/systemrw/data/usb /etc/data/usb/\n\
/systemrw/boot_hsusb_comp /etc/usb/boot_hsusb_comp\n\
/systemrw/wifi /etc/misc/wifi/\n\
/systemrw/tel.conf /etc/tel.conf\n\
/systemrw/OSNMA_MerkleTree.xml /etc/OSNMA_MerkleTree.xml\n\
/systemrw/resourcemanager.xml /etc/resourcemanager.xml\n\
/systemrw/chrony.conf /etc/chrony.conf\n\
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
/systemrw/telsdk_app.conf /etc/telsdk_app.conf\n\
/systemrw/Datafilter.conf /etc/Datafilter.conf\n\
/systemrw/rtcmConfig.conf /etc/rtcmConfig.conf\n\
"
VOLATILE_BINDS:sa525m:qti-distro-tele-perf = "\
/systemrw/adb_devid  /etc/adb_devid\n\
/systemrw/data /etc/data/\n\
/systemrw/data/adpl /etc/data/adpl/\n\
/systemrw/data/usb /etc/data/usb/\n\
/systemrw/boot_hsusb_comp /etc/usb/boot_hsusb_comp\n\
/systemrw/wifi /etc/misc/wifi/\n\
/systemrw/tel.conf /etc/tel.conf\n\
/systemrw/OSNMA_MerkleTree.xml /etc/OSNMA_MerkleTree.xml\n\
/systemrw/resourcemanager.xml /etc/resourcemanager.xml\n\
/systemrw/chrony.conf /etc/chrony.conf\n\
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
/systemrw/telsdk_app.conf /etc/telsdk_app.conf\n\
/systemrw/Datafilter.conf /etc/Datafilter.conf\n\
/systemrw/rtcmConfig.conf /etc/rtcmConfig.conf\n\
"

VOLATILE_BINDS:sa525m-televm = "\
/systemrw/chrony.conf /etc/chrony.conf\n\
/systemrw/data /etc/data/\n\
/systemrw/power_state.conf /etc/power_state.conf\n\
/systemrw/tel.conf /etc/tel.conf\n\
/systemrw/OSNMA_MerkleTree.xml /etc/OSNMA_MerkleTree.xml\n\
/systemrw/rtcmConfig.conf /etc/rtcmConfig.conf\n\
/systemrw/qmi_fw.conf /vendor/etc/qmi_fw.conf\n\
/systemrw/gps.conf /etc/gps.conf\n\
/systemrw/eCall.conf /etc/eCall.conf\n\
/systemrw/telsdk_app.conf /etc/telsdk_app.conf\n\
"

VOLATILE_BINDS:sa525m-fotavm = "\
/systemrw/power_state.conf /etc/power_state.conf\n\
/systemrw/tel.conf /etc/tel.conf\n\
/systemrw/qmi_fw.conf /vendor/etc/qmi_fw.conf\n\
/systemrw/gps.conf /etc/gps.conf\n\
"

VOLATILE_BINDS:sa510m = "\
/systemrw/tel.conf /etc/tel.conf\n\
"

do_install:append:sa525m(){
    #Remove deprecated StandardOutput=syslog
    for service in ${SYSTEMD_SERVICE:${PN}}; do
         sed -i '/StandardOutput=syslog/d' ${D}${systemd_system_unitdir}/$service
     done
}
