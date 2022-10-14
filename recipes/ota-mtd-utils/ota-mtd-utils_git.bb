inherit autotools pkgconfig

PR = "r0"

DESCRIPTION = "OTA mtdutils from Android"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

DEPENDS += "bzip2-replacement-native libdivsufsort-native curl openssl libmodpb64 liblog libchrome binderstreaming boringssl"
DEPENDS += " ${@bb.utils.contains('DISTRO_FEATURES', '', 'libcutils curl data', '', d)}"
PACKAGECONFIG[curl] = "--enable-curl,--disable-curl,curl"
PACKAGECONFIG[ssl-curl] = "--enable-ssl-curl,--disable-ssl-curl,curl,openssl"
PACKAGECONFIG[openssl] = "--enable-openssl,--disable-openssl,openssl"

inherit ${@bb.utils.contains('PACKAGECONFIG', 'python', 'python3native', '', d)}

RDEPENDS_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'nand-ab', '', '', d)}"
RDEPENDS_${PN}-python += "${@bb.utils.contains('PACKAGECONFIG', 'python', 'python3-core', '', d)}"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://OTA/recovery/mtdutils/"

S = "${WORKDIR}/OTA/recovery/mtdutils/"


BBCLASSEXTEND = "native"

EXTRA_OECONF += " ${@bb.utils.contains('DISTRO_FEATURES', 'nad-prod', '--with-nad_prod=true', '', d)}"
EXTRA_OECONF += "--with-glib --with-core-includes=${WORKSPACE}/system/core/include"
EXTRA_OECONF += " --with-host-os=${HOST_OS}"
EXTRA_OECONF += " --disable-static"

EXTRA_OECONF_append_msm = " --enable-leproperties"
EXTRA_OECONF_append_msm = " LE_PROPERTIES_ENABLED=true"

FILES_${PN}  = "${sysconfdir}"
FILES_${PN} += "/system"
FILES_${PN} += "/lib"

FILES_${PN}-dbg    = "${libdir}/.debug/libotamtdutils.*"
FILES_${PN}        = "${libdir}/libotamtdutils.so.* ${libdir}/pkgconfig/*"
FILES_${PN}-dev    = "${libdir}/libotamtdutils.so ${libdir}/libotamtdutils.la ${includedir}"

CPPFLAGS += "-I${STAGING_INCDIR}/libselinux"
CPPFLAGS += "-I${STAGING_INCDIR}/cutils"

do_stage () {
    install -m 0644 ${STAGING_INCDIR}/
    oe_libinstall -a -so libotamtdutils ${STAGING_LIBDIR}
}
