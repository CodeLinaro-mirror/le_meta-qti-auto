FILESEXTRAPATHS_prepend := "${THISDIR}/chrony:"

SRC_URI += "file://chrony-televm.conf"

do_install_append() {
    if [ ${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-tele', 'True', 'False', d)} = True ]; then
        rm -f ${D}${sysconfdir}/chrony.conf
        install -m 0644 ${WORKDIR}/chrony-televm.conf ${D}${sysconfdir}/chrony.conf
    fi
}
