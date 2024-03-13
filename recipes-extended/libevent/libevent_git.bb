SUMMARY = "library event from android required for stream update"
DESCRIPTION = "${SUMMARY}"

LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
BSD;md5=3775480a712fc46a69647678acb234cb"

DEPENDS += "libcutils"

PR = "r0"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://OTA/streaming/external/libevent/"

S = "${WORKDIR}/OTA/streaming/external/libevent/"

BBCLASSEXTEND = "native"

inherit autotools pkgconfig
