FILESEXTRAPATHS:prepend:sa525m := "${THISDIR}/files:"

VOLATILE_BINDS:sa525m = "\
/systemrw/adb_devid  /etc/adb_devid\n\
/systemrw/data /etc/data/\n\
/systemrw/data/adpl /etc/data/adpl/\n\
/systemrw/data/usb /etc/data/usb/\n\
/systemrw/data/ipa /etc/data/ipa/\n\
/systemrw/boot_hsusb_comp /etc/usb/boot_hsusb_comp\n\
/systemrw/misc/wifi /etc/misc/wifi/\n\
/systemrw/c2c /etc/c2c/\n\
/systemrw/tel.conf /etc/tel.conf\n\
/systemrw/tm.conf /etc/tm.conf\n\
/systemrw/resourcemanager.xml /etc/resourcemanager.xml\n\
/systemrw/enable /etc/cv2x/enable\n\
/systemrw/ObeConfig.conf /etc/ObeConfig.conf\n\
/systemrw/qvirtmgr.json  /etc/qvirtmgr.json\n\
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
"

VOLATILE_BINDS:sa525m-televm = "\
/systemrw/enable /etc/cv2x/enable\n\
/systemrw/data /etc/data/\n\
/systemrw/tm.conf /etc/tm.conf\n\
/systemrw/power_state.conf /etc/power_state.conf\n\
/systemrw/tel.conf /etc/tel.conf\n\
/systemrw/ObeConfig.conf /etc/ObeConfig.conf\n\
/systemrw/qmi_fw.conf /vendor/etc/qmi_fw.conf\n\
/systemrw/gps.conf /etc/gps.conf\n\
/systemrw/eCall.conf /etc/eCall.conf\n\
"

VOLATILE_BINDS:sa525m-fotavm = "\
/systemrw/power_state.conf /etc/power_state.conf\n\
/systemrw/tel.conf /etc/tel.conf\n\
/systemrw/qmi_fw.conf /vendor/etc/qmi_fw.conf\n\
/systemrw/gps.conf /etc/gps.conf\n\
"
