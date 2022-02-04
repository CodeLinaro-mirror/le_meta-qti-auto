inherit autotools-brokensep pkgconfig systemd

SUMMARY = "sensor client api library"
DESCRIPTION = "The client api provides library interface to the clients"
PR = "r1"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

DEPENDS = "glib-2.0 sensor-socket libcutils sensor-hal-daemon-hdr libsensors"
FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://hardware/qcom/sensors/sensor-service/sensor_client_api"
SRC_URI += "file://sensors.conf"
S = "${WORKDIR}/hardware/qcom/sensors/sensor-service/sensor_client_api"

EXTRA_OECONF += "${@bb.utils.contains('MACHINE_FEATURES', 'external-ap', '--with-external_ap', '', d)}"

EXTRA_OECONF += "--with-core-includes=${WORKSPACE}/system/core/include \
                --with-glib"

do_install_append () {

    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -m 0644 -D ${WORKDIR}/sensors.conf  ${D}${sysconfdir}/sensors.conf
    fi
}

