SUMMARY = "QTI package groups for Telematics modules"
DESCRIPTION = "Package group to bring in all basic packages for LE Telematics system"
LICENSE = "BSD-3-Clause"

inherit packagegroup

OPENAVB ?= "False"
OPENAVB_sa415m = "True"
OPENAVB_sa410m = "True"
OPENAVB_sa515m = "True"
OPENAVB_sa525m = "True"

PROVIDES = "${PACKAGES}"
PACKAGES = ' \
    packagegroup-qti-telematics \
    packagegroup-qti-telematics-utils \
    packagegroup-qti-telematics-vnw \
    ${@bb.utils.contains_any('MACHINE_FEATURES', [ 'qti-cv2x', 'qti-wwan-plus-cv2x' ], 'packagegroup-qti-telematics-cv2x', '', d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'qti-sensors', 'packagegroup-qti-telematics-sensors', '', d)} \
    '

RDEPENDS_packagegroup-qti-telematics = "\
    packagegroup-qti-telematics-utils \
    packagegroup-qti-telematics-vnw \
    ${@bb.utils.contains_any('MACHINE_FEATURES', [ 'qti-cv2x', 'qti-wwan-plus-cv2x' ], 'packagegroup-qti-telematics-cv2x', '', d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'qti-sensors', 'packagegroup-qti-telematics-sensors', '', d)} \
    ${@bb.utils.contains('COMBINED_FEATURES', 'qti-mvm', 'packagegroup-qti-telematics-mvm', '', d)} \
    ${@bb.utils.contains('COMBINED_FEATURES', 'vbleima', 'keyutils ima-evm-utils attr ima-cert-setup', '',d)} \
    "

RDEPENDS_packagegroup-qti-telematics-cv2x = "\
    ${@bb.utils.contains_any('MACHINE_FEATURES', ['external-ap', 'qti-external-ap'], 'aerolink-configurations', '', d)} \
    "

RDEPENDS_packagegroup-qti-telematics-sensors = "\
    ${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-guest', '', 'sensor-util-lib sensor-util-testapp', d)}\
    libsensors sensor-hal-daemon sensor-hal-daemon-hdr sensor-socket sensor-client-api sensor-client-api-testapp sensors-test"

RDEPENDS_packagegroup-qti-telematics-utils = " udpreplay"

RDEPENDS_packagegroup-qti-telematics-vnw = "\
    ${@oe.utils.conditional('OPENAVB', 'True', 'open-avb', '', d)} \
    start-scripts-init-can can-utils \
    ${@bb.utils.contains('MACHINE', 'sa515m', 'vnw-eth-switch', '', d)} \
    "

RDEPENDS_packagegroup-qti-telematics-mvm = "\
    mvm-dlkm \
    "
