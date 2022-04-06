inherit autotools pkgconfig

PR = "r0"

DESCRIPTION = "libchrome from Android"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"

DEPENDS += "bzip2-replacement-native libdivsufsort-native curl libevent liblog"
DEPENDS += " ${@bb.utils.contains('DISTRO_FEATURES', '', 'libcutils curl', '', d)}"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://OTA/streaming/external/libchrome/"

S = "${WORKDIR}/OTA/streaming/external/libchrome/"

BBCLASSEXTEND = "native"
