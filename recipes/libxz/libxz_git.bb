inherit autotools pkgconfig

PR = "r0"

DESCRIPTION = "libxz from Android"
LICENSE = "PD"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
PD;md5=b3597d12946881e13cb3b548d1173851"

DEPENDS += "bzip2-replacement-native libdivsufsort-native curl openssl libmodpb64 liblog"
DEPENDS += " ${@bb.utils.contains('DISTRO_FEATURES', '', 'libcutils curl data', '', d)}"
PACKAGECONFIG[curl] = "--enable-curl,--disable-curl,curl"
PACKAGECONFIG[ssl-curl] = "--enable-ssl-curl,--disable-ssl-curl,curl,openssl"
PACKAGECONFIG[openssl] = "--enable-openssl,--disable-openssl,openssl"

inherit ${@bb.utils.contains('PACKAGECONFIG', 'python', 'python3native', '', d)}

RDEPENDS_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'nand-ab', '', '', d)}"
RDEPENDS_${PN}-python += "${@bb.utils.contains('PACKAGECONFIG', 'python', 'python3-core', '', d)}"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://OTA/streaming/external/xz-embedded/"

S = "${WORKDIR}/OTA/streaming/external/xz-embedded/"


BBCLASSEXTEND = "native"

EXTRA_OECONF += " --with-core-includes=${WORKSPACE}/system/core/include"
EXTRA_OECONF += " --with-host-os=${HOST_OS}"
EXTRA_OECONF += " --disable-static"

EXTRA_OECONF_append_msm = " --enable-leproperties"
EXTRA_OECONF_append_msm = " LE_PROPERTIES_ENABLED=true"

FILES_${PN}  = "${sysconfdir}"
FILES_${PN} += "/system"
FILES_${PN} += "/lib"

FILES_${PN}-dbg    = "${libdir}/.debug/libxz.*"
FILES_${PN}        = "${libdir}/libxz.so.* ${libdir}/pkgconfig/*"
FILES_${PN}-dev    = "${libdir}/libxz.so ${libdir}/libxz.la ${includedir}"


