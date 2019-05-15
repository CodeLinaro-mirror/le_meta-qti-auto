inherit pkgconfig cmake pythonnative

SUMMARY = "Telephony service for QTI's Modem"
DESCRIPTION = "Telephony service for QTI's Modem"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

PACKAGE_ARCH ?= "${MACHINE_ARCH}"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://telux/services/ril/"
S = "${WORKDIR}/telux/services/ril"

EXTRA_OECMAKE += "${@bb.utils.contains('MACHINE_FEATURES', 'external-ap', '-DRIL_FOR_EXTERNAL_AP=ON', '', d)}"

DEPENDS += "glib-2.0 nanopb python-protobuf-native"
