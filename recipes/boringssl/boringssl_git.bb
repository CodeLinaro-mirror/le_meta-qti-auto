inherit autotools pkgconfig

PR = "r0"

DESCRIPTION = "libbssl from Android"
LICENSE = "OpenSSL"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
OpenSSL;md5=4eb1764f3e65fafa1a25057f9082f2ae"

DEPENDS += "bzip2-replacement-native libdivsufsort-native curl"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://OTA/streaming/external/boringssl/"

S = "${WORKDIR}/OTA/streaming/external/boringssl/"


BBCLASSEXTEND = "native"
