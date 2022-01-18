inherit autotools systemd pkgconfig

SUMMARY = "sensor hal daemon service"
DESCRIPTION = "This recipe compiles sensor service and configuration files"
PR = "r1"

LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=3775480a712fc46a69647678acb234cb"

DEPENDS = "glib-2.0 libsensors sensor-socket powermanager-lib"
FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://hardware/qcom/sensors/sensor-service/sensor_hal_daemon"
SRC_URI +="file://sensor_hal_daemon.service"
SRC_URI +="file://sensor_hal_daemon-tmpfilesd.conf"
SRC_URI +="file://sensors.conf"
S = "${WORKDIR}/hardware/qcom/sensors/sensor-service/sensor_hal_daemon"

EXTRA_OECONF = "--with-core-includes=${WORKSPACE}/system/core/include \
		--with-glib"

SYSTEMD_SERVICE_${PN} = "sensor_hal_daemon.service"

do_install_append () {

    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        ## Install systemd-tmpfiles config file
        install -d ${D}${sysconfdir}/tmpfiles.d/
        install -m 0644 ${WORKDIR}/sensor_hal_daemon-tmpfilesd.conf ${D}${sysconfdir}/tmpfiles.d/${BPN}.conf

        ## Install systemd service unit file
        install -d ${D}${sysconfdir}/systemd/system/
        install -m 0644 ${WORKDIR}/sensor_hal_daemon.service -D ${D}${sysconfdir}/systemd/system/sensor_hal_daemon.service

	install -m 0644 -D ${WORKDIR}/sensors.conf  ${D}${sysconfdir}/sensors.conf
    fi
}
