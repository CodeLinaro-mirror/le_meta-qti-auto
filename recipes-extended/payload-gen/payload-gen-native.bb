SUMMARY = "stream update payload bin file generation"
DESCRIPTION = "invoke script file to generate stream update payload bin file"

inherit native
PR = "r0"

DESCRIPTION = "generate stream update interface files"
LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta-qti-bsp/files/common-licenses/\
${LICENSE};md5=3771d4920bd6cdb8cbdf1e8344489ee0"

DEPENDS += "stream-update-native libsparse-native unzip-native aidl-native"

RDEPENDS_${PN} = "releasetools-native"
SRC_URI = "file://OTA/streaming/system/update_engine/scripts/brillo_update_payload \
            file://OTA/streaming/external/shflags/src/shflags \
            file://gen_full_stream.sh \
           "

S = "${WORKDIR}/payload"

PACKAGES += "${PN}-bin"
FILES_${PN}-bin += "${bindir}"

do_configure[depends] += "stream-update-native:do_compile"

do_configure() {
    echo "Running update engine interface files ${S}"
    cp -f ${WORKDIR}/gen_full_stream.sh ${S}
    chmod 755 ${S}/*
}
FILESPATH =+ "${WORKSPACE}:"
