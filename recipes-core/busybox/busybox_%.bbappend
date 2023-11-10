FILESEXTRAPATHS_prepend := "${THISDIR}/busybox:"

SRC_URI += "\
            file://automountsdcard.sh \
            file://no-shell-history.cfg \
"

SRC_URI:append:sa525m = "file://taskset.cfg"

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then        install -d ${D}${sysconfdir}/udev/scripts/
        install -m 0744 ${WORKDIR}/automountsdcard.sh \
            ${D}${sysconfdir}/udev/scripts/automountsdcard.sh
    fi
}
