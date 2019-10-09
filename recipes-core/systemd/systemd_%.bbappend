FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append += "file://61-diag.rules"
SRC_URI_append += "file://61-pps.rules"
SRC_URI_append += "file://Allow-powermgr-group-to-communicate.patch"
SRC_URI_append += "file://init_sys_mss.conf"
SRC_URI_append += "file://postmss.service"
SRC_URI_append += "file://postmss"
SRC_URI_append += "file://usb.conf"
SRC_URI_append += "file://adbd.conf"
SRC_URI_append += "file://tftp_server.conf"
SRC_URI_append += "file://servicemanager.conf"
SRC_URI_append += "file://0001-Remove-queuing-mechanism-update-to-fq-codel.patch"
SRC_URI_append += "file://mask-failed-to-connect-to-journal-socket-errors.patch"
SRC_URI_append += "file://Removed-the-symlink-for-localtime.patch"
SRC_URI_append += "file://Removed-specified-group-render-and-KVM.patch"

PACKAGECONFIG_remove_auto = " \
    acl \
    binfmt \
    hibernate \
    kmod \
"

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -d ${D}${sysconfdir}/udev/rules.d/
        install -m 0555 ${WORKDIR}/61-diag.rules ${D}${sysconfdir}/udev/rules.d/61-diag.rules
        install -m 0555 ${WORKDIR}/61-pps.rules ${D}${sysconfdir}/udev/rules.d/61-pps.rules

        # Install drop-ins for systemd service files
        install -d ${D}/lib/systemd/system/init_sys_mss.service.d
        install -d ${D}/lib/systemd/system/usb.service.d
        install -d ${D}/lib/systemd/system/adbd.service.d
        install -d ${D}/lib/systemd/system/tftp_server.service.d
        install -d ${D}/lib/systemd/system/servicemanager.service.d

        install -m 0644 ${WORKDIR}/init_sys_mss.conf ${D}/lib/systemd/system/init_sys_mss.service.d/init_sys_mss.conf
        install -m 0644 ${WORKDIR}/usb.conf ${D}/lib/systemd/system/usb.service.d/usb.conf
        install -m 0644 ${WORKDIR}/adbd.conf ${D}/lib/systemd/system/adbd.service.d/adbd.conf
        install -m 0644 ${WORKDIR}/tftp_server.conf ${D}/lib/systemd/system/tftp_server.service.d/tftp_server.conf
        install -m 0644 ${WORKDIR}/servicemanager.conf ${D}/lib/systemd/system/servicemanager.service.d/servicemanager.conf

        #Install service files and scripts
        install -d ${D}${sysconfdir}/initscripts/
        install -d ${D}/lib/systemd/system/multi-user.target.wants
        install -m 0755 ${WORKDIR}/postmss ${D}${sysconfdir}/initscripts/postmss
        install -m 0644 ${WORKDIR}/postmss.service ${D}/lib/systemd/system/postmss.service
        ln -sf /lib/systemd/system/postmss.service ${D}/lib/systemd/system/multi-user.target.wants/postmss.service
    fi
}

do_install_append_auto() {
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
        rm -f ${D}${base_libdir}/udev/rules.d/60-persistent-storage.rules
        rm -f ${D}${base_libdir}/udev/rules.d/60-persistent-storage-tape.rules
        rm -f ${D}${base_libdir}/udev/rules.d/60-sensor.rules
        rm -f ${D}${base_libdir}/udev/rules.d/70-joystick.rules
        rm -f ${D}${base_libdir}/udev/rules.d/70-mouse.rules
        rm -f ${D}${base_libdir}/udev/rules.d/70-touchpad.rules
        rm -f ${D}${base_libdir}/udev/rules.d/71-seat.rules
        rm -f ${D}${base_libdir}/udev/rules.d/73-seat-late.rules
        rm -f ${D}${base_libdir}/udev/rules.d/80-drivers.rules
        rm -f ${D}${sysconfdir}/udev/rules.d/touchscreen.rules
        rm -f ${D}${base_libdir}/udev/rules.d/mountpartitions.rules
        rm -f ${D}${sysconfdir}/udev/rules.d/mtpserver.rules
    fi
}

FILES_${PN} += "${sysconfdir}/udev/rules.d/61-diag.rules \
               ${sysconfdir}/udev/rules.d/61-pps.rules"
