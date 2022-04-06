inherit native autotools-brokensep pkgconfig

PR = "r0"

DESCRIPTION = "AB Stream updater "
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"

DEPENDS += "bzip2-replacement-native libdivsufsort-native libmincrypt-native bison-native flex-native glib-2.0-native"
DEPENDS += "zlib-native libcutils-native liblog-native libbase-native libsparse-native e2fsprogs curl-native libxz-native libbrillo-native libevent-native libalzma-native libbspatch-native binderstreaming-native libchrome-native libutils-native \
protobuf protobuf-native \
aidl-native aidl-lib-native"

RDEPENDS_${PN} = "zlib"
RDEPENDS_${PN}-bin = "recovery-lib"
SRC_URI = "file://OTA/streaming/system/update_engine/"
SRC_URI =+ "file://stream-update.service"
SRC_URI =+ "file://stream-update.rules"
S = "${WORKDIR}/OTA/streaming/system/update_engine/"

EXTRA_OECONF = "--with-glib"

DEPENDS += "qemu-native"

do_configure[depends] += "stream-update:do_compile"
BBCLASSEXTEND = "native"

PACKAGES += "${PN}-bin"
FILES_${PN}-bin += "${bindir}"

do_compile_prepend () {
   echo "Running interface generation"
   ${S}/update_metadata_proto.sh
   ${S}/update_aidl_interface.sh
}

FILESPATH =+ "${WORKSPACE}:"
