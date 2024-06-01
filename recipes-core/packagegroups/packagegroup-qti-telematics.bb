SUMMARY = "QTI package groups for Telematics modules"
DESCRIPTION = "Package group to bring in all basic packages for LE Telematics system"
LICENSE = "BSD-3-Clause"

inherit packagegroup

OPENAVB ?= "False"
OPENAVB_sa415m = "True"
OPENAVB_sa410m = "${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-guest', 'False', 'True',d)}"
OPENAVB_sa515m = "True"
OPENAVB_sa525m = "${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-guest', 'False', 'True',d)}"

SENSORIDL ?= "False"
SENSORIDL_sa525m = "True"

# Define whether to install packagegroup-qti-telematics-cv2x-its, for ITS stacks and related packages
# Normally this is enabled for external APs only, but can also be enabled for specific targets, like sa525m
CV2X_ITS ?= "${@bb.utils.contains_any('MACHINE_FEATURES', ['external-ap', 'qti-external-ap'], "True", "False", d)}"
CV2X_ITS_sa525m = "${@bb.utils.contains_any('MACHINE_FEATURES', [ 'qti-cv2x', 'qti-wwan-plus-cv2x' ], 'True', 'False',d)}"

PROVIDES = "${PACKAGES}"
PACKAGES = ' \
    packagegroup-qti-telematics \
    packagegroup-qti-telematics-utils \
    packagegroup-qti-telematics-vnw \
    ${@bb.utils.contains_any('MACHINE_FEATURES', [ 'qti-cv2x', 'qti-wwan-plus-cv2x' ], 'packagegroup-qti-telematics-cv2x', '', d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'qti-sensors', 'packagegroup-qti-telematics-sensors', '', d)} \
    ${@oe.utils.conditional('CV2X_ITS', 'True', 'packagegroup-qti-telematics-cv2x-its', '', d)} \
    '

RDEPENDS_packagegroup-qti-telematics = "\
    ${MLPREFIX}packagegroup-qti-telematics-utils \
    ${MLPREFIX}packagegroup-qti-telematics-vnw \
    ${@bb.utils.contains_any('MACHINE_FEATURES', [ 'qti-cv2x', 'qti-wwan-plus-cv2x' ], '${MLPREFIX}packagegroup-qti-telematics-cv2x', '', d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'qti-sensors', '${MLPREFIX}packagegroup-qti-telematics-sensors', '', d)} \
    ${@bb.utils.contains('COMBINED_FEATURES', 'qti-mvm', '${MLPREFIX}packagegroup-qti-telematics-mvm', '', d)} \
    ${@bb.utils.contains('COMBINED_FEATURES', 'vbleima', 'keyutils ima-evm-utils attr ima-cert-setup', '',d)} \
    "

RDEPENDS_packagegroup-qti-telematics-cv2x = "\
    ${@oe.utils.conditional('CV2X_ITS', 'True', '${MLPREFIX}packagegroup-qti-telematics-cv2x-its', '', d)} \
    "

RDEPENDS_packagegroup-qti-telematics-cv2x-its = "\
    aerolink-configurations \
    "

RDEPENDS_packagegroup-qti-telematics-sensors = "\
    ${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-guest', '', 'sensor-util-lib sensor-util-testapp', d)}\
    libsensors sensor-hal-daemon sensor-socket sensor-client-api sensor-client-api-testapp sensor-testapp-legacy \
    ${@oe.utils.conditional('SENSORIDL', 'True', 'sensor-idl-client', '', d)} \
    "

RDEPENDS_packagegroup-qti-telematics-utils = "\
    ${@oe.utils.conditional('CV2X_ITS', 'True', 'udpreplay', '', d)} \
    "

RDEPENDS_packagegroup-qti-telematics-vnw = "\
    ${@oe.utils.conditional('OPENAVB', 'True', 'open-avb', '', d)} \
    ${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-guest', '', 'start-scripts-init-can can-utils', d)} \
    ${@bb.utils.contains('MACHINE', 'sa515m', 'vnw-eth-switch', '', d)} \
    "

RDEPENDS_packagegroup-qti-telematics-mvm = "\
    mvm-dlkm \
    "
