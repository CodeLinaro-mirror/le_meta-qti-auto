FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI  += "file://servicemanager_auto.service"

SYSTEMD_SERVICE:${PN} = " ${@bb.utils.contains('PACKAGECONFIG', 'systemd', 'servicemanager.service', '', d)}"

USERADD_PARAM:${PN} += "-u 3020 -U binderfs;"
do_install:append:sa525m() {
  rm -rf ${D}${systemd_unitdir}/system/servicemanager.service
  rm -rf ${D}${systemd_unitdir}/system/binderfs.service
  install -m 0664 ${WORKDIR}/servicemanager_auto.service ${D}${systemd_unitdir}/system/servicemanager.service
}

FILES:${PN} += "${systemd_unitdir}/system/"
