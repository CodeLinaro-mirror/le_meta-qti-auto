INSANE_SKIP_${PN} += "installed-vs-shipped"

SYSTEMD_SERVICE = "udisks.service"

do_install_append () {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/udisks.service ${D}${systemd_unitdir}/system/udisks.service
    install -m 0644 ${WORKDIR}/automount.service ${D}${systemd_unitdir}/system/automount.service
}

do_patch_append() {
    bb.build.exec_func('do_fix_rw', d)
}

do_fix_rw() {
    sed -i -e 's/MOUNT_OPTIONS="ro/MOUNT_OPTIONS="rw/' ${WORKDIR}/automount.sh
}

