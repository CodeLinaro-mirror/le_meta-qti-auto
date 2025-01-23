FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI  += "file://servicemanager_auto.service"

SYSTEMD_SERVICE:${PN} = " ${@bb.utils.contains('PACKAGECONFIG', 'systemd', 'servicemanager.service', '', d)}"

USERADD_PARAM:${PN} += "-u 3020 -U binder;"
do_install:append:sa525m() {
  rm -rf ${D}${systemd_unitdir}/system/servicemanager.service
  rm -rf ${D}${systemd_unitdir}/system/binderfs.service
  install -m 0664 ${WORKDIR}/servicemanager_auto.service ${D}${systemd_unitdir}/system/servicemanager.service
  sed -i -e "s/$/ \, RUN+=\"\/bin\/sh -c 'chmod 0660 \/dev\/binder \&\& chown binder:binder \/dev\/binder\'\"/g" ${D}${sysconfdir}/udev/rules.d/50-binder.rules
}

do_install:append:sa510m() {
  rm -rf ${D}${systemd_unitdir}/system/servicemanager.service
  rm -rf ${D}${systemd_unitdir}/system/binderfs.service
  install -m 0664 ${WORKDIR}/servicemanager_auto.service ${D}${systemd_unitdir}/system/servicemanager.service
  sed -i -e "s/$/ \, RUN+=\"\/bin\/sh -c 'chmod 0660 \/dev\/binder \&\& chown binder:binder \/dev\/binder\'\"/g" ${D}${sysconfdir}/udev/rules.d/50-binder.rules
}

EXTRA_OECONF:remove:sa510m = "--enable-32bit-binder-ipc"

FILES:${PN} += "${systemd_unitdir}/system/"
