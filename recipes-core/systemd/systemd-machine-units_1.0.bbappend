
do_install_append () {
    if ${@bb.utils.contains('IMAGE_FSTYPES', 'ubi', 'true', 'false', d)}; then
        if ${@bb.utils.contains('DISTRO_FEATURES','nand-squashfs','true','false',d)}; then
            if ${@bb.utils.contains('MACHINE', 'sa415m', 'true', 'false', d)}; then
                if [ -f ${D}${sysconfdir}/initscripts/firmware-ubi-mount.sh ]; then
                    rm -f ${D}${sysconfdir}/initscripts/firmware-ubi-mount.sh
                fi
                install -m 0744 ${WORKDIR}/firmware-ubi-mount.sh ${D}${sysconfdir}/initscripts/firmware-ubi-mount.sh
                if ${@bb.utils.contains('DISTRO_FEATURES','nad-prod','true','false',d)}; then
                    install -d ${D}/lib/systemd/system/data.mount.d
                    install  -m 0644 ${WORKDIR}/data.conf ${D}/lib/systemd/system/data.mount.d/data.conf
                fi
            fi
        else
            if ${@bb.utils.contains('MACHINE', 'sa415m', 'true', 'false', d)}; then
                if [ -f ${D}${sysconfdir}/initscripts/firmware-ubi-mount.sh ]; then
                    rm -f ${D}${sysconfdir}/initscripts/firmware-ubi-mount.sh
                fi
                install -m 0744 ${WORKDIR}/firmware-ubi-mount.sh ${D}${sysconfdir}/initscripts/firmware-ubi-mount.sh
           fi
        fi
    fi
}
