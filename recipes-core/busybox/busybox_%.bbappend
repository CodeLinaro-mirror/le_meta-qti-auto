FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "\
            file://automountsdcard.sh \
"

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then        install -d ${D}${sysconfdir}/udev/scripts/
        install -m 0744 ${WORKDIR}/automountsdcard.sh \
            ${D}${sysconfdir}/udev/scripts/automountsdcard.sh
    fi
}
