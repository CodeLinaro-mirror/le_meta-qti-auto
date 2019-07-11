# Including the file depends on chipset
INCSUFFIX = "${@bb.utils.contains('MACHINE', '', 'connman-conf', 'none',d)}"
FOLDERSUFFIX = "${@bb.utils.contains('MACHINE', 'qtiquingvm', 'connman-conf', 'none',d)}"

FILESEXTRAPATHS_append := ":${THISDIR}/${FOLDERSUFFIX}"

SRC_URI = "file://main.conf"

FILES_${PN} += "${sysconfdir}/connman/*"

do_install_append () {
  install -d ${D}${sysconfdir}/connman/
  install -m 0644 ${WORKDIR}/main.conf ${D}${sysconfdir}/connman/
  # For early_ethernet, eth is configure in early_init. Just let connman ignore it.
  if ${@bb.utils.contains('DISTRO_FEATURES', 'early-ethernet', 'true', 'false', d)}; then
      sed -i '/^NetworkInterfaceBlacklist/s/$/,eth0/' ${D}${sysconfdir}/connman/main.conf
  fi
}

# Including the file depends on chipset
include ${INCSUFFIX}-${MACHINE}.inc
