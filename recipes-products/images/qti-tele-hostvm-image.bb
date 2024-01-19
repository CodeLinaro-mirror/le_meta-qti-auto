# QTI Linux Telematics Host VM image file.
# Provides packages required to build
# QTI Linux Telematics Host VM image.

require qti-tele-image.inc

IMAGE_FEATURES += "vm-bootsys-volume vm-systemrw-volume"

# Install km-loader for selected machines
EVDEVMODULE ?= 'False'
EVDEVMODULE_sa515m = 'True'
EVDEVMODULE_sa415m = 'True'

CORE_IMAGE_EXTRA_INSTALL += "\
        ${@bb.utils.contains('MACHINE_FEATURES', 'emmc-boot', 'e2fsprogs e2fsprogs-e2fsck e2fsprogs-mke2fs', '', d)} \
        ${MLIBPREFIX}glib-2.0 \
        ${MLIBPREFIX}i2c-tools \
        kernel-modules \
        ${@oe.utils.conditional('EVDEVMODULE', 'True', 'km-loader', '', d)} \
        ${MLIBPREFIX}net-tools \
        ${MLIBPREFIX}pps-tools \
        ${MLIBPREFIX}libgpiod ${MLIBPREFIX}libgpiod-tools \
        ${MLIBPREFIX}spitools \
        ${MLIBPREFIX}coreutils \
        ${MLIBPREFIX}android-tools \
        ${MLIBPREFIX}packagegroup-android-utils \
        ${MLIBPREFIX}packagegroup-qti-core \
        ${@bb.utils.contains('MACHINE_FEATURES', 'android-binder', '${MLIBPREFIX}binder', '', d)} \
        ${@bb.utils.contains('MACHINE_FEATURES', 'qti-data-modem', '${MLIBPREFIX}packagegroup-qti-data', '', d)} \
        ${@bb.utils.contains_any('COMBINED_FEATURES', 'qti-adsp qti-cdsp qti-modem qti-slpi', '${MLIBPREFIX}packagegroup-qti-dsp', '', d)} \
        ${@bb.utils.contains('MACHINE_FEATURES', 'qti-location', '${MLIBPREFIX}packagegroup-qti-location ${MLIBPREFIX}packagegroup-qti-location-auto', '', d)} \
        ${@bb.utils.contains('MACHINE_FEATURES', 'qti-bluetooth', '${MLIBPREFIX}packagegroup-qti-bt', '', d)} \
        ${@bb.utils.contains('MACHINE_FEATURES', 'qti-wlan', '${MLIBPREFIX}packagegroup-qti-wlan', '', d)} \
        ${@bb.utils.contains('COMBINED_FEATURES', 'qti-security', '${MLIBPREFIX}packagegroup-qti-securemsm', '', d)} \
        ${@bb.utils.contains('COMBINED_FEATURES', 'qti-audio', '${MLIBPREFIX}packagegroup-qti-audio', '', d)} \
        ${@bb.utils.contains('MACHINE_FEATURES', 'qti-cv2x', '${MLIBPREFIX}packagegroup-qti-telematics-cv2x', '', d)} \
        ${MLIBPREFIX}packagegroup-qti-ss-mgr \
        ${MLIBPREFIX}packagegroup-qti-telematics \
        ${@bb.utils.contains('DISTRO_FEATURES', 'qti-telux', '${MLIBPREFIX}packagegroup-qti-telsdk', '', d)} \
        ${@bb.utils.contains('DISTRO_FEATURES', 'selinux', '${MLIBPREFIX}packagegroup-selinux-minimal', '', d)} \
        ${MLIBPREFIX}packagegroup-startup-scripts \
        ${MLIBPREFIX}packagegroup-support-utils \
        ${MLIBPREFIX}subsystem-ramdump \
        ${MLIBPREFIX}systemd-machine-units \
        ${@bb.utils.contains('MACHINE_FEATURES', 'nand-boot', '${MLIBPREFIX}mtd-utils-ubifs', '', d)} \
        ${MLIBPREFIX}qmi-shutdown-modem \
        ${MLIBPREFIX}modem-shutdown \
        ${@bb.utils.contains('MACHINE_FEATURES', 'qti-virtualization', '${MLIBPREFIX}packagegroup-qti-virtualization', '', d)} \
        ${@oe.utils.conditional('DEBUG_BUILD', '1', '${MLIBPREFIX}packagegroup-qti-debug-tools', '', d )} \
        ${@bb.utils.contains('COMBINED_FEATURES', 'qti-nad-telaf', '${MLIBPREFIX}packagegroup-qti-telaf', '', d)} \
"

# Following packages will be enabled later
CORE_IMAGE_EXTRA_INSTALL_remove_sa525m = "\
       ${MLIBPREFIX}qmi-shutdown-modem ${MLIBPREFIX}modem-shutdown \
       ${MLIBPREFIX}packagegroup-qti-security-test \
"
