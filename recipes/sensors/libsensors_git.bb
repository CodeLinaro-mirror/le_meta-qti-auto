inherit autotools-brokensep pkgconfig

DESCRIPTION = "Sensor library"
PR = "r1"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

FILESPATH =+ "${WORKSPACE}:"

SRC_URI += "file://hardware/qcom/sensors/"
SRC_URI += "file://iio.sh"
SRC_URI += "file://sensors.sh"
SRC_URI += "file://61-iio.rules"
SRC_URI += "file://61-sensor.rules"
S = "${WORKDIR}/hardware/qcom/sensors"

DEPENDS = "glib-2.0"

EXTRA_OECONF = "--with-glib"

do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -d ${D}${sysconfdir}/udev/rules.d/
        install -m 0444 ${WORKDIR}/61-sensor.rules ${D}${sysconfdir}/udev/rules.d/61-sensor.rules
        install -m 0444 ${WORKDIR}/61-iio.rules ${D}${sysconfdir}/udev/rules.d/61-iio.rules
        install -d ${D}${sysconfdir}/udev/scripts/
        install -m 0555 ${WORKDIR}/sensors.sh ${D}${sysconfdir}/udev/scripts/sensors.sh
        install -m 0555 ${WORKDIR}/iio.sh ${D}${sysconfdir}/udev/scripts/iio.sh
    fi
    install -d ${D}${base_libdir}/firmware/
    install -m 0755 ${S}/st/Documentation/LinuxHal/mlc_asm330lhhx/towing_impact/towing_impact_v0_52.ucf ${D}${base_libdir}/firmware/st_asm330lhhx_mlc.bin
}

FILES_${PN} += "${sysconfdir}/udev/rules.d/61-sensor.rules \
               ${sysconfdir}/udev/rules.d/61-iio.rules \
               ${sysconfdir}/udev/scripts/* \
               ${base_libdir}/firmware/*"
