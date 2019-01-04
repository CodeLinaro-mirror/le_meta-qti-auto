
dirs755_append +="/firmware /dsp "

do_install_append_smack () {
      # replace the old smack rules from "System _ -----l" to "System _ rwxa--"
      sed -i "1c System _ rwxa--"  ${D}/${sysconfdir}/smack/accesses.d/default-access-domains
}

do_install_append () {
    if ${@bb.utils.contains('DISTRO_FEATURES','ab-boot-support','true','false',d)};then
        sed -i -e '/^Description/a\After=dev-disk-by\\x2dpartlabel-modem_a.device' ${D}${sysconfdir}/systemd/system/firmware-mount.service
        sed -i -e '/^Description/a\Requires=dev-disk-by\\x2dpartlabel-modem_a.device' ${D}${sysconfdir}/systemd/system/firmware-mount.service
        sed -i -e '/^Description/a\After=dev-disk-by\\x2dpartlabel-dsp_a.device' ${D}${sysconfdir}/systemd/system/dsp-mount.service
        sed -i -e '/^Description/a\Requires=dev-disk-by\\x2dpartlabel-dsp_a.device' ${D}${sysconfdir}/systemd/system/dsp-mount.service
    fi

    if [ -L ${D}/usr/local ]; then
        rm ${D}/usr/local
    fi
}
