FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " file://firmware-mount.service"
SRC_URI += " file://mountpartitions.rules"
SRC_URI += " file://systemrw.conf"
SRC_URI += " file://firmware-ubi-mount.sh"
SRC_URI += " file://non-hlos-squash.sh"
SRC_URI += " file://vm-bootsys-ubi-mount.sh"
SRC_URI += " file://vm-bootsys-mount.service"
SRC_URI += " file://vm_systemrw.mount"

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
}
