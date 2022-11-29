
do_install_append () {
    if ${@bb.utils.contains('IMAGE_FSTYPES', 'ubi', 'true', 'false', d)}; then
        if ${@bb.utils.contains('DISTRO_FEATURES','nand-squashfs','true','false',d)}; then
            if ${@bb.utils.contains('MACHINE', 'sa515m', 'true', 'false', d)}; then
                if ${@bb.utils.contains('DISTRO_FEATURES','nad-prod','true','false',d)}; then
                  # for NAD modem is moved as volume in nad_ubi[system] partition
                    if ${@bb.utils.contains('DISTRO_FEATURES','modem-volume','true','false',d)}; then
                        if [ -f ${D}${sysconfdir}/initscripts/firmware-ubi-mount.sh ]; then
                          rm -f ${D}${sysconfdir}/initscripts/firmware-ubi-mount.sh
                        fi
                        install -m 0744 ${WORKDIR}/non-hlos-squash.sh ${D}${sysconfdir}/initscripts/firmware-ubi-mount.sh
                    fi
                    install -d ${D}/lib/systemd/system/data.mount.d
                    install  -m 0644 ${WORKDIR}/data.conf ${D}/lib/systemd/system/data.mount.d/data.conf
                fi
            fi
        fi
    fi
}
