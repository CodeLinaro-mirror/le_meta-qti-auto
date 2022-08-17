inherit autotools pkgconfig

PR = "r0"

DESCRIPTION = "libbrillo from Android"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"

DEPENDS += "bzip2-replacement-native libdivsufsort-native curl openssl libmodpb64 liblog libchrome binderstreaming boringssl telaf-flash-access"
DEPENDS += " ${@bb.utils.contains('DISTRO_FEATURES', '', 'libcutils curl data', '', d)}"
PACKAGECONFIG[curl] = "--enable-curl,--disable-curl,curl"
PACKAGECONFIG[ssl-curl] = "--enable-ssl-curl,--disable-ssl-curl,curl,openssl"
PACKAGECONFIG[openssl] = "--enable-openssl,--disable-openssl,openssl"

inherit ${@bb.utils.contains('PACKAGECONFIG', 'python', 'python3native', '', d)}

RDEPENDS_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'nand-ab', '', '', d)}"
RDEPENDS_${PN}-python += "${@bb.utils.contains('PACKAGECONFIG', 'python', 'python3-core', '', d)}"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://OTA/streaming/external/libbrillo/"

S = "${WORKDIR}/OTA/streaming/external/libbrillo/"


BBCLASSEXTEND = "native"

EXTRA_OECONF += " --with-core-includes=${WORKSPACE}/system/core/include"
EXTRA_OECONF += " --with-host-os=${HOST_OS}"
EXTRA_OECONF += " --disable-static"
EXTRA_OECONF += " ${@bb.utils.contains('DISTRO_FEATURES', 'nand-boot', '--with-nand_boot=true', '', d)}"

EXTRA_OECONF_append_msm = " --enable-leproperties"
EXTRA_OECONF_append_msm = " LE_PROPERTIES_ENABLED=true"

FILES_${PN}  = "${sysconfdir}"
FILES_${PN} += "/system"
FILES_${PN} += "/lib"

FILES_${PN}-dbg    = "${libdir}/.debug/libbrillo.*"
FILES_${PN}        = "${libdir}/libbrillo.so.* ${libdir}/pkgconfig/*"
FILES_${PN}-dev    = "${libdir}/libbrillo.so ${libdir}/libbrillo.la ${includedir}"

CPPFLAGS += "-I${STAGING_INCDIR}/libselinux"
CPPFLAGS += "-I${STAGING_INCDIR}/cutils"

do_stage () {
    install -m 0644 brillo/flag_helper.h ${STAGING_INCDIR}/
    oe_libinstall -a -so libbrillo ${STAGING_LIBDIR}
}
