FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append += "file://auto_platform.conf"
SRC_URI_append += "file://0001-Remove-queuing-mechanism-update-to-fq-codel.patch"
SRC_URI_append += "file://0001-Allow-powermgr-group-to-communicate.patch"
SRC_URI_append += "file://61-pps.rules"

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -m 0644 ${WORKDIR}/auto_platform.conf -D ${D}/etc/tmpfiles.d/auto_platform.conf
	install -m 0555 ${WORKDIR}/61-pps.rules ${D}${sysconfdir}/udev/rules.d/61-pps.rules
    fi
}

FILES_${PN} += "${sysconfdir}/udev/rules.d/61-pps.rules"
