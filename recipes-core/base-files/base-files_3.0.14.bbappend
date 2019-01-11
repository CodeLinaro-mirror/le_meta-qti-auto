
dirs755_append +="/firmware /dsp /bt_firmware"

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
        sed -i -e '/^Description/a\After=dev-disk-by\\x2dpartlabel-bluetooth_a.device' ${D}${sysconfdir}/systemd/system/bluetooth-mount.service
        sed -i -e '/^Description/a\Requires=dev-disk-by\\x2dpartlabel-bluetooth_a.device' ${D}${sysconfdir}/systemd/system/bluetooth-mount.service
        sed -i 's/bt_firmware/bluetooth/g' ${D}${sysconfdir}/systemd/system/bluetooth-mount.service
        install -m 0755 -d ${D}/bluetooth
    fi

    if [ -L ${D}/usr/local ]; then
        rm ${D}/usr/local
    fi
}
