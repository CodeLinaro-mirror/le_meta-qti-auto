do_install_append() {
    if ${@bb.utils.contains('EXTRA_OECONF', '--with-systemd', 'true', 'false', d)}; then
        chmod 555 ${D}${sysconfdir}/init.post_boot.sh
        chmod 555 ${D}${sysconfdir}/init.qti.debug.sh
    fi
}
