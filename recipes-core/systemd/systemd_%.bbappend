FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_sdxpoorwills += "file://61-sensor.rules"
SRC_URI_append_sdxpoorwills += "file://61-iio.rules"

do_install_append_sdxpoorwills() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -d ${D}${sysconfdir}/udev/rules.d/
        install -m 0555 ${WORKDIR}/61-sensor.rules ${D}${sysconfdir}/udev/rules.d/61-sensor.rules
        install -m 0555 ${WORKDIR}/61-iio.rules ${D}${sysconfdir}/udev/rules.d/61-iio.rules
    fi
}

FILES_${PN} += "${sysconfdir}/udev/rules.d/61-sensor.rules \
               ${sysconfdir}/udev/rules.d/61-iio.rules"
