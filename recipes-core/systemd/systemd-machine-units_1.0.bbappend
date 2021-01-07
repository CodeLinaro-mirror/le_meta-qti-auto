
do_install_append () {
    if ${@bb.utils.contains('IMAGE_FSTYPES', 'ubi', 'true', 'false', d)}; then
        if ${@bb.utils.contains('DISTRO_FEATURES','nand-squashfs','true','false',d)}; then
            if ${@bb.utils.contains('MACHINE', 'sa2150p-nand', 'true', 'false', d)}; then
                if [ -f ${D}${sysconfdir}/initscripts/firmware-ubi-mount.sh ]; then
                    rm -f ${D}${sysconfdir}/initscripts/firmware-ubi-mount.sh
                fi
                install -m 0744 ${WORKDIR}/firmware-ubi-mount.sh ${D}${sysconfdir}/initscripts/firmware-ubi-mount.sh
           fi
       fi
   fi
}
