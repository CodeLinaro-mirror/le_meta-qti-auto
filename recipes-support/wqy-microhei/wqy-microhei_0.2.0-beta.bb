SUMMARY = "WenQuanYi microhei font"
HOMEPAGE = "http://sourceforge.net/projects/wqy"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "http://downloads.sourceforge.net/project/wqy/${PN}/${PV}/${PN}-${PV}.tar.gz"
SRC_URI[md5sum] = "a124c5c6606f4f3b733d3477380e9d2f"
SRC_URI[sha256sum] = "2802ac8023aa36a66ea6e7445854e3a078d377ffff42169341bd237871f7213e"

PACKAGE_ARCH = "${MACHINE_ARCH}"

do_install() {
        mkdir -p ${D}/${datadir}/fonts
        install -m 0644 ${WORKDIR}/wqy-microhei/wqy-microhei.ttc ${D}/${datadir}/fonts/
}

FILES_${PN} = "${datadir}/fonts/wqy-microhei.ttc"
