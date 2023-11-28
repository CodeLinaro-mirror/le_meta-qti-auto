DESCRIPTION = "This recipe is required for copying the files to container to start"

LICENSE = "LGPL-2.1"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=1a6d268fd218675ffea8be556788b780"

SRC_URI += "file://lxc_init"

do_install() {
   install -m 0755  -d ${D}${base_sbindir}/
   install -m 0755  -d ${D}/proc
   install -m 0755  -d ${D}/sys
   install -m 0755  -d ${D}/tmp

   install -m 0755 ${WORKDIR}/lxc_init ${D}${base_sbindir}/init
}

FILES_${PN} += "${base_sbindir}/*"
FILES_${PN} += "/proc"
FILES_${PN} += "/sys"
FILES_${PN} += "/tmp"
