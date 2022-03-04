inherit autotools pkgconfig

PR = "r0"

DESCRIPTION = "libbssl from Android"
LICENSE = "OpenSSL"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
OpenSSL;md5=4eb1764f3e65fafa1a25057f9082f2ae"

DEPENDS += "bzip2-replacement-native libdivsufsort-native curl"
DEPENDS += " ${@bb.utils.contains('DISTRO_FEATURES', '', 'libcutils curl data', '', d)}"
PACKAGECONFIG[curl] = "--enable-curl,--disable-curl,curl"
PACKAGECONFIG[ssl-curl] = "--enable-ssl-curl,--disable-ssl-curl,curl"

inherit ${@bb.utils.contains('PACKAGECONFIG', 'python', 'python3native', '', d)}

RDEPENDS_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'nand-ab', '', '', d)}"
RDEPENDS_${PN}-python += "${@bb.utils.contains('PACKAGECONFIG', 'python', 'python3-core', '', d)}"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://OTA/streaming/external/boringssl/"

S = "${WORKDIR}/OTA/streaming/external/boringssl/"


BBCLASSEXTEND = "native"

EXTRA_OECONF += " --with-core-includes=${WORKSPACE}/system/core/include"
EXTRA_OECONF += " --with-host-os=${HOST_OS}"
EXTRA_OECONF += " --disable-static"

EXTRA_OECONF_append_msm = " --enable-leproperties"
EXTRA_OECONF_append_msm = " LE_PROPERTIES_ENABLED=true"

FILES_${PN}  = "${sysconfdir}"
FILES_${PN} += "/system"
FILES_${PN} += "/lib"

FILES_${PN}-dbg    = "${libdir}/.debug/libbssl.*"
FILES_${PN}        = "${libdir}/libbssl.so.* ${libdir}/pkgconfig/*"
FILES_${PN}-dev    = "${libdir}/libbssl.so ${libdir}/libbssl.la ${includedir}"


