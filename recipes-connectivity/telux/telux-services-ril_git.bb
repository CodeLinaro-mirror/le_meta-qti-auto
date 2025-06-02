inherit pkgconfig cmake pythonnative

SUMMARY = "Telephony service for QTI's Modem"
DESCRIPTION = "Telephony service for QTI's Modem"

LICENSE = "Apache-2.0 & BSD-3-Clause-Clear"

LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

LIC_FILES_CHKSUM += "file://${COREBASE}/meta-qti-bsp/files/common-licenses/\
BSD-3-Clause-Clear;md5=48b43ba58d0f8e9ef3704313a46b7a43"

PACKAGE_ARCH ?= "${MACHINE_ARCH}"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://telux/services/ril/"
S = "${WORKDIR}/telux/services/ril"

EXTRA_OECMAKE += "${@bb.utils.contains('MACHINE_FEATURES', 'external-ap', '-DRIL_FOR_EXTERNAL_AP=ON', '', d)}"

DEPENDS += "glib-2.0 nanopb python-protobuf-native"
