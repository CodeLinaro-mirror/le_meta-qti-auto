inherit autotools-brokensep pkgconfig

SUMMARY = "sensor socket library"
DESCRIPTION = "This establishes sockets communication between clients and sensor hal daemon"
PR = "r1"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

DEPENDS = "glib-2.0 libcutils qmi-framework sensor-util-lib"
DEPENDS:append = " ${@bb.utils.contains('MACHINE_FEATURES', 'dlt-logging', ' sensor-dlt-log', '', d)}"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://hardware/qcom/sensors/sensor-service/sensor_socket"
S = "${WORKDIR}/hardware/qcom/sensors/sensor-service/sensor_socket"

PACKAGECONFIG:append = "${@bb.utils.contains('MACHINE_FEATURES', 'dlt-logging', ' dlt_logging_enabled', '', d)}"
PACKAGECONFIG[dlt_logging_enabled] = "--with-dltlogging,--without-dltlogging,dlt-daemon"

EXTRA_OECONF = "--with-glib  \
		--with-core-includes=${WORKSPACE}/system/core/include"

