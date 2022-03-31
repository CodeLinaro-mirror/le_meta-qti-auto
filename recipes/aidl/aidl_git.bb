inherit native autotools pkgconfig
PR = "r0"

DESCRIPTION = "aidl tool from Android"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"
DEPENDS += "bzip2-replacement-native libdivsufsort-native libmincrypt-native bison-native flex-native glib-2.0-native aidl-lib-native"
DEPENDS += "zlib-native libcutils-native liblog-native libbase-native libsparse-native"
FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://OTA/streaming/system/tools/aidl/src/"

AIDL_HEADERS="${TMPDIR}/work/x86_64-linux/aidl/git-r0/build"
S = "${WORKDIR}/OTA/streaming/system/tools/aidl/src/"

#EXTRA_OECONF = "--with-sanitized-headers=${STAGING_KERNEL_BUILDDIR}/usr/include \
#                --with-core-headers=${STAGING_INCDIR_NATIVE}"

EXTRA_OECONF = "--with-sanitized-headers=${STAGING_KERNEL_BUILDDIR}/usr/include \
                --with-core-headers=${STAGING_INCDIR_NATIVE} --with-aidl-headers=${AIDL_HEADERS}"

BBCLASSEXTEND = "native"

do_configure[depends] += "aidl-lib-native:do_compile"

do_configure_append() {
  cp ${TMPDIR}/work/x86_64-linux/aidl-lib-native/git-r0/build/aidl_language_y.hh ${S}
  cp ${TMPDIR}/work/x86_64-linux/aidl-lib-native/git-r0/build/location.hh ${S}
  cp ${TMPDIR}/work/x86_64-linux/aidl-lib-native/git-r0/build/position.hh ${S}
  cp ${TMPDIR}/work/x86_64-linux/aidl-lib-native/git-r0/build/libaidl_common.la ${S}
  cp -rf ${TMPDIR}/work/x86_64-linux/aidl-lib-native/git-r0/OTA/streaming/system/tools/aidl/main_cpp.cpp ${S}
  cp -rf ${TMPDIR}/work/x86_64-linux/aidl-lib-native/git-r0/OTA/streaming/system/tools/aidl/aidl_language.cpp ${S}
  cp -rf ${TMPDIR}/work/x86_64-linux/aidl-lib-native/git-r0/OTA/streaming/system/tools/aidl/aidl.cpp ${S}
  cp -rf ${TMPDIR}/work/x86_64-linux/aidl-lib-native/git-r0/OTA/streaming/system/tools/aidl/aidl_language_l.ll ${S}
  cp -rf ${TMPDIR}/work/x86_64-linux/aidl-lib-native/git-r0/OTA/streaming/system/tools/aidl/*.h ${S}
}

PACKAGES += "${PN}-bin"
FILES_${PN}-bin += "${bindir}"
