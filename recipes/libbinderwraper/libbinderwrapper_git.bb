inherit autotools pkgconfig

PR = "r0"

DESCRIPTION = "libbinderwrapper from Android"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

DEPENDS += "bzip2-replacement-native libdivsufsort-native curl openssl libmodpb64 liblog libbrillo libchrome binderstreaming"
DEPENDS += " ${@bb.utils.contains('DISTRO_FEATURES', '', 'libcutils curl data', '', d)}"
PACKAGECONFIG[curl] = "--enable-curl,--disable-curl,curl"
PACKAGECONFIG[ssl-curl] = "--enable-ssl-curl,--disable-ssl-curl,curl,openssl"
PACKAGECONFIG[openssl] = "--enable-openssl,--disable-openssl,openssl"

inherit ${@bb.utils.contains('PACKAGECONFIG', 'python', 'python3native', '', d)}

RDEPENDS_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'nand-ab', '', '', d)}"
RDEPENDS_${PN}-python += "${@bb.utils.contains('PACKAGECONFIG', 'python', 'python3-core', '', d)}"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://OTA/system/core/libbinderwrapper/"

S = "${WORKDIR}/OTA/system/core/libbinderwrapper/"


BBCLASSEXTEND = "native"

EXTRA_OECONF += " --with-core-includes=${WORKSPACE}/system/core/include"
EXTRA_OECONF += " --with-host-os=${HOST_OS}"
EXTRA_OECONF += " --disable-static"

EXTRA_OECONF_append_msm = " --enable-leproperties"
EXTRA_OECONF_append_msm = " LE_PROPERTIES_ENABLED=true"

FILES_${PN}  = "${sysconfdir}"
FILES_${PN} += "/system"
FILES_${PN} += "/lib"

FILES_${PN}-dbg    = "${libdir}/.debug/libbinderwrapper.*"
FILES_${PN}        = "${libdir}/libbinderwrapper.so.* ${libdir}/pkgconfig/*"
FILES_${PN}-dev    = "${libdir}/libbinderwrapper.so ${libdir}/libbinderwrapper.la ${includedir}"

CPPFLAGS += "-I${STAGING_INCDIR}/libselinux"
CPPFLAGS += "-I${STAGING_INCDIR}/cutils"

do_stage () {
    oe_libinstall -a -so libbinderwrapper ${STAGING_LIBDIR}
}
