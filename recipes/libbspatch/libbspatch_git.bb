inherit autotools pkgconfig

PR = "r0"

DESCRIPTION = "bsdiff from Android"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
BSD;md5=3775480a712fc46a69647678acb234cb"

DEPENDS += "bzip2-replacement-native curl openssl libmodpb64 liblog libdivsufsort"
DEPENDS += " ${@bb.utils.contains('DISTRO_FEATURES', '', 'libcutils curl data', '', d)}"
PACKAGECONFIG[curl] = "--enable-curl,--disable-curl,curl"
PACKAGECONFIG[ssl-curl] = "--enable-ssl-curl,--disable-ssl-curl,curl,openssl"
PACKAGECONFIG[openssl] = "--enable-openssl,--disable-openssl,openssl"

inherit ${@bb.utils.contains('PACKAGECONFIG', 'python', 'python3native', '', d)}

RDEPENDS_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'nand-ab', '', '', d)}"
RDEPENDS_${PN}-python += "${@bb.utils.contains('PACKAGECONFIG', 'python', 'python3-core', '', d)}"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://OTA/streaming/external/bsdiff/"

S = "${WORKDIR}/OTA/streaming/external/bsdiff/"

BBCLASSEXTEND = "native"

EXTRA_OECONF += " --with-core-includes=${WORKSPACE}/system/core/include"
EXTRA_OECONF += " --with-host-os=${HOST_OS}"
EXTRA_OECONF += " --disable-static"

EXTRA_OECONF_append_msm = " --enable-leproperties"
EXTRA_OECONF_append_msm = " LE_PROPERTIES_ENABLED=true"

FILES_${PN}  = "${sysconfdir}"
FILES_${PN} += "/system"
FILES_${PN} += "/lib"

FILES_${PN}-dbg    = "${libdir}/.debug/libbspatch.*"
FILES_${PN}        = "${libdir}/libbspatch.so.* ${libdir}/pkgconfig/*"
FILES_${PN}-dev    = "${libdir}/libbspatch.so ${libdir}/libbspatch.la ${includedir}"


