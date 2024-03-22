SUMMARY = "library bspatch from android required for stream update"
DESCRIPTION = "${SUMMARY}"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
BSD;md5=3775480a712fc46a69647678acb234cb"

DEPENDS += "bzip2-replacement-native curl openssl libmodpb64 liblog libdivsufsort-native libcutils bzip2"

PR = "r0"
FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://OTA/streaming/external/bsdiff/"

S = "${WORKDIR}/OTA/streaming/external/bsdiff/"

BBCLASSEXTEND = "native"

inherit autotools pkgconfig
