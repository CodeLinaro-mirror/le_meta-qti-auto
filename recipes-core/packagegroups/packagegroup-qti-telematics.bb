SUMMARY = "QTI package groups for Telematics modules"
DESCRIPTION = "Package group to bring in all basic packages for LE Telematics system"
LICENSE = "BSD-3-Clause"

inherit packagegroup

PROVIDES = "${PACKAGES}"
PACKAGES = ' \
    packagegroup-qti-telematics \
    packagegroup-qti-telematics-utils \
    packagegroup-qti-telematics-vnw \
    ${@bb.utils.contains('MACHINE_FEATURES', 'qti-cv2x', 'packagegroup-qti-telematics-cv2x', '', d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'qti-sensors', 'packagegroup-qti-telematics-sensors', '', d)} \
    '

RDEPENDS_packagegroup-qti-telematics = "\
    packagegroup-qti-telematics-utils \
    packagegroup-qti-telematics-vnw \
    ${@bb.utils.contains('MACHINE_FEATURES', 'qti-cv2x', 'packagegroup-qti-telematics-cv2x', '', d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'qti-sensors', 'packagegroup-qti-telematics-sensors', '', d)} \
    "

RDEPENDS_packagegroup-qti-telematics-cv2x = "\
    aerolink-configurations \
    "

RDEPENDS_packagegroup-qti-telematics-sensors = " libsensors sensor-hal-daemon sensor-hal-daemon-hdr sensor-socket sensor-client-api sensor-client-api-testapp "

RDEPENDS_packagegroup-qti-telematics-utils = " udpreplay"

RDEPENDS_packagegroup-qti-telematics-vnw = "\
    open-avb \
    start-scripts-init-can can-utils \
    "
