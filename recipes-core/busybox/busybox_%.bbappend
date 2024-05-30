FILESEXTRAPATHS:prepend := "${THISDIR}/busybox:"

SRC_URI += "\
            file://automountsdcard.sh \
            file://no-shell-history.cfg \
            file://busybox_utilities.cfg \
"

SRC_URI:append:sa525m = "file://taskset.cfg"

do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then        install -d ${D}${sysconfdir}/udev/scripts/
        install -m 0555 ${WORKDIR}/automountsdcard.sh \
            ${D}${sysconfdir}/udev/scripts/automountsdcard.sh
    fi
}
