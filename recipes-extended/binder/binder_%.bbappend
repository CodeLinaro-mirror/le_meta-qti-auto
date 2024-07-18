FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI  += "file://servicemanager.conf"
SRC_URI  += "file://binderfs.rules"
SRC_URI  += "file://binderfs_udev.sh"

USERADD_PARAM:${PN} += "-u 3020 -U binderfs;"
do_install:append:sa525m() {
  install -d ${D}${systemd_unitdir}/system/servicemanager.service.d
  install  -m 0660 ${WORKDIR}/servicemanager.conf ${D}${systemd_unitdir}/system/servicemanager.service.d/servicemanager.conf
  install -d ${D}${sysconfdir}/udev/rules.d/
  install -m 0644 ${WORKDIR}/binderfs.rules ${D}${sysconfdir}/udev/rules.d/binderfs.rules
  install -d ${D}${sysconfdir}/udev/scripts/
  install -m 0555 ${WORKDIR}/binderfs_udev.sh ${D}${sysconfdir}/udev/scripts/binderfs_udev.sh
}
