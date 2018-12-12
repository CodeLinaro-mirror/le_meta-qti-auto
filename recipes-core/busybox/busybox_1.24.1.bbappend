prefix = "/usr"

INSANE_SKIP_${PN} += "installed-vs-shipped"

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        if grep -q "CONFIG_SYSLOGD=y" ${B}/.config; then
            install -d ${D}${systemd_unitdir}/system
            sed 's,@base_sbindir@,${base_sbindir},g' < ${WORKDIR}/busybox-syslog.service.in \
                > ${D}${systemd_unitdir}/system/busybox-syslog.service
        fi
    fi
}
