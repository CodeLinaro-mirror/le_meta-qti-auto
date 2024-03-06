do_install:append () {
      rm -f ${D}${systemd_unitdir}/system/rdisc.service
      rm -f ${D}${systemd_unitdir}/system/ninfod.service
}

SYSTEMD_SERVICE:${PN}-rdisc:remove = "rdisc.service"
SYSTEMD_SERVICE:${PN}-ninfod:remove = "ninfod.service"
