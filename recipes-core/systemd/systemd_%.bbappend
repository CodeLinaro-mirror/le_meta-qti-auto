FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append += "file://0001-Remove-queuing-mechanism-update-to-fq-codel.patch"
SRC_URI_append += "file://0001-Allow-powermgr-group-to-communicate.patch"
SRC_URI_append += "file://61-pps.rules"
SRC_URI_append += "file://0001-systemd-mask-journald-messages-and-remove-rules-with.patch"
SRC_URI_append += "file://0001-Allow-system-user-to-use-dbus-for-communication.patch"
SRC_URI_append += "file://loc_bootup_iio.sh"
SRC_URI_append += "file://systemd-udev-trigger.conf"
SRC_URI_append += "file://init_sys_mss.conf"
SRC_URI_append += "file://postmss.service"
SRC_URI_append += "file://postmss"
SRC_URI_append += "file://usb.conf"
SRC_URI_append += "file://adbd.conf"
SRC_URI_append += "file://loc_launcher.conf"
SRC_URI_append += "file://logd.conf"
SRC_URI_append += "file://init-can.conf"
SRC_URI_append += "file://location_hal_daemon.conf"
SRC_URI_append += "file://qwesd.conf"
SRC_URI_append += "file://qseecomd.conf"
SRC_URI_append += "file://qwes_license_store.conf"
SRC_URI_append += "file://evdev_load.conf"
SRC_URI_append += "file://sensor_hal_daemon.conf"

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -m 0644 ${WORKDIR}/61-pps.rules ${D}${sysconfdir}/udev/rules.d/61-pps.rules
        install -d ${D}${sysconfdir}/initscripts/
        install -m 0755 ${WORKDIR}/loc_bootup_iio.sh ${D}${sysconfdir}/initscripts/loc_bootup_iio.sh

        if ${@bb.utils.contains('MACHINE', 'sa515m', 'true', 'false', d)}; then
        # Install drop-ins for systemd service files
        install -d ${D}/lib/systemd/system/systemd-udev-trigger.service.d
        install -d ${D}/lib/systemd/system/init_sys_mss.service.d
        install -d ${D}/lib/systemd/system/usb.service.d
        install -d ${D}/lib/systemd/system/adbd.service.d
        install -d ${D}/etc/systemd/system/loc_launcher.service.d
        install -d ${D}/lib/systemd/system/logd.service.d
        install -d ${D}/lib/systemd/system/init-can.service.d
        install -d ${D}/etc/systemd/system/location_hal_daemon.service.d
        install -d ${D}/lib/systemd/system/qwesd.service.d
        install -d ${D}/lib/systemd/system/qseecomd.service.d
        install -d ${D}/lib/systemd/system/qwes_license_store.service.d
        install -d ${D}/etc/systemd/system/evdev_load.service.d
        install -d ${D}/etc/systemd/system/sensor_hal_daemon.service.d
        install -m 0644 ${WORKDIR}/systemd-udev-trigger.conf ${D}/lib/systemd/system/systemd-udev-trigger.service.d/systemd-udev-trigger.conf
        install -m 0644 ${WORKDIR}/init_sys_mss.conf ${D}/lib/systemd/system/init_sys_mss.service.d/init_sys_mss.conf
        install -m 0644 ${WORKDIR}/usb.conf ${D}/lib/systemd/system/usb.service.d/usb.conf
        install -m 0644 ${WORKDIR}/adbd.conf ${D}/lib/systemd/system/adbd.service.d/adbd.conf
        install -m 0644 ${WORKDIR}/loc_launcher.conf ${D}/etc/systemd/system/loc_launcher.service.d/loc_launcher.conf
        install -m 0644 ${WORKDIR}/logd.conf ${D}/lib/systemd/system/logd.service.d/logd.conf
        install -m 0644 ${WORKDIR}/init-can.conf ${D}/lib/systemd/system/init-can.service.d/init-can.conf
        install -m 0644 ${WORKDIR}/location_hal_daemon.conf ${D}/etc/systemd/system/location_hal_daemon.service.d/location_hal_daemon.conf
        install -m 0644 ${WORKDIR}/qwesd.conf ${D}/lib/systemd/system/qwesd.service.d/qwesd.conf
        install -m 0644 ${WORKDIR}/qseecomd.conf ${D}/lib/systemd/system/qseecomd.service.d/qseecomd.conf
        install -m 0644 ${WORKDIR}/qwes_license_store.conf ${D}/lib/systemd/system/qwes_license_store.service.d/qwes_license_store.conf
        install -m 0644 ${WORKDIR}/evdev_load.conf ${D}/etc/systemd/system/evdev_load.service.d/evdev_load.conf
        install -m 0644 ${WORKDIR}/sensor_hal_daemon.conf ${D}/etc/systemd/system/sensor_hal_daemon.service.d/sensor_hal_daemon.conf

        #Install service files and scripts
        install -d ${D}${sysconfdir}/initscripts/
        install -d ${D}/lib/systemd/system/multi-user.target.wants
        install -m 0755 ${WORKDIR}/postmss ${D}${sysconfdir}/initscripts/postmss
        install -m 0644 ${WORKDIR}/postmss.service ${D}/lib/systemd/system/postmss.service
        ln -sf /lib/systemd/system/postmss.service ${D}/lib/systemd/system/multi-user.target.wants/postmss.service
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
