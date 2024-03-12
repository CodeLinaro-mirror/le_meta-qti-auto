SUMMARY = "QTI package groups for Telematics modules"
DESCRIPTION = "Package group to bring in all basic packages for LE Telematics system"
LICENSE = "BSD-3-Clause"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

OPENAVB ?= "False"
OPENAVB:sa415m = "True"
OPENAVB:sa410m = "${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-guest', 'False', 'True',d)}"
OPENAVB:sa515m = "True"
#OPENAVB:sa525m = "${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-fota', 'False', 'True',d)}"
PTPVIRT ?=  "False"
PTPVIRT:sa525m = "${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-fota', 'False', 'True',d)}"
#OPENAVB:sa525m = "${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-guest', 'False', 'True',d)}"

# Define whether to install packagegroup-qti-telematics-cv2x-its, for ITS stacks and related packages
# Normally this is enabled for external APs only, but can also be enabled for specific targets, like sa525m
CV2X_ITS ?= "${@bb.utils.contains_any('MACHINE_FEATURES', ['external-ap', 'qti-external-ap'], "True", "False", d)}"
CV2X_ITS:sa525m = "${@bb.utils.contains_any('MACHINE_FEATURES', [ 'qti-cv2x', 'qti-wwan-plus-cv2x' ], 'True', 'False',d)}"

PROVIDES = "${PACKAGES}"
PACKAGES = ' \
    packagegroup-qti-telematics \
    packagegroup-qti-telematics-utils \
    packagegroup-qti-telematics-vnw \
    ${@bb.utils.contains_any('MACHINE_FEATURES', [ 'qti-cv2x', 'qti-wwan-plus-cv2x' ], 'packagegroup-qti-telematics-cv2x', '', d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'qti-sensors', 'packagegroup-qti-telematics-sensors', '', d)} \
    ${@oe.utils.conditional('CV2X_ITS', 'True', 'packagegroup-qti-telematics-cv2x-its', '', d)} \
    '

RDEPENDS:packagegroup-qti-telematics = "\
    ${MLPREFIX}packagegroup-qti-telematics-utils \
    ${MLPREFIX}packagegroup-qti-telematics-vnw \
    ${@bb.utils.contains_any('MACHINE_FEATURES', [ 'qti-cv2x', 'qti-wwan-plus-cv2x' ], '${MLPREFIX}packagegroup-qti-telematics-cv2x', '', d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'qti-sensors', '${MLPREFIX}packagegroup-qti-telematics-sensors', '', d)} \
    ${@bb.utils.contains('COMBINED_FEATURES', 'qti-mvm', '${MLPREFIX}packagegroup-qti-telematics-mvm', '', d)} \
    ${@bb.utils.contains('COMBINED_FEATURES', 'vbleima', 'keyutils ima-evm-utils attr ima-cert-setup', '',d)} \
    "

RDEPENDS:packagegroup-qti-telematics-cv2x = "\
    ${@oe.utils.conditional('CV2X_ITS', 'True', '${MLPREFIX}packagegroup-qti-telematics-cv2x-its', '', d)} \
    "

RDEPENDS:packagegroup-qti-telematics-cv2x-its = "\
    aerolink-configurations \
    "

RDEPENDS:packagegroup-qti-telematics-sensors = "\
    ${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-guest', '', 'sensor-util-lib sensor-util-testapp', d)}\
    libsensors sensor-hal-daemon sensor-socket sensor-client-api sensor-client-api-testapp sensors-test"

RDEPENDS:packagegroup-qti-telematics-utils = "\
    ${@oe.utils.conditional('CV2X_ITS', 'True', 'udpreplay', '', d)} \
    "

RDEPENDS:packagegroup-qti-telematics-vnw = "\
    ${@oe.utils.conditional('OPENAVB', 'True', 'open-avb', '', d)} \
    ${@oe.utils.conditional('PTPVIRT', 'True', 'ptp-virtual', '', d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-guest', '', 'start-scripts-init-can can-utils', d)} \
    ${@bb.utils.contains('MACHINE', 'sa515m', 'vnw-eth-switch', '', d)} \
    "

RDEPENDS:packagegroup-qti-telematics-mvm = "\
    mvm-dlkm \
    "
