inherit systemd

DESCRIPTION = "Kernel Module Loader"
PR = "r0"

LICENSE          = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=7a434440b651f4a472ca93716d01033a"

FILESPATH =+ "${WORKSPACE}:"

SRC_URI += "file://evdev_load.service"
SYSTEMD_SERVICE:${PN} += "evdev_load.service"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install () {
      # Place evdev_load.service in systemd unitdir
      install -d ${D}${systemd_unitdir}/system/
      install -m 0644 ${WORKDIR}/evdev_load.service  \
          -D ${D}${systemd_unitdir}/system/evdev_load.service

}

FILES:${PN} += "${systemd_unitdir}/system/evdev_load.service"
