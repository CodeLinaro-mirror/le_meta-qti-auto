FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI  += "file://servicemanager.conf"
do_install:append:sa525m() {
    install -d ${D}${systemd_unitdir}/system/servicemanager.service.d
    install  -m 0666 ${WORKDIR}/servicemanager.conf ${D}${systemd_unitdir}/system/servicemanager.service.d/servicemanager.conf
}
