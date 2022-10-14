inherit native autotools pkgconfig useradd

DESCRIPTION = "Android Binder support"
HOMEPAGE = "http://developer.android.com/"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"

PR = "r0"

DEPENDS = "libcutils-native libselinux-native system-core-native glib-2.0-native libutils-native"

FILESPATH =+ "${WORKSPACE}/OTA/streaming/frameworks/:"

SRC_URI  = "file://native"

S = "${WORKDIR}/native"

BBCLASSEXTEND = "native"

EXTRA_OECONF = "--with-glib"

do_configure_append() {
    cp -rf ${WORKDIR}/recipe-sysroot/usr/include/linux/ ${WORKDIR}/recipe-sysroot-native/usr/include/
}
