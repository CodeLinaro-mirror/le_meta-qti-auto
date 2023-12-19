FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append += " \
    file://0001-Remove-queuing-mechanism-update-to-fq-codel.patch \
    file://0001-Allow-powermgr-group-to-communicate.patch \
    file://61-pps.rules \
    file://0001-systemd-mask-journald-messages-and-remove-rules-with.patch \
    file://0001-Allow-system-user-to-use-dbus-for-communication.patch \
    file://loc_bootup_iio.sh \
    file://postmss.service \
    file://postmss \
    file://sensor_bootup_iio.sh \
    file://${BASEMACHINE}/ \
    ${@bb.utils.contains('COMBINED_FEATURES', 'qti-nad-core', 'file://mtd.rules', '',d)} \
    file://platform.rules \
"

PACKAGECONFIG_remove = " \
    acl \
    binfmt \
    hibernate \
    kmod \
"

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -m 0644 ${WORKDIR}/61-pps.rules ${D}${sysconfdir}/udev/rules.d/61-pps.rules

        install -m 0644 ${WORKDIR}/platform.rules ${D}${sysconfdir}/udev/rules.d/platform.rules

        if ${@bb.utils.contains('COMBINED_FEATURES', 'qti-nad-core', 'true', 'false', d)}; then
                install -m 0644 ${WORKDIR}/mtd.rules -D ${D}${sysconfdir}/udev/rules.d/mtd.rules
        fi

        install -d ${D}${systemd_unitdir}/system/
        cp -fR ${WORKDIR}/${BASEMACHINE}/* ${D}${systemd_unitdir}/system/

        #Install service files and scripts
        install -d ${D}${sysconfdir}/initscripts/
        install -d ${D}${systemd_unitdir}/system/basic.target.wants/

        if ${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-guest', 'false', 'true', d)}; then
            install -m 0755 ${WORKDIR}/postmss ${D}${sysconfdir}/initscripts/postmss
            install -m 0644 ${WORKDIR}/postmss.service ${D}${systemd_unitdir}/system/postmss.service
            ln -sf ${systemd_unitdir}/system/postmss.service \
                    ${D}${systemd_unitdir}/system/basic.target.wants/postmss.service

            rm -rf ${D}${systemd_unitdir}/system/adbd.service.d/adbd-gvm.conf
        fi

        if ${@bb.utils.contains('MACHINE_FEATURES', 'qti-vm-guest', 'true', 'false', d)}; then
            rm -rf ${D}${systemd_unitdir}/system/QCMAP_ConnectionManagerd.service.d/QCMAP_ConnectionManagerd-pvm.conf
        fi

        #Install iio bootup script for sensors
        if ${@bb.utils.contains('MACHINE', 'sa515m', 'true', 'false', d)}; then
            install -m 0755 ${WORKDIR}/loc_bootup_iio.sh ${D}${sysconfdir}/initscripts/loc_bootup_iio.sh
        else
            install -m 0755 ${WORKDIR}/sensor_bootup_iio.sh ${D}${sysconfdir}/initscripts/loc_bootup_iio.sh
        fi
    fi
}

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        rm -f ${D}${base_libdir}/udev/ata_id
        rm -f ${D}${base_libdir}/udev/cdrom_id
        rm -f ${D}${base_libdir}/udev/scsi_id
        rm -f ${D}${base_libdir}/udev/v4l_id
        rm -f ${D}${base_libdir}/udev/rules.d/60-cdrom_id.rules
        rm -f ${D}${base_libdir}/udev/rules.d/60-drm.rules
        rm -f ${D}${base_libdir}/udev/rules.d/60-evdev.rules
        rm -f ${D}${base_libdir}/udev/rules.d/60-input_id.rules
        rm -f ${D}${base_libdir}/udev/rules.d/60-persistent-input.rules
        rm -f ${D}${base_libdir}/udev/rules.d/60-persistent-storage-tape.rules
        rm -f ${D}${base_libdir}/udev/rules.d/70-joystick.rules
        rm -f ${D}${base_libdir}/udev/rules.d/70-mouse.rules
        rm -f ${D}${base_libdir}/udev/rules.d/70-touchpad.rules
        rm -f ${D}${base_libdir}/udev/rules.d/71-seat.rules
        rm -f ${D}${base_libdir}/udev/rules.d/73-seat-late.rules
        rm -f ${D}${base_libdir}/udev/rules.d/80-drivers.rules
        rm -f ${D}${sysconfdir}/udev/rules.d/touchscreen.rules
        rm -f ${D}${sysconfdir}/udev/rules.d/mtpserver.rules
    fi
}
FILES_${PN} += "${sysconfdir}/udev/rules.d/61-pps.rules"
FILES_${PN} += "${sysconfdir}/udev/rules.d/platform.rules"
