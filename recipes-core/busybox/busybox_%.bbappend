FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_sdxpoorwills += "file://sensors.sh"
SRC_URI_append_sdxpoorwills += "file://iio.sh"

do_install_append_sdxpoorwills() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -d ${D}${sysconfdir}/udev/scripts/
        install -m 0555 ${WORKDIR}/sensors.sh ${D}${sysconfdir}/udev/scripts/sensors.sh
        install -m 0555 ${WORKDIR}/iio.sh ${D}${sysconfdir}/udev/scripts/iio.sh
    fi
}

FILES_${PN} += "${sysconfdir}/udev/scripts/*"
