inherit autotools pkgconfig

SUMMARY = "sensor util library"
DESCRIPTION = "The provides library interface to the util clients"
PR = "r1"
LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta-qti-bsp/files/common-licenses/\
${LICENSE};md5=3771d4920bd6cdb8cbdf1e8344489ee0"

DEPENDS = "glib-2.0 libcutils diag"

FILESPATH =+ "${WORKSPACE}:"
SRC_URI = "file://hardware/qcom/sensors/sensor-service/sensor_utils/lib"
S = "${WORKDIR}/hardware/qcom/sensors/sensor-service/sensor_utils/lib"

PACKAGECONFIG:append = "${@bb.utils.contains('MACHINE_FEATURES', 'commonlog', ' clog_logging_enabled', '', d)}"
PACKAGECONFIG:append = "${@bb.utils.contains('MACHINE_FEATURES', 'dlt-logging', ' dlt_logging_enabled', '', d)}"

PACKAGECONFIG[clog_logging_enabled] = "--with-clog,--without-clog,commonlog-lib,commonlog-lib"
PACKAGECONFIG[dlt_logging_enabled] = "--with-dltlogging,--without-dltlogging,dlt-daemon,dlt-daemon"

EXTRA_OECONF = "--with-core-includes=${WORKSPACE}/system/core/include \
                --with-glib"
