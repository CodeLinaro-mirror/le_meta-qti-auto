FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_auto += "file://usb_flashless.service"

do_install_append_sa515m() {
   if ${@bb.utils.contains('DISTRO_FEATURES', 'flashless', 'true', 'false', d)}; then
      install -d ${D}${systemd_unitdir}/system/
      install -m 0644 ${WORKDIR}/usb_flashless.service -D ${D}${systemd_unitdir}/system/usb_flashless.service
   fi
}

do_install_append() {
   if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
	rm -rf ${D}${systemd_unitdir}/system/multi-user.target.wants/usbd.service
	rm -rf ${D}${systemd_unitdir}/system/ffbm.target.wants/usbd.service
	rm -rf ${D}${systemd_unitdir}/system/local-fs.target.wants/usbd.service
	rm -rf ${systemd_unitdir}/system/usbd.service
  fi
}

FILES_${PN} += "${systemd_unitdir}/system/*"
