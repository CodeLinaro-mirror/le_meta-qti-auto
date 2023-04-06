inherit cmake

DESCRIPTION = "UDPReplay Software"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=0835ade698e0bcf8506ecda2f7b4f302"

PACKAGE_ARCH ?= "${MACHINE_ARCH}"

DEPENDS = "libpcap"

TARGET_CFLAGS += "-Wno-format-security"

SRCREV = "43ff11641959507b84d967b0c23455084c3da692"

SRC_URI = "${CLO_LE_GIT}/external/rigtorp/udpreplay.git;protocol=https;branch=caf_migration/udpreplay/master"
SRC_URI += "file://udpreplay_ipv4_dest_1.patch"
SRC_URI += "file://udpreplay_ipv6_dest_2.patch"
SRC_URI += "file://udpreplay_dest_port_3.patch"
SRC_URI += "file://udpreplay_nanosecond_interval_4.patch"
SRC_URI += "file://udpreplay_burst_and_srcport_5.patch"

S = "${WORKDIR}/git"

SOLIBS = ".so*"
FILES_SOLIBSDEV = ""
