DESCRIPTION = "Start up script for setting up the can link"
HOMEPAGE = "http://codeaurora.org"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/BSD;md5=3775480a712fc46a69647678acb234cb"
LICENSE = "BSD"
inherit update-rc.d systemd

SRC_URI += "file://init-can.sh"
SRC_URI += "file://61-can.rules"
S = "${WORKDIR}"
SRC_DIR = "${THISDIR}"

PR = "r2"

INITSCRIPT_NAME = "init-can.sh"
INITSCRIPT_PARAMS = "start 45 5 . stop 3 0 1 6 ."

do_compile[noexec] = "1"

do_install() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -d ${D}${sysconfdir}/udev/rules.d/
        install -d ${D}${sysconfdir}/udev/scripts/
        install -m 0555 ${WORKDIR}/init-can.sh -D ${D}${sysconfdir}/udev/scripts/init-can.sh
        install -m 0444 ${WORKDIR}/61-can.rules -D ${D}${sysconfdir}/udev/rules.d/61-can.rules
    else
        install -d ${D}${sysconfdir}/init.d/
        install -m 0555 ${WORKDIR}/${INITSCRIPT_NAME} -D ${D}${sysconfdir}/init.d/${INITSCRIPT_NAME}
    fi
}
