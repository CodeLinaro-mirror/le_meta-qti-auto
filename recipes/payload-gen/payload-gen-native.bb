inherit native
PR = "r0"

DESCRIPTION = "generate stream update interface files"
LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta-qti-bsp/files/common-licenses/\
${LICENSE};md5=48b43ba58d0f8e9ef3704313a46b7a43"

DEPENDS += "stream-update-native libsparse-native unzip-native"

RDEPENDS_${PN} = "releasetools-native"
FILESPATH = "${WORKSPACE}/poky/meta-qti-auto/recipes/payload-gen/:"
SRC_URI += "file://gen_full_stream.sh"

S = "${WORKDIR}/payload"

PACKAGES += "${PN}-bin"
FILES_${PN}-bin += "${bindir}"

do_configure[depends] += "stream-update-native:do_compile"

do_configure() {
    echo "Running update engine interface files ${S}"
    cp ${WORKDIR}/gen_full_stream.sh ${S}
    chmod 755 ${S}/*
}
