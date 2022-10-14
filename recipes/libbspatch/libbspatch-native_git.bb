inherit native autotools pkgconfig

PR = "r0"

DESCRIPTION = "bsdiff from Android"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
BSD;md5=3775480a712fc46a69647678acb234cb"

DEPENDS += "bzip2-native curl openssl libmodpb64 liblog libdivsufsort"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://OTA/streaming/external/bsdiff/"

S = "${WORKDIR}/OTA/streaming/external/bsdiff/"

BBCLASSEXTEND = "native"
