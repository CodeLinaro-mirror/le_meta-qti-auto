FILESEXTRAPATHS_prepend := "${THISDIR}/busybox:"
SRC_URI += "\
            file://automountsdcard.sh \
            file://no-shell-history.cfg \
            file://console_util_opts.cfg \
            file://core_opts.cfg \
            file://debug_opts.cfg \
            file://applets_opts.cfg \
"

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then        install -d ${D}${sysconfdir}/udev/scripts/
        install -m 0744 ${WORKDIR}/automountsdcard.sh \
            ${D}${sysconfdir}/udev/scripts/automountsdcard.sh
    fi
}
