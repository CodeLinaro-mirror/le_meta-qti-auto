FILESEXTRAPATHS:prepend := "${THISDIR}/busybox:"

SRC_URI += "\
            file://automountsdcard.sh \
            file://no-shell-history.cfg \
            file://busybox_utilities.cfg \
"

SRC_URI:append:sa525m = "file://taskset.cfg"

SRC_URI:append:sa525m:qti-distro-tele-perf += "file://busybox_utilities_perf.cfg"

do_install:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then        install -d ${D}${sysconfdir}/udev/scripts/
        install -m 0555 ${WORKDIR}/automountsdcard.sh \
            ${D}${sysconfdir}/udev/scripts/automountsdcard.sh
    fi
}

ERROR_QA:remove = "patch-status"
PROVIDES += "bash"
RPROVIDES:${PN} += "bash"
ALTERNATIVE_PRIORITY[cp] = "100"
