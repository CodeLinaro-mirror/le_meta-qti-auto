FILESEXTRAPATHS:prepend:sa525m := "${THISDIR}/files:"

VOLATILE_BINDS:sa525m = "\
/systemrw/adb_devid  /etc/adb_devid\n\
/systemrw/data /etc/data/\n\
/systemrw/data/adpl /etc/data/adpl/\n\
/systemrw/data/usb /etc/data/usb/\n\
/systemrw/data/ipa /etc/data/ipa/\n\
/systemrw/boot_hsusb_comp /etc/usb/boot_hsusb_comp\n\
/systemrw/wifi /etc/misc/wifi/\n\
/systemrw/c2c /etc/c2c/\n\
/systemrw/tel.conf /etc/tel.conf\n\
/systemrw/tm.conf /etc/tm.conf\n\
/systemrw/resourcemanager.xml /etc/resourcemanager.xml\n\
/systemrw/enable /etc/cv2x/enable\n\
/systemrw/ObeConfig.conf /etc/ObeConfig.conf\n\
/systemrw/qvirtmgr.json  /etc/qvirtmgr.json\n\
"

VOLATILE_BINDS:sa525m-televm = "\
/systemrw/enable /etc/cv2x/enable\n\
/systemrw/data /etc/data/\n\
/systemrw/power_state.conf /etc/power_state.conf\n\
/systemrw/tel.conf /etc/tel.conf\n\
/systemrw/ObeConfig.conf /etc/ObeConfig.conf\n\
"

VOLATILE_BINDS:sa525m-fotavm = "\
/systemrw/power_state.conf /etc/power_state.conf\n\
/systemrw/tel.conf /etc/tel.conf\n\
"
