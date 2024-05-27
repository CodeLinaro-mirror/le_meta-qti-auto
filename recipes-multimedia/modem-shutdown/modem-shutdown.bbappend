do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        chmod 555 ${D}/${sysconfdir}/initscripts/modem-shutdown
    fi
}
