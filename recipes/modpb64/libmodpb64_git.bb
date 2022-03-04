inherit autotools pkgconfig

PR = "r0"

DESCRIPTION = "libmodp64 from Android"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"

DEPENDS += "bzip2-replacement-native libdivsufsort-native curl"
DEPENDS += " ${@bb.utils.contains('DISTRO_FEATURES', '', 'libcutils curl data', '', d)}"
PACKAGECONFIG[curl] = "--enable-curl,--disable-curl,curl"
PACKAGECONFIG[ssl-curl] = "--enable-ssl-curl,--disable-ssl-curl,curl"
PACKAGECONFIG[openssl] = "--enable-openssl,--disable-openssl,openssl"

inherit ${@bb.utils.contains('PACKAGECONFIG', 'python', 'python3native', '', d)}

RDEPENDS_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'nand-ab', '', '', d)}"
RDEPENDS_${PN}-python += "${@bb.utils.contains('PACKAGECONFIG', 'python', 'python3-core', '', d)}"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://OTA/streaming/external/modp_b64/"

S = "${WORKDIR}/OTA/streaming/external/modp_b64/"


BBCLASSEXTEND = "native"





