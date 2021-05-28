FILESEXTRAPATHS_prepend := "${THISDIR}/busybox:"

SRC_URI += "\
            file://automountsdcard.sh \
            file://createsoftlinks.sh \
"

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then        install -d ${D}${sysconfdir}/udev/scripts/
        install -m 0744 ${WORKDIR}/automountsdcard.sh \
            ${D}${sysconfdir}/udev/scripts/automountsdcard.sh

        if ${@bb.utils.contains('MACHINE', 'sa2150p', 'true', 'false', d)}; then
          install -d ${D}${sysconfdir}/udev/scripts/
          install -m 0744 ${WORKDIR}/createsoftlinks.sh ${D}${sysconfdir}/udev/scripts/createsoftlinks.sh
        fi
    fi
}
