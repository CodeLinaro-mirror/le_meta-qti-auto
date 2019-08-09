inherit qcommon
DESCRIPTION = "Provide native media hardware Headers"
LICENSE = "BSD-3-Clause & Apache-2.0 & MIT"
LIC_FILES_CHKSUM = " \
    file://${COREBASE}/meta/files/common-licenses/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9 \
    file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10 \
    file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302 \
    "

SRC_URI = "file://frameworks"
S = "${WORKDIR}/frameworks"

do_install() {
    install -d ${D}${includedir}/media/hardware
    install -m 0644 ${S}/native/include/media/hardware/*.h -D ${D}${includedir}/media/hardware/
}

ALLOW_EMPTY_${PN} = "1"
do_configure[noexec] = "1"
do_compile[noexec] = "1"

