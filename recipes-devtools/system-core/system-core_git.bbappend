FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://0001-Fix-adb-shell-env-issue.patch"

EXTRA_OECONF_append = " --disable-libsync"

COMPOSITION = "901D"

do_install_append() {
    # update usb.service to depend on var-volatile.mount
    sed -i -e '/^After/d' ${D}${systemd_unitdir}/system/usb.service
    sed -i -e '/^Requires/d' ${D}${systemd_unitdir}/system/usb.service
    sed -i -e '/^Descr/a\RequiresMountsFor=\/var' ${D}${systemd_unitdir}/system/usb.service
    sed -i -e '/^Descr/a\Requires=var-adb_devid.service var-usb.service' ${D}${systemd_unitdir}/system/usb.service
    sed -i -e '/^Descr/a\After=var-volatile.mount leprop.service' ${D}${systemd_unitdir}/system/usb.service
}
