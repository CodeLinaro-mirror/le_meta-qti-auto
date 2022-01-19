FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append += "file://0001-Remove-queuing-mechanism-update-to-fq-codel.patch"
SRC_URI_append += "file://0001-Allow-powermgr-group-to-communicate.patch"
SRC_URI_append += "file://61-pps.rules"
SRC_URI_append += "file://0001-systemd-mask-journald-messages-and-remove-rules-with.patch"
SRC_URI_append += "file://0001-Allow-system-user-to-use-dbus-for-communication.patch"

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
	install -m 0644 ${WORKDIR}/61-pps.rules ${D}${sysconfdir}/udev/rules.d/61-pps.rules
    fi
}

do_install_append_sa2150p() {
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
    fi

}

FILES_${PN} += "${sysconfdir}/udev/rules.d/61-pps.rules"
