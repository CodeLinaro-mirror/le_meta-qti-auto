MACHINE_FEATURES:append = " qti-eap"
MACHINE_FEATURES:remove += "qti-wwan-plus-cv2x qti-cv2x-compensator qti-mvm qti-location qti-wlan qti-nad-telaf"
USBCOMPOSITION = "901D"
SDCARD_DEVICE:sa525m = "mmcblk1"

FLAVOR = "apq"
SYSTEMD_AUTO_ENABLE:modem-monitor = "enable"
