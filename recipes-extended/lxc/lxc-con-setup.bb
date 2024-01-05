DESCRIPTION = "This recipe is required for copying the files to container to start"

LICENSE = "LGPL-2.1"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=1a6d268fd218675ffea8be556788b780"

SRC_URI = "file://rcS   \
           file://inittab"

do_install() {
   install -m 0755  -d ${D}/proc
   install -m 0755  -d ${D}/${sysconfdir}/init.d
   install -m 0755  -d ${D}/sys
   install -m 0755  -d ${D}/tmp
   install -m 0755  -d ${D}/dev

   install -m 0744 ${WORKDIR}/inittab ${D}/${sysconfdir}
   install -m 0744 ${WORKDIR}/rcS ${D}/${sysconfdir}/init.d/
   chmod 744 ${D}/${sysconfdir}/init.d/rcS

}

FILES_${PN} += "${sysconfdir}/*"
FILES_${PN} += "/proc"
FILES_${PN} += "/sys"
FILES_${PN} += "/tmp"
FILES_${PN} += "/dev"
