inherit autotools pkgconfig

PR = "r0"

DESCRIPTION = "libxz from Android"
LICENSE = "PD"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
PD;md5=b3597d12946881e13cb3b548d1173851"

DEPENDS += "bzip2-replacement-native libdivsufsort-native curl openssl libmodpb64 liblog"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://OTA/streaming/external/xz-embedded/"

S = "${WORKDIR}/OTA/streaming/external/xz-embedded/"

BBCLASSEXTEND = "native"
