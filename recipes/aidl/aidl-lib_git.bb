inherit native autotools pkgconfig
PR = "r0"

DESCRIPTION = "aidl tool from Android"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"
DEPENDS += "bzip2-replacement-native libdivsufsort-native libmincrypt-native bison-native flex-native glib-2.0-native"
DEPENDS += "zlib-native libcutils-native liblog-native libbase-native libsparse-native"
FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://OTA/streaming/system/tools/aidl/"

AIDL_HEADERS="${TMPDIR}/work/x86_64-linux/aidl-lib-native/git-r0/build"
S = "${WORKDIR}/OTA/streaming/system/tools/aidl/"

#EXTRA_OECONF = "--with-sanitized-headers=${STAGING_KERNEL_BUILDDIR}/usr/include \
#                --with-core-headers=${STAGING_INCDIR_NATIVE}"

EXTRA_OECONF = "--with-sanitized-headers=${STAGING_KERNEL_BUILDDIR}/usr/include \
                --with-core-headers=${STAGING_INCDIR_NATIVE} --with-aidl-headers=${AIDL_HEADERS}"

BBCLASSEXTEND = "native"

FILES_${PN}-dbg    = "${libdir}/.debug/libaidl_common.*"
FILES_${PN}        = "${libdir}/libaidl_common.so.* ${libdir}/pkgconfig/*"
FILES_${PN}-dev    = "${libdir}/libaidl_common.so ${libdir}/libaidl_common.la ${includedir}"

