FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://firmware-mount.service"
SRC_URI += " file://mountpartitions.rules"
SRC_URI += " file://systemrw.conf"
SRC_URI += " file://firmware-ubi-mount.sh"
SRC_URI += " file://non-hlos-squash.sh"
SRC_URI += " file://vm-bootsys-ubi-mount.sh"
SRC_URI += " file://vm-bootsys-mount.service"
SRC_URI += " file://vm_systemrw.mount"
SRC_URI += " ${@bb.utils.contains('MACHINE_FEATURES', 'qti-tele-lxc', 'file://lxcrootfs-mount.service', '', d)}"
SRC_URI += " ${@bb.utils.contains('MACHINE_FEATURES', 'qti-tele-lxc', 'file://lxcrootfs-ubi-mount.sh', '', d)}"

do_install:append () {
    if ${@bb.utils.contains('IMAGE_FSTYPES', 'ubi', 'true', 'false', d)}; then
        if ${@bb.utils.contains('DISTRO_FEATURES','nand-squashfs','true','false',d)}; then
            if ${@bb.utils.contains('MACHINE', 'sa2150p-nand', 'true', 'false', d)}; then
                if [ -f ${D}${sysconfdir}/initscripts/firmware-ubi-mount.sh ]; then
                    # Remove non-hlos-squash.sh script
                    rm -f ${D}${sysconfdir}/initscripts/firmware-ubi-mount.sh
                fi
                install -m 0555 ${WORKDIR}/firmware-ubi-mount.sh ${D}${sysconfdir}/initscripts/firmware-ubi-mount.sh
           fi
       fi
   fi
   if [ -f ${D}${sysconfdir}/initscripts/lxcrootfs-ubi-mount.sh ]; then
      chmod 555 ${D}${sysconfdir}/initscripts/lxcrootfs-ubi-mount.sh
   fi
   if [ -f ${D}${sysconfdir}/initscripts/vm-bootsys-ubi-mount.sh ]; then
      chmod 555 ${D}${sysconfdir}/initscripts/vm-bootsys-ubi-mount.sh
   fi
}
