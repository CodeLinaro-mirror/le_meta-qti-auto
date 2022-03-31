SUMMARY = "idl tool to generate source file from aidl interface file"
inherit native autotools pkgconfig
PR = "r0"

DESCRIPTION = "\
.aidl files are introduced by android for IPC between two process.\
This tool enables aidl bin which generates interface files from .aidl,\
 compiler doesnt understand .aidl file. This is tool is enabled as part of \
enabling stream update feature on LE. Stream update is android solution for update \
and it uses .aidl files for IPC"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"
DEPENDS += "bzip2-replacement-native libdivsufsort-native libmincrypt-native bison-native flex-native glib-2.0-native \
             zlib-native libcutils-native liblog-native libbase-native libsparse-native aidl-lib-native"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://OTA/streaming/system/tools/aidl/src/"

S = "${WORKDIR}/OTA/streaming/system/tools/aidl/src/"


BBCLASSEXTEND = "native"

do_configure[depends] += "aidl-lib-native:do_compile"

do_configure_append() {
  cp ${TMPDIR}/work/x86_64-linux/aidl-lib-native/git-r0/build/location.hh ${S}
  cp ${TMPDIR}/work/x86_64-linux/aidl-lib-native/git-r0/build/position.hh ${S}
  cp ${RECIPE_SYSROOT}-native/usr/include/aidl_language_l.ll ${S}
}

PACKAGES += "${PN}-bin"
FILES_${PN}-bin += "${bindir}"
