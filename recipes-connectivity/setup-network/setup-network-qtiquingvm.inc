
do_install_append () {
  install -d ${D}${systemd_system_unitdir}
  install -d ${D}${bindir}
  install -m 0755 ${WORKDIR}/setup-network.sh ${D}${bindir}/setup-network.sh
  install -m 0644 ${WORKDIR}/setup-network.service ${D}${systemd_unitdir}/system/
}

SYSTEMD_SERVICE_${PN} = "setup-network.service"
