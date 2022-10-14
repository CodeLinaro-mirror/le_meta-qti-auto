inherit native autotools pkgconfig

PR = "r0"

DESCRIPTION = "libmodp64 from Android"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"

DEPENDS += "bzip2-replacement-native libdivsufsort-native curl-native"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://OTA/streaming/external/modp_b64/"

S = "${WORKDIR}/OTA/streaming/external/modp_b64/"

BBCLASSEXTEND = "native"





